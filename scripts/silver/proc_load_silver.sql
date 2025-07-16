/*  
---  
Stored Procedure: Load Silver Layer (Bronze -> Silver)  
---  
Script Purpose:  
This stored procedure performs the ETL (Extract, Transform, Load) process  
to populate the 'silver' schema tables from the 'bronze' schema.  

Actions Performed:  
- Truncates Silver tables.  
- Inserts transformed and cleansed data from Bronze into Silver tables.  

Parameters:  
None.  
This stored procedure does not accept any parameters or return any values.  

Usage Example:  
EXEC Silver.load_silver;  
==============================================================  
*/ 

EXEC silver.load_silver

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '=====================================';
        PRINT 'Loading Silver Layer';
        PRINT '=====================================';

        -- silver.brands
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.brands';
        TRUNCATE TABLE silver.brands;
        PRINT '>> Inserting Data Into Table: silver.brands';
        INSERT INTO silver.brands (brand_id, brand_name, category_id)
        SELECT brand_id, brand_name, category_id
        FROM bronze.brands;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> ------------------';

        -- silver.categories
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.categories';
        TRUNCATE TABLE silver.categories;
        PRINT '>> Inserting Data Into Table: silver.categories';
        INSERT INTO silver.categories (category_id, category_name)
        SELECT category_id, category_name
        FROM bronze.categories;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> ------------------';

        -- silver.customers
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.customers';
        TRUNCATE TABLE silver.customers;
        PRINT '>> Inserting Data Into Table: silver.customers';
        INSERT INTO silver.customers (
            customer_id, first_name, last_name, mobile_number,
            nationality, gender, date_of_birth, city,
            loyalty_tier, joining_date
        )
        SELECT 
            customer_id, first_name, last_name,
            CASE 
                WHEN digits_only LIKE '001%' THEN STUFF(digits_only, 1, 3, '')
                WHEN digits_only LIKE '1%' THEN STUFF(digits_only, 1, 1, '')
                ELSE digits_only
            END AS cleaned_mobile_number,
            nationality, gender, date_of_birth, city,
            loyalty_tier, joining_date
        FROM (
            SELECT *,
                digits_only = (
                    SELECT SUBSTRING(step1, n, 1)
                    FROM (
                        SELECT TOP (LEN(step1)) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
                        FROM (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) a(n),
                             (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) b(n)
                    ) AS numbers
                    WHERE SUBSTRING(step1, n, 1) LIKE '[0-9]'
                    ORDER BY n
                    FOR XML PATH('')
                )
            FROM (
                SELECT *,
                    step1 = CASE 
                        WHEN PATINDEX('%[a-zA-Z]%', mobile_number) > 0 
                        THEN LEFT(mobile_number, PATINDEX('%[a-zA-Z]%', mobile_number) - 1)
                        ELSE mobile_number
                    END
            FROM bronze.customers
            ) AS step1_table
        ) AS cleaned_table;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> ------------------';

        -- silver.products
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.products';
        TRUNCATE TABLE silver.products;
        PRINT '>> Inserting Data Into Table: silver.products';
        INSERT INTO silver.products (product_id, product_name, brand_id, category_id, price)
        SELECT product_id, product_name, brand_id, category_id, price
        FROM bronze.products;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> ------------------';

        -- silver.transactions
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.transactions';
        TRUNCATE TABLE silver.transactions;
        PRINT '>> Inserting Cleaned Data Into Table: silver.transactions';
        INSERT INTO silver.transactions (
            transaction_id, customer_id, total_amount, transactions_date, transactions_status, vendor_id
        )
        SELECT
            transaction_id,
            customer_id,
            total_amount,
            transactions_date,
            CASE 
                WHEN transactions_status LIKE 'Completed%' THEN 'Completed'
                WHEN transactions_status LIKE 'Pending%' THEN 'Pending'
                WHEN transactions_status LIKE 'Failed%' THEN 'Failed'
                ELSE transactions_status
            END AS transactions_status,
            vendor_id
        FROM bronze.transactions;

        DELETE FROM silver.transactions
        WHERE transactions_status IN ('Pending', 'Failed');
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> ------------------';

        -- silver.transaction_lines
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.transaction_lines';
        TRUNCATE TABLE silver.transaction_lines;
        PRINT '>> Inserting Cleaned Data Into Table: silver.transaction_lines';
        INSERT INTO silver.transaction_lines (
            transaction_line_id, transaction_id, product_id, price
        )
        SELECT tl.transaction_line_id, tl.transaction_id, tl.product_id, tl.price
        FROM bronze.transaction_lines tl
        WHERE EXISTS (
            SELECT 1
            FROM silver.transactions t
            WHERE t.transaction_id = tl.transaction_id
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> ------------------';

        SET @batch_end_time = GETDATE();
        PRINT '=====================================';
        PRINT 'Loading Silver Layer is Completed';
        PRINT '>> Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '=====================================';

    END TRY
    BEGIN CATCH
        PRINT '=====================================';
        PRINT 'ERROR OCCURRED DURING LOADING SILVER LAYER';
        PRINT ERROR_MESSAGE();
        PRINT '=====================================';
    END CATCH
END;
