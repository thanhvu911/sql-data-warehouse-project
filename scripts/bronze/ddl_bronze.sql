/*DDL Script: Create Bronze Tables  
---  
Script Purpose:  
    This script creates tables in the 'bronze' schema, dropping existing tables if they already exist.  
    Run this script to re-define the DDL structure of 'bronze' tables  
*/

IF OBJECT_ID('bronze.brands','U') IS NOT NULL
    DROP TABLE bronze.brands;
-- Brands table
CREATE TABLE bronze.brands (
    brand_id NVARCHAR(50),
    brand_name NVARCHAR(50),
    category_id NVARCHAR(50),
);

IF OBJECT_ID('bronze.transactions','U') IS NOT NULL
    DROP TABLE bronze.transactions;
-- Transactions table
CREATE TABLE bronze.transactions (
    transaction_id NVARCHAR(100),
    customer_id NVARCHAR(50),
    total_amount DECIMAL(10,2), 
    transactions_date DATE,
    transactions_status NVARCHAR(50),
    vendor_id NVARCHAR(100),
);

IF OBJECT_ID('bronze.transaction_lines','U') IS NOT NULL
    DROP TABLE bronze.transaction_lines;
-- Transaction Lines table
CREATE TABLE bronze.transaction_lines (
    transaction_line_id NVARCHAR(100),
    transaction_id NVARCHAR(100),
    product_id NVARCHAR(100),
    price DECIMAL(10,2)
);

IF OBJECT_ID('bronze.products','U') IS NOT NULL
    DROP TABLE bronze.products;
-- Products table
CREATE TABLE bronze.products (
    product_id NVARCHAR(50),
    product_name NVARCHAR(255),
    brand_id NVARCHAR(50),
    category_id NVARCHAR(50),
    price DECIMAL(10,2)         
);

IF OBJECT_ID('bronze.customers','U') IS NOT NULL
    DROP TABLE bronze.customers;
-- Customers table
CREATE TABLE bronze.customers (
    customer_id NVARCHAR(50),
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    mobile_number NVARCHAR(100),
    nationality NVARCHAR(100),
    gender NVARCHAR(10),
    date_of_birth DATE,
    city NVARCHAR(100),
    loyalty_tier NVARCHAR(20),
    joining_date DATE
);

IF OBJECT_ID('bronze.categories','U') IS NOT NULL
    DROP TABLE bronze.categories;
-- Categories table
CREATE TABLE bronze.categories (
    category_id NVARCHAR(50),
    category_name NVARCHAR(50)
);
