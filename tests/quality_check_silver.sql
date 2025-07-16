/*  
***************************************************************  
Quality Checks  
***************************************************************  

Script Purpose:  
    This script performs various quality checks for data consistency, accuracy,  
    and standardization across the 'silver' schema. It includes checks for:  
    - Null or duplicate primary keys.  
    - Unwanted spaces in string fields.  
    - Data standardization and consistency.  
    - Invalid date ranges and orders.  
    - Data consistency between related fields.  

Usage Notes:  
    - Run these checks after data loading into the Silver Layer.  
    - Investigate and resolve any discrepancies found during the checks.  
*/  

-- Check unmatched data among bronze.brands and bronze.categories and bronze.products
SELECT 
    brand_id,
    brand_name,
    category_id
FROM bronze.brands
WHERE category_id NOT IN 
(SELECT distinct category_id from bronze.categories)

SELECT 
    brand_id,
    brand_name,
    category_id
FROM bronze.brands
WHERE category_id NOT IN 
(SELECT distinct category_id from bronze.products)

-- check if transaction date is later than today
SELECT * 
FROM silver.transactions
WHERE transactions_date >=  GETDATE()

-- check for invalid nationality in customer
SELECT DISTINCT nationality
FROM silver.customers
ORDER BY nationality

-- check for invalid transaction_id
SELECT 
    transaction_line_id,
    transaction_id,
    product_id
FROM bronze.transaction_lines
WHERE transaction_id NOT IN 
(SELECT distinct transaction_id from bronze.transactions)

-- Check for unwanted Spaces
-- Expectation: No Results

SELECT brand_id
FROM bronze.brands
WHERE brand_id != TRIM(brand_id) OR brand_name != TRIM(brand_name) OR category_id != TRIM(category_id)

SELECT category_id
FROM bronze.categories
WHERE category_id != TRIM(category_id) OR category_name != TRIM(category_name)

SELECT customer_id
FROM bronze.customers
WHERE customer_id != TRIM(customer_id)  OR first_name != TRIM(first_name) OR last_name != TRIM(last_name) OR gender != TRIM(gender) OR loyalty_tier != TRIM(loyalty_tier) OR nationality != TRIM(nationality)

SELECT brand_id
FROM bronze.brands
WHERE brand_id != TRIM(brand_id) OR brand_name != TRIM(brand_name) OR category_id != TRIM(category_id)

SELECT product_id
FROM bronze.products
WHERE product_id != TRIM(product_id) OR product_name != TRIM(product_name) OR brand_id != TRIM(brand_id) OR category_id != TRIM(category_id)

SELECT transaction_line_id
FROM bronze.transaction_lines
WHERE transaction_line_id != TRIM(transaction_line_id) OR transaction_id != TRIM(transaction_id) OR product_id != TRIM(product_id)

SELECT transaction_id
FROM bronze.transactions
WHERE transaction_id != TRIM(transaction_id) OR customer_id != TRIM(customer_id) OR transactions_status != TRIM(transactions_status) OR vendor_id != TRIM(vendor_id)

-- Date Standardization & Consistency
SELECT DISTINCT gender
FROM bronze.customers

SELECT DISTINCT loyalty_tier
FROM bronze.customers

-- Check For Null or Duplicates in Primary Key
-- Expectation: No Result
SELECT * FROM bronze.brands

SELECT brand_id,
COUNT (*)
FROM bronze.brands
GROUP BY brand_id
HAVING COUNT(*) > 1 OR brand_id IS NULL

SELECT * FROM bronze.categories

SELECT category_id,
COUNT (*)
FROM bronze.categories
GROUP BY category_id
HAVING COUNT(*) > 1 OR category_id IS NULL

SELECT * FROM bronze.customers

SELECT customer_id,
COUNT (*)
FROM bronze.customers
GROUP BY customer_id
HAVING COUNT(*) > 1 OR customer_id IS NULL

SELECT * FROM bronze.products

SELECT product_id,
COUNT (*)
FROM bronze.products
GROUP BY product_id
HAVING COUNT(*) > 1 OR product_id IS NULL

SELECT * FROM bronze.transaction_lines

SELECT transaction_line_id,
COUNT (*)
FROM bronze.transaction_lines
GROUP BY transaction_line_id
HAVING COUNT(*) > 1 OR transaction_line_id IS NULL

SELECT * FROM bronze.transactions

SELECT transaction_id,
COUNT (*)
FROM bronze.transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1 OR transaction_id IS NULL
