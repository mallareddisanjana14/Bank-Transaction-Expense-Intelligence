USE bank_transaction_db;


-- =====================================================
-- 1. CTE: Customer Financial Summary
-- =====================================================

WITH customer_summary AS (
    SELECT
        customer_id,
        COUNT(*) AS total_transactions,

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
                ELSE 0
            END
        ) AS total_income

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


-- =====================================================
-- 2. Window Function: Customer Expense Ranking
-- =====================================================

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

    RANK() OVER (
        ORDER BY total_expense DESC
    ) AS expense_rank

FROM customer_expense
ORDER BY expense_rank
LIMIT 20;


-- =====================================================
-- 3. Window Function: Ranking Within Account Type
-- =====================================================

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


-- =====================================================
-- 4. Running Total of Monthly Expenses
-- =====================================================

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


-- =====================================================
-- 5. Create Customer Financial Summary View
-- =====================================================

CREATE OR REPLACE VIEW customer_financial_summary AS

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


-- Test the View

SELECT *
FROM customer_financial_summary
LIMIT 10;


-- =====================================================
-- 6. Stored Procedure: Customer Summary
-- =====================================================

DROP PROCEDURE IF EXISTS get_customer_summary;

DELIMITER //

CREATE PROCEDURE get_customer_summary(
    IN p_customer_id VARCHAR(20)
)

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


-- Test Stored Procedure

CALL get_customer_summary('CUST000002');


-- =====================================================
-- 7. Audit Table for Trigger
-- =====================================================

CREATE TABLE IF NOT EXISTS transaction_audit (

    audit_id INT AUTO_INCREMENT PRIMARY KEY,

    transaction_id VARCHAR(20),

    action_type VARCHAR(20),

    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);


-- =====================================================
-- 8. Trigger: Record New Transactions
-- =====================================================

DROP TRIGGER IF EXISTS after_transaction_insert;

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


-- =====================================================
-- 9. Index on Customer ID
-- =====================================================

CREATE INDEX idx_customer_id
ON transactions(customer_id);


-- =====================================================
-- 10. Check Index
-- =====================================================

SHOW INDEX
FROM transactions;


-- =====================================================
-- 11. Query Optimization Check
-- =====================================================

EXPLAIN

SELECT *

FROM transactions

WHERE customer_id = 'CUST038846';