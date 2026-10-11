%default INPUT '/retail/input/retail_transactions.csv'
%default CLEANED_OUT '/retail/cleaned/retail_transactions'
%default GROUPED_OUT '/retail/grouped/customer_product_category'

raw_transactions = LOAD '$INPUT'
    USING PigStorage(',')
    AS (
        transaction_id:chararray,
        transaction_date_raw:chararray,
        customer_id:chararray,
        region:chararray,
        product_category:chararray,
        product_name:chararray,
        quantity_raw:chararray,
        unit_price_inr_raw:chararray,
        discount_pct_raw:chararray,
        sales_amount_inr_raw:chararray,
        payment_method:chararray
    );

transactions_without_header = FILTER raw_transactions
    BY transaction_id != 'transaction_id';

typed_transactions = FOREACH transactions_without_header GENERATE
    transaction_id AS transaction_id,
    ToDate(transaction_date_raw, 'M/d/yyyy') AS transaction_date,
    customer_id AS customer_id,
    region AS region,
    product_category AS product_category,
    product_name AS product_name,
    (int)quantity_raw AS quantity,
    (int)unit_price_inr_raw AS unit_price_inr,
    (int)discount_pct_raw AS discount_pct,
    (bigdecimal)sales_amount_inr_raw AS sales_amount_inr,
    payment_method AS payment_method;

distinct_transactions = DISTINCT typed_transactions;

-- All observed sales are positive; this retains every observed transaction
-- while excluding zero or negative sales if they occur in future input.
positive_sales = FILTER distinct_transactions BY sales_amount_inr > 0;

cleaned_transactions = FOREACH positive_sales GENERATE
    transaction_id AS transaction_id,
    ToString(transaction_date, 'yyyy-MM-dd') AS transaction_date,
    customer_id AS customer_id,
    region AS region,
    product_category AS product_category,
    product_name AS product_name,
    quantity AS quantity,
    unit_price_inr AS unit_price_inr,
    discount_pct AS discount_pct,
    sales_amount_inr AS sales_amount_inr,
    payment_method AS payment_method;

STORE cleaned_transactions
    INTO '$CLEANED_OUT'
    USING PigStorage(',');

customer_category_groups = GROUP cleaned_transactions
    BY (customer_id, product_category);

customer_category_summary = FOREACH customer_category_groups GENERATE
    FLATTEN(group) AS (customer_id:chararray, product_category:chararray),
    COUNT(cleaned_transactions) AS transaction_count,
    SUM(cleaned_transactions.quantity) AS total_quantity,
    SUM(cleaned_transactions.sales_amount_inr) AS total_sales_inr;

STORE customer_category_summary
    INTO '$GROUPED_OUT'
    USING PigStorage(',');
