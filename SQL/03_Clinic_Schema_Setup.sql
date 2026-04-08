CREATE DATABASE IF NOT EXISTS clinic_db;
USE clinic_db;

CREATE TABLE clinics (
    cid VARCHAR(50),
    clinic_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE customer (
    uid VARCHAR(50),
    name VARCHAR(100),
    mobile VARCHAR(20)
);

CREATE TABLE clinic_sales (
    oid VARCHAR(50),
    uid VARCHAR(50),
    cid VARCHAR(50),
    amount DECIMAL(10,2),
    datetime TIMESTAMP,
    sales_channel VARCHAR(50)
);

CREATE TABLE expenses (
    eid VARCHAR(50),
    cid VARCHAR(50),
    description TEXT,
    amount DECIMAL(10,2),
    datetime TIMESTAMP
);