# Retail Sales and Customer Purchase Pattern Analysis

## Project title

Retail Sales and Customer Purchase Pattern Analysis Using Apache Pig, Apache Hive, and Microsoft Power BI

## Project status
The end-to-end HDFS, Pig, Hive, and Power BI workflow is complete. The saved four-page Power BI report uses the inspected dataset and verified Hive exports.

## Problem statement

This project builds a big data workflow for preparing retail transaction data and analyzing sales and customer purchase patterns with Apache Pig, Apache Hive, and Microsoft Power BI.

## Objectives

- Prepare transaction data for analysis using Apache Pig.
- Analyze sales, products, customers, payments, and regions using Apache Hive.
- Present verified analytical results in a multi-page Power BI dashboard.
- Base all schemas, transformations, and findings on the supplied dataset.

## Technologies

Technologies used include Windows 11, WSL2 Ubuntu, VS Code, Java 17, Hadoop 3.4.2, Apache Pig 0.17.0, Apache Hive 4.0.1, HDFS, and Microsoft Power BI.

## Dataset description

The supplied file is a comma-separated CSV containing 1,500 transaction records and 11 columns. The header is present. Inspection found no missing field values, no exact duplicate records, and 1,500 unique transaction IDs.

| Column | Observed type |
| --- | --- |
| `transaction_id` | String identifier |
| `transaction_date` | Date, formatted `M/d/yyyy` |
| `customer_id` | String identifier |
| `region` | String/category |
| `product_category` | String/category |
| `product_name` | String/category |
| `quantity` | Integer |
| `unit_price_inr` | Integer |
| `discount_pct` | Integer percentage |
| `sales_amount_inr` | Decimal |
| `payment_method` | String/category |

The observed transaction dates span 2025-01-01 through 2025-12-31. `sales_amount_inr` ranges from INR 159.20 to INR 11,895.75. `quantity` ranges from 1 to 5, `unit_price_inr` from INR 199 to INR 2,799, and `discount_pct` from 0% to 20%.

Observed product categories are Beauty, Clothing, Electronics, Grocery, and Home & Kitchen. The five regions are Central, East, North, South, and West. Payment methods are Cash, Credit Card, Debit Card, Net Banking, and UPI. There are 200 distinct customer IDs and 25 distinct product names.

## HDFS preparation

The configured HDFS filesystem is `hdfs://localhost:9000`. Existing HDFS contents were inspected before changes. `/retail/input/retail_transactions.csv` was already present and was retained; its SHA-256 matched the local dataset file, and its header and sample records were verified. The missing `/retail/cleaned/`, `/retail/grouped/`, and `/retail/output/` directories were created without deleting existing HDFS data.

```text
/retail/
  input/retail_transactions.csv
  cleaned/
  grouped/
  output/
```

HDFS was started using the existing configuration and stored metadata; no format or configuration changes were made.

## Pig processing

The dataset-specific script is `pig/retail_cleaning.pig`. It was run with Pig 0.17.0 in MapReduce mode using `/opt/pig/bin/pig`; Pig is installed at that path but is not on the WSL command `PATH`.

The script loads the 11 observed columns as text, skips the CSV header, converts the date to an ISO `yyyy-MM-dd` value and numeric columns to integer/decimal types, removes exact duplicate rows, and filters for `sales_amount_inr > 0`. This is a conservative rule: the observed minimum is INR 159.20, so no current transactions were removed by the filter. The source also had no exact duplicates and all 1,500 transaction IDs were unique.

Cleaned transactions are stored at `/retail/cleaned/retail_transactions/` and customer/product-category summaries at `/retail/grouped/customer_product_category/`. The grouped output includes transaction count, total quantity, and total sales for each customer/category pair.

Validation confirmed 1,500 cleaned rows and 770 grouped rows. Grouped totals reconcile with the source: 1,500 transactions, 2,573 units, and INR 1,883,001.20 in sales. HDFS samples from both outputs were inspected.

## Hive setup

The SQL setup scripts are `hive/create_database.sql` and `hive/create_table.sql`. Hive 4.0.1 is available at `/opt/hive/bin/hive`; Beeline was used through the configured HiveServer2. The `retail_db` database was created after confirming that it did not already exist. The external `retail_transactions` table uses the observed 11-column schema and points to `/retail/cleaned/retail_transactions/` in HDFS.

Hive verification succeeded for `SHOW DATABASES`, `SHOW TABLES`, `DESCRIBE retail_transactions`, and `SELECT * FROM retail_transactions LIMIT 10`. The Hive aggregate check returned 1,500 transactions, 2,573 units, and INR 1,883,001.20 in revenue, matching the Pig and source totals.

The configured MySQL metastore lacked its Hive schema, so—after approval—it was initialized to schema version 4.0.0. HiveServer2 also required local runtime-only settings for Hive-on-Java-17 operation and this single-user WSL setup: a temporary Hadoop configuration overlay at `/tmp/retail-hadoop-conf.kZ1p7p` allows the local `monica` user, and this HiveServer2 process runs with `hive.server2.enable.doAs=false`. The installed Hadoop and Hive configuration files were not edited. These runtime settings must be considered when restarting the services.

## Hive analysis and exported results

The 15 dataset-specific analyses are in `hive/analysis_queries.sql`. Each query was executed through Beeline against `retail_db.retail_transactions` and exported as a headered CSV2 file to `hive/output/`. The exports include category revenue, monthly sales, top customers and products, payment method analysis, overall KPIs, quantity and discount analyses, customer purchase frequency and repeat customers, regional distribution and revenue, and payment preferences.

All 15 files were checked for CSV headers and parsed data rows. The results reconcile: overall KPIs report 1,500 transactions, 200 customers, 2,573 units, INR 1,883,001.20 in revenue, an average transaction value of INR 1,255.334133, and an average discount of 5.46%. Monthly, category, and regional revenue totals each reconcile to overall revenue; monthly transaction and quantity totals reconcile to the KPIs. The monthly export contains 12 months, and the repeat-customer analysis contains 200 customers.

Hive-on-MapReduce initially exceeded the default 256 MB HiveServer2 heap. The aggregate query succeeded after restarting HiveServer2 with a process-only 1 GB heap; the stored data and installed Hadoop/Hive configuration were not changed. The HiveServer2 process is currently running with that temporary heap setting.

| Export | Data rows |
| --- | ---: |
| `revenue_by_category.csv` | 5 |
| `monthly_sales.csv` | 12 |
| `top_10_customers.csv` | 10 |
| `best_selling_products.csv` | 10 |
| `payment_method_analysis.csv` | 5 |
| `overall_sales_kpis.csv` | 1 |
| `category_sales.csv` | 5 |
| `top_products_by_revenue.csv` | 10 |
| `quantity_sold_by_product.csv` | 25 |
| `discount_analysis.csv` | 5 |
| `customer_purchase_frequency.csv` | 200 |
| `repeat_customers.csv` | 200 |
| `regional_distribution.csv` | 5 |
| `region_wise_revenue.csv` | 5 |
| `payment_preferences.csv` | 5 |

## Power BI dashboard

The completed report is saved as `powerbi/Retail_Sales_Dashboard.pbix`. Its model uses the Hive-cleaned transaction export and actual Hive summary CSVs, not generated sample data. The fact export contains 1,500 records and all 11 Hive table columns; revenue (INR 1,883,001.20) and quantity (2,573) reconcile with the verified Hive KPIs. The 15 aggregate result CSVs in `hive/output/` remain available for direct comparison.

`powerbi/RetailTransactions.pq` contains the Power Query import and type-conversion steps for the Hive export, including a month-start field for monthly visuals. `powerbi/Measures.dax` contains the revenue, transaction, order value, quantity, discount, customer, purchase-frequency, and repeat-customer measures. If the project is moved, update the file path in the Power Query source.

The report contains these four pages:

1. **Sales Overview:** total revenue (INR 1.88M), average order value (INR 1.26K), exact transaction count (1,500), monthly transaction volume, and monthly revenue.
2. **Product Analysis:** revenue by category, top 10 products by revenue, quantity by product, and revenue by discount percentage.
3. **Customer Purchase Analysis:** purchase frequency by customer, customer revenue, repeat-customer count (200), and distinct customers by region.
4. **Payment and Regional Analysis:** payment-method revenue and transaction volume, region revenue and transaction volume, and a payment-method slicer.

The category-revenue chart was compared with the Hive export: Electronics INR 558,716.60; Home & Kitchen INR 478,227.90; Clothing INR 468,489.05; Beauty INR 214,562.85; Grocery INR 163,004.80. The payment-method slicer was tested: selecting Cash filtered payment revenue to Cash and reduced transaction counts to that method; clearing the selection restored all five methods. The product-category slicer was also tested and filters the category, discount, and quantity visuals. The top-10 revenue chart uses the Hive-generated overall ranking, so it remains an all-store ranking when a category is selected.

Screenshots of the saved report pages are available here:

- [Sales Overview](report/screenshots/01_sales_overview.png)
- [Product Analysis](report/screenshots/02_product_analysis.png)
- [Customer Purchase Analysis](report/screenshots/03_customer_purchase_analysis.png)
- [Payment and Regional Analysis](report/screenshots/04_payment_and_regional_analysis.png)

The report is saved with Sales Overview first and with no slicer selections applied.

## Results and conclusion

The validated pipeline processed 1,500 transactions totaling 2,573 units and INR 1,883,001.20 in revenue. The Power BI KPI cards and chart data use the Hive results, and the category totals reconcile with Hive. The dashboard brings the requested sales, product, customer, payment, and regional views into one four-page report.

## Architecture

```mermaid
flowchart LR
    A[Supplied dataset] --> B[HDFS]
    B --> C[Apache Pig]
    C --> D[Cleaned and grouped data]
    D --> E[Apache Hive]
    E --> F[Analytical results]
    F --> G[Microsoft Power BI]
```

## Project layout

```text
dataset/
pig/
  output/
hive/
  output/
powerbi/
report/
  screenshots/
```

## Environment check

Checked from the configured WSL Ubuntu shell: Java 17.0.20.1, Hadoop 3.4.2, Pig 0.17.0 (`/opt/pig/bin/pig`), and Hive 4.0.1 (`/opt/hive/bin/hive`) respond to their version commands. Pig and Hive are not on the WSL command path. No software was installed and no Hadoop, Pig, Hive, or Java configuration files were changed.

## Future scope

Potential extensions include adding a date slicer and building a refreshed dashboard model that can rank products dynamically within the selected category.
#   R e t a i l _ B i g D a t a _ A n a l y t i c s  
 