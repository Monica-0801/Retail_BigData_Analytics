USE retail_db;

CREATE EXTERNAL TABLE IF NOT EXISTS retail_transactions (
    transaction_id STRING,
    transaction_date DATE,
    customer_id STRING,
    region STRING,
    product_category STRING,
    product_name STRING,
    quantity INT,
    unit_price_inr INT,
    discount_pct INT,
    sales_amount_inr DECIMAL(12, 2),
    payment_method STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/retail/cleaned/retail_transactions';
