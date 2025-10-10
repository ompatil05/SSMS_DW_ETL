/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Determine the first and last order date and the total duration in months
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months
FROM gold.fact_sales;

-- FIND THE OLDEST AND YOUNGEST CUSTOMERS 
WITH CustomerAge AS (
	SELECT 
		customer_key,
		CONCAT(first_name, ' ', last_name) AS customer_name,
		birth_date,
		DATEDIFF(YEAR, birth_date, GETDATE()) AS age
	FROM gold.dim_customers
	WHERE birth_date IS NOT NULL
)
SELECT *
FROM CustomerAge 
WHERE birth_date = (SELECT MIN(birth_date) FROM CustomerAge)
   OR birth_date = (SELECT MAX(birth_date) FROM CustomerAge)

-- AVG AGE OF CUSTOMERS 
SELECT 
	AVG(DATEDIFF(YEAR , birth_date , GETDATE())) AS AVG_AGE 
FROM gold.dim_customers