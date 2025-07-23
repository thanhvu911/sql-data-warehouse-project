### Data Catalog for Gold Layer

#### Overview  
The Gold Layer contains refined business-level data optimized for analytics and reporting, featuring dimension tables for business entities and fact tables for transactional metrics.

---

### 1. **gold.dim_customers**  
- **Purpose:** Stores master customer data including demographic details, location, and loyalty status.  
- **Columns:**  

| Column Name       | Data Type       | Description                                                                 |
|-------------------|-----------------|-----------------------------------------------------------------------------|
| customer_key      | BIGINT          | Unique surrogate key for customer records (primary key).                    |
| customer_id       | NVARCHAR(50)    | Business identifier for the customer.                                       |
| first_name        | NVARCHAR(50)    | Legal first name of the customer.                                           |
| last_name         | NVARCHAR(50)    | Legal last name or surname of the customer.                                 |
| gender            | NVARCHAR(10)    | Gender identity (e.g., `Male`, `Female`).                                   |
| mobile_number     | NVARCHAR(100)   | Contact mobile number.                                                      |
| date_of_birth     | DATE            | Customer's birth date (format: `YYYY-MM-DD`).                               |
| city              | NVARCHAR(100)   | City of residence .                                                         |
| nationality       | NVARCHAR(100)   | Nationality or country of origin.                                           |
| joining_date      | DATE            | Date when the customer registered/enrolled (format: `YYYY-MM-DD`).          |
| loyalty_tier      | NVARCHAR(20)    | Customer's current loyalty status (e.g., `Silver`, `Gold`, `Platinum`).     |

---

### 2. **gold.dim_products**  
- **Purpose:** Defines product attributes including categorization, branding, and pricing.  
- **Columns:**  

| Column Name     | Data Type       | Description                                                                 |
|-----------------|-----------------|-----------------------------------------------------------------------------|
| product_key     | BIGINT          | Unique surrogate key for product records (primary key).                     |
| product_id      | NVARCHAR(50)    | Business identifier for the product.                                        |
| category_id     | NVARCHAR(50)    | Identifier for the product category.                                        |
| brand_id        | NVARCHAR(50)    | Identifier for the product brand.                                           |
| product_name    | NVARCHAR(255)   | Descriptive name/title of the product.                                      |
| category_name   | NVARCHAR(50)    | High-level classification.                                                  |
| brand_name      | NVARCHAR(50)    | Brand associated with the product.                                          |
| price           | DECIMAL(10,2)   | Current retail price per unit.                                              |

---

### 3. **gold.fact_sales**  
- **Purpose:** Tracks transactional sales data at the line-item granularity.  
- **Columns:**  

| Column Name          | Data Type       | Description                                                                 |
|----------------------|-----------------|-----------------------------------------------------------------------------|
| transaction_line_id  | NVARCHAR(100)   | Unique identifier for each line item in a transaction.                      |
| customer_key         | BIGINT          | Foreign key linking to `dim_customers` (identifies purchasing customer).    |
| product_key          | BIGINT          | Foreign key linking to `dim_products` (identifies purchased product).       |
| transaction_id       | NVARCHAR(100)   | Identifier for the overall sales transaction.                               |
| transactions_date    | DATE            | Date of the sale (format: `YYYY-MM-DD`).                                    |
| price                | DECIMAL(10,2)   | Unit price of the product at the time of sale.                              |
| total_amount         | DECIMAL(10,2)   | Final amount paid for the line item.                                        |

---

### Key Relationships  
- **`fact_sales.customer_key` → `dim_customers.customer_key`**  
  Links sales transactions to customer profiles.  
- **`fact_sales.product_key` → `dim_products.product_key`**  
  Associates sales line items with product details.