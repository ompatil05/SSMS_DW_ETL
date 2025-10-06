DROP TABLE IF EXISTS silver.crm_cust_info
CREATE TABLE silver.crm_cust_info(
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_first_name VARCHAR(50),
	cst_last_name VARCHAR(50),
	cst_martial_status VARCHAR(50),
	cst_gndr VARCHAR(50),
	cst_create_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

DROP TABLE IF EXISTS silver.crm_prd_info
CREATE TABLE  silver.crm_prd_info(
	prd_id INT,
	cat_id NVARCHAR(50),
	prd_key NVARCHAR(50),
	prd_nm VARCHAR(50),
	prd_cost INT,
	prd_line VARCHAR(50),
	prd_start_date DATE,
	prd_end_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
)

DROP TABLE IF EXISTS silver.crm_sales_details
CREATE TABLE silver.crm_sales_details
(
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT, 
	sls_order_date NVARCHAR(50),
	sls_ship_date NVARCHAR(50),
	sls_due_date NVARCHAR(50),
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
)

DROP TABLE IF EXISTS silver.erp_cust_AZ12
CREATE TABLE silver.erp_cust_AZ12 (
	cid NVARCHAR(50),
	birth_date DATE,
	gndr VARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
)

DROP TABLE IF EXISTS silver.erp_loc_A101
CREATE TABLE  silver.erp_loc_A101(
	cid NVARCHAR(50),
	country VARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
)

DROP TABLE IF EXISTS silver.erp_px_cat_G1V2
CREATE TABLE silver.erp_px_cat_G1V2 (
	id NVARCHAR(50),
	category VARCHAR(50),
	sub_category NVARCHAR(50),
	maintenance NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
)