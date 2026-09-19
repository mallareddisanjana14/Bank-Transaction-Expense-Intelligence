USE bank_transaction_db;


-- =====================================================
-- 1. Fraud Rate by Transaction Type
-- =====================================================

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


-- =====================================================
-- 2. Fraud Rate by Channel
-- =====================================================

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


-- =====================================================
-- 3. Fraud Rate by Transaction Type and Channel
-- =====================================================

SELECT
    transaction_type,
    channel,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_transactions,
    ROUND(
        SUM(is_fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percent
FROM transactions
GROUP BY transaction_type, channel
HAVING COUNT(*) >= 500
ORDER BY fraud_rate_percent DESC;


-- =====================================================
-- 4. High-Value Transactions Above ₹10 Lakh
-- =====================================================

SELECT
    COUNT(*) AS high_value_transactions,
    SUM(is_fraud) AS fraud_transactions,
    ROUND(
        SUM(is_fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percent
FROM transactions
WHERE transaction_amount > 1000000;


-- =====================================================
-- 5. High-Value Fraud by Transaction Type
-- =====================================================

SELECT
    transaction_type,
    COUNT(*) AS high_value_transactions,
    SUM(is_fraud) AS fraud_transactions,
    ROUND(
        SUM(is_fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percent
FROM transactions
WHERE transaction_amount > 1000000
GROUP BY transaction_type
ORDER BY fraud_rate_percent DESC;


-- =====================================================
-- 6. Amount-Based Risk Classification
-- =====================================================

SELECT
    CASE
        WHEN transaction_amount > 1000000
            THEN 'High Amount Risk'
        ELSE 'Normal Amount'
    END AS risk_category,

    COUNT(*) AS total_transactions,

    SUM(is_fraud) AS fraud_transactions,

    ROUND(
        SUM(is_fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percent

FROM transactions

GROUP BY
    CASE
        WHEN transaction_amount > 1000000
            THEN 'High Amount Risk'
        ELSE 'Normal Amount'
    END;


-- =====================================================
-- 7. Fraud Rate by Transaction Hour
-- =====================================================

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


-- =====================================================
-- 8. Rule-Based Risk Classification
-- =====================================================

SELECT
    risk_category,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_transactions,

    ROUND(
        SUM(is_fraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_percent

FROM
(
    SELECT
        is_fraud,

        CASE

            WHEN transaction_amount > 1000000
                 AND transaction_type IN
                 ('NEFT', 'RTGS', 'Cheque')
                THEN 'High Risk'

            WHEN transaction_amount > 1000000
                 OR transaction_type IN
                 ('NEFT', 'RTGS', 'Cheque')
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