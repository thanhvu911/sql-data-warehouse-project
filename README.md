# Retail Performance Intelligence Hub
Building a modern data warehouse with SQL Server, including ETL processes, data modeling.

Overview
The Retail Performance Intelligence Hub is an end-to-end data solution that transforms raw transactional data into actionable business insights. Using a medallion architecture (bronze → silver → gold), this system enables retailers to optimize inventory levels, maximize sales, and enhance customer loyalty through data-driven decision making.

Key Capabilities:

📊 Real-time inventory optimization

💰 Sales performance analytics

👥 Customer loyalty scoring

📈 Category performance tracking

Architecture:
Medallion Data Layers
Layer	Purpose	Key Datasets	Storage Format
Bronze	Raw data ingestion	brands, transactions, transaction_lines, products, customers, categories
Silver	Data cleaning & enrichment	cleaned_transactions, enriched_products, standardized_customers, validated_sales
Gold	Business-ready analytics	sales_fact, product_dim, customer_dim inventory_snapshot	Materialized Views
<img width="1069" height="749" alt="DataArchitecture drawio" src="https://github.com/user-attachments/assets/3aa1f42b-d18a-4559-8154-73d913bfb5f3" />

How to Use
Clone the repository and set up your SQL Server environment.
Ingest raw data into the Bronze layer using SQL scripts.
Transform and enrich data in the Silver layer.
Model the Gold layer into fact and dimension tables optimized for reporting.
Query the Gold layer or use BI tools to extract insights.

Project Structure
datasets/ — Raw dataset files (e.g. transactional, product, customer data)
scripts/ — ETL scripts divided by layer: Bronze, Silver, Gold
Materialized views to support fast, analytics-ready queries
Database schema and migration scripts (if provided)
