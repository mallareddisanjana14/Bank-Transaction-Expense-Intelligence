# Bank Transaction & Expense Intelligence System

A SQL and Python-based banking transaction analysis project designed to analyze large-scale retail banking transactions, identify spending patterns, study customer behavior, analyze fraudulent transactions, and implement rule-based transaction risk analysis.

The project uses MySQL for database management and SQL-based analysis, combined with Python for data exploration, visualization, MySQL integration, and Excel reporting.

---

## Project Overview

Financial transaction data contains valuable information about customer spending, transaction behavior, payment channels, account activity, and potential fraudulent activity.

The objective of this project is to build a complete data analysis workflow using SQL and Python without using machine learning or AI.

The project processes approximately 550,000 banking transactions and performs:

- Data exploration and cleaning
- Transaction and financial analysis
- Income and expense analysis
- Transaction-type analysis
- Merchant-category analysis
- Customer spending analysis
- Fraud analysis
- High-value transaction analysis
- Rule-based risk classification
- Advanced SQL analysis
- Python and MySQL integration
- Data visualization
- Excel-based reporting

---

## Project Objectives

The main objectives of the project are:

1. Explore and understand a large banking transaction dataset.
2. Clean and prepare the data for analysis.
3. Store the cleaned data in a MySQL database.
4. Analyze transaction volume and transaction value.
5. Identify major income and expense patterns.
6. Analyze transaction types and payment channels.
7. Identify customers with high transaction activity.
8. Analyze fraudulent transactions using existing fraud labels.
9. Investigate high-value transactions and their fraud rates.
10. Develop a rule-based transaction risk classification system.
11. Demonstrate advanced SQL concepts.
12. Connect Python with MySQL for analytical workflows.
13. Generate visualizations and Excel reports.
14. Document the complete analysis workflow.

---

## Dataset

The project uses an Indian banking transactions dataset containing approximately 550,000 retail banking transactions covering the period from 2019 to 2024.

The dataset contains 20 columns:

| Column | Description |
|---|---|
| `transaction_id` | Unique transaction identifier |
| `customer_id` | Customer identifier |
| `transaction_date` | Date of transaction |
| `transaction_time` | Time of transaction |
| `account_type` | Type of bank account |
| `transaction_type` | Transaction/payment method |
| `transaction_amount` | Transaction amount |
| `transaction_direction` | Credit or Debit |
| `account_balance` | Account balance after transaction |
| `merchant_category` | Merchant or transaction category |
| `state` | Customer or transaction state |
| `credit_score` | Customer credit score |
| `has_loan` | Indicates whether the customer has a loan |
| `loan_type` | Type of loan |
| `emi_amount` | EMI amount |
| `transaction_status` | Transaction status |
| `channel` | Transaction channel |
| `kyc_status` | KYC status |
| `is_fraud` | Fraud indicator |
| `transaction_hour` | Hour of transaction |

---

## Technologies Used

### Programming Language

- Python

### Database

- MySQL

### Python Libraries

- Pandas
- NumPy
- Matplotlib
- Seaborn
- mysql-connector-python
- OpenPyXL

### SQL Concepts

- Database creation
- Table creation
- Data loading
- SELECT queries
- Filtering
- Aggregations
- GROUP BY
- ORDER BY
- CASE statements
- JOIN concepts
- Common Table Expressions (CTEs)
- Window functions
- Ranking
- Running totals
- Views
- Stored procedures
- Triggers
- Indexes
- EXPLAIN
- Query optimization

### Reporting

- Excel
- Markdown

---

## Project Workflow

The project follows the workflow below:

```text
Raw Dataset
     |
     v
Data Exploration
     |
     v
Data Cleaning
     |
     v
Cleaned CSV
     |
     v
MySQL Database
     |
     v
SQL Analysis
     |
     +----------------------+
     |                      |
     v                      v
Advanced SQL          Risk Analysis
     |                      |
     +----------+-----------+
                |
                v
        Python + MySQL
                |
                v
        Data Visualization
                |
                v
          Excel Reporting
                |
                v
          Final Report
