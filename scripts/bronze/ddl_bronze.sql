/*
=========================================================================================
Creating the 11 Core Database Tables - The Book Hoarder Dataset
=========================================================================================

Script Purpose:
    This script creates the 11 core tables based on the data schema from the dataset generator.
    It checks whether tables exist & drops them if they do.

Core Tables Created:
    MIS Tables (5): channels, campaigns, campaign_impressions, campaign_clicks, campaign_spend
    CRM Tables (6): customers, products, web_sessions, orders, order_lines, page_views

=========================================================================================
*/

-- ======================================================================================
-- MIS TABLES (Marketing Information System)
-- ======================================================================================

IF OBJECT_ID('bronze.mis_channels', 'U') IS NOT NULL
    DROP TABLE bronze.mis_channels;
CREATE TABLE bronze.mis_channels (
    channel_key         INT,
    channel_id          VARCHAR(50),
    channel_name        VARCHAR(100),
    channel_category    VARCHAR(50),
    channel_type        VARCHAR(50),
    "platform"          VARCHAR(100)
);

IF OBJECT_ID('bronze.mis_campaigns', 'U') IS NOT NULL
    DROP TABLE bronze.mis_campaigns;
CREATE TABLE bronze.mis_campaigns (
    campaign_key            INT,
    campaign_id             VARCHAR(50),
    campaign_name           VARCHAR(255),
    campaign_type           VARCHAR(100),
    campaign_objective      VARCHAR(100),
    campaign_manager        VARCHAR(100),
    campaign_start_date     DATE,
    campaign_end_date       DATE,
    campaign_status         VARCHAR(50),
    target_audience         VARCHAR(255),
    budget_allocated        DECIMAL(12,2),
    campaign_description    TEXT,
    promotional_offer       VARCHAR(255),
    promo_code              VARCHAR(50),
    creative_version        VARCHAR(50)
);

IF OBJECT_ID('bronze.mis_campaign_impressions', 'U') IS NOT NULL
    DROP TABLE bronze.mis_campaign_impressions;
CREATE TABLE bronze.mis_campaign_impressions (
    impression_key          BIGINT,
    campaign_id             VARCHAR(50),
    channel_id              VARCHAR(50),
    impression_timestamp    DATETIME2,
    impression_id           VARCHAR(100),
    "user_id"               VARCHAR(100),
    device_type             VARCHAR(50),
    placement               VARCHAR(255),
    creative_id             VARCHAR(50),
    cost                    DECIMAL(10,4)
);

IF OBJECT_ID('bronze.mis_campaign_clicks', 'U') IS NOT NULL
    DROP TABLE bronze.mis_campaign_clicks;
CREATE TABLE bronze.mis_campaign_clicks (
    click_key           BIGINT,
    campaign_id         VARCHAR(50),
    channel_id          VARCHAR(50),
    click_timestamp     DATETIME2,
    click_id            VARCHAR(100),
    impression_id       VARCHAR(100),
    "user_id"           VARCHAR(100),
    device_type         VARCHAR(50),
    landing_page_url    VARCHAR(500),
    cost                DECIMAL(10,4)
);

IF OBJECT_ID('bronze.mis_campaign_spend', 'U') IS NOT NULL
    DROP TABLE bronze.mis_campaign_spend;
CREATE TABLE bronze.mis_campaign_spend (
    spend_key       BIGINT,
    campaign_id     VARCHAR(50),
    channel_id      VARCHAR(50),
    spend_date      DATE,
    amount_spent    DECIMAL(12,2),
    spend_category  VARCHAR(100),
    notes           TEXT
);

-- ======================================================================================
-- CRM TABLES (Customer Relationship Management)
-- ======================================================================================

IF OBJECT_ID('bronze.crm_customers', 'U') IS NOT NULL
    DROP TABLE bronze.crm_customers;
CREATE TABLE bronze.crm_customers (
    customer_key        BIGINT,
    customer_id         VARCHAR(50),
    email               VARCHAR(255),
    first_name          VARCHAR(100),
    last_name           VARCHAR(100),
    date_of_birth       DATE,
    gender              VARCHAR(20),
    phone               VARCHAR(50),
    country             VARCHAR(100),
    region              VARCHAR(50),
    "state"             VARCHAR(100),
    city                VARCHAR(100),
    postal_code         VARCHAR(20),
    address_line1       VARCHAR(255),
    address_line2       VARCHAR(255),
    preferred_language  VARCHAR(50),
    customer_status     VARCHAR(50),
    registration_date   DATE,
    email_opt_in        VARCHAR(20),
    sms_opt_in          VARCHAR(20),
    push_opt_in         VARCHAR(20),
    effective_date      DATE,
    "expiry_date"       DATE
);

IF OBJECT_ID('bronze.crm_products', 'U') IS NOT NULL
    DROP TABLE bronze.crm_products;
CREATE TABLE bronze.crm_products (
    product_key         BIGINT,
    product_id          VARCHAR(50),
    isbn                VARCHAR(20),
    title               VARCHAR(500),
    author              VARCHAR(255),
    publisher           VARCHAR(255),
    publication_date    DATE,
    product_type        VARCHAR(50),
    genre               VARCHAR(100),
    sub_genre           VARCHAR(100),
    "language"          VARCHAR(50),
    page_count          INT,
    duration_minutes    INT,
    price               DECIMAL(10,2),
    cost                DECIMAL(10,2),
    in_stock            BIT,
    stock_quantity      INT,
    bestseller_flag     BIT,
    new_release_flag    BIT,
    effective_date      DATE,
    "expiry_date"       DATE
);

IF OBJECT_ID('bronze.crm_web_sessions', 'U') IS NOT NULL
    DROP TABLE bronze.crm_web_sessions;
CREATE TABLE bronze.crm_web_sessions (
    session_key                 BIGINT,
    "session_id"                VARCHAR(100),
    customer_id                 VARCHAR(50),
    session_start_timestamp     DATETIME2,
    session_end_timestamp       DATETIME2,
    device_type                 VARCHAR(50),
    operating_system            VARCHAR(100),
    browser                     VARCHAR(100),
    ip_address                  VARCHAR(50),
    utm_source                  VARCHAR(255),
    utm_medium                  VARCHAR(255),
    utm_campaign                VARCHAR(255),
    utm_content                 VARCHAR(255),
    utm_term                    VARCHAR(255),
    referrer_url                VARCHAR(500),
    landing_page_url            VARCHAR(500),
    page_views                  INT,
    bounce_flag                 BIT,
    new_visitor_flag            BIT,
    transaction_flag            BIT,
    order_id                    VARCHAR(100)
);

IF OBJECT_ID('bronze.crm_orders', 'U') IS NOT NULL
    DROP TABLE bronze.crm_orders;
CREATE TABLE bronze.crm_orders (
    order_key               BIGINT,
    order_id                VARCHAR(100),
    customer_id             VARCHAR(50),
    order_timestamp         DATETIME2,
    order_status            VARCHAR(50),
    order_channel           VARCHAR(50),
    store_id                VARCHAR(50),
    subtotal                DECIMAL(12,2),
    discount_amount         DECIMAL(12,2),
    shipping_cost           DECIMAL(12,2),
    tax_amount              DECIMAL(12,2),
    total_amount            DECIMAL(12,2),
    payment_method          VARCHAR(50),
    shipping_method         VARCHAR(50),
    shipping_address_line1  VARCHAR(255),
    shipping_address_line2  VARCHAR(255),
    shipping_city           VARCHAR(100),
    shipping_postal_code    VARCHAR(20),
    shipping_country        VARCHAR(100),
    promo_code              VARCHAR(50),
    discount_percent        DECIMAL(5,2),
    first_purchase_flag     BIT,
    gift_order_flag         BIT
);

IF OBJECT_ID('bronze.crm_order_lines', 'U') IS NOT NULL
    DROP TABLE bronze.crm_order_lines;
CREATE TABLE bronze.crm_order_lines (
    line_key            BIGINT,
    order_id            VARCHAR(100),
    product_id          VARCHAR(50),
    line_number         INT,
    quantity            INT,
    unit_price          DECIMAL(10,2),
    unit_cost           DECIMAL(10,2),
    discount_amount     DECIMAL(10,2),
    line_total          DECIMAL(12,2)
);

IF OBJECT_ID('bronze.crm_page_views', 'U') IS NOT NULL
    DROP TABLE bronze.crm_page_views;
CREATE TABLE bronze.crm_page_views (
    page_view_key           BIGINT,
    "session_id"            VARCHAR(100),
    page_view_timestamp     DATETIME2,
    page_url                VARCHAR(500),
    page_title              VARCHAR(255),
    page_type               VARCHAR(100),
    product_id              VARCHAR(50),
    previous_page_url       VARCHAR(500),
    time_on_page_seconds    INT,
    scroll_depth_percent    INT,
    exit_page_flag          BIT,
    entry_page_flag         BIT
);

/*
=========================================================================================
END OF SCHEMA CREATION - 11 CORE TABLES
=========================================================================================

Summary:
- 5 MIS tables: channels, campaigns, campaign_impressions, campaign_clicks, campaign_spend
- 6 CRM tables: customers, products, web_sessions, orders, order_lines, page_views
- All tables include appropriate data types matching Python generator
- BIT type used for boolean flags (0/1)
- DECIMAL types with appropriate precision for monetary values
- VARCHAR sizes aligned with expected data ranges
- TEXT type used for long-form content fields
- Reserved keywords quoted with double quotes

Notes:
- All timestamp fields use DATETIME2 for precision
- Historization supported through effective_date and expiry_date fields 
  in customers and products tables

=========================================================================================
*/