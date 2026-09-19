CREATE DATABASE bank_transaction_db;

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