-- Advanced E-commerce Analytics Queries

-- 1. Monthly Revenue Growth Rate
-- Demonstrates: Window functions (LAG), CTEs, and arithmetic operations.
WITH MonthlyRevenue AS (
    SELECT 
        strftime('%Y-%m', order_date) AS month,
        SUM(total_amount) AS revenue
    FROM orders
    WHERE status = 'Completed'
    GROUP BY 1
)
SELECT 
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
    ROUND(((revenue - LAG(revenue) OVER (ORDER BY month)) / LAG(revenue) OVER (ORDER BY month)) * 100, 2) AS growth_rate_pct
FROM MonthlyRevenue;


-- 2. Customer Lifetime Value (CLV) Analysis
-- Demonstrates: Aggregations, Joins, and ranking.
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    ROUND(SUM(o.total_amount) / COUNT(o.order_id), 2) AS avg_order_value,
    RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS clv_rank
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'Completed'
GROUP BY 1, 2
ORDER BY total_spent DESC
LIMIT 10;


-- 3. Cohort Analysis (Retention Rate)
-- Demonstrates: Complex CTEs, Date manipulation, and self-joins/subqueries.
WITH CustomerCohorts AS (
    -- Group customers by their first purchase month
    SELECT 
        customer_id,
        strftime('%Y-%m', MIN(order_date)) AS cohort_month
    FROM orders
    WHERE status = 'Completed'
    GROUP BY 1
),
OrderMonths AS (
    -- Get all months each customer made a purchase
    SELECT DISTINCT
        customer_id,
        strftime('%Y-%m', order_date) AS order_month
    FROM orders
    WHERE status = 'Completed'
),
CohortSizes AS (
    -- Count total customers in each cohort
    SELECT 
        cohort_month,
        COUNT(customer_id) AS cohort_size
    FROM CustomerCohorts
    GROUP BY 1
),
Retention AS (
    -- Calculate how many customers from each cohort returned in subsequent months
    SELECT 
        c.cohort_month,
        o.order_month,
        COUNT(DISTINCT o.customer_id) AS active_customers
    FROM CustomerCohorts c
    JOIN OrderMonths o ON c.customer_id = o.customer_id
    GROUP BY 1, 2
)
SELECT 
    r.cohort_month,
    r.order_month,
    r.active_customers,
    s.cohort_size,
    ROUND((CAST(r.active_customers AS FLOAT) / s.cohort_size) * 100, 2) AS retention_rate_pct
FROM Retention r
JOIN CohortSizes s ON r.cohort_month = s.cohort_month
ORDER BY r.cohort_month, r.order_month;


-- 4. RFM Segmentation (Recency, Frequency, Monetary)
-- Demonstrates: NTILE for scoring, CTEs, and business logic implementation.
WITH RFM_Base AS (
    SELECT 
        customer_id,
        MAX(order_date) AS last_order_date,
        COUNT(order_id) AS frequency,
        SUM(total_amount) AS monetary
    FROM orders
    WHERE status = 'Completed'
    GROUP BY 1
),
RFM_Scores AS (
    SELECT 
        customer_id,
        -- Recency: Lower date difference is better (higher score)
        -- Note: Using '2026-01-01' as the reference date for the project
        NTILE(5) OVER (ORDER BY last_order_date ASC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
    FROM RFM_Base
)
SELECT 
    customer_id,
    r_score, f_score, m_score,
    (r_score + f_score + m_score) AS total_rfm_score,
    CASE 
        WHEN (r_score + f_score + m_score) >= 13 THEN 'Champions'
        WHEN (r_score + f_score + m_score) >= 10 THEN 'Loyal Customers'
        WHEN (r_score + f_score + m_score) >= 7 THEN 'At Risk'
        ELSE 'Lost'
    END AS customer_segment
FROM RFM_Scores
ORDER BY total_rfm_score DESC;


-- 5. Product Affinity Analysis (Market Basket Analysis)
-- Demonstrates: Self-joins and frequency counting.
SELECT 
    p1.product_name AS product_a,
    p2.product_name AS product_b,
    COUNT(*) AS times_bought_together
FROM order_items oi1
JOIN order_items oi2 ON oi1.order_id = oi2.order_id AND oi1.product_id < oi2.product_id
JOIN products p1 ON oi1.product_id = p1.product_id
JOIN products p2 ON oi2.product_id = p2.product_id
GROUP BY 1, 2
ORDER BY times_bought_together DESC
LIMIT 10;


-- 6. Churn Prediction (Inactive Customers)
-- Demonstrates: Date arithmetic and filtering.
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    MAX(o.order_date) AS last_purchase_date,
    julianday('2026-01-01') - julianday(MAX(o.order_date)) AS days_since_last_purchase
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY 1, 2
HAVING days_since_last_purchase > 90
ORDER BY days_since_last_purchase DESC;
