-- Create and select database
CREATE DATABASE IF NOT EXISTS hotel_db;
USE hotel_db;

-- Users table
CREATE TABLE users (
    user_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    phone_number VARCHAR(20),
    mail_id VARCHAR(100),
    billing_address TEXT
);

-- Bookings table
CREATE TABLE bookings (
    booking_id VARCHAR(50) PRIMARY KEY,
    booking_date TIMESTAMP,
    room_no VARCHAR(50),
    user_id VARCHAR(50)
);

-- Items table
CREATE TABLE items (
    item_id VARCHAR(50) PRIMARY KEY,
    item_name VARCHAR(100),
    item_rate DECIMAL(10,2)
);

-- Booking commercials table
CREATE TABLE booking_commercials (
    id VARCHAR(50) PRIMARY KEY,
    booking_id VARCHAR(50),
    bill_id VARCHAR(50),
    bill_date TIMESTAMP,
    item_id VARCHAR(50),
    item_quantity DECIMAL(10,2)
);