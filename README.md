# Retail Sales and Customer Purchase Pattern Analysis Using Apache Pig, Apache Hive, and Microsoft Power BI

## 1. Project Overview

This project analyzes retail transaction data using Big Data technologies to identify sales trends, customer purchasing behavior, product performance, payment preferences, and regional sales patterns.

Apache Pig is used to clean and transform the transaction data. Apache Hive is used to perform analytical queries on the processed data. Microsoft Power BI is used to visualize the analytical results through interactive dashboards.

## 2. Problem Statement

Retail businesses generate large amounts of transaction data containing information about customers, products, sales, discounts, regions, and payment methods. Analyzing this data manually can be time-consuming and makes it difficult to identify meaningful business patterns.

This project develops a data-processing and analytics workflow using Apache Hadoop, Apache Pig, Apache Hive, and Power BI to transform raw retail transactions into useful business insights.

## 3. Objectives

- Process retail transaction data using Hadoop and HDFS.
- Clean the dataset and remove duplicate transactions.
- Filter transactions based on sales amount.
- Group transactions by customer and product category.
- Perform analytical queries using Apache Hive.
- Identify high-revenue categories and best-selling products.
- Analyze monthly sales and customer purchase patterns.
- Examine payment preferences and regional performance.
- Develop interactive Power BI dashboards for business analysis.

## 4. Technologies Used

| Technology | Purpose |
|---|---|
| Apache Hadoop | Distributed data storage and processing infrastructure |
| HDFS | Stores the input dataset and processed files |
| Apache Pig | Data cleaning, transformation and grouping |
| Pig Latin | Defines the data-processing workflow |
| Apache Hive | Performs analytical queries on processed data |
| HiveQL | Queries, aggregates and analyzes retail data |
| Microsoft Power BI | Creates interactive dashboards and visualizations |
| CSV | Stores the input dataset and exported results |
| VS Code | Project development and file management |
| Java | Supports the Hadoop ecosystem |

## 5. Dataset Description

The project uses a retail transaction dataset in CSV format.

The dataset contains the following fields:

| Column | Description |
|---|---|
| transaction_id | Unique transaction identifier |
| transaction_date | Date of the transaction |
| customer_id | Customer identifier |
| region | Geographic region of the transaction |
| product_category | Category of the purchased product |
| product_name | Name of the purchased product |
| quantity | Quantity purchased |
| unit_price_inr | Unit price in Indian rupees |
| discount_pct | Discount percentage |
| sales_amount_inr | Sales amount in Indian rupees |
| payment_method | Payment method used |

The dataset is inspected before processing to verify its schema, data types, missing values, duplicates, and numeric ranges.

## 6. System Architecture

The project follows a sequential data-processing and analytics architecture.

Retail Transaction Dataset (CSV)  
↓  
Hadoop Distributed File System (HDFS)  
↓  
Apache Pig — Data Cleaning and Transformation  
↓  
Cleaned Transactions and Grouped Summaries  
↓  
Apache Hive — Analytical Queries  
↓  
Query Result Files  
↓  
Microsoft Power BI — Interactive Dashboards  
↓  
Business Insights

## 7. Project Workflow

### Step 1: Dataset Preparation

The retail transaction dataset is inspected and prepared for processing. Its column structure, data types, missing values, and duplicate records are examined.

### Step 2: HDFS Storage

The input CSV dataset is uploaded to HDFS. Separate directories are maintained for input data, cleaned data, grouped data, and analytical outputs.

### Step 3: Apache Pig Processing

Apache Pig processes the input dataset using Pig Latin.

The processing steps include:

1. Loading the CSV dataset.
2. Handling the header row.
3. Converting fields to appropriate data types.
4. Removing duplicate transactions according to the selected deduplication rule.
5. Filtering invalid or non-positive sales amounts according to the project's filtering rule.
6. Grouping transactions by customer and product category.
7. Calculating transaction counts, total quantities, and total sales.
8. Storing the cleaned data and grouped summaries in HDFS.

### Step 4: Apache Hive Analysis

Apache Hive creates a database and an external table over the cleaned transaction data.

HiveQL queries are used to analyze revenue, monthly sales, customer purchase values, best-selling products, payment methods, discounts, and regional performance.

### Step 5: Power BI Visualization

The verified transaction data or exported Hive query results are imported into Power BI.

The report contains four dashboard pages covering sales overview, product analysis, customer purchase analysis, and payment and regional analysis.

### Step 6: Validation

The output files, Hive tables, analytical query results, and Power BI figures are checked for consistency. Screenshots are collected as evidence of successful execution.

## 8. Apache Pig — Data Processing

Apache Pig is used to process and transform the retail dataset.

The main operations include:

- **LOAD:** Reads the transaction dataset.
- **FILTER:** Selects records satisfying the sales filtering condition.
- **DISTINCT:** Removes identical complete records.
- **FOREACH ... GENERATE:** Transforms and selects fields.
- **GROUP:** Groups transactions by customer and product category.
- **COUNT:** Calculates the number of records in a group.
- **SUM:** Calculates total sales and quantity.
- **STORE:** Saves the processed results to HDFS.

The cleaned transaction data is stored separately from the grouped customer-category summaries.

## 9. Apache Hive — Analytical Queries

Apache Hive provides a SQL-like interface for querying the processed data.

The database is named `retail_db`, and the primary transaction table is named `retail_transactions`.

The five required analytical queries are:

1. **Total Revenue by Product Category:** Identifies categories contributing the highest revenue.
2. **Monthly Sales Analysis:** Examines monthly revenue and transaction trends.
3. **Top 10 Customers:** Ranks customers according to total purchase value.
4. **Best-Selling Products:** Identifies products with the highest total quantity sold.
5. **Payment Method Analysis:** Compares transaction counts and revenue across payment methods.

Additional analyses include overall sales KPIs, discount analysis, customer purchase frequency, repeat customers, category-wise quantity sold, and region-wise revenue.

## 10. Power BI Dashboard

The Power BI report consists of four pages.

### Page 1: Sales Overview

- Total revenue
- Total transactions
- Average transaction value
- Monthly sales trend
- Transaction volume

### Page 2: Product Analysis

- Category-wise revenue
- Top-selling products
- Quantity sold
- Discount analysis

### Page 3: Customer Purchase Analysis

- Customer-wise revenue
- Purchase frequency
- Repeat customers
- Regional distribution

### Page 4: Payment and Regional Analysis

- Payment method distribution
- Revenue by payment method
- Region-wise revenue
- Region-wise transaction volume

Charts, KPI cards, and slicers enable users to explore the data and compare business performance.

## 11. Project Results

Record the actual results after executing the complete workflow.

- Number of input transactions: [Enter verified count]
- Number of cleaned transactions: [Enter verified count]
- Number of duplicate records removed: [Enter verified count]
- Number of records excluded by the sales filter: [Enter verified count]
- Highest-revenue product category: [Enter actual result]
- Top-selling product: [Enter actual result]
- Highest-value customer: [Enter actual result]
- Most-used payment method: [Enter actual result]
- Highest-revenue region: [Enter actual result]

The final findings are based on the verified output of Apache Pig, Apache Hive, and Power BI.

## 12. Advantages

- Organizes the retail data-processing workflow.
- Reduces manual data cleaning and aggregation.
- Supports analysis of customer and product performance.
- Enables monthly, regional, and payment-related comparisons.
- Provides visual summaries for business decision-making.
- Demonstrates the integration of Hadoop, Pig, Hive, and Power BI.

## 13. Future Enhancements

- Process larger retail datasets.
- Automate scheduled data ingestion and reporting.
- Introduce advanced customer segmentation.
- Develop sales forecasting models.
- Analyze product recommendations and customer buying patterns.
- Integrate automated alerts for unusual sales changes.

## 14. Conclusion

This project demonstrates a Big Data analytics workflow for retail transaction analysis. Apache Hadoop and HDFS provide the storage infrastructure, Apache Pig performs data cleaning and transformation, and Apache Hive enables analytical querying. Microsoft Power BI presents the resulting information through interactive dashboards.

The integrated workflow helps transform raw retail transactions into interpretable insights about sales performance, product demand, customer behavior, payment preferences, and regional trends.

## 15. Project Folder Structure

Retail_BigData_Analytics/

- dataset/
  - retail_transactions.csv
- pig/
  - retail_cleaning.pig
  - output/
- hive/
  - create_database.sql
  - create_table.sql
  - analysis_queries.sql
  - output/
- powerbi/
  - Retail_Sales_Dashboard.pbix
- report/
  - project_report.docx
  - architecture.png
  - screenshots/
- README.md

## 16. Execution and Verification

The project is executed in the following order:

1. Verify the input dataset.
2. Upload the dataset to HDFS.
3. Execute the Apache Pig processing script.
4. Verify cleaned and grouped HDFS outputs.
5. Create the Hive database and transaction table.
6. Execute the required Hive analytical queries.
7. Export and verify query results.
8. Import the required data into Power BI.
9. Complete and validate all four dashboard pages.
10. Save screenshots and document the actual findings.

**Note:** Replace all placeholders in the results section with actual verified outputs. Do not report unmeasured results or claim successful execution before testing the relevant stage.
