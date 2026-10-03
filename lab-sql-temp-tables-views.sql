USE sakila;

-- Step 1: Create a View
DROP TEMPORARY TABLE IF EXISTS rental_sumarizes;

CREATE OR REPLACE VIEW rental_sumarizes AS
SELECT
c.customer_id,
c.first_name,
c.last_name,
c.email,
COUNT(r.rental_id) AS rental_count
FROM customer c
LEFT JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY
c.customer_id,
c.first_name,
c.last_name,
c.email;

-- Step 2: Create a Temporary Table
CREATE TEMPORARY TABLE customer_total_paid AS
SELECT
rs.customer_id,
SUM(p.amount) AS total_paid
FROM rental_sumarizes rs
LEFT JOIN payment p
ON rs.customer_id = p.customer_id
GROUP BY rs.customer_id;

SELECT * FROM customer_total_paid;

-- Step 3: Create a CTE and the Customer Summary Report

WITH customer_sumary_cte AS
(SELECT
rs.first_name,
rs.last_name,
rs.email,
rs.rental_count,
ctp.total_paid
FROM rental_sumarizes rs
JOIN customer_total_paid ctp
ON rs.customer_id = ctp.customer_id)
SELECT
first_name,
last_name,
email,
rental_count,
total_paid,
total_paid / rental_count AS average
FROM customer_sumary_cte;
