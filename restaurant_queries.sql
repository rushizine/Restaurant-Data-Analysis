-- =====================================================================
-- Restaurant Data Analysis - SQL (MySQL)
-- Table: restaurants  (loaded from data/restaurants_clean.csv)
-- Note: rating = 0 means "not rated", so averages use aggregate_rating > 0
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1: CREATE TABLE AND LOAD DATA
-- ---------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS restaurant_db;
USE restaurant_db;

CREATE TABLE restaurants (
    restaurant_id        INT,
    restaurant_name      VARCHAR(255),
    country_code         INT,
    city                 VARCHAR(100),
    address              VARCHAR(500),
    locality             VARCHAR(255),
    locality_verbose     VARCHAR(255),
    longitude            DECIMAL(10, 6),
    latitude             DECIMAL(10, 6),
    cuisines             VARCHAR(255),
    average_cost_for_two INT,
    currency             VARCHAR(50),
    has_table_booking    VARCHAR(3),
    has_online_delivery  VARCHAR(3),
    is_delivering_now    VARCHAR(3),
    switch_to_order_menu VARCHAR(3),
    price_range          INT,
    aggregate_rating     DECIMAL(2, 1),
    rating_color         VARCHAR(20),
    rating_text          VARCHAR(20),
    votes                INT
);

-- Check: should show 9551
SELECT COUNT(*) AS total_restaurants FROM restaurants;

-- Top 3 cuisines and their percentage
-- (LIKE finds the cuisine name anywhere inside the cuisines text)
-- Numbers can differ by 0.03% from Python because a few restaurants repeat a cuisine twice.
SELECT 'North Indian' AS cuisine,
       COUNT(*) AS restaurants,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM restaurants), 2) AS percentage
FROM restaurants WHERE cuisines LIKE '%North Indian%'
UNION ALL
SELECT 'Chinese', COUNT(*),
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM restaurants), 2)
FROM restaurants WHERE cuisines LIKE '%Chinese%'
UNION ALL
SELECT 'Fast Food', COUNT(*),
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM restaurants), 2)
FROM restaurants WHERE cuisines LIKE '%Fast Food%';


-- City with the most restaurants
SELECT city, COUNT(*) AS restaurants
FROM restaurants
GROUP BY city
ORDER BY restaurants DESC
LIMIT 1;

-- Average rating of each city (only cities with 20+ rated restaurants)
SELECT city,
       COUNT(*) AS rated_restaurants,
       ROUND(AVG(aggregate_rating), 2) AS avg_rating
FROM restaurants
WHERE aggregate_rating > 0
GROUP BY city
HAVING COUNT(*) >= 20
ORDER BY avg_rating DESC;


-- Price range - count and percentage
SELECT price_range,
       COUNT(*) AS restaurants,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM restaurants), 2) AS percentage
FROM restaurants
GROUP BY price_range
ORDER BY price_range;


-- Percentage of restaurants with online delivery
SELECT has_online_delivery,
       COUNT(*) AS restaurants,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM restaurants), 2) AS percentage
FROM restaurants
GROUP BY has_online_delivery;

-- Average rating with and without online delivery
SELECT has_online_delivery,
       ROUND(AVG(aggregate_rating), 2) AS avg_rating
FROM restaurants
WHERE aggregate_rating > 0
GROUP BY has_online_delivery;

-- Same comparison inside India only (country_code = 1)
SELECT has_online_delivery,
       ROUND(AVG(aggregate_rating), 2) AS avg_rating
FROM restaurants
WHERE aggregate_rating > 0 AND country_code = 1
GROUP BY has_online_delivery;


-- Rating distribution (rating ranges)
SELECT CASE WHEN aggregate_rating <= 2.0 THEN '0 - 2.0'
            WHEN aggregate_rating <= 2.5 THEN '2.1 - 2.5'
            WHEN aggregate_rating <= 3.0 THEN '2.6 - 3.0'
            WHEN aggregate_rating <= 3.5 THEN '3.1 - 3.5'
            WHEN aggregate_rating <= 4.0 THEN '3.6 - 4.0'
            WHEN aggregate_rating <= 4.5 THEN '4.1 - 4.5'
            ELSE '4.6 - 5.0' END AS rating_range,
       COUNT(*) AS restaurants
FROM restaurants
WHERE aggregate_rating > 0
GROUP BY rating_range
ORDER BY rating_range;

-- Average votes
SELECT ROUND(AVG(votes), 1) AS avg_votes_all FROM restaurants;
SELECT ROUND(AVG(votes), 1) AS avg_votes_rated FROM restaurants WHERE aggregate_rating > 0;


-- Most common cuisine combinations (2 or more cuisines)
SELECT cuisines, COUNT(*) AS restaurants
FROM restaurants
WHERE cuisines LIKE '%,%'
GROUP BY cuisines
ORDER BY restaurants DESC
LIMIT 10;

-- Average rating of combinations (20+ rated restaurants)
SELECT cuisines,
       COUNT(*) AS rated_restaurants,
       ROUND(AVG(aggregate_rating), 2) AS avg_rating
FROM restaurants
WHERE aggregate_rating > 0 AND cuisines LIKE '%,%'
GROUP BY cuisines
HAVING COUNT(*) >= 20
ORDER BY avg_rating DESC
LIMIT 10;


-- Busiest localities (remove rows with wrong coordinates)
SELECT locality, city, COUNT(*) AS restaurants
FROM restaurants
WHERE longitude <> 0 AND latitude <> 0
GROUP BY locality, city
ORDER BY restaurants DESC
LIMIT 10;


-- Restaurant chains (same name used 5+ times)
SELECT restaurant_name,
       COUNT(*) AS outlets,
       ROUND(AVG(CASE WHEN aggregate_rating > 0 THEN aggregate_rating END), 2) AS avg_rating,
       SUM(votes) AS total_votes
FROM restaurants
GROUP BY restaurant_name
HAVING COUNT(*) >= 5
ORDER BY outlets DESC
LIMIT 10;


-- Top 10 restaurants by votes
SELECT restaurant_name, city, aggregate_rating, votes
FROM restaurants
ORDER BY votes DESC
LIMIT 10;

-- Lowest votes (rated restaurants only; 0-vote restaurants are all unrated)
SELECT restaurant_name, city, aggregate_rating, votes
FROM restaurants
WHERE aggregate_rating > 0
ORDER BY votes ASC
LIMIT 10;

-- Average rating by number of votes
SELECT CASE WHEN votes <= 50  THEN '1. Below 50'
            WHEN votes <= 200 THEN '2. 50-200'
            WHEN votes <= 1000 THEN '3. 200-1000'
            ELSE '4. Above 1000' END AS votes_group,
       COUNT(*) AS restaurants,
       ROUND(AVG(aggregate_rating), 2) AS avg_rating
FROM restaurants
WHERE aggregate_rating > 0
GROUP BY votes_group
ORDER BY votes_group;


--  % with online delivery and table booking in each price range
SELECT price_range,
       COUNT(*) AS restaurants,
       ROUND(SUM(CASE WHEN has_online_delivery = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_online_delivery,
       ROUND(SUM(CASE WHEN has_table_booking = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_table_booking
FROM restaurants
GROUP BY price_range
ORDER BY price_range;
