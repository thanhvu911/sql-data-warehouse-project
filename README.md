# Retail Performance Intelligence Hub
Building a modern data warehouse with SQL Server, including ETL processes, data modeling, and analytics.

Overview
The Retail Performance Intelligence Hub is an end-to-end data solution that transforms raw transactional data into actionable business insights. Using a medallion architecture (bronze → silver → gold), this system enables retailers to optimize inventory levels, maximize sales, and enhance customer loyalty through data-driven decision making.

Key Capabilities:

📊 Real-time inventory optimization

💰 Sales performance analytics

👥 Customer loyalty scoring

📈 Category performance tracking

🚀 Predictive reordering system

Architecture:
Medallion Data Layers
Layer	Purpose	Key Datasets	Storage Format
Bronze	Raw data ingestion	brands, transactions, transaction_lines, products, customers, categories	Parquet
Silver	Data cleaning & enrichment	cleaned_transactions, enriched_products, standardized_customers, validated_sales	Delta Lake
Gold	Business-ready analytics	sales_fact, product_dim, customer_dim, time_dim, inventory_snapshot	Materialized Views
