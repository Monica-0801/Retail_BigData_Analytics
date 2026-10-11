USE retail_db;

-- 1. Total revenue by product category
SELECT
    product_category,
    SUM(sales_amount_inr) AS total_revenue_inr
FROM retail_transactions
GROUP BY product_category
ORDER BY total_revenue_inr DESC, product_category;

-- 2. Monthly sales analysis
SELECT
    DATE_FORMAT(transaction_date, 'yyyy-MM') AS sales_month,
    COUNT(DISTINCT transaction_id) AS transaction_count,
    SUM(quantity) AS total_quantity,
    SUM(sales_amount_inr) AS total_revenue_inr
FROM retail_transactions
GROUP BY DATE_FORMAT(transaction_date, 'yyyy-MM')
ORDER BY sales_month;

-- 3. Top 10 customers by purchase value
SELECT
    customer_id,
    COUNT(DISTINCT transaction_id) AS transaction_count,
    SUM(sales_amount_inr) AS purchase_value_inr
FROM retail_transactions
GROUP BY customer_id
ORDER BY purchase_value_inr DESC, customer_id
LIMIT 10;

-- 4. Best-selling products by quantity sold
SELECT
    product_name,
    product_category,
    SUM(quantity) AS quantity_sold,
    SUM(sales_amount_inr) AS revenue_inr
FROM retail_transactions
GROUP BY product_name, product_category
ORDER BY quantity_sold DESC, revenue_inr DESC, product_name
LIMIT 10;

-- 5. Payment method analysis
SELECT
    payment_method,
    COUNT(DISTINCT transaction_id) AS transaction_count,
    SUM(sales_amount_inr) AS total_revenue_inr,
    AVG(sales_amount_inr) AS average_transaction_value_inr
FROM retail_transactions
GROUP BY payment_method
ORDER BY total_revenue_inr DESC, payment_method;

-- 6. Overall sales KPIs
SELECT
    COUNT(DISTINCT transaction_id) AS total_transactions,
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(quantity) AS total_quantity_sold,
    SUM(sales_amount_inr) AS total_revenue_inr,
    AVG(sales_amount_inr) AS average_transaction_value_inr,
    AVG(discount_pct) AS average_discount_pct
FROM retail_transactions;

-- 7. Category-wise sales
SELECT
    product_category,
    COUNT(DISTINCT transaction_id) AS transaction_count,
    SUM(quantity) AS quantity_sold,
    SUM(sales_amount_inr) AS total_revenue_inr,
    AVG(sales_amount_inr) AS average_transaction_value_inr
FROM retail_transactions
GROUP BY product_category
ORDER BY total_revenue_inr DESC, product_category;

-- 8. Top 10 products by revenue
SELECT
    product_name,
    product_category,
    SUM(sales_amount_inr) AS total_revenue_inr,
    SUM(quantity) AS quantity_sold,
    COUNT(DISTINCT transaction_id) AS transaction_count
FROM retail_transactions
GROUP BY product_name, product_category
ORDER BY total_revenue_inr DESC, quantity_sold DESC, product_name
LIMIT 10;

-- 9. Quantity sold by product
SELECT
    product_name,
    product_category,
    SUM(quantity) AS quantity_sold
FROM retail_transactions
GROUP BY product_name, product_category
ORDER BY quantity_sold DESC, product_name;

-- 10. Discount analysis by observed discount percentage
SELECT
    discount_pct,
    COUNT(DISTINCT transaction_id) AS transaction_count,
    SUM(quantity) AS quantity_sold,
    AVG(sales_amount_inr) AS average_transaction_value_inr,
    SUM(sales_amount_inr) AS total_revenue_inr
FROM retail_transactions
GROUP BY discount_pct
ORDER BY discount_pct;

-- 11. Customer purchase frequency and customer-wise revenue
SELECT
    customer_id,
    COUNT(DISTINCT transaction_id) AS purchase_frequency,
    SUM(sales_amount_inr) AS customer_revenue_inr,
    MIN(transaction_date) AS first_purchase_date,
    MAX(transaction_date) AS last_purchase_date
FROM retail_transactions
GROUP BY customer_id
ORDER BY purchase_frequency DESC, customer_revenue_inr DESC, customer_id;

-- 12. Repeat customers
SELECT
    customer_id,
    purchase_frequency,
    customer_revenue_inr
FROM (
    SELECT
        customer_id,
        COUNT(DISTINCT transaction_id) AS purchase_frequency,
        SUM(sales_amount_inr) AS customer_revenue_inr
    FROM retail_transactions
    GROUP BY customer_id
) customer_purchases
WHERE purchase_frequency > 1
ORDER BY purchase_frequency DESC, customer_revenue_inr DESC, customer_id;

-- 13. Regional transaction and customer distribution
SELECT
    region,
    COUNT(DISTINCT transaction_id) AS transaction_count,
    COUNT(DISTINCT customer_id) AS distinct_customers,
    SUM(quantity) AS quantity_sold
FROM retail_transactions
GROUP BY region
ORDER BY transaction_count DESC, region;

-- 14. Region-wise revenue
SELECT
    region,
    COUNT(DISTINCT transaction_id) AS transaction_count,
    SUM(sales_amount_inr) AS total_revenue_inr,
    AVG(sales_amount_inr) AS average_transaction_value_inr
FROM retail_transactions
GROUP BY region
ORDER BY total_revenue_inr DESC, region;

-- 15. Payment preferences by transaction share
WITH payment_totals AS (
    SELECT
        payment_method,
        COUNT(DISTINCT transaction_id) AS transaction_count,
        SUM(sales_amount_inr) AS total_revenue_inr
    FROM retail_transactions
    GROUP BY payment_method
)
SELECT
    payment_method,
    transaction_count,
    total_revenue_inr,
    ROUND(
        100.0 * transaction_count / SUM(transaction_count) OVER (),
        2
    ) AS transaction_share_pct
FROM payment_totals
ORDER BY transaction_count DESC, payment_method;
