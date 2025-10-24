/*
=========================================================================================
CLEANING THE CUSTOMERS TABLE - OKS!!!
=========================================================================================
*/

IF EXISTS (SELECT TOP 1 1 FROM silver.crm_customers)
	TRUNCATE TABLE silver.crm_customers; 
	
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'index_customer_key' AND object_id = OBJECT_ID('bronze.crm_customers'))
    DROP INDEX index_customer_key ON bronze.crm_customers;

CREATE UNIQUE INDEX index_customer_key ON bronze.crm_customers (customer_key);

WITH cleaned_customers AS ( 
	SELECT
		customer_key,
		customer_id,
		email,
		TRIM(silver.INITCAP(first_name)) AS first_name,
		TRIM(silver.INITCAP(last_name)) AS last_name,
		date_of_birth,
		CASE 
			WHEN UPPER(TRIM(gender)) = 'M' THEN 'Male' 
			WHEN UPPER(TRIM(gender)) = 'F' THEN 'Female' 
			ELSE 'Unknown' 
		END AS gender, 
		TRIM(phone) AS phone,
		COALESCE(country,'Unknown') AS country, 
		COALESCE(region,'Unknown') AS region, 
		COALESCE("state",'Unknown') AS [state], 
		COALESCE(city,'Unknown') AS city, 
		TRIM(postal_code) AS postal_code, 
		TRIM(silver.INITCAP(address_line1)) AS address_line1, 
		TRIM(silver.INITCAP(address_line2)) AS address_line2, 
		COALESCE(TRIM(silver.INITCAP(preferred_language)),'Unknown') AS preferred_language, 
		TRIM(silver.INITCAP(customer_status)) AS customer_status, 
		registration_date, 
		TRIM(silver.INITCAP(email_opt_in)) AS email_opt_in,
		TRIM(silver.INITCAP(sms_opt_in)) AS sms_opt_in, 
		TRIM(silver.INITCAP(push_opt_in)) AS push_opt_in, 
		effective_date, 
		DATEADD(DAY,-1,"expiry_date") AS [expiry_date], 
		ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY effective_date DESC) AS record_version 
	FROM bronze.crm_customers 
	WHERE 
		--"expiry_date" IS NULL --Filters the records for most recent information 
		DATEDIFF(YEAR,date_of_birth,'2025-01-15') BETWEEN 5 AND 110 --Filters the records for customers aged 5 to 110 (there are outliers) 
		AND registration_date > date_of_birth
)

INSERT INTO silver.crm_customers ( 
	customer_key, 
	customer_id, 
	email, 
	first_name, 
	last_name, 
	date_of_birth, 
	gender, 
	phone, 
	country, 
	region, 
	[state], 
	city, 
	postal_code, 
	address_line1, 
	address_line2, 
	preferred_language, 
	customer_status, 
	registration_date, 
	email_opt_in, 
	sms_opt_in, 
	push_opt_in, 
	effective_date, 
	[expiry_date], 
	record_version 
)

SELECT * 
FROM cleaned_customers;

SELECT *
FROM silver.crm_customers;

/*
=========================================================================================
CLEANING THE ORDER LINES TABLE
=========================================================================================
*/

WITH cleaned_products_expiry AS (
	SELECT
		product_id,
		price,
		cost,
		effective_date,
		COALESCE(DATEADD(DAY,-1,LEAD(effective_date) OVER (PARTITION BY product_id ORDER BY effective_date)),'2025-01-15') AS "expiry_date"
	FROM bronze.crm_products
)

INSERT INTO silver.crm_order_lines (
	line_key,
    order_id,
    product_id,
    line_number,
    quantity,
    unit_price,
    unit_cost,
    discount_amount,
    line_total
)

SELECT
	ol.line_key,
	ol.order_id,
	ol.product_id,
	ROW_NUMBER() OVER (PARTITION BY ol.order_id ORDER BY ol.line_key) AS line_number,
	ol.quantity,
	p.price AS unit_price,
	p.cost AS unit_cost,
	COALESCE(ol.discount_amount,0) AS discount_amount,
	(p.price - COALESCE(ol.discount_amount,0)) * ol.quantity AS line_total
FROM bronze.crm_order_lines AS ol
LEFT JOIN bronze.crm_orders AS o
ON ol.order_id = o.order_id
LEFT JOIN cleaned_products_expiry AS p
ON ol.product_id = p.product_id
AND CAST(o.order_timestamp AS DATE) BETWEEN p.effective_date AND p."expiry_date"
ORDER BY ol.line_key;

SELECT *
FROM silver.crm_order_lines
ORDER BY line_key;

/*
=========================================================================================
CLEANING THE ORDERS TABLE
=========================================================================================
*/

WITH cleaned_customers_expiry AS (
	SELECT 
		customer_id,
		COALESCE(country,'Unknown') AS country,
		COALESCE(state,'Unknown') AS state,
		COALESCE(city,'Unknown') AS city,
		TRIM(silver.INITCAP(address_line1)) AS address_line1,
		TRIM(silver.INITCAP(address_line2)) AS address_line2,
		TRIM(silver.INITCAP(postal_code)) postal_code,
		effective_date,
		COALESCE(DATEADD(DAY,-1,LAG(effective_date,1) OVER (PARTITION BY customer_id ORDER BY effective_date DESC)),'2025-01-15') "expiry_date"
	FROM bronze.crm_customers
),
order_totals AS (
	SELECT
		order_id,
		SUM(line_total) AS subtotal
	FROM silver.crm_order_lines
	GROUP BY order_id
),
cleaned_orders AS (
	SELECT
		o.order_key,
		o.order_id,
		o.customer_id,
		o.order_timestamp,
		TRIM(silver.INITCAP(o.order_status)) AS order_status,
		TRIM(silver.INITCAP(o.order_channel)) AS order_channel,
		o.store_id,
		ot.subtotal,
		ROUND(ot.subtotal * (o.discount_percent / 100), 2) AS discount_amount,
		o.shipping_cost,
		ROUND((ot.subtotal - ROUND(ot.subtotal * (o.discount_percent / 100), 2)) * 0.08, 2) AS tax_amount,
		((SUM(ot.subtotal) OVER (PARTITION BY o.order_id ORDER BY o.order_id) - o.discount_amount) + o.shipping_cost + ROUND((ot.subtotal - ROUND(ot.subtotal * (o.discount_percent / 100), 2)) * 0.08, 2)) AS total_amount,
		TRIM(silver.INITCAP(o.payment_method)) AS payment_method,
		TRIM(silver.INITCAP(o.shipping_method)) AS shipping_method,
		c.address_line1 AS shipping_address_line1,
		c.address_line2 AS shipping_address_line2,
		c.city AS shipping_city,
		c.postal_code AS shipping_postal_code,
		c.country AS shipping_country,
		c."state" AS shipping_state,
		COALESCE(TRIM(UPPER(O.promo_code)),'None') AS promo_code,
		CAST(o.discount_percent AS INT) AS discount_percent,
		CASE
			WHEN o.first_purchase_flag = 1 THEN 'Yes'
			ELSE 'No'
		END AS first_purchase_flag,
		CASE
			WHEN o.gift_order_flag = 1 THEN 'Yes'
			ELSE 'No'
		END AS gift_order_flag
	FROM bronze.crm_orders AS o
	LEFT JOIN order_totals AS ot
	ON o.order_id = ot.order_id
	LEFT JOIN cleaned_customers_expiry AS c
	ON o.customer_id = c.customer_id
	AND CAST(o.order_timestamp AS DATE) BETWEEN c.effective_date AND c."expiry_date"
)

INSERT INTO silver.crm_orders (
	order_key,
    order_id,
    customer_id,
    order_timestamp,
    order_status,
    order_channel,
    store_id,
    subtotal,
    discount_amount,
    shipping_cost,
    tax_amount,
    total_amount,
    payment_method,
    shipping_method,
    shipping_address_line1,
    shipping_address_line2,
    shipping_city,
    shipping_postal_code,
    shipping_country,
	shipping_state,
    promo_code,
    discount_percent,
    first_purchase_flag,
    gift_order_flag
)

SELECT *
FROM cleaned_orders;

SELECT *
FROM silver.crm_orders;

/*
=========================================================================================
CLEANING THE PAGE VIEWS TABLE
=========================================================================================
*/

SELECT *
FROM bronze.crm_page_views;












































































































/*
=========================================================================================
CLEANING THE PRODUCTS TABLE
=========================================================================================
*/

INSERT INTO silver.crm_products (
	product_key,
    product_id,
    isbn,
    title,
    author,
    publisher,
    publication_date,
    product_type,
    genre,
    sub_genre,
    "language",
    page_count,
    duration_minutes,
    price,
    cost,
    in_stock,
    stock_quantity,
    bestseller_flag,
    new_release_flag,
    effective_date,
    "expiry_date"
)

SELECT 
	product_key,
    product_id,
    isbn,
    title,
    author,
    publisher,
    publication_date,
    product_type,
    genre,
    sub_genre,
    "language",
    page_count,
    duration_minutes,
    price,
    cost,
    in_stock,
    stock_quantity,
    bestseller_flag,
    new_release_flag,
    effective_date,
    "expiry_date"
FROM bronze.crm_products;
