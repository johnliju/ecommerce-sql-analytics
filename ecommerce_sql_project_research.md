# E-commerce SQL Project Research Findings

## Project Theme: Customer Behavior Analysis and Revenue Optimization

### Key Analytics & Metrics
1.  **Cohort Analysis**: Tracking customer retention over time by grouping users based on their first purchase month.
2.  **Customer Lifetime Value (CLV)**: Estimating the total revenue a customer will generate during their relationship with the business.
3.  **Churn Rate**: Identifying customers who haven't made a purchase in a specific period (e.g., 30, 60, 90 days).
4.  **RFM Analysis (Recency, Frequency, Monetary)**: Segmenting customers based on how recently they bought, how often they buy, and how much they spend.
5.  **Product Affinity Analysis**: Identifying products often bought together (Market Basket Analysis).
6.  **Sales Performance Trends**: Daily/Monthly revenue growth, Average Order Value (AOV), and top-performing categories.

### Recommended Database Schema
-   **Users/Customers**: `customer_id`, `first_name`, `last_name`, `email`, `signup_date`, `country`.
-   **Products**: `product_id`, `product_name`, `category`, `price`, `stock_quantity`.
-   **Orders**: `order_id`, `customer_id`, `order_date`, `total_amount`, `status`.
-   **Order_Items**: `order_item_id`, `order_id`, `product_id`, `quantity`, `unit_price`.
-   **Reviews**: `review_id`, `product_id`, `customer_id`, `rating`, `review_date`.

### Advanced SQL Techniques to Showcase
-   **Common Table Expressions (CTEs)** for readable and modular queries.
-   **Window Functions** (`RANK`, `DENSE_RANK`, `SUM() OVER`, `LAG/LEAD`) for trend analysis and ranking.
-   **Aggregate Functions** with `GROUP BY` and `HAVING`.
-   **Subqueries and Joins** for complex data retrieval.
-   **Date/Time Functions** for cohort and churn analysis.
-   **Case Statements** for customer segmentation.
