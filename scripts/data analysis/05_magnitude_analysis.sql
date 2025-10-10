/*
===============================================================================
Magnitude Analysis
===============================================================================
Purpose:
    - To quantify data and group results by specific dimensions.
    - For understanding data distribution across categories.

SQL Functions Used:
    - Aggregate Functions: SUM(), COUNT(), AVG()
    - GROUP BY, ORDER BY
===============================================================================
*/

-- TOTAL CUSTOMERS BY GENDER 
SELECT 
	gender,
	COUNT(*) AS total_customers ,
	CONCAT(ROUND(CAST(COUNT(*) AS FLOAT) / SUM(COUNT(*)) OVER() * 100, 2) , '%' )AS percentage
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

-- TOTAL CUSTOMERS BY COUNTRIES
SELECT 
	country,
	COUNT(*) AS total_customers,
	CONCAT(ROUND(CAST(100 * COUNT(*) AS FLOAT)/ SUM(COUNT(*)) OVER() , 2) , '%') AS percentage
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;

-- HOW MANY OF OUR CUSTOMERS ARE SINGLE OR MARRIED 
SELECT 
	martial_status,
	COUNT(*) AS TOTAL_CUSTOMERS,
	CONCAT(ROUND(CAST(100 * COUNT(*)  AS FLOAT)/ SUM(COUNT(*)) OVER() , 2),'%') AS percentage
FROM gold.dim_customers
GROUP BY martial_status;

-- AVG COST IN EACH CATEGORY 
SELECT 
	category,
	AVG(cost) AS avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC;

 -- TOTAL REVENUE GENRATED BY EACH CATEGORY  
SELECT 
	P.category,
	SUM(S.sales_amount) AS total_cost,
	CONCAT(ROUND(100 * SUM(CAST(S.sales_amount  AS FLOAT))/ SUM(SUM(S.sales_amount)) OVER() ,2 ) , '%') AS cost_share_percentage
FROM  gold.fact_sales AS S 
LEFT JOIN gold.dim_products AS P
ON P.product_key = S.product_key
GROUP BY P.category
ORDER BY total_cost DESC;

-- DISTRIBUTION OF SOLD ITEMS ACROSS COUNTRIES 
SELECT
	country,
	COUNT(S.quantity)  AS Sold_quantity
FROM gold.fact_sales AS S
LEFT JOIN gold.dim_customers AS C
ON C.customer_key = S.customer_key
GROUP BY country
ORDER BY Sold_quantity DESC;   

-- WHAT IS THE TOTAL REVENUE GENRATED BY EACH CUSTOMERS 
SELECT 
	TOP 5
	C.customer_key,
	C.first_name,
	C.last_name,
	SUM(S.sales_amount) AS total_revenue
FROM gold.fact_sales AS S 
LEFT JOIN gold.dim_customers AS C 
ON C.customer_key = S.customer_key
GROUP BY C.customer_key,
		 C.first_name,
		 C.last_name
ORDER BY total_revenue DESC;

-- Find total products by category
SELECT
    category,
    COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;