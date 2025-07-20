/*  
***************************************************************  
Quality Checks by Table  
***************************************************************  

Script Purpose:  
    This script performs structured quality checks for data consistency, accuracy,  
    and standardization across each table in the 'silver' and 'bronze' schemas.  

Instructions:
    - Run this script after loading data into the Silver Layer.
    - Each section prints the table name and runs a series of checks specific to that table.
    - Expectation: No rows returned means the table passes validation.
*/

/* ===========================
   TABLE: bronze.brands
   =========================== */
PRINT 'Checking bronze.brands'

-- Null or duplicate brand_id
SELECT brand_id, COUNT(*) 
FROM bronze.brands 
GROUP BY brand_id 
HAVING COUNT(*) > 1 OR brand_id IS NULL;

-- Unwanted spaces
SELECT * 
FROM bronze.brands
WHERE brand_id != TRIM(brand_id)
   OR brand_name != TRIM(brand_name)
   OR category_id != TRIM(category_id);

-- Invalid category_id reference (should exist in categories and products)
SELECT brand_id, brand_name, category_id
FROM bronze.brands
WHERE category_id NOT IN (SELECT DISTINCT category_id FROM bronze.categories);

SELECT brand_id, brand_name, category_id
FROM bronze.brands
WHERE category_id NOT IN (SELECT DISTINCT category_id FROM bronze.products);


/* ===========================
   TABLE: bronze.categories
   =========================== */
PRINT 'Checking bronze.categories'

-- Null or duplicate category_id
SELECT category_id, COUNT(*) 
FROM bronze.categories 
GROUP BY category_id 
HAVING COUNT(*) > 1 OR category_id IS NULL;

-- Unwanted spaces
SELECT * 
FROM bronze.categories
WHERE category_id != TRIM(category_id)
   OR category_name != TRIM(category_name);


/* ===========================
   TABLE: bronze.customers
   =========================== */
PRINT 'Checking bronze.customers'

-- Null or duplicate customer_id
SELECT customer_id, COUNT(*) 
FROM bronze.customers 
GROUP BY customer_id 
HAVING COUNT(*) > 1 OR customer_id IS NULL;

-- Unwanted spaces
SELECT * 
FROM bronze.customers
WHERE customer_id != TRIM(customer_id)
   OR first_name != TRIM(first_name)
   OR last_name != TRIM(last_name)
   OR gender != TRIM(gender)
   OR nationality != TRIM(nationality)
   OR loyalty_tier != TRIM(loyalty_tier);

-- Unexpected values in gender
SELECT DISTINCT gender 
FROM bronze.customers;

-- Unexpected values in loyalty tier
SELECT DISTINCT loyalty_tier 
FROM bronze.customers;

-- Check invalid nationalities in silver layer
SELECT DISTINCT nationality
FROM silver.customers
ORDER BY nationality;


/* ===========================
   TABLE: bronze.products
   =========================== */
PRINT 'Checking bronze.products'

-- Null or duplicate product_id
SELECT product_id, COUNT(*) 
FROM bronze.products 
GROUP BY product_id 
HAVING COUNT(*) > 1 OR product_id IS NULL;

-- Unwanted spaces
SELECT * 
FROM bronze.products
WHERE product_id != TRIM(product_id)
   OR product_name != TRIM(product_name)
   OR brand_id != TRIM(brand_id)
   OR category_id != TRIM(category_id);


/* ===========================
   TABLE: bronze.transaction_lines
   =========================== */
PRINT 'Checking bronze.transaction_lines'

-- Null or duplicate transaction_line_id
SELECT transaction_line_id, COUNT(*) 
FROM bronze.transaction_lines 
GROUP BY transaction_line_id 
HAVING COUNT(*) > 1 OR transaction_line_id IS NULL;

-- Unwanted spaces
SELECT * 
FROM bronze.transaction_lines
WHERE transaction_line_id != TRIM(transaction_line_id)
   OR transaction_id != TRIM(transaction_id)
   OR product_id != TRIM(product_id);

-- transaction_id reference integrity
SELECT transaction_line_id, transaction_id, product_id
FROM bronze.transaction_lines
WHERE transaction_id NOT IN 
(SELECT DISTINCT transaction_id FROM bronze.transactions);


/* ===========================
   TABLE: bronze.transactions
   =========================== */
PRINT 'Checking bronze.transactions'

-- Null or duplicate transaction_id
SELECT transaction_id, COUNT(*) 
FROM bronze.transactions 
GROUP BY transaction_id 
HAVING COUNT(*) > 1 OR transaction_id IS NULL;

-- Unwanted spaces
SELECT * 
FROM bronze.transactions
WHERE transaction_id != TRIM(transaction_id)
   OR customer_id != TRIM(customer_id)
   OR transactions_status != TRIM(transactions_status)
   OR vendor_id != TRIM(vendor_id);


/* ===========================
   TABLE: silver.transactions
   =========================== */
PRINT 'Checking silver.transactions'

-- Transactions dated in the future
SELECT * 
FROM silver.transactions
WHERE transactions_date >= GETDATE();
