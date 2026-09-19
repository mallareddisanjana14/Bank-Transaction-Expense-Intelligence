# BANK TRANSACTION & EXPENSE INTELLIGENCE SYSTEM

## Capstone Project Report

---

## 1. Introduction

Banking transaction data contains valuable information about customer spending,
transaction behavior, payment channels, and potentially fraudulent activities.

The objective of this project is to analyze a large Indian banking transaction
dataset using Python and SQL.

The project focuses on data exploration, cleaning, database analysis,
customer expense analysis, fraud analysis, and rule-based transaction risk
classification.

No Machine Learning or Artificial Intelligence techniques are used in this
project.

---

## 2. Project Objectives

The main objectives are:

1. Explore and understand banking transaction data.
2. Clean and prepare the dataset for analysis.
3. Store the cleaned data in a MySQL database.
4. Analyze transaction types and transaction amounts.
5. Analyze customer income and expenses.
6. Identify high-value transactions.
7. Analyze fraudulent transactions.
8. Create rule-based transaction risk categories.
9. Demonstrate advanced SQL concepts.
10. Connect Python with MySQL for analysis and visualization.
11. Generate an Excel-based analytical output.

---

## 3. Dataset Description

The dataset contains approximately 550,000 banking transactions.

The data covers transactions from 2019 to 2024 and contains 20 columns.

Important fields include:

- transaction_id
- customer_id
- transaction_date
- transaction_time
- account_type
- transaction_type
- transaction_amount
- transaction_direction
- account_balance
- merchant_category
- state
- credit_score
- has_loan
- loan_type
- emi_amount
- transaction_status
- channel
- kyc_status
- is_fraud
- transaction_hour

---

## 4. Technologies Used

### Python

- Pandas
- NumPy
- Matplotlib
- Seaborn
- MySQL Connector
- OpenPyXL

### Database

- MySQL 8.0

### SQL Concepts

- SELECT
- WHERE
- GROUP BY
- ORDER BY
- CASE
- CTE
- Window Functions
- Views
- Stored Procedures
- Triggers
- Indexes
- EXPLAIN

---

## 5. Project Workflow

The project follows these stages:

Raw Dataset

↓

Python Data Exploration

↓

Data Cleaning

↓

Cleaned CSV

↓

MySQL Database

↓

SQL Analysis

↓

Advanced SQL

↓

Python + MySQL Integration

↓

Excel Output

↓

Final Report

---

## 6. Data Exploration and Cleaning

Python was used to examine the structure and quality of the dataset.

The dataset contains:

- 550,000 rows
- 20 columns
- 0 duplicate rows

The main missing values were found in the `loan_type` column.

Missing loan type values were handled carefully because customers without
loans naturally have no loan type.

The transaction date was converted into a proper datetime format for
time-based analysis.

Additional checks were performed on:

- Data types
- Missing values
- Duplicate records
- Transaction amounts
- Account balances
- Credit scores
- Transaction hours
- Transaction directions
- Fraud indicators

The cleaned dataset was saved as:

`indian_banking_transactions_cleaned.csv`

---

## 7. MySQL Database

A MySQL database named:

`bank_transaction_db`

was created.

The main table is:

`transactions`

The cleaned dataset containing 550,000 transactions was successfully loaded
into the table.

The database was verified using row counts and sample queries.

---

## 8. Overall Transaction Analysis

The main overall results are:

| Metric | Result |
|---|---:|
| Total Transactions | 550,000 |
| Total Income | ₹7,655,754,979.94 |
| Total Expense | ₹8,793,146,683.62 |
| Average Transaction | ₹29,907.09 |
| Fraud Transactions | 4,873 |
| Overall Fraud Rate | 0.89% |

The total debit amount is higher than the total credit amount in the dataset.

---

## 9. Transaction Type Analysis

UPI has the highest transaction volume with 153,986 transactions.

RTGS has the highest total transaction value at approximately
₹8.88 billion.

This demonstrates that transaction volume and transaction value can provide
different insights.

The major transaction types include:

- UPI
- IMPS
- NEFT
- POS
- ATM Withdrawal
- Net Banking
- RTGS
- Auto Debit
- Cheque
- Credit Card

---

## 10. Expense Analysis

Debit transactions were analyzed by merchant category.

Retail had the highest total debit spending.

Other major categories included:

- E-Commerce
- Food & Dining
- Travel
- Utilities
- Peer Transfer
- Entertainment
- Healthcare
- Investment
- Education

This analysis helps identify categories where the largest amount of money is
being spent.

---

## 11. Customer Expense Analysis

Customer-level analysis was performed using SQL aggregation.

The top customers by total debit expense were identified.

The highest-spending customer in the dataset had approximately
₹10.17 million in total debit transactions.

High spending does not automatically mean fraudulent activity.

Customer-level analysis is useful for identifying unusual or high-value
financial behavior that may require further investigation.

---

## 12. Fraud Analysis

The dataset contains 4,873 fraudulent transactions.

The overall fraud rate is approximately 0.89%.

Fraud was analyzed using:

- Transaction type
- Channel
- Transaction amount
- Transaction hour
- Transaction type + channel

RTGS had the highest overall fraud rate among transaction types at
approximately 1.85%.

UPI had the highest number of fraud transactions because it also has the
largest transaction volume.

---

## 13. High-Value Transaction Analysis

Transactions above ₹1,000,000 were classified as high-value transactions.

There were:

- 1,746 high-value transactions
- 144 fraudulent transactions
- 8.25% fraud rate

The high-value group therefore had a substantially higher observed fraud
rate than the overall dataset.

However, transaction amount alone does not prove fraud.

---

## 14. Rule-Based Risk Classification

A rule-based risk classification system was developed using SQL.

### High Risk

A transaction is classified as High Risk when:

- Amount is greater than ₹1,000,000

AND

- Transaction type is NEFT, RTGS, or Cheque.

### Medium Risk

A transaction is classified as Medium Risk when:

- Amount is greater than ₹1,000,000

OR

- Transaction type is NEFT, RTGS, or Cheque.

### Low Risk

All other transactions are classified as Low Risk.

The results were:

| Risk Category | Transactions | Fraud Transactions | Fraud Rate |
|---|---:|---:|---:|
| High Risk | 1,733 | 144 | 8.31% |
| Medium Risk | 119,570 | 1,304 | 1.09% |
| Low Risk | 428,697 | 3,425 | 0.80% |

The High Risk category had a much higher observed fraud rate.

These categories are analytical flags and should not be treated as proof of
fraud.

---

## 15. Advanced SQL Analysis

Several advanced SQL techniques were implemented.

### CTE

A Common Table Expression was used to calculate customer-level income,
expense, and net flow.

### Window Functions

`RANK()` was used to rank customers according to their total expenses.

`PARTITION BY` was used to rank customers within account types.

A running total was also calculated for monthly expenses.

### View

A view named:

`customer_financial_summary`

was created to provide customer-level financial information.

### Stored Procedure

The procedure:

`get_customer_summary`

returns the financial summary of a selected customer.

### Trigger

A trigger was created to record newly inserted transactions in an audit
table.

### Index

An index was created on:

`customer_id`

The `EXPLAIN` command confirmed that the customer ID index was being used for
customer-specific queries.

---

## 16. Python and MySQL Integration

Python was connected to MySQL using:

`mysql-connector-python`

SQL queries were executed from Python and the results were loaded into
Pandas DataFrames.

Python was then used to create visualizations for:

- Transaction type analysis
- Fraud rate
- Risk categories
- Top customers
- Monthly expenses
- Channel-based fraud

---

## 17. Excel Output

An Excel workbook was created using OpenPyXL.

The workbook contains:

- Overall Summary
- Transaction Types
- Fraud Analysis
- Risk Analysis
- Top Customers
- Monthly Expenses
- Channel Fraud

The output file is:

`bank_transaction_analysis.xlsx`

---

## 18. Key Findings

The major findings from the project are:

1. UPI has the highest transaction volume.
2. RTGS has the highest total transaction value.
3. Retail has the highest total debit spending.
4. RTGS has the highest overall fraud rate among transaction types.
5. High-value transactions have a substantially higher observed fraud rate.
6. Fraud occurs across different transaction types and channels.
7. Transaction hour alone is not a strong standalone fraud indicator.
8. Rule-based risk classification can help prioritize transactions for
   further investigation.
9. High transaction value does not automatically mean that a transaction is
   fraudulent.
10. Transaction volume and transaction value provide different business
    insights.

---

## 19. Limitations

The project has several limitations:

- Fraud detection is rule-based rather than Machine Learning based.
- High-risk transactions are not necessarily fraudulent.
- The dataset may not represent every real-world banking transaction.
- Some data fields contain missing values.
- January 2024 contains only a small number of transactions and should not
  be compared directly with complete years.
- The analysis identifies patterns but does not establish causation.

---

## 20. Future Scope

Future improvements could include:

- More detailed customer behavior analysis
- Additional fraud detection rules
- Automated reporting
- Interactive dashboards
- Real-time transaction monitoring
- Machine Learning-based fraud detection
- More advanced customer segmentation

---

## 21. Conclusion

The Bank Transaction & Expense Intelligence System demonstrates how Python
and SQL can be combined to analyze a large banking transaction dataset.

Python was used for data exploration, cleaning, visualization, and MySQL
integration.

MySQL was used for structured data storage, transaction analysis, advanced
queries, customer analysis, fraud analysis, risk classification, views,
stored procedures, triggers, and query optimization.

The project successfully demonstrates a complete data analysis workflow from
raw data to database analysis and business insights.