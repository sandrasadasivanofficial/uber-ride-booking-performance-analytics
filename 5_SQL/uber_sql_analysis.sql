create database uber;
use uber;

SET SQL_SAFE_UPDATES = 0;
UPDATE ncr_ride_bookings_cleaned
SET `Avg VTAT` = NULL
WHERE `Avg VTAT` = '';

UPDATE ncr_ride_bookings_cleaned
SET `Avg CTAT` = NULL
WHERE `Avg CTAT` = '';

UPDATE ncr_ride_bookings_cleaned
SET `Booking Value` = NULL
WHERE `Booking Value` = '';

UPDATE ncr_ride_bookings_cleaned
SET `Ride Distance` = NULL
WHERE `Ride Distance` = '';

UPDATE ncr_ride_bookings_cleaned
SET `Driver Ratings` = NULL
WHERE `Driver Ratings` = '';

UPDATE ncr_ride_bookings_cleaned
SET `Customer Rating` = NULL
WHERE `Customer Rating` = '';

ALTER TABLE ncr_ride_bookings_cleaned
    MODIFY COLUMN `Date` DATE,
    MODIFY COLUMN `Time` TIME,
    MODIFY COLUMN `Avg VTAT` DOUBLE,
    MODIFY COLUMN `Avg CTAT` DOUBLE,
    MODIFY COLUMN `Booking Value` DECIMAL(10,2),
    MODIFY COLUMN `Ride Distance` DOUBLE,
    MODIFY COLUMN `Driver Ratings` DOUBLE,
    MODIFY COLUMN `Customer Rating` DOUBLE;

ALTER TABLE ncr_ride_bookings_cleaned
    MODIFY COLUMN `Booking ID` VARCHAR(50),
    MODIFY COLUMN `Booking Status` VARCHAR(50),
    MODIFY COLUMN `Customer ID` VARCHAR(50),
    MODIFY COLUMN `Vehicle Type` VARCHAR(100),
    MODIFY COLUMN `Pickup Location` VARCHAR(100),
    MODIFY COLUMN `Drop Location` VARCHAR(100),
    MODIFY COLUMN `Reason for cancelling by Customer` VARCHAR(255),
    MODIFY COLUMN `Driver Cancellation Reason` VARCHAR(255),
    MODIFY COLUMN `Incomplete Rides Reason` VARCHAR(255),
    MODIFY COLUMN `Payment Method` VARCHAR(100);

SET SQL_SAFE_UPDATES = 1;

USE uber;

-- 1 DATASET OVERVIEW
------------------------
-- Display the first 10 bookings
SELECT *
FROM ncr_ride_bookings_cleaned
LIMIT 10;

-- Display table columns and data types
DESCRIBE ncr_ride_bookings_cleaned;

-- Find the total number of bookings
SELECT COUNT(*) AS total_bookings
FROM ncr_ride_bookings_cleaned;

-- Find the total number of unique bookings
SELECT COUNT(DISTINCT `Booking ID`) AS unique_bookings
FROM ncr_ride_bookings_cleaned;

-- Find the total number of unique customers
SELECT COUNT(DISTINCT `Customer ID`) AS unique_customers
FROM ncr_ride_bookings_cleaned;

-- Find the number of duplicate booking IDs
SELECT COUNT(*) AS duplicate_booking_ids
FROM (
    SELECT `Booking ID`
    FROM ncr_ride_bookings_cleaned
    WHERE `Booking ID` IS NOT NULL
    GROUP BY `Booking ID`
    HAVING COUNT(*) > 1
) AS duplicate_ids;

-- Display all booking statuses
SELECT DISTINCT `Booking Status`
FROM ncr_ride_bookings_cleaned;

-- Display all vehicle types
SELECT DISTINCT `Vehicle Type`
FROM ncr_ride_bookings_cleaned;

-- Display all payment methods
SELECT DISTINCT `Payment Method`
FROM ncr_ride_bookings_cleaned;

-- Find the earliest and latest booking dates
SELECT MIN(`Date`) AS earliest_date,
       MAX(`Date`) AS latest_date
FROM ncr_ride_bookings_cleaned;

-- Count missing values in important columns
SELECT
    SUM(`Booking ID` IS NULL) AS missing_booking_ids,
    SUM(`Customer ID` IS NULL) AS missing_customer_ids,
    SUM(`Booking Value` IS NULL) AS missing_booking_values,
    SUM(`Ride Distance` IS NULL) AS missing_ride_distances,
    SUM(`Driver Ratings` IS NULL) AS missing_driver_ratings,
    SUM(`Customer Rating` IS NULL) AS missing_customer_ratings
FROM ncr_ride_bookings_cleaned;

-- 2.BOOKING PERFORMANCE ANALYSIS
------------------------------------
-- Find the number of bookings for each vehicle type
SELECT `Vehicle Type`,
       COUNT(*) AS booking_count
FROM ncr_ride_bookings_cleaned
GROUP BY `Vehicle Type`
ORDER BY booking_count DESC;

-- Find the number of bookings for each payment method
SELECT `Payment Method`,
       COUNT(*) AS booking_count
FROM ncr_ride_bookings_cleaned
GROUP BY `Payment Method`
ORDER BY booking_count DESC;

-- Find the vehicle types with more than 1000 bookings
SELECT `Vehicle Type`,
       COUNT(*) AS booking_count
FROM ncr_ride_bookings_cleaned
GROUP BY `Vehicle Type`
HAVING COUNT(*) > 1000
ORDER BY booking_count DESC;

-- Compare booking statuses across vehicle types
SELECT `Vehicle Type`,
       `Booking Status`,
       COUNT(*) AS booking_count
FROM ncr_ride_bookings_cleaned
GROUP BY `Vehicle Type`, `Booking Status`
ORDER BY `Vehicle Type`, booking_count DESC;

-- 3.BOOKING VALUE AND RIDE DISTANCE ANALYSIS
------------------------------------------------
-- Find the total booking value
SELECT SUM(`Booking Value`) AS total_booking_value
FROM ncr_ride_bookings_cleaned;

-- Find the average booking value
SELECT AVG(`Booking Value`) AS average_booking_value
FROM ncr_ride_bookings_cleaned;

-- Find the highest and lowest booking values
SELECT MAX(`Booking Value`) AS highest_booking_value,
       MIN(`Booking Value`) AS lowest_booking_value
FROM ncr_ride_bookings_cleaned;

-- Find the total and average ride distance
SELECT SUM(`Ride Distance`) AS total_ride_distance,
       AVG(`Ride Distance`) AS average_ride_distance
FROM ncr_ride_bookings_cleaned;

-- Find bookings with a value greater than 1000
SELECT `Booking ID`, `Booking Value`
FROM ncr_ride_bookings_cleaned
WHERE `Booking Value` > 1000;

-- Find bookings with a value between 500 and 2000
SELECT `Booking ID`, `Booking Value`
FROM ncr_ride_bookings_cleaned
WHERE `Booking Value` BETWEEN 500 AND 2000;

-- Find bookings with a ride distance greater than 10
SELECT `Booking ID`, `Ride Distance`
FROM ncr_ride_bookings_cleaned
WHERE `Ride Distance` > 10;

-- Find the 10 bookings with the highest booking values
SELECT `Booking ID`, `Vehicle Type`, `Booking Value`
FROM ncr_ride_bookings_cleaned
WHERE `Booking Value` IS NOT NULL
ORDER BY `Booking Value` DESC
LIMIT 10;

-- Find the 10 longest rides
SELECT `Booking ID`,
       `Pickup Location`,
       `Drop Location`,
       `Ride Distance`
FROM ncr_ride_bookings_cleaned
WHERE `Ride Distance` IS NOT NULL
ORDER BY `Ride Distance` DESC
LIMIT 10;

-- Find bookings with a value above the overall average
SELECT `Booking ID`, `Booking Value`
FROM ncr_ride_bookings_cleaned
WHERE `Booking Value` > (
    SELECT AVG(`Booking Value`)
    FROM ncr_ride_bookings_cleaned
);

-- Find rides longer than the average ride distance
SELECT `Booking ID`, `Ride Distance`
FROM ncr_ride_bookings_cleaned
WHERE `Ride Distance` > (
    SELECT AVG(`Ride Distance`)
    FROM ncr_ride_bookings_cleaned
);

-- Find bookings with the highest booking value
SELECT `Booking ID`, `Booking Value`
FROM ncr_ride_bookings_cleaned
WHERE `Booking Value` = (
    SELECT MAX(`Booking Value`)
    FROM ncr_ride_bookings_cleaned
);

-- Compare average and total booking value by vehicle type
SELECT `Vehicle Type`,
       AVG(`Booking Value`) AS average_booking_value,
       SUM(`Booking Value`) AS total_booking_value
FROM ncr_ride_bookings_cleaned
GROUP BY `Vehicle Type`
ORDER BY total_booking_value DESC;

-- Find average ride distance by vehicle type
SELECT `Vehicle Type`,
       AVG(`Ride Distance`) AS average_ride_distance
FROM ncr_ride_bookings_cleaned
GROUP BY `Vehicle Type`
ORDER BY average_ride_distance DESC;

-- Find average booking value by payment method
SELECT `Payment Method`,
       AVG(`Booking Value`) AS average_booking_value
FROM ncr_ride_bookings_cleaned
GROUP BY `Payment Method`
ORDER BY average_booking_value DESC;

-- Find total booking value by payment method
SELECT `Payment Method`,
       SUM(`Booking Value`) AS total_booking_value
FROM ncr_ride_bookings_cleaned
GROUP BY `Payment Method`
ORDER BY total_booking_value DESC;

-- Check whether longer rides have higher booking values
SELECT
    CASE
        WHEN `Ride Distance` < 5 THEN 'Short Ride'
        WHEN `Ride Distance` <= 15 THEN 'Medium Ride'
        WHEN `Ride Distance` > 15 THEN 'Long Ride'
        ELSE 'Unknown'
    END AS ride_category,
    COUNT(*) AS booking_count,
    AVG(`Booking Value`) AS average_booking_value
FROM ncr_ride_bookings_cleaned
GROUP BY ride_category
ORDER BY average_booking_value DESC;


-- 4.CUSTOMER AND DRIVER RATINGS ANALYSIS

-- Find the average driver and customer ratings
SELECT AVG(`Driver Ratings`) AS average_driver_rating,
       AVG(`Customer Rating`) AS average_customer_rating
FROM ncr_ride_bookings_cleaned;

-- Find bookings with driver ratings below 3
SELECT `Booking ID`, `Driver Ratings`
FROM ncr_ride_bookings_cleaned
WHERE `Driver Ratings` < 4;

-- Find bookings with customer ratings below 3
SELECT `Booking ID`, `Customer Rating`
FROM ncr_ride_bookings_cleaned
WHERE `Customer Rating` < 4;

-- Compare average driver and customer ratings by vehicle type
SELECT `Vehicle Type`,
       AVG(`Driver Ratings`) AS average_driver_rating,
       AVG(`Customer Rating`) AS average_customer_rating
FROM ncr_ride_bookings_cleaned
GROUP BY `Vehicle Type`
ORDER BY average_driver_rating DESC;

-- Find customers who made more than one booking
SELECT `Customer ID`,
       COUNT(*) AS total_bookings
FROM ncr_ride_bookings_cleaned
WHERE `Customer ID` IS NOT NULL
GROUP BY `Customer ID`
HAVING COUNT(*) > 1
ORDER BY total_bookings DESC;

-- Count customers who made more than one booking
SELECT COUNT(*) AS repeat_customers
FROM (
    SELECT `Customer ID`
    FROM ncr_ride_bookings_cleaned
    WHERE `Customer ID` IS NOT NULL
    GROUP BY `Customer ID`
    HAVING COUNT(*) > 1
) AS customer_bookings;


-- 5.CANCELLATION AND INCOMPLETE RIDE ANALYSIS
------------------------------------------------
-- Count customer cancellations, driver cancellations and incomplete rides
SELECT
    SUM(`Cancelled Rides by Customer`) AS customer_cancellations,
    SUM(`Cancelled Rides by Driver`) AS driver_cancellations,
    SUM(`Incomplete Rides`) AS incomplete_rides
FROM ncr_ride_bookings_cleaned;

-- Find reasons for customer cancellations
SELECT `Reason for cancelling by Customer`,
       COUNT(*) AS cancellation_count
FROM ncr_ride_bookings_cleaned
WHERE `Reason for cancelling by Customer` IS NOT NULL
GROUP BY `Reason for cancelling by Customer`
ORDER BY cancellation_count DESC;

-- Find reasons for driver cancellations
SELECT `Driver Cancellation Reason`,
       COUNT(*) AS cancellation_count
FROM ncr_ride_bookings_cleaned
WHERE `Driver Cancellation Reason` IS NOT NULL
GROUP BY `Driver Cancellation Reason`
ORDER BY cancellation_count DESC;

-- Find reasons for incomplete rides
SELECT `Incomplete Rides Reason`,
       COUNT(*) AS incomplete_ride_count
FROM ncr_ride_bookings_cleaned
WHERE `Incomplete Rides Reason` IS NOT NULL
GROUP BY `Incomplete Rides Reason`
ORDER BY incomplete_ride_count DESC;

-- 6.PICKUP, DROP LOCATION AND ROUTE ANALYSIS
------------------------------------------------
-- Find the number of bookings for each pickup location
SELECT `Pickup Location`,
       COUNT(*) AS booking_count
FROM ncr_ride_bookings_cleaned
GROUP BY `Pickup Location`
ORDER BY booking_count DESC;

-- Find the number of bookings for each drop location
SELECT `Drop Location`,
       COUNT(*) AS booking_count
FROM ncr_ride_bookings_cleaned
GROUP BY `Drop Location`
ORDER BY booking_count DESC;

-- Find the 10 most frequently booked pickup-to-drop routes
SELECT `Pickup Location`,
       `Drop Location`,
       COUNT(*) AS route_bookings
FROM ncr_ride_bookings_cleaned
WHERE `Pickup Location` IS NOT NULL
  AND `Drop Location` IS NOT NULL
GROUP BY `Pickup Location`, `Drop Location`
ORDER BY route_bookings DESC
LIMIT 10;

-- Find routes with the highest average booking value
SELECT `Pickup Location`,
       `Drop Location`,
       COUNT(*) AS route_bookings,
       AVG(`Booking Value`) AS average_booking_value
FROM ncr_ride_bookings_cleaned
WHERE `Pickup Location` IS NOT NULL
  AND `Drop Location` IS NOT NULL
GROUP BY `Pickup Location`, `Drop Location`
HAVING COUNT(*) >= 10
ORDER BY average_booking_value DESC
LIMIT 10;

-- 7.DATE AND TIME ANALYSIS
-------------------------------
-- Find daily booking counts
SELECT `Date`,
       COUNT(*) AS booking_count
FROM ncr_ride_bookings_cleaned
GROUP BY `Date`
ORDER BY `Date`;

-- Find monthly booking counts
SELECT YEAR(`Date`) AS booking_year,
       MONTH(`Date`) AS booking_month,
       COUNT(*) AS booking_count
FROM ncr_ride_bookings_cleaned
GROUP BY YEAR(`Date`), MONTH(`Date`)
ORDER BY booking_year, booking_month;

-- Find monthly total booking value
SELECT YEAR(`Date`) AS booking_year,
       MONTH(`Date`) AS booking_month,
       SUM(`Booking Value`) AS total_booking_value
FROM ncr_ride_bookings_cleaned
GROUP BY YEAR(`Date`), MONTH(`Date`)
ORDER BY booking_year, booking_month;

-- Find booking counts by hour
SELECT HOUR(`Time`) AS booking_hour,
       COUNT(*) AS booking_count
FROM ncr_ride_bookings_cleaned
WHERE `Time` IS NOT NULL
GROUP BY HOUR(`Time`)
ORDER BY booking_hour;

-- Find the busiest day of the week
SELECT DAYNAME(`Date`) AS booking_day,
       COUNT(*) AS booking_count
FROM ncr_ride_bookings_cleaned
WHERE `Date` IS NOT NULL
GROUP BY DAYNAME(`Date`)
ORDER BY booking_count DESC;

-- Compare average booking value by day of the week
SELECT DAYNAME(`Date`) AS booking_day,
       AVG(`Booking Value`) AS average_booking_value
FROM ncr_ride_bookings_cleaned
WHERE `Date` IS NOT NULL
GROUP BY DAYNAME(`Date`)
ORDER BY average_booking_value DESC;

-- 8.VEHICLE AND CUSTOMER ARRIVAL TIME ANALYSIS
-----------------------------------------------
-- Find average vehicle and customer arrival times
SELECT AVG(`Avg VTAT`) AS average_vtat,
       AVG(`Avg CTAT`) AS average_ctat
FROM ncr_ride_bookings_cleaned;

-- Compare average arrival times by vehicle type
SELECT `Vehicle Type`,
       AVG(`Avg VTAT`) AS average_vtat,
       AVG(`Avg CTAT`) AS average_ctat
FROM ncr_ride_bookings_cleaned
GROUP BY `Vehicle Type`
ORDER BY average_vtat;

-- 9.BOOKING VALUE CATEGORIES
----------------------------------
-- Categorize bookings by booking value
SELECT `Booking ID`,
       `Booking Value`,
       CASE
           WHEN `Booking Value` IS NULL THEN 'Unknown'
           WHEN `Booking Value` < 500 THEN 'Low'
           WHEN `Booking Value` <= 1500 THEN 'Medium'
           ELSE 'High'
       END AS booking_value_category
FROM ncr_ride_bookings_cleaned
LIMIT 100;

-- Count bookings in each booking value category
SELECT
    CASE
        WHEN `Booking Value` IS NULL THEN 'Unknown'
        WHEN `Booking Value` < 500 THEN 'Low'
        WHEN `Booking Value` <= 1500 THEN 'Medium'
        ELSE 'High'
    END AS booking_value_category,
    COUNT(*) AS booking_count
FROM ncr_ride_bookings_cleaned
GROUP BY booking_value_category
ORDER BY booking_count DESC;


-- 10.RANKING VEHICLE TYPES
-------------------------------
-- Rank vehicle types by number of bookings
SELECT `Vehicle Type`,
       COUNT(*) AS booking_count,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS vehicle_booking_rank
FROM ncr_ride_bookings_cleaned
GROUP BY `Vehicle Type`;


-- 11.STRING FUNCTIONS
------------------
-- Display booking IDs in uppercase
SELECT UPPER(`Booking ID`) AS booking_id
FROM ncr_ride_bookings_cleaned
LIMIT 10;

-- Display vehicle types in lowercase
SELECT LOWER(`Vehicle Type`) AS vehicle_type
FROM ncr_ride_bookings_cleaned
LIMIT 10;

-- Find the length of booking IDs
SELECT `Booking ID`,
       LENGTH(`Booking ID`) AS booking_id_length
FROM ncr_ride_bookings_cleaned
LIMIT 10;

-- Combine pickup and drop locations into a route
SELECT `Booking ID`,
       CONCAT(`Pickup Location`, ' - ', `Drop Location`) AS ride_route
FROM ncr_ride_bookings_cleaned
LIMIT 10;

-- 12.CREATE OR UPDATE VIEWS
------------------
-- Create or update a view containing booking details
CREATE OR REPLACE VIEW booking_details AS
SELECT `Booking ID`,
       `Date`,
       `Time`,
       `Booking Status`,
       `Customer ID`,
       `Vehicle Type`,
       `Pickup Location`,
       `Drop Location`,
       `Booking Value`,
       `Ride Distance`
FROM ncr_ride_bookings_cleaned;

-- Display booking details from the view
SELECT *
FROM booking_details
LIMIT 100;

-- Create or update a view containing cancelled bookings
CREATE OR REPLACE VIEW cancelled_bookings AS
SELECT `Booking ID`,
       `Date`,
       `Booking Status`,
       `Vehicle Type`,
       `Pickup Location`,
       `Drop Location`
FROM ncr_ride_bookings_cleaned
WHERE LOWER(`Booking Status`) LIKE '%cancel%';

-- Display cancelled bookings from the view
SELECT *
FROM cancelled_bookings
LIMIT 100;
