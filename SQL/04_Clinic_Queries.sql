USE clinic_db;

-- Optional: clear old data
DELETE FROM clinic_sales;
DELETE FROM expenses;
DELETE FROM customer;
DELETE FROM clinics;

-- CLINICS
INSERT INTO clinics VALUES
('c1', 'Platinum Rx Clinic', 'Hyderabad', 'Telangana', 'India'),
('c2', 'HealthCare Plus', 'Mumbai', 'Maharashtra', 'India'),
('c3', 'City Care Clinic', 'Hyderabad', 'Telangana', 'India'),
('c4', 'Wellness Center', 'Mumbai', 'Maharashtra', 'India');

-- CUSTOMERS
INSERT INTO customer VALUES
('u1', 'Ravi Kumar', '9876543210'),
('u2', 'Sneha Reddy', '9123456780'),
('u3', 'Amit Sharma', '9988776655');

-- CLINIC SALES
INSERT INTO clinic_sales VALUES
('o1', 'u1', 'c1', 500, '2021-10-05 10:30:00', 'online'),
('o2', 'u2', 'c1', 1200, '2021-10-15 12:00:00', 'offline'),
('o3', 'u3', 'c2', 800, '2021-11-10 14:00:00', 'online'),
('o4', 'u1', 'c1', 1500, '2021-11-20 16:00:00', 'offline'),
('o5', 'u2', 'c2', 2000, '2021-12-05 11:00:00', 'online'),
('o6', 'u1', 'c3', 700, '2021-10-10 10:00:00', 'online'),
('o7', 'u2', 'c4', 600, '2021-10-12 11:00:00', 'offline');

-- EXPENSES
INSERT INTO expenses VALUES
('e1', 'c1', 'Electricity Bill', 300, '2021-10-01 09:00:00'),
('e2', 'c1', 'Staff Salary', 2000, '2021-10-31 18:00:00'),
('e3', 'c2', 'Rent', 1500, '2021-11-01 10:00:00'),
('e4', 'c2', 'Maintenance', 500, '2021-11-15 12:00:00'),
('e5', 'c1', 'Medicines Purchase', 1000, '2021-12-01 13:00:00'),
('e6', 'c3', 'Maintenance', 200, '2021-10-05 09:00:00'),
('e7', 'c4', 'Rent', 300, '2021-10-06 10:00:00');

-- Q1: Revenue by channel
SELECT 
    sales_channel,
    SUM(amount) AS revenue
FROM clinic_sales
WHERE EXTRACT(YEAR FROM datetime) = 2021
GROUP BY sales_channel;

-- Q2: Top 10 customers
SELECT 
    uid,
    SUM(amount) AS total_spent
FROM clinic_sales
WHERE EXTRACT(YEAR FROM datetime) = 2021
GROUP BY uid
ORDER BY total_spent DESC
LIMIT 10;

-- Q3: Month-wise profit/loss
WITH revenue AS (
    SELECT 
        DATE_FORMAT(datetime, '%Y-%m') AS month,
        SUM(amount) AS total_revenue
    FROM clinic_sales
    GROUP BY DATE_FORMAT(datetime, '%Y-%m')
),
expense AS (
    SELECT 
        DATE_FORMAT(datetime, '%Y-%m') AS month,
        SUM(amount) AS total_expense
    FROM expenses
    GROUP BY DATE_FORMAT(datetime, '%Y-%m')
)
SELECT 
    r.month,
    r.total_revenue,
    e.total_expense,
    (r.total_revenue - e.total_expense) AS profit,
    CASE 
        WHEN (r.total_revenue - e.total_expense) > 0 THEN 'Profitable'
        ELSE 'Not Profitable'
    END AS status
FROM revenue r
JOIN expense e 
ON r.month = e.month;

-- Q4: Most profitable clinic per city
WITH profit_calc AS (
    SELECT 
        c.city,
        c.cid,
        SUM(cs.amount) - COALESCE(SUM(e.amount),0) AS profit,
        RANK() OVER (PARTITION BY c.city ORDER BY (SUM(cs.amount) - COALESCE(SUM(e.amount),0)) DESC) AS rnk
    FROM clinics c
    JOIN clinic_sales cs ON c.cid = cs.cid
    LEFT JOIN expenses e ON c.cid = e.cid
    GROUP BY c.city, c.cid
)
SELECT * FROM profit_calc WHERE rnk = 1;

-- Q5: Second least profitable clinic per state
WITH profit_calc AS (
    SELECT 
        c.state,
        c.cid,
        SUM(cs.amount) - COALESCE(SUM(e.amount),0) AS profit,
        RANK() OVER (PARTITION BY c.state ORDER BY (SUM(cs.amount) - COALESCE(SUM(e.amount),0)) ASC) AS rnk
    FROM clinics c
    JOIN clinic_sales cs ON c.cid = cs.cid
    LEFT JOIN expenses e ON c.cid = e.cid
    GROUP BY c.state, c.cid
)
SELECT * FROM profit_calc WHERE rnk = 2;
