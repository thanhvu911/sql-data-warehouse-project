/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_products AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY product_id) AS product_key,
	pd.product_id,
	pd.category_id,
	pd.brand_id,
	pd.product_name,
	c.category_name,
	b.brand_name,
	pd.price
FROM silver.products pd
LEFT JOIN silver.brands b ON pd.brand_id = b.brand_id
LEFT JOIN silver.categories c on pd.category_id = c.category_id
GO

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY joining_date) AS customer_key,
	c.customer_id,
	c.first_name,
	c.last_name,
	c.gender,
	c.mobile_number,
	c.date_of_birth,
	c.city,
	c.nationality,
	c.joining_date,
	c.loyalty_tier
FROM silver.customers c
GO

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
	tl.transaction_line_id,
	dc.customer_key,
	dp.product_key,
	t.transaction_id,
	t.transactions_date,
	tl.price,
	t.total_amount
FROM silver.transaction_lines tl
LEFT JOIN silver.transactions t on tl.transaction_id = t.transaction_id
LEFT JOIN gold.dim_customers dc on t.customer_id = dc.customer_id
LEFT JOIN gold.dim_products dp on tl.product_id = dp.product_id
GO
