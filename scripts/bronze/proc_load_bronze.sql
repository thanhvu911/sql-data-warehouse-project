/*
====================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
====================================================================================

Script Purpose:
This stored procedure loads data into the 'bronze' schema from external CSV files.
It performs the following actions:
  - Truncates the bronze tables before loading data.
  - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
  None.
  This stored procedure does not accept any parameters or return any values.

Usage Example:
  EXEC bronze.load_bronze;

====================================================================================
*/

EXEC bronze.load_bronze

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT'====================================='
		PRINT'Loading Bronze Layer'
		PRINT'====================================='

		SET @start_time = GETDATE();
		PRINT'>> Truncating Table: bronze.brands'
		TRUNCATE TABLE bronze.brands;

		BULK INSERT bronze.brands
		FROM 'C:\Users\Admin\Downloads\grocery transaction\brands_dataset.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			KEEPNULLS,
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) +' seconds';
		PRINT '>> ------------------';

		SET @start_time = GETDATE();
		PRINT'>> Truncating Table: bronze.categories'
		TRUNCATE TABLE bronze.categories;

		PRINT'>> Inserting Data Into: bronze.categories'
		BULK INSERT bronze.categories
		FROM 'C:\Users\Admin\Downloads\grocery transaction\categories_dataset.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			KEEPNULLS,
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) +' seconds';
		PRINT '>> ------------------';

		SET @start_time = GETDATE();
		PRINT'>> Truncating Table: bronze.customers'
		TRUNCATE TABLE bronze.customers;

		PRINT'>> Inserting Data Into: bronze.customers'
		BULK INSERT bronze.customers
		FROM 'C:\Users\Admin\Downloads\grocery transaction\customers_dataset.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0A',  -- CRLF (Windows-style line endings)
			KEEPNULLS,
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) +' seconds';
		PRINT '>> ------------------';

		SET @start_time = GETDATE();
		PRINT'>> Truncating Table: bronze.products'
		TRUNCATE TABLE bronze.products;

		PRINT'>> Inserting Data Into: bronze.products'
		BULK INSERT bronze.products
		FROM 'C:\Users\Admin\Downloads\grocery transaction\products_dataset.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			KEEPNULLS,
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) +' seconds';
		PRINT '>> ------------------';

		SET @start_time = GETDATE();
		PRINT'>> Truncating Table: bronze.transaction_lines'
		TRUNCATE TABLE bronze.transaction_lines;

		PRINT'>> Inserting Data Into: bronze.transaction_lines'
		BULK INSERT bronze.transaction_lines
		FROM 'C:\Users\Admin\Downloads\grocery transaction\transaction_lines_dataset.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0A', -- CRLF (Windows-style line endings)
			KEEPNULLS,
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) +' seconds';
		PRINT '>> ------------------';

		SET @start_time = GETDATE();
		PRINT'>> Truncating Table: bronze.transaction'
		TRUNCATE TABLE bronze.transactions;

		PRINT'>> Inserting Data Into: bronze.transactions'
		BULK INSERT bronze.transactions
		FROM 'C:\Users\Admin\Downloads\grocery transaction\transactions_dataset.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0A',
			KEEPNULLS,
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) +' seconds';
		PRINT '>> ------------------';
	SET @batch_end_time = GETDATE();
		PRINT '====================================='
		PRINT 'Loading Bronze Layer is Completed'
		PRINT '>> Total Load Duration:' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) +' seconds';
		PRINT '====================================='


	END TRY
	BEGIN CATCH 
		PRINT '====================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'ERROR MESSAGE' + ERROR_MESSAGE();
		PRINT '====================================='
	END CATCH
END
