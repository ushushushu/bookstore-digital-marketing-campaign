/*
=========================================================================================
Stored Procedure: Load the Bronze Layer (Source -> Bronze)
=========================================================================================

Script Purpose:	
	This stored procedure loads the data into the 'bronze' schema from external CSV files.
	It performs the following actions:
		- Truncates the bronze tables before loading the data
		- Uses the 'BULK INSERT' command to load data from CSV files to the bronze layer

Parameters:
	None. This stored procedure doesn't accept any parameters or returns any values

Usage example:
	EXEC bronze.load_bronze;

=========================================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE()
		PRINT '=========================================================================================';
		PRINT 'Loading the Bronze Layer';
		PRINT '=========================================================================================';
	
		PRINT '-----------------------------------------------------------------------------------------';
		PRINT 'Loading the CRM tables';
		PRINT '-----------------------------------------------------------------------------------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating the bronze.crm_customers table';
		TRUNCATE TABLE bronze.crm_customers;
		PRINT '>> Inserting data in the bronze.crm_customers table';
		BULK INSERT bronze.crm_customers
		FROM 'C:\Users\LENOVO\Downloads\the-book-hoarder-digital-marketing-campaign-project\crm\customers.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------------------------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating the bronze.crm_order_lines table';
		TRUNCATE TABLE bronze.crm_order_lines;
		PRINT '>> Inserting data in the bronze.crm_order_lines table';
		BULK INSERT bronze.crm_order_lines
		FROM 'C:\Users\LENOVO\Downloads\the-book-hoarder-digital-marketing-campaign-project\crm\order_lines.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------------------------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating the bronze.crm_orders table';
		TRUNCATE TABLE bronze.crm_orders;
		PRINT '>> Inserting data in the bronze.crm_orders table';
		BULK INSERT bronze.crm_orders
		FROM 'C:\Users\LENOVO\Downloads\the-book-hoarder-digital-marketing-campaign-project\crm\orders.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------------------------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating the bronze.crm_page_views table';
		TRUNCATE TABLE bronze.crm_page_views;
		PRINT '>> Inserting data in the bronze.crm_page_views table';
		BULK INSERT bronze.crm_page_views
		FROM 'C:\Users\LENOVO\Downloads\the-book-hoarder-digital-marketing-campaign-project\crm\page_views.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------------------------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating the bronze.crm_products table';
		TRUNCATE TABLE bronze.crm_products;
		PRINT '>> Inserting data in the bronze.crm_products table';
		BULK INSERT bronze.crm_products
		FROM 'C:\Users\LENOVO\Downloads\the-book-hoarder-digital-marketing-campaign-project\crm\products.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------------------------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating the bronze.crm_web_sessions table';
		TRUNCATE TABLE bronze.crm_web_sessions;
		PRINT '>> Inserting data in the bronze.crm_web_sessions table';
		BULK INSERT bronze.crm_web_sessions
		FROM 'C:\Users\LENOVO\Downloads\the-book-hoarder-digital-marketing-campaign-project\crm\web_sessions.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------------------------------';

		PRINT '-----------------------------------------------------------------------------------------';
		PRINT 'Loading the MIS tables';
		PRINT '-----------------------------------------------------------------------------------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating the bronze.mis_campaign_clicks table';
		TRUNCATE TABLE bronze.mis_campaign_clicks;
		PRINT '>> Inserting data in the bronze.mis_campaign_clicks table';
		BULK INSERT bronze.mis_campaign_clicks
		FROM 'C:\Users\LENOVO\Downloads\the-book-hoarder-digital-marketing-campaign-project\mis\campaign_clicks.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------------------------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating the bronze.mis_campaign_impressions table';
		TRUNCATE TABLE bronze.mis_campaign_impressions;
		PRINT '>> Inserting data in the bronze.mis_campaign_impressions table';
		BULK INSERT bronze.mis_campaign_impressions
		FROM 'C:\Users\LENOVO\Downloads\the-book-hoarder-digital-marketing-campaign-project\mis\campaign_impressions.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------------------------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating the bronze.mis_campaign_spend table';
		TRUNCATE TABLE bronze.mis_campaign_spend;
		PRINT '>> Inserting data in the bronze.mis_campaign_spend table';
		BULK INSERT bronze.mis_campaign_spend
		FROM 'C:\Users\LENOVO\Downloads\the-book-hoarder-digital-marketing-campaign-project\mis\campaign_spend.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------------------------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating the bronze.mis_campaigns table';
		TRUNCATE TABLE bronze.mis_campaigns;
		PRINT '>> Inserting data in the bronze.mis_campaigns table';
		BULK INSERT bronze.mis_campaigns
		FROM 'C:\Users\LENOVO\Downloads\the-book-hoarder-digital-marketing-campaign-project\mis\campaigns.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------------------------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating the bronze.mis_channels table';
		TRUNCATE TABLE bronze.mis_channels;
		PRINT '>> Inserting data in the bronze.mis_channels table';
		BULK INSERT bronze.mis_channels
		FROM 'C:\Users\LENOVO\Downloads\the-book-hoarder-digital-marketing-campaign-project\mis\channels.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------------------------------';
		
		SET @batch_end_time = GETDATE()
		PRINT '=========================================================================================';
		PRINT 'COMPLETED: Loading the Bronze Layer';
		PRINT 'Total load duration: ' + CAST(DATEDIFF(second,@batch_start_time,@batch_end_time) AS VARCHAR) + ' seconds';
		PRINT '=========================================================================================';
	END TRY
	BEGIN CATCH
		PRINT '=========================================================================================';
		PRINT 'ERROR: Loading the Bronze Layer';
		PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
		PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS VARCHAR);
		PRINT 'ERROR STATE: ' + CAST(ERROR_STATE() AS VARCHAR);
		PRINT '=========================================================================================';
	END CATCH
END