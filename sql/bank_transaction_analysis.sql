CREATE DATABASE bank_transaction_db;

USE bank_transaction_db;

SHOW DATABASES;

USE bank_transaction_db;

CREATE TABLE transactions (
    transaction_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    transaction_date DATE,
    transaction_time TIME,
    account_type VARCHAR(30),
    transaction_type VARCHAR(30),
    transaction_amount DECIMAL(15,2),
    transaction_direction VARCHAR(10),
    account_balance DECIMAL(15,2),
    merchant_category VARCHAR(50),
    state VARCHAR(50),
    credit_score INT,
    has_loan TINYINT,
    loan_type VARCHAR(30),
    emi_amount DECIMAL(15,2),
    transaction_status VARCHAR(20),
    channel VARCHAR(30),
    kyc_status VARCHAR(20),
    is_fraud TINYINT,
    transaction_hour TINYINT
);


USE bank_transaction_db;

SHOW TABLES;

USE bank_transaction_db;

SELECT COUNT(*) AS total_rows
FROM transactions;

USE bank_transaction_db;

TRUNCATE TABLE transactions;

SELECT COUNT(*) AS total_rows
FROM transactions;

SELECT COUNT(*) FROM transactions;

SELECT
    transaction_type,
    transaction_direction,
    COUNT(*) AS total_transactions,
    SUM(transaction_amount) AS total_amount,
    AVG(transaction_amount) AS average_amount
FROM transactions
GROUP BY transaction_type, transaction_direction
ORDER BY transaction_type, transaction_direction;


SELECT
    merchant_category,
    COUNT(*) AS total_transactions,
    SUM(transaction_amount) AS total_amount,
    AVG(transaction_amount) AS average_amount
FROM transactions
WHERE transaction_direction = 'Debit'
GROUP BY merchant_category
ORDER BY total_amount DESC;


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


SELECT
    transaction_type,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_transactions,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_percent
FROM transactions
GROUP BY transaction_type
ORDER BY fraud_rate_percent DESC;


SELECT
    channel,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_transactions,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_percent
FROM transactions
GROUP BY channel
ORDER BY fraud_rate_percent DESC;


SELECT
    transaction_type,
    channel,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_transactions,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_percent
FROM transactions
GROUP BY transaction_type, channel
HAVING COUNT(*) >= 500
ORDER BY fraud_rate_percent DESC;

SELECT
    COUNT(*) AS high_value_transactions,
    SUM(is_fraud) AS fraud_transactions,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_percent
FROM transactions
WHERE transaction_amount > 1000000;

SELECT
    CASE
        WHEN transaction_amount > 1000000 THEN 'High Amount Risk'
        ELSE 'Normal Amount'
    END AS risk_category,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_transactions,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_percent
FROM transactions
GROUP BY
    CASE
        WHEN transaction_amount > 1000000 THEN 'High Amount Risk'
        ELSE 'Normal Amount'
    END;

SELECT
    transaction_type,
    COUNT(*) AS high_value_transactions,
    SUM(is_fraud) AS fraud_transactions,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_percent
FROM transactions
WHERE transaction_amount > 1000000
GROUP BY transaction_type
ORDER BY fraud_rate_percent DESC;


SELECT
    transaction_hour,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_transactions,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_percent
FROM transactions
GROUP BY transaction_hour
ORDER BY fraud_rate_percent DESC;


SELECT
    transaction_id,
    customer_id,
    transaction_date,
    transaction_type,
    transaction_amount,
    is_fraud,

    (
        CASE
            WHEN transaction_amount > 1000000 THEN 2
            ELSE 0
        END
        +
        CASE
            WHEN transaction_type IN ('NEFT', 'RTGS', 'Cheque') THEN 1
            ELSE 0
        END
    ) AS risk_score,

    CASE
        WHEN (
            CASE
                WHEN transaction_amount > 1000000 THEN 2
                ELSE 0
            END
            +
            CASE
                WHEN transaction_type IN ('NEFT', 'RTGS', 'Cheque') THEN 1
                ELSE 0
            END
        ) >= 3 THEN 'High Risk'

        WHEN (
            CASE
                WHEN transaction_amount > 1000000 THEN 2
                ELSE 0
            END
            +
            CASE
                WHEN transaction_type IN ('NEFT', 'RTGS', 'Cheque') THEN 1
                ELSE 0
            END
        ) >= 1 THEN 'Medium Risk'

        ELSE 'Low Risk'
    END AS risk_category

FROM transactions
LIMIT 20;


SELECT
    risk_category,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_transactions,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_percent
FROM
(
    SELECT
        is_fraud,
        CASE
            WHEN transaction_amount > 1000000
                 AND transaction_type IN ('NEFT', 'RTGS', 'Cheque')
                THEN 'High Risk'

            WHEN transaction_amount > 1000000
                 OR transaction_type IN ('NEFT', 'RTGS', 'Cheque')
                THEN 'Medium Risk'

            ELSE 'Low Risk'
        END AS risk_category
    FROM transactions
) AS risk_data
GROUP BY risk_category
ORDER BY
    CASE risk_category
        WHEN 'High Risk' THEN 1
        WHEN 'Medium Risk' THEN 2
        WHEN 'Low Risk' THEN 3
    END;
    
    
    WITH customer_summary AS (
    SELECT
        customer_id,
        COUNT(*) AS total_transactions,
        SUM(CASE
            WHEN transaction_direction = 'Debit'
            THEN transaction_amount
            ELSE 0
        END) AS total_expense,
        SUM(CASE
            WHEN transaction_direction = 'Credit'
            THEN transaction_amount
            ELSE 0
        END) AS total_income
    FROM transactions
    GROUP BY customer_id
)
SELECT
    customer_id,
    total_transactions,
    total_income,
    total_expense,
    total_income - total_expense AS net_flow
FROM customer_summary
ORDER BY net_flow DESC
LIMIT 10;


WITH customer_expense AS (
    SELECT
        customer_id,
        COUNT(*) AS total_transactions,
        SUM(transaction_amount) AS total_expense
    FROM transactions
    WHERE transaction_direction = 'Debit'
    GROUP BY customer_id
)
SELECT
    customer_id,
    total_transactions,
    total_expense,
    RANK() OVER (ORDER BY total_expense DESC) AS expense_rank
FROM customer_expense
ORDER BY expense_rank
LIMIT 20;


WITH customer_expense AS (
    SELECT
        customer_id,
        account_type,
        SUM(
            CASE
                WHEN transaction_direction = 'Debit'
                THEN transaction_amount
                ELSE 0
            END
        ) AS total_expense
    FROM transactions
    GROUP BY customer_id, account_type
)
SELECT
    customer_id,
    account_type,
    total_expense,
    RANK() OVER (
        PARTITION BY account_type
        ORDER BY total_expense DESC
    ) AS account_type_rank
FROM customer_expense
ORDER BY account_type, account_type_rank
LIMIT 30;


WITH monthly_expense AS (
    SELECT
        YEAR(transaction_date) AS year,
        MONTH(transaction_date) AS month,
        SUM(transaction_amount) AS monthly_expense
    FROM transactions
    WHERE transaction_direction = 'Debit'
    GROUP BY
        YEAR(transaction_date),
        MONTH(transaction_date)
)
SELECT
    year,
    month,
    monthly_expense,
    SUM(monthly_expense) OVER (
        ORDER BY year, month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_expense
FROM monthly_expense
ORDER BY year, month;


CREATE VIEW customer_financial_summary AS
SELECT
    customer_id,
    COUNT(*) AS total_transactions,

    SUM(
        CASE
            WHEN transaction_direction = 'Credit'
            THEN transaction_amount
            ELSE 0
        END
    ) AS total_income,

    SUM(
        CASE
            WHEN transaction_direction = 'Debit'
            THEN transaction_amount
            ELSE 0
        END
    ) AS total_expense,

    SUM(
        CASE
            WHEN transaction_direction = 'Credit'
            THEN transaction_amount
            ELSE -transaction_amount
        END
    ) AS net_flow

FROM transactions
GROUP BY customer_id;


SELECT *
FROM customer_financial_summary;




DELIMITER //

CREATE PROCEDURE get_customer_summary(IN p_customer_id VARCHAR(20))
BEGIN
    SELECT
        customer_id,
        COUNT(*) AS total_transactions,

        SUM(
            CASE
                WHEN transaction_direction = 'Credit'
                THEN transaction_amount
                ELSE 0
            END
        ) AS total_income,

        SUM(
            CASE
                WHEN transaction_direction = 'Debit'
                THEN transaction_amount
                ELSE 0
            END
        ) AS total_expense,

        SUM(
            CASE
                WHEN transaction_direction = 'Credit'
                THEN transaction_amount
                ELSE -transaction_amount
            END
        ) AS net_flow

    FROM transactions
    WHERE customer_id = p_customer_id
    GROUP BY customer_id;
END //

DELIMITER ;

CALL get_customer_summary('CUST000002');



CREATE TABLE transaction_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id VARCHAR(20),
    action_type VARCHAR(20),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


DELIMITER //

CREATE TRIGGER after_transaction_insert
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    INSERT INTO transaction_audit (
        transaction_id,
        action_type
    )
    VALUES (
        NEW.transaction_id,
        'INSERT'
    );
END //

DELIMITER ;


INSERT INTO transactions (
    transaction_id,
    customer_id,
    transaction_date,
    transaction_time,
    account_type,
    transaction_type,
    transaction_amount,
    transaction_direction,
    account_balance,
    merchant_category,
    state,
    credit_score,
    has_loan,
    loan_type,
    emi_amount,
    transaction_status,
    channel,
    kyc_status,
    is_fraud,
    transaction_hour
)
VALUES (
    'TEST_TRIGGER_001',
    'CUST000002',
    '2024-01-01',
    '12:00:00',
    'Savings',
    'UPI',
    100.00,
    'Debit',
    5000.00,
    'Retail',
    'Madhya Pradesh',
    700,
    0,
    NULL,
    0.00,
    'Success',
    'Mobile_App',
    'Verified',
    0,
    12
);


SELECT *
FROM transaction_audit
WHERE transaction_id = 'TEST_TRIGGER_001';


SELECT COUNT(*) AS test_rows
FROM transactions
WHERE transaction_id = 'TEST_TRIGGER_001';

SELECT COUNT(*) AS total_rows
FROM transactions;

DELETE FROM transactions
WHERE transaction_id = 'TEST_TRIGGER_001';


SELECT COUNT(*) AS total_rows
FROM transactions;

CREATE INDEX idx_customer_id
ON transactions(customer_id);

SHOW INDEX FROM transactions;

EXPLAIN
SELECT *
FROM transactions
WHERE customer_id = 'CUST038846';