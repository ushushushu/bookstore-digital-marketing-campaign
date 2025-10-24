/*
=========================================================================================
TESTING THE CUSTOMERS TABLE COLUMNS
=========================================================================================
*/

/*
--------------------------------------------------
Checking the customer_key column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT customer_key
FROM silver.crm_customers
WHERE customer_key IS NULL;

-- Check for duplicate records
-- Expectation: None
SELECT
	customer_key,
	COUNT(*)
FROM silver.crm_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

/*
--------------------------------------------------
Checking the customer_id column
--------------------------------------------------
*/

-- Check for nulls or suspicious values
-- Expectation: None
SELECT customer_id
FROM silver.crm_customers
WHERE 
	customer_id IS NULL
	OR customer_id NOT LIKE 'CUST%'
;

-- Check for duplicates
-- Expectation: None
SELECT
	customer_id,
	COUNT(*)
FROM silver.crm_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Check for special characters
-- Expectation: None
-- Result: None
SELECT customer_id
FROM silver.crm_customers
WHERE PATINDEX('%[^a-zA-Z0-9]%', customer_id) > 0;

/*
--------------------------------------------------
Checking the email column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT email
FROM silver.crm_customers
WHERE email IS NULL;

-- Check for email addresses not matching their customer_id
-- Expectation: None
SELECT *
FROM silver.crm_customers
WHERE
	email != TRIM(LOWER(email))
	OR email != CONCAT('customer',silver.EXTRACT_BASE_NUMBER(customer_id),'@email.com')
;

/*
--------------------------------------------------
Checking the first_name & last_name columns
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT
	first_name,
	last_name
FROM silver.crm_customers
WHERE
	first_name IS NULL
	OR last_name IS NULL
;

-- Check for special characters (not matching letters a-z, numbers 0-9, & space)
-- Expectation: None
SELECT
	first_name,
	last_name
FROM silver.crm_customers
WHERE 
	PATINDEX('%[^a-zA-Z0-9 ]%', first_name) > 0
	OR PATINDEX('%[^a-zA-Z0-9 ]%', last_name) > 0
;

-- Check for names with extra spaces or names having improper capitalization
-- Expectation: None
SELECT
	first_name,
	last_name
FROM silver.crm_customers
WHERE
	first_name != TRIM(silver.INITCAP(first_name))
	OR last_name != TRIM(silver.INITCAP(last_name))
;

/*
--------------------------------------------------
Checking the date_of_birth column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT date_of_birth
FROM silver.crm_customers
WHERE date_of_birth IS NULL;

-- Check for outliers
-- Exepctation: None
SELECT
	customer_id,
	date_of_birth,
	DATEDIFF(YEAR,date_of_birth,GETDATE()) AS age
FROM silver.crm_customers
WHERE
	DATEDIFF(YEAR,date_of_birth,GETDATE()) < 5
	OR DATEDIFF(YEAR,date_of_birth,GETDATE()) > 110
;

/*
--------------------------------------------------
Checking the gender column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT gender
FROM silver.crm_customers
WHERE gender IS NULL;

-- Check for untrimmed, improperly capitalized values
-- Expectation: None
SELECT DISTINCT gender
FROM silver.crm_customers
WHERE gender != TRIM(silver.INITCAP(gender));

/*
--------------------------------------------------
Checking the phone column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT phone
FROM silver.crm_customers
WHERE phone IS NULL;

-- Check for characters other than numbers, '+', & '-'
-- Expectation: None
SELECT phone
FROM silver.crm_customers
WHERE PATINDEX('%[^0-9+-]%', phone) > 0 

/*
--------------------------------------------------
Checking the country, region, state, city columns
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT
	country,
	region,
	"state",
	city
FROM silver.crm_customers
WHERE
	country IS NULL
	OR region IS NULL
	OR "state" IS NULL
	OR city IS NULL
;

-- Check for untrimmed, improperly capitalized values
-- Expectation: None
SELECT country
FROM silver.crm_customers
WHERE country != TRIM(silver.INITCAP(country));

SELECT region
FROM silver.crm_customers
WHERE region != TRIM(silver.INITCAP(region));

SELECT "state"
FROM silver.crm_customers
WHERE "state" != TRIM(silver.INITCAP("state"));

SELECT city
FROM silver.crm_customers
WHERE city != TRIM(silver.INITCAP(city));

/*
--------------------------------------------------
Checking the postal_code column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT postal_code
FROM silver.crm_customers
WHERE postal_code IS NULL;

-- Check for non-numbered values
-- Expectation: None
SELECT postal_code
FROM silver.crm_customers
WHERE PATINDEX('%[^0-9]%', postal_code) > 0 ;

/*
--------------------------------------------------
Checking the address_line1 & address_line2 columns
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT
	address_line1,
	address_line2
FROM silver.crm_customers
WHERE
	address_line1 IS NULL
	OR address_line2 IS NULL
;

-- Check for untrimmed, improperly capitalized values
-- Expectation: None
SELECT address_line1
FROM silver.crm_customers
WHERE address_line1 != TRIM(silver.INITCAP(address_line1));

-- Check for untrimmed, improperly capitalized values
-- Expectation: None
SELECT address_line2
FROM silver.crm_customers
WHERE address_line2 != TRIM(silver.INITCAP(address_line2));

/*
--------------------------------------------------
Checking the preferred_language column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT preferred_language
FROM silver.crm_customers
WHERE preferred_language IS NULL;

-- Check for non-letter values
-- Expectation: None
SELECT preferred_language
FROM silver.crm_customers
WHERE PATINDEX('%[^a-zA-Z]%', preferred_language) > 0;

/*
--------------------------------------------------
Checking the customer_status column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT customer_status
FROM silver.crm_customers
WHERE customer_status IS NULL;

-- Check for non-letter values
-- Expectation: None
SELECT customer_status
FROM silver.crm_customers
WHERE PATINDEX('%[^a-zA-Z]%', customer_status) > 0;

/*
--------------------------------------------------
Checking the registration_date column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT registration_date
FROM silver.crm_customers
WHERE registration_date IS NULL;

-- Check for invalid registration (registrations occurred before the customers' date of birth)
-- Expectation: None
SELECT *
FROM silver.crm_customers
WHERE registration_date < date_of_birth;

/*
--------------------------------------------------
Checking the email_opt_in, sms_opt_in, & push_opt_in columns
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT
	email_opt_in,
	sms_opt_in,
	push_opt_in
FROM silver.crm_customers
WHERE
	email_opt_in IS NULL
	OR sms_opt_in IS NULL
	OR push_opt_in IS NULL
;

-- Check for suspcious values
-- Expectation: None
SELECT DISTINCT email_opt_in
FROM silver.crm_customers;

SELECT DISTINCT sms_opt_in
FROM silver.crm_customers;

SELECT DISTINCT push_opt_in
FROM silver.crm_customers;

/*
--------------------------------------------------
Checking the effective_date columns
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT effective_date
FROM silver.crm_customers
WHERE effective_date IS NULL;

-- Check for invalid effective dates (effective date occurred before the customer's date of birth)
-- Expectation: None
SELECT *
FROM silver.crm_customers
WHERE effective_date < date_of_birth;

/*
--------------------------------------------------
Checking the expiry_date columns
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT "expiry_date"
FROM silver.crm_customers
WHERE "expiry_date" IS NULL;

-- Check for suspcious values
-- Expectation: None
-- Results: None
SELECT
	customer_id,
	effective_date,
	"expiry_date"
FROM silver.crm_customers
WHERE
	"expiry_date" < effective_date
;

SELECT
	customer_id,
	effective_date,
	--"expiry_date",
	DATEADD(DAY,-1,"expiry_date") AS cleaned_exp,
	ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY effective_date DESC) AS record_version
FROM bronze.crm_customers
WHERE customer_id = 'CUST00000015';

/*
=========================================================================================
TESTING THE ORDER LINES TABLE COLUMNS
=========================================================================================
*/

/*
--------------------------------------------------
Checking the line_key column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT line_key
FROM bronze.crm_order_lines
WHERE line_key IS NULL;

-- Check for duplicates
-- Expectation: None
SELECT
	line_key,
	COUNT(*)
FROM bronze.crm_order_lines
GROUP BY line_key
HAVING COUNT(*) > 1;

/*
--------------------------------------------------
Checking the order_id column
--------------------------------------------------
*/

-- Check for nulls or special characters
-- Expectation: None
SELECT order_id
FROM bronze.crm_order_lines
WHERE
	order_id IS NULL
	OR PATINDEX('%[^A-Z0-9]%', order_id) > 0;
;

-- Check for untrimmed, improperly capitalized values
-- Expectation: None
SELECT order_id
FROM bronze.crm_order_lines
WHERE order_id != UPPER(TRIM(order_id));

-- Check for duplicates
-- Expectation: None
SELECT
	order_id,
	COUNT(*)
FROM bronze.crm_order_lines
GROUP BY order_id
HAVING COUNT(*) > 1;

/*
--------------------------------------------------
Checking the product_id column
--------------------------------------------------
*/

-- Check for nulls or special characters
-- Expectation: None
SELECT product_id
FROM bronze.crm_order_lines
WHERE
	product_id IS NULL
	OR PATINDEX('%[^A-Z0-9]%', product_id) > 0;

-- Check for duplicates
-- Expectation: None
SELECT
	product_id,
	COUNT(*)
FROM bronze.crm_order_lines
GROUP BY product_id
HAVING COUNT(*) > 1;

/*
--------------------------------------------------
Checking the line_number column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT line_number
FROM bronze.crm_order_lines
WHERE line_number IS NULL;

-- Check if the line number is sequential based on the order id
WITH correct_line_num AS (
	SELECT
		line_key,
		order_id,
		product_id,
		line_number,
		ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY line_key) AS expected_line_number
	FROM bronze.crm_order_lines
)

-- Expectation: All valid
SELECT
	*,
	CASE
		WHEN line_number = expected_line_number THEN 'Valid'
		ELSE 'Invalid'
	END AS line_validation
FROM correct_line_num;

/*
--------------------------------------------------
Checking the quantity column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT quantity
FROM bronze.crm_order_lines
WHERE quantity IS NULL;

/*
--------------------------------------------------
Checking the unit_price column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT unit_price
FROM bronze.crm_order_lines
WHERE unit_price IS NULL;

-- Check if the unit price in this table matches the historical product price in the products table
WITH cleaned_products_exp_date AS (
	SELECT
		product_id,
		price,
		cost,
		effective_date,
		CASE
			WHEN DATEADD(DAY,-1,LEAD(effective_date) OVER (PARTITION BY product_id ORDER BY effective_date)) IS NULL THEN CAST(GETDATE() AS DATE)
			ELSE DATEADD(DAY,-1,LEAD(effective_date) OVER (PARTITION BY product_id ORDER BY effective_date))
		END AS "expiry_date",
		ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY effective_date) AS record_version
	FROM bronze.crm_products
)

-- Expectation: All match
SELECT
	p.product_id,
	CASE
		WHEN CAST(o.order_timestamp AS DATE) BETWEEN p.effective_date AND p."expiry_date" THEN p.price
		ELSE NULL
	END AS actual_product_price,
	p.effective_date,
	p."expiry_date",
	ROW_NUMBER() OVER (PARTITION BY p.product_id ORDER BY p.product_id) AS record_version,
	CAST(o.order_timestamp AS DATE) AS order_date,
	ol.unit_price AS order_line_product_price,
	CASE
		WHEN o.order_timestamp = p.effective_date AND ol.unit_price = p.price THEN 'Match'
		ELSE 'Mismatch'
	END AS match_price
FROM cleaned_products_exp_date AS p
LEFT JOIN bronze.crm_order_lines AS ol
ON p.product_id = ol.product_id
LEFT JOIN bronze.crm_orders AS o
ON ol.order_id = o.order_id
WHERE ol.product_id IS NOT NULL;

/*
--------------------------------------------------
Checking the unit_cost column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
-- Result: None
SELECT unit_cost
FROM bronze.crm_order_lines
WHERE unit_cost IS NULL;

-- Check if the unit price in this table matches the historical product cost in the products table
WITH cleaned_products_exp_date AS (
	SELECT
		product_id,
		price,
		cost,
		effective_date,
		CASE
			WHEN DATEADD(DAY,-1,LEAD(effective_date) OVER (PARTITION BY product_id ORDER BY effective_date)) IS NULL THEN CAST(GETDATE() AS DATE)
			ELSE DATEADD(DAY,-1,LEAD(effective_date) OVER (PARTITION BY product_id ORDER BY effective_date))
		END AS "expiry_date",
		ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY effective_date) AS record_version
	FROM bronze.crm_products
)

-- Expectation: None
-- Result: Mismatch in pricing
SELECT
	p.product_id,
	p.cost AS actual_product_cost,
	p.effective_date,
	p."expiry_date",
	ROW_NUMBER() OVER (PARTITION BY p.product_id ORDER BY p.effective_date) AS record_version,
	CAST(o.order_timestamp AS DATE) AS order_date,
	ol.unit_cost AS order_line_product_cost
FROM cleaned_products_exp_date AS p
LEFT JOIN bronze.crm_order_lines AS ol
ON p.product_id = ol.product_id
LEFT JOIN bronze.crm_orders AS o
ON ol.order_id = o.order_id
WHERE ol.product_id IS NOT NULL;

/*
--------------------------------------------------
Checking the discount_amount column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
-- Result: Records with null values
-- Action: Will convert to 0
SELECT discount_amount
FROM bronze.crm_order_lines
WHERE discount_amount IS NULL;

/*
--------------------------------------------------
Checking the line_total column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
-- Result: None
SELECT line_total
FROM bronze.crm_order_lines
WHERE line_total IS NULL;

-- Check if the line amount is correctly calculated based on the corrected unit price & discount amount
-- Equation: line amount = ( (unit price - discount amount) * quantity )
WITH cleaned_products_exp_date AS (
	SELECT
		product_id,
		price,
		cost,
		effective_date,
		CASE
			WHEN DATEADD(DAY,-1,LEAD(effective_date) OVER (PARTITION BY product_id ORDER BY effective_date)) IS NULL THEN CAST(GETDATE() AS DATE)
			ELSE DATEADD(DAY,-1,LEAD(effective_date) OVER (PARTITION BY product_id ORDER BY effective_date))
		END AS "expiry_date",
		ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY effective_date) AS record_version
	FROM bronze.crm_products
),
check_line_amt_validity AS (
	SELECT
		ol.line_key,
		ol.order_id,
		ol.product_id,
		ol.line_number,
		ol.quantity,
		p.price AS correct_unit_price,
		COALESCE(ol.discount_amount,0) AS correct_discount_amount,
		(p.price - COALESCE(ol.discount_amount,0)) * ol.quantity AS correct_line_total,
		ol.unit_price,
		ol.discount_amount,
		ol.line_total,
		CASE
			WHEN ol.discount_amount = (p.price - COALESCE(ol.discount_amount,0)) * ol.quantity THEN 'Match'
			ELSE 'Mismatch'
		END AS match_line_amt
	FROM bronze.crm_order_lines AS ol
	LEFT JOIN bronze.crm_orders AS o
	ON ol.order_id = o.order_id
	LEFT JOIN cleaned_products_exp_date AS p
	ON ol.product_id = p.product_id
	AND CAST(o.order_timestamp AS DATE) BETWEEN p.effective_date AND p."expiry_date"
)

-- Expectation: Matching line amounts
-- Result: Mismatch in line amounts
-- Action: Mismatch is caused by incorrect unit cost & discount amount (see lines 593 & 684 to check), will re-calculate
SELECT *
FROM check_line_amt_validity
ORDER BY line_key;

/*
=========================================================================================
TESTING THE ORDERS TABLE COLUMNS
=========================================================================================
*/

/*
--------------------------------------------------
Checking the order_key column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
-- Result: None
SELECT order_key
FROM bronze.crm_orders
WHERE order_key IS NULL;

-- Check for duplicates
-- Expectation: None
-- Result: None
SELECT
	order_key,
	COUNT(*)
FROM bronze.crm_orders
GROUP BY order_key
HAVING COUNT(*) > 1;

/*
--------------------------------------------------
Checking the order_id column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
-- Result: None
SELECT order_id
FROM bronze.crm_orders
WHERE order_key IS NULL;

-- Check for duplicates
-- Expectation: None
-- Result: None
SELECT
	order_id,
	COUNT(*)
FROM bronze.crm_orders
GROUP BY order_id
HAVING COUNT(*) > 1;

/*
--------------------------------------------------
Checking the order_timestamp column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
-- Result: None
SELECT order_timestamp
FROM bronze.crm_orders
WHERE order_timestamp IS NULL;

/*
--------------------------------------------------
Checking the order_status column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
-- Result: None
SELECT order_status
FROM bronze.crm_orders
WHERE order_status IS NULL;

-- Check for untrimmed, improperly capitalizeed values
-- Expectation: None
-- Result: Records with untrimmed, inconsistent capitalization
SELECT order_status
FROM bronze.crm_orders
WHERE order_status != TRIM(silver.INITCAP(order_status));

SELECT DISTINCT TRIM(silver.INITCAP(order_status))
FROM bronze.crm_orders;

/*
--------------------------------------------------
Checking the order_channel column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
-- Result: None
SELECT order_channel
FROM bronze.crm_orders
WHERE order_channel IS NULL;

-- Check for untrimmed, improperly capitalizeed values
-- Expectation: None
-- Result: Records with untrimmed, inconsistent capitalization
SELECT order_channel
FROM bronze.crm_orders
WHERE order_channel != TRIM(silver.INITCAP(order_channel));

SELECT DISTINCT TRIM(silver.INITCAP(order_channel))
FROM bronze.crm_orders;

/*
--------------------------------------------------
Checking the store_id column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
-- Result: Records with null values
-- Action: Won't replace with other values, lest they be wrong
SELECT store_id
FROM bronze.crm_orders
WHERE store_id IS NULL;

-- Check for other values
-- Expectation: None
-- Result: Only null values are present since all orders come from the company website
SELECT DISTINCT store_id
FROM bronze.crm_orders;

/*
--------------------------------------------------
Checking the subtotal column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT subtotal
FROM bronze.crm_orders
WHERE subtotal IS NULL;

-- Check if the subtotal is bigger than the discount amount, which will then make the subtotal negative & invalid
-- Expectation: None
SELECT
	order_id,
	subtotal,
	discount_amount,
	CASE
		WHEN subtotal >= discount_amount THEN 'Valid'
		ELSE 'Invalid'
	END AS valid_totals
FROM bronze.crm_orders;

-- Check if the total line amount per order in the order lines table = subtotal in the orders table
WITH cleaned_products_exp_date AS (
	SELECT
		product_id,
		price,
		cost,
		effective_date,
		COALESCE(DATEADD(DAY,-1,LEAD(effective_date) OVER (PARTITION BY product_id ORDER BY effective_date)),'2025-01-15') AS "expiry_date"
	FROM bronze.crm_products
)

-- Expectation: All match
SELECT
	o.order_id,
	ol.quantity,
	p.price AS unit_price,
	COALESCE(ol.discount_amount,0) AS discount_amount,
	SUM((p.price - COALESCE(ol.discount_amount,0)) * ol.quantity) OVER (PARTITION BY o.order_id ORDER BY o.order_id) AS correct_subtotal,
	o.subtotal AS order_subtotal,
	CASE
		WHEN o.subtotal = SUM((p.price - COALESCE(ol.discount_amount,0)) * ol.quantity) OVER (PARTITION BY o.order_id ORDER BY o.order_id) THEN 'Match'
		ELSE 'Mismatch'
	END AS match_subtotal
FROM bronze.crm_order_lines AS ol
LEFT JOIN bronze.crm_orders AS o
ON ol.order_id = o.order_id
LEFT JOIN cleaned_products_exp_date AS p
ON ol.product_id = p.product_id
AND CAST(o.order_timestamp AS DATE) BETWEEN p.effective_date AND p."expiry_date"
ORDER BY ol.line_key;

/*
--------------------------------------------------
Checking the discount_amount column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT discount_amount
FROM bronze.crm_orders
WHERE discount_amount IS NULL;

-- Check for other values
SELECT DISTINCT discount_amount
FROM bronze.crm_orders;

/*
--------------------------------------------------
Checking the shipping_cost column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT shipping_cost
FROM bronze.crm_orders
WHERE shipping_cost IS NULL;

-- Check for other values
SELECT DISTINCT shipping_cost
FROM bronze.crm_orders;

-- Check if the free shipping promo turns shipping cost to 0
-- Expectation: All match
SELECT
	--order_id
	shipping_cost,
	COALESCE(promo_code,'None'),
	CASE
		WHEN (COALESCE(promo_code,'None') LIKE '%SHIP' AND shipping_cost = 0) OR (COALESCE(promo_code,'None') = 'None' AND shipping_cost != 0) THEN 'Match'
		ELSE 'Mismatch'
	END as match_free_shipping
FROM bronze.crm_orders;

/*
--------------------------------------------------
Checking the tax_amount column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT shipping_cost
FROM bronze.crm_orders
WHERE shipping_cost IS NULL;

-- Check for other values
SELECT DISTINCT shipping_cost
FROM bronze.crm_orders;

/*
--------------------------------------------------
Checking the total_amount column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT total_amount
FROM bronze.crm_orders
WHERE total_amount IS NULL;

-- Check if total_amount is correctly calculated, given changes in the subtotal
-- If subtotal is changed, the discount amount (5%-10% of subtotal, based on discount percent) & tax amount (8% of subtotal minus discount amount) must be re-calculated
-- total_amount = (subtotal - discount_amount) + shipping_cost + tax_amount
WITH order_totals AS (
	SELECT
		order_id,
		SUM(line_total) AS subtotal
	FROM silver.crm_order_lines
	GROUP BY order_id
)

-- Expectation: All match
SELECT
	o.order_key,
	o.order_id,
	ot.subtotal,
	ROUND(ot.subtotal * (o.discount_percent / 100), 2) AS discount_amount,
	o.shipping_cost,
	ROUND((ot.subtotal - ROUND(ot.subtotal * (o.discount_percent / 100), 2)) * 0.08, 2) AS tax_amount,
	((SUM(ot.subtotal) OVER (PARTITION BY o.order_id ORDER BY o.order_id) - o.discount_amount) + o.shipping_cost + ROUND((ot.subtotal - ROUND(ot.subtotal * (o.discount_percent / 100), 2)) * 0.08, 2)) AS correct_total_amount,
	o.total_amount AS original_loan_amount,
	CASE
		WHEN o.total_amount = ((SUM(ot.subtotal) OVER (PARTITION BY o.order_id ORDER BY o.order_id) - o.discount_amount) + o.shipping_cost + ROUND((ot.subtotal - ROUND(ot.subtotal * (o.discount_percent / 100), 2)) * 0.08, 2)) THEN 'Match'
		ELSE 'Mismatch'
	END AS valid_total
FROM bronze.crm_orders AS o
LEFT JOIN order_totals AS ot
ON o.order_id = ot.order_id;

/*
--------------------------------------------------
Checking the payment_method column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT payment_method
FROM bronze.crm_orders
WHERE payment_method IS NULL;

-- Check for untrimmed, improperly capitalized values
-- Expectation: None
SELECT payment_method
FROM bronze.crm_orders
WHERE payment_method != TRIM(silver.INITCAP(payment_method));

/*
--------------------------------------------------
Checking the shipping_method column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT shipping_method
FROM bronze.crm_orders
WHERE shipping_method IS NULL;

-- Check for untrimmed, improperly capitalized values
-- Expectation: None
SELECT shipping_method
FROM bronze.crm_orders
WHERE shipping_method != TRIM(silver.INITCAP(shipping_method));

/*
--------------------------------------------------
Checking the shipping_address_line1 column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT shipping_address_line1
FROM bronze.crm_orders
WHERE shipping_address_line1 IS NULL;

-- Check for other values because there's lots of null values
-- Expectation: Non-null values, must match the customer's address_line1 in the customers table
SELECT DISTINCT shipping_address_line1
FROM bronze.crm_orders;

/*
--------------------------------------------------
Checking the shipping_address_line2 column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT shipping_address_line2
FROM bronze.crm_orders
WHERE shipping_address_line2 IS NULL;

-- Check for other values because there's lots of null values
-- Expectation: Non-null values, must match the customer's address_line2 in the customers table
SELECT DISTINCT shipping_address_line2
FROM bronze.crm_orders;

/*
--------------------------------------------------
Checking the shipping_city column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT shipping_city
FROM bronze.crm_orders
WHERE shipping_city IS NULL;

-- Check for other values because there's lots of null values
-- Expectation: Non-null values, must match the customer's city in the customers table
SELECT DISTINCT shipping_city
FROM bronze.crm_orders;

/*
--------------------------------------------------
Checking the shipping_postal_code column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT shipping_postal_code
FROM bronze.crm_orders
WHERE shipping_city IS NULL;

-- Check for other values because there's lots of null values
-- Expectation: Non-null values, must match the customer's city in the customers table
SELECT DISTINCT shipping_postal_code
FROM bronze.crm_orders;

/*
--------------------------------------------------
Checking the shipping_country column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT shipping_country
FROM bronze.crm_orders
WHERE shipping_city IS NULL;

-- Check for other values because there's lots of null values
-- Expectation: Non-null values, must match the customer's city in the customers table
SELECT DISTINCT shipping_country
FROM bronze.crm_orders;

/*
--------------------------------------------------
Checking the promo_code column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT promo_code
FROM bronze.crm_orders
WHERE promo_code IS NULL;

-- Check for untrimmed, improperly capitalized values
-- Expectation: None
SELECT promo_code
FROM bronze.crm_orders
WHERE promo_code != TRIM(UPPER(promo_code))

/*
--------------------------------------------------
Checking the discount_percent column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT discount_percent
FROM bronze.crm_orders
WHERE discount_percent IS NULL;

-- Check for the column's data type
-- Expectation: Integer
SELECT DISTINCT SQL_VARIANT_PROPERTY(discount_percent, 'BaseType')
FROM bronze.crm_orders;

/*
--------------------------------------------------
Checking the first_purchase_flag column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT first_purchase_flag
FROM bronze.crm_orders
WHERE first_purchase_flag IS NULL;

-- Check for other values because there's lots of null values
-- Expectation: Non-null values, must match the customer's city in the customers table
SELECT DISTINCT first_purchase_flag
FROM bronze.crm_orders;

SELECT COUNT(promo_code)
FROM bronze.crm_orders
WHERE CAST(order_timestamp AS DATE) < '2023-01-01';


--7949
--585

/*
--------------------------------------------------
Checking the gift_order_flag column
--------------------------------------------------
*/

SELECT promo_code
FROM bronze.crm_orders
WHERE promo_code IS NOT NULL
























































































/*
=========================================================================================
TESTING THE PRODUCTS TABLE COLUMNS
=========================================================================================
*/

-- Check for nulls
-- Expectation: None
SELECT product_key
FROM bronze.crm_products
WHERE product_key IS NULL;

-- Check for duplicates
-- Expectation: None
SELECT
	product_key,
	COUNT(*)
FROM bronze.crm_products
GROUP BY product_key
HAVING COUNT(*) > 1

/*
--------------------------------------------------
Checking the product_key column
--------------------------------------------------
*/

-- Check for nulls
-- Expectation: None
SELECT product_id
FROM bronze.crm_products
WHERE product_id IS NULL;

-- Check for duplicates
-- Expectation: None
SELECT
	product_id,
	COUNT(*)
FROM bronze.crm_products
GROUP BY product_id
HAVING COUNT(*) > 1

-- Check for historization
-- Expectation: None
SELECT 
	product_id,
	title,
	effective_date,
    "expiry_date"
FROM bronze.crm_products
WHERE product_id IN ('PROD00000097','PROD00000100');

/*
--------------------------------------------------
Checking the product_id column
--------------------------------------------------
*/

/*
--------------------------------------------------
Checking the isbn column
--------------------------------------------------
*/

/*
--------------------------------------------------
Checking the title column
--------------------------------------------------
*/

/*
--------------------------------------------------
Checking the author column
--------------------------------------------------
*/

/*
--------------------------------------------------
Checking the publisher column
--------------------------------------------------
*/

/*
--------------------------------------------------
Checking the publication_date column
--------------------------------------------------
*/

/*
--------------------------------------------------
Checking the product_type column
--------------------------------------------------
*/

/*
--------------------------------------------------
Checking the genre column
--------------------------------------------------
*/

/*
--------------------------------------------------
Checking the sub_genre column
--------------------------------------------------
*/

/*
--------------------------------------------------
Checking the language column
--------------------------------------------------
*/

/*
--------------------------------------------------
Checking the page_count column
--------------------------------------------------
*/

/*
--------------------------------------------------
Checking the duration_minutes column
--------------------------------------------------
*/

/*
--------------------------------------------------
Checking the price column
--------------------------------------------------
*/

/*
--------------------------------------------------
Checking the cost column
--------------------------------------------------
*/

/*
--------------------------------------------------
Checking the in_stock column
--------------------------------------------------
*/

/*
--------------------------------------------------
Checking the stock_quantity column
--------------------------------------------------
*/

/*
--------------------------------------------------
Checking the bestseller_flag column
--------------------------------------------------
*/

/*
--------------------------------------------------
Checking the new_release_flag column
--------------------------------------------------
*/

/*
--------------------------------------------------
Checking the effective_date column
--------------------------------------------------
*/

/*
--------------------------------------------------
Checking the expiry_date column
--------------------------------------------------
*/

SELECT 
	last_name,
	STRING_SPLIT(TRIM(last_name), AS last_name1
FROM bronze.crm_customers;