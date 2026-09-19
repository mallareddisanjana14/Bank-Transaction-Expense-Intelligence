USE bank_transaction_db;

-- 1. Overall Transaction Summary
SELECT
    COUNT(*) AS total_transactions,
    SUM(CASE
        WHEN transaction_direction = 'Credit'
        THEN transaction_amount ELSE 0
    END) AS total_income,
    SUM(CASE
        WHEN transaction_direction = 'Debit'
        THEN transaction_amount ELSE 0
    END) AS total_expense,
    AVG(transaction_amount) AS average_transaction
FROM transactions;


-- 2. Transaction Type Summary
SELECT
    transaction_type,
    COUNT(*) AS total_transactions,
    SUM(transaction_amount) AS total_amount,
    AVG(transaction_amount) AS average_amount
FROM transactions
GROUP BY transaction_type
ORDER BY total_amount DESC;


-- 3. Transaction Type by Direction
SELECT
    transaction_type,
    transaction_direction,
    COUNT(*) AS total_transactions,
    SUM(transaction_amount) AS total_amount,
    AVG(transaction_amount) AS average_amount
FROM transactions
GROUP BY transaction_type, transaction_direction
ORDER BY transaction_type, transaction_direction;


-- 4. Debit Spending by Merchant Category
SELECT
    merchant_category,
    COUNT(*) AS total_transactions,
    SUM(transaction_amount) AS total_amount,
    AVG(transaction_amount) AS average_amount
FROM transactions
WHERE transaction_direction = 'Debit'
GROUP BY merchant_category
ORDER BY total_amount DESC;


-- 5. Monthly Expense Trend
SELECT
    YEAR(transaction_date) AS year,
    MONTH(transaction_date) AS month,
    COUNT(*) AS total_transactions,
    SUM(transaction_amount) AS total_expense,
    AVG(transaction_amount) AS average_expense
FROM transactions
WHERE transaction_direction = 'Debit'
GROUP BY YEAR(transaction_date), MONTH(transaction_date)
ORDER BY year, month;


-- 6. Top 10 Customers by Expense
SELECT
    customer_id,
    COUNT(*) AS total_transactions,
    SUM(transaction_amount) AS total_expense,
    AVG(transaction_amount) AS average_expense
FROM transactions
WHERE transaction_direction = 'Debit'
GROUP BY customer_id
ORDER BY total_expense DESC
LIMIT 10;


-- 7. Top 20 High-Value Fraudulent Transactions
SELECT
    transaction_id,
    customer_id,
    transaction_date,
    transaction_type,
    transaction_amount,
    transaction_direction,
    merchant_category,
    channel,
    is_fraud
FROM transactions
WHERE is_fraud = 1
ORDER BY transaction_amount DESC
LIMIT 20;


-- 8. Fraud Rate by Transaction Type
SELECT
    transaction_type,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_transactions,
    ROUND(
        SUM(is_fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percent
FROM transactions
GROUP BY transaction_type
ORDER BY fraud_rate_percent DESC;


-- 9. Fraud Rate by Channel
SELECT
    channel,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_transactions,
    ROUND(
        SUM(is_fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percent
FROM transactions
GROUP BY channel
ORDER BY fraud_rate_percent DESC;


-- 10. High-Value Transactions
SELECT
    COUNT(*) AS high_value_transactions,
    SUM(is_fraud) AS fraud_transactions,
    ROUND(
        SUM(is_fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percent
FROM transactions
WHERE transaction_amount > 1000000;


-- 11. Fraud by Transaction Hour
SELECT
    transaction_hour,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_transactions,
    ROUND(
        SUM(is_fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percent
FROM transactions
GROUP BY transaction_hour
ORDER BY fraud_rate_percent DESC;