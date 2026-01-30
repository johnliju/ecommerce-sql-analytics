# E-commerce Customer Behavior and Revenue Optimization Analysis (SQL Project)

## Project Overview

This project is a comprehensive,  SQL piece designed to showcase advanced data analysis and business intelligence skills within the **E-commerce** domain. It focuses on transforming raw transactional data into actionable business insights, which is a core competency for any Data Scientist or Data Analyst.

The primary goal is to analyze customer behavior and optimize revenue by calculating and interpreting key performance indicators (KPIs) using advanced SQL techniques.

## Business Value and Data Science Focus

The project addresses critical business questions faced by E-commerce companies, demonstrating the ability to:
*   **Measure Growth:** Track and analyze monthly revenue trends and growth rates.
*   **Segment Customers:** Identify high-value, loyal, and at-risk customers for targeted marketing campaigns.
*   **Assess Retention:** Understand how customer cohorts behave over time to improve long-term profitability.
*   **Optimize Inventory/Marketing:** Discover product relationships to inform bundling strategies and personalized recommendations.
*   **Predict Churn:** Proactively identify inactive customers to reduce churn and increase Customer Lifetime Value (CLV).

## Database Schema

The relational database is designed to model a typical E-commerce platform, ensuring data integrity and facilitating complex joins for deep analysis.

| Table Name | Description | Key Columns | Relationships |
| :--- | :--- | :--- | :--- |
| `customers` | Stores customer demographic and registration data. | `customer_id` (PK), `signup_date`, `country` | 1:N with `orders` |
| `products` | Contains product details and inventory information. | `product_id` (PK), `product_name`, `category`, `price` | 1:N with `order_items`, `reviews` |
| `orders` | Records transaction-level data. | `order_id` (PK), `customer_id`, `order_date`, `total_amount`, `status` | N:1 with `customers` |
| `order_items` | Details the products within each order (line items). | `order_item_id` (PK), `order_id`, `product_id`, `quantity`, `unit_price` | N:1 with `orders`, `products` |
| `reviews` | Captures customer feedback and ratings for products. | `review_id` (PK), `product_id`, `customer_id`, `rating` | N:1 with `products`, `customers` |

## Advanced SQL Analysis

The `analytics_queries.sql` file contains six complex queries that leverage advanced SQL features to derive critical business metrics.

### 1. Monthly Revenue Growth Rate
**SQL Technique:** Common Table Expressions (CTEs) and **Window Functions** (`LAG`).
**Business Insight:** This query calculates the month-over-month percentage change in revenue. It is essential for tracking business performance, identifying seasonal trends, and measuring the impact of marketing initiatives.

### 2. Customer Lifetime Value (CLV) Analysis
**SQL Technique:** Aggregation, Joins, and **Window Functions** (`RANK`).
**Business Insight:** CLV is a key metric for understanding the long-term value of a customer. By ranking customers based on their total spend, the business can identify its most valuable customers (VIPs) and allocate resources for retention and personalized offers.

### 3. Cohort Analysis (Retention Rate)
**SQL Technique:** Complex CTEs, Date Manipulation (`strftime`), and self-joins.
**Business Insight:** This analysis groups customers by their acquisition month (cohort) and tracks their retention rate in subsequent months. It provides a clear picture of product stickiness and the long-term quality of customer acquisition channels.

### 4. RFM Segmentation (Recency, Frequency, Monetary)
**SQL Technique:** CTEs, Date Arithmetic, and **Window Functions** (`NTILE`).
**Business Insight:** RFM is a powerful customer segmentation model. Customers are scored from 1 to 5 on three dimensions:
*   **Recency:** How recently they purchased.
*   **Frequency:** How often they purchase.
*   **Monetary:** How much they spend.
The final score is used to segment customers into actionable groups like 'Champions', 'Loyal Customers', and 'At Risk', enabling highly targeted marketing strategies.

### 5. Product Affinity Analysis (Market Basket Analysis)
**SQL Technique:** **Self-Join** on the `order_items` table.
**Business Insight:** By identifying which products are frequently purchased together, the business can create effective product bundles, optimize store layout/recommendation engines, and increase the Average Order Value (AOV).

### 6. Churn Prediction (Inactive Customers)
**SQL Technique:** Date Arithmetic (`julianday`) and Filtering (`HAVING`).
**Business Insight:** This query identifies customers who have not made a purchase in over 90 days. This list serves as a high-priority target for re-engagement campaigns, which is a cost-effective way to recover lost revenue compared to acquiring new customers.

## Setup and Usage

### Prerequisites
*   Python 3.x
*   `pandas` library (`pip install pandas`)
*   SQLite (or any SQL environment to adapt the queries)

### Files Included
*   `schema.sql`: The complete database schema for creating the tables.
*   `generate_data.py`: Python script to generate realistic, synthetic E-commerce data (customers, products, orders, etc.) and save it as CSV files.
*   `analytics_queries.sql`: The core deliverable, containing the 6 advanced SQL queries.
*   `load_data.py`: Python script to create the SQLite database (`ecommerce.db`) and load the CSV data into the tables.

### Instructions
1.  **Generate Data:** Run the Python script to create the CSV files:
    ```bash
    python3 generate_data.py
    ```
2.  **Setup Database:** Run the data loading script to create the `ecommerce.db` SQLite file and populate the tables:
    ```bash
    python3 load_data.py
    ```
3.  **Run Analysis:** Connect to the `ecommerce.db` file using a SQLite client and execute the queries in `analytics_queries.sql` to perform the analysis.

## Technologies Used
*   **SQL (SQLite Dialect)**: For database definition and advanced analytics.
*   **Python (Pandas)**: For synthetic data generation and database setup.
*   **Relational Database Design**: For creating a normalized, production-ready schema.
