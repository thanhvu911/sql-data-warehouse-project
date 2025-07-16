/*DDL Script: Create Silver Tables  
---  
Script Purpose:  
    This script creates tables in the 'silver' schema, dropping existing tables if they already exist.  
    Run this script to re-define the DDL structure of 'silver' tables  
*/

IF OBJECT_ID('silver.brands','U') IS NOT NULL
    DROP TABLE silver.brands;
-- Brands table
CREATE TABLE silver.brands (
    brand_id NVARCHAR(50),
    brand_name NVARCHAR(50),
    category_id NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('silver.transactions','U') IS NOT NULL
    DROP TABLE silver.transactions;
-- Transactions table
CREATE TABLE silver.transactions (
    transaction_id NVARCHAR(100),
    customer_id NVARCHAR(50),
    total_amount DECIMAL(10,2), 
    transactions_date DATE,
    transactions_status NVARCHAR(50),
    vendor_id NVARCHAR(100),
    dwh_create_date DATETIME2 DEFAULT GETDATE()

);

IF OBJECT_ID('silver.transaction_lines','U') IS NOT NULL
    DROP TABLE silver.transaction_lines;
-- Transaction Lines table
CREATE TABLE silver.transaction_lines (
    transaction_line_id NVARCHAR(100),
    transaction_id NVARCHAR(100),
    product_id NVARCHAR(100),
    price DECIMAL(10,2),
    dwh_create_date DATETIME2 DEFAULT GETDATE()

);

IF OBJECT_ID('silver.products','U') IS NOT NULL
    DROP TABLE silver.products;
-- Products table
CREATE TABLE silver.products (
    product_id NVARCHAR(50),
    product_name NVARCHAR(255),
    brand_id NVARCHAR(50),
    category_id NVARCHAR(50),
    price DECIMAL(10,2),
    dwh_create_date DATETIME2 DEFAULT GETDATE()

);

IF OBJECT_ID('silver.customers','U') IS NOT NULL
    DROP TABLE silver.customers;
-- Customers table
CREATE TABLE silver.customers (
    customer_id NVARCHAR(50),
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    mobile_number NVARCHAR(100),
    nationality NVARCHAR(100),
    gender NVARCHAR(10),
    date_of_birth DATE,
    city NVARCHAR(100),
    loyalty_tier NVARCHAR(20),
    joining_date DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()

);

IF OBJECT_ID('silver.categories','U') IS NOT NULL
    DROP TABLE silver.categories;
-- Categories table
CREATE TABLE silver.categories (
    category_id NVARCHAR(50),
    category_name NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()

);
