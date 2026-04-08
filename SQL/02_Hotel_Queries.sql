USE hotel_db;

DELETE FROM booking_commercials;
DELETE FROM bookings;
DELETE FROM items;
DELETE FROM users;

-- USERS
INSERT INTO users VALUES
('21wrcxuy-67erfn', 'John Doe', '9712345678', 'john.doe@example.com', 'Street Y, ABC City'),
('31abcdxy-78ghjk', 'Jane Smith', '9812345678', 'jane.smith@example.com', 'Street Z, XYZ City');


-- ITEMS
INSERT INTO items VALUES
('itm-a9e8-q8fu', 'Tawa Paratha', 18),
('itm-a07vh-aer8', 'Mix Veg', 89),
('itm-w978-23u4', 'Paneer Curry', 150);


-- BOOKINGS
INSERT INTO bookings VALUES
('bk-09f3e-95hj', '2021-09-23 07:36:48', 'rm-bhf9-aerjn', '21wrcxuy-67erfn'),
('bk-q034-q4o', '2021-10-15 10:15:00', 'rm-xh12-ert9', '31abcdxy-78ghjk'),
('bk-new-1', '2021-10-20 11:00:00', 'rm-new-1', '21wrcxuy-67erfn'),
('bk-11aa-22bb', '2021-11-10 09:00:00', 'rm-zz99-yy88', '21wrcxuy-67erfn');


-- BOOKING COMMERCIALS
INSERT INTO booking_commercials VALUES
('q34r-3q4o8-q34u', 'bk-09f3e-95hj', 'bl-0a87y-q340', '2021-09-23 12:03:22', 'itm-a9e8-q8fu', 3),
('q3o4-ahf32-o2u4', 'bk-09f3e-95hj', 'bl-0a87y-q340', '2021-09-23 12:03:22', 'itm-a07vh-aer8', 1),
('bill-new-1', 'bk-new-1', 'bl-new-1', '2021-10-20 13:00:00', 'itm-w978-23u4', 10),
('134lr-oyfo8-3qk4', 'bk-q034-q4o', 'bl-34qhd-r7h8', '2021-10-15 12:05:37', 'itm-w978-23u4', 8),
('44abc-xyz-9999', 'bk-11aa-22bb', 'bl-77tt-8899', '2021-11-10 13:00:00', 'itm-a9e8-q8fu', 5),
('55def-xyz-8888', 'bk-11aa-22bb', 'bl-77tt-8899', '2021-11-10 13:00:00', 'itm-a07vh-aer8', 2);


-- Q1: Last booked room per user
SELECT user_id, room_no
FROM (
    SELECT user_id, room_no,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY booking_date DESC) AS rn
    FROM bookings
) t
WHERE rn = 1;


-- Q2: Total billing in November 2021
SELECT 
    bc.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_bill
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE MONTH(bc.bill_date) = 11
  AND YEAR(bc.bill_date) = 2021
GROUP BY bc.booking_id;


-- Q3: Bills > 1000 in October 2021
SELECT 
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE MONTH(bc.bill_date) = 10
  AND YEAR(bc.bill_date) = 2021
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000;


-- Q4: Most & least ordered item per month
WITH item_counts AS (
    SELECT 
        MONTH(bc.bill_date) AS month,
        i.item_name,
        SUM(bc.item_quantity) AS total_qty,
        RANK() OVER (PARTITION BY MONTH(bc.bill_date)
                     ORDER BY SUM(bc.item_quantity) DESC) AS rnk_desc,
        RANK() OVER (PARTITION BY MONTH(bc.bill_date)
                     ORDER BY SUM(bc.item_quantity) ASC) AS rnk_asc
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), i.item_name
)
SELECT * FROM item_counts
WHERE rnk_desc = 1 OR rnk_asc = 1;


-- Q5: Second highest bill per month
WITH bills AS (
    SELECT 
        MONTH(bill_date) AS month,
        bill_id,
        SUM(item_quantity * i.item_rate) AS total_bill,
        RANK() OVER (PARTITION BY MONTH(bill_date)
                     ORDER BY SUM(item_quantity * i.item_rate) DESC) AS rnk
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bill_date) = 2021
    GROUP BY MONTH(bill_date), bill_id
)
SELECT * FROM bills WHERE rnk = 2;