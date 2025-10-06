-- GOLD DIM CUSTOMERS VIEW
CREATE OR ALTER VIEW gold.dim_customers AS
SELECT 
    ROW_NUMBER() OVER(ORDER BY CI.cst_id) AS customer_key, -- surrogate key
    CI.cst_id AS customer_id,
    CI.cst_key AS customer_number,
    CI.cst_first_name AS first_name,
    CI.cst_last_name AS last_name,
    CL.country AS country,
    CI.cst_martial_status AS martial_status,
    CASE 
        WHEN CI.cst_gndr != 'n/a' THEN CI.cst_gndr
        ELSE COALESCE(CE.gndr, 'n/a')
    END AS gender,
    CE.birth_date AS birth_date,
    CI.cst_create_date AS create_date
FROM silver.crm_cust_info AS CI
LEFT JOIN silver.erp_cust_AZ12 AS CE
    ON CI.cst_id = CE.cid
LEFT JOIN silver.erp_loc_A101 AS CL
    ON CI.cst_id = CL.cid;
GO

-- GOLD DIM PRODUCTS VIEW
CREATE OR ALTER VIEW gold.dim_products AS
SELECT 
    ROW_NUMBER() OVER(ORDER BY PO.prd_start_date, PO.prd_key) AS product_key, -- surrogate key
    PO.prd_id AS product_id,
    PO.prd_key AS product_number,
    PO.prd_nm AS product_name,
    PO.cat_id AS category_id,
    PX.category AS category,
    PX.sub_category AS subcategory,
    PX.maintenance AS maintenance,
    PO.prd_cost AS cost,
    PO.prd_line AS product_line,
    PO.prd_start_date AS start_date
FROM silver.crm_prd_info AS PO
LEFT JOIN silver.erp_px_cat_G1V2 AS PX
    ON PO.cat_id = PX.id
WHERE PO.prd_end_date IS NULL;  -- filter out historical data
GO
   
-- GOLD FACT SALES VIEW
CREATE OR ALTER VIEW gold.fact_sales AS 
SELECT 
    SD.sls_ord_num AS order_number,
    PR.product_key,
    CK.customer_key,
    SD.sls_order_date AS order_date,
    SD.sls_ship_date AS ship_date,
    SD.sls_due_date AS due_date,
    SD.sls_sales AS sales_amount,
    SD.sls_quantity AS quantity,
    SD.sls_price AS price
FROM silver.crm_sales_details AS SD
LEFT JOIN gold.dim_products AS PR
ON PR.product_number = SD.sls_prd_key
LEFT JOIN gold.dim_customers AS CK
ON CK.customer_id = SD.sls_cust_id;
GO