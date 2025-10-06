CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN
    BEGIN TRY
        DECLARE @STARTTIME DATETIME, @ENDTIME DATETIME;

        SET @STARTTIME = GETDATE();
        PRINT '==============================================';
        PRINT 'LOADING SILVER LAYER';
        PRINT '==============================================';

        -- CRM CUST INFO
        PRINT '-----------------------------------------------';
        PRINT 'LOADING CRM CUSTOMER INFO TABLE';
        PRINT '-----------------------------------------------';

        SET @STARTTIME = GETDATE();
        PRINT '>>> TRUNCATE TABLE: silver.crm_cust_info';
        TRUNCATE TABLE silver.crm_cust_info;

        PRINT '>>> INSERT DATA INTO: silver.crm_cust_info';
        INSERT INTO silver.crm_cust_info (
            cst_id,
            cst_key,
            cst_first_name,
            cst_last_name,
            cst_martial_status,
            cst_gndr,
            cst_create_date
        )
        SELECT
            cst_id,
            cst_key,
            TRIM(cst_first_name),
            TRIM(cst_last_name),
            CASE 
                WHEN TRIM(UPPER(cst_martial_status)) = 'S' THEN 'Single'
                WHEN TRIM(UPPER(cst_martial_status)) = 'M' THEN 'Married'
                ELSE 'n/a'
            END AS cst_martial_status,
            CASE 
                WHEN TRIM(UPPER(cst_gndr)) = 'F' THEN 'Female'
                WHEN TRIM(UPPER(cst_gndr)) = 'M' THEN 'Male'
                ELSE 'n/a'
            END AS cst_gndr,
            cst_create_date
        FROM (
            SELECT *,
                   ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag
            FROM bronze.crm_cust_info
            WHERE cst_id IS NOT NULL
        ) t
        WHERE flag = 1;

        SET @ENDTIME = GETDATE();
        PRINT '>>> LOADING TIME FOR silver.crm_cust_info: ' + CAST(DATEDIFF(SECOND, @STARTTIME, @ENDTIME) AS NVARCHAR) + ' SECONDS';

        -- CRM PRODUCT INFO
        PRINT '-----------------------------------------------';
        PRINT 'LOADING CRM PRODUCT INFO TABLE';
        PRINT '-----------------------------------------------';

        SET @STARTTIME = GETDATE();
        PRINT '>>> TRUNCATE TABLE: silver.crm_prd_info';
        TRUNCATE TABLE silver.crm_prd_info;

        PRINT '>>> INSERT DATA INTO: silver.crm_prd_info';
        INSERT INTO silver.crm_prd_info (
            prd_id,
            cat_id,
            prd_key,
            prd_nm,
            prd_cost,
            prd_line,
            prd_start_date,
            prd_end_date
        )
        SELECT
            prd_id,
            REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
            SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
            prd_nm,
            COALESCE(prd_cost, 0) AS prd_cost,
            CASE UPPER(TRIM(prd_line))
                WHEN 'M' THEN 'Mountain'
                WHEN 'R' THEN 'Road'
                WHEN 'S' THEN 'Other Sales'
                WHEN 'T' THEN 'Touring'
                ELSE 'n/a'
            END AS prd_line,
            prd_start_date,
            DATEADD(DAY, -1, LEAD(prd_start_date) OVER(PARTITION BY prd_key ORDER BY prd_start_date)) AS prd_end_date
        FROM bronze.crm_prd_info;

        SET @ENDTIME = GETDATE();
        PRINT '>>> LOADING TIME FOR silver.crm_prd_info: ' + CAST(DATEDIFF(SECOND, @STARTTIME, @ENDTIME) AS NVARCHAR) + ' SECONDS';

        -- CRM SALES DETAILS
        PRINT '-----------------------------------------------';
        PRINT 'LOADING CRM SALES DETAILS TABLE';
        PRINT '-----------------------------------------------';

        SET @STARTTIME = GETDATE();
        PRINT '>>> TRUNCATE TABLE: silver.crm_sales_details';
        TRUNCATE TABLE silver.crm_sales_details;

        PRINT '>>> INSERT DATA INTO: silver.crm_sales_details';
        INSERT INTO silver.crm_sales_details (
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            sls_order_date,
            sls_ship_date,
            sls_due_date,
            sls_sales,
            sls_quantity,
            sls_price
        )
        SELECT
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            CASE WHEN sls_order_date = 0 OR LEN(sls_order_date) != 8 THEN NULL
                 ELSE CAST(CAST(sls_order_date AS NVARCHAR) AS DATE)
            END AS sls_order_date,
            CASE WHEN sls_ship_date = 0 OR LEN(sls_ship_date) != 8 THEN NULL
                 ELSE CAST(CAST(sls_ship_date AS NVARCHAR) AS DATE)
            END AS sls_ship_date,
            CASE WHEN sls_due_date = 0 OR LEN(sls_due_date) != 8 THEN NULL
                 ELSE CAST(CAST(sls_due_date AS NVARCHAR) AS DATE)
            END AS sls_due_date,
            CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
                 THEN sls_quantity * ABS(sls_price)
                 ELSE sls_sales
            END AS sls_sales,
            sls_quantity,
            CASE WHEN sls_price IS NULL OR sls_price <= 0 OR sls_price != sls_sales / COALESCE(sls_quantity, 0)
                 THEN sls_sales / COALESCE(sls_quantity, 0)
                 ELSE sls_price
            END AS sls_price
        FROM bronze.crm_sales_details;

        SET @ENDTIME = GETDATE();
        PRINT '>>> LOADING TIME FOR silver.crm_sales_details: ' + CAST(DATEDIFF(SECOND, @STARTTIME, @ENDTIME) AS NVARCHAR) + ' SECONDS';

        -- ERP CUSTOMER AZ12
        PRINT '-----------------------------------------------';
        PRINT 'LOADING ERP CUST AZ12 TABLE';
        PRINT '-----------------------------------------------';

        SET @STARTTIME = GETDATE();
        PRINT '>>> TRUNCATE TABLE: silver.erp_cust_AZ12';
        TRUNCATE TABLE silver.erp_cust_AZ12;

        PRINT '>>> INSERT DATA INTO: silver.erp_cust_AZ12';
        INSERT INTO silver.erp_cust_AZ12 (
            cid,
            birth_date,
            gndr
        )
        SELECT
            SUBSTRING(cid, 9, LEN(TRIM(cid))) AS cid,
            birth_date,
            CASE 
                WHEN UPPER(TRIM(gndr)) IN ('F', 'FEMALE') THEN 'Female'
                WHEN UPPER(TRIM(gndr)) IN ('M', 'MALE') THEN 'Male'
                ELSE 'n/a'
            END AS gndr
        FROM bronze.erp_cust_AZ12;

        SET @ENDTIME = GETDATE();
        PRINT '>>> LOADING TIME FOR silver.erp_cust_AZ12: ' + CAST(DATEDIFF(SECOND, @STARTTIME, @ENDTIME) AS NVARCHAR) + ' SECONDS';

        -- ERP LOCATION A101
        PRINT '-----------------------------------------------';
        PRINT 'LOADING ERP LOC A101 TABLE';
        PRINT '-----------------------------------------------';

        SET @STARTTIME = GETDATE();
        PRINT '>>> TRUNCATE TABLE: silver.erp_loc_A101';
        TRUNCATE TABLE silver.erp_loc_A101;

        PRINT '>>> INSERT DATA INTO: silver.erp_loc_A101';
        INSERT INTO silver.erp_loc_A101 (
            cid,
            country
        )
        SELECT
            SUBSTRING(cid, 7, LEN(TRIM(cid))) AS cid,
            CASE
                WHEN UPPER(TRIM(country)) IN ('US', 'UNITED STATES', 'USA') THEN 'USA'
                WHEN UPPER(TRIM(country)) IN ('DE', 'GERMANY') THEN 'GER'
                WHEN UPPER(TRIM(country)) IN ('AU', 'AUSTRALIA') THEN 'AUS'
                WHEN UPPER(TRIM(country)) IN ('UK', 'UNITED KINGDOM') THEN 'UK'
                WHEN UPPER(TRIM(country)) IN ('CA', 'CANADA') THEN 'CA'
                WHEN UPPER(TRIM(country)) IN ('FR', 'FRANCE') THEN 'FRA'
                ELSE 'n/a'
            END AS country
        FROM bronze.erp_loc_A101;

        SET @ENDTIME = GETDATE();
        PRINT '>>> LOADING TIME FOR silver.erp_loc_A101: ' + CAST(DATEDIFF(SECOND, @STARTTIME, @ENDTIME) AS NVARCHAR) + ' SECONDS';

        -- ERP PX CATEGORY G1V2
        PRINT '-----------------------------------------------';
        PRINT 'LOADING ERP PX CAT G1V2 TABLE';
        PRINT '-----------------------------------------------';

        SET @STARTTIME = GETDATE();
        PRINT '>>> TRUNCATE TABLE: silver.erp_px_cat_G1V2';
        TRUNCATE TABLE silver.erp_px_cat_G1V2;

        PRINT '>>> INSERT DATA INTO: silver.erp_px_cat_G1V2';
        INSERT INTO silver.erp_px_cat_G1V2 (
            id,
            category,
            sub_category,
            maintenance
        )
        SELECT
            id,
            category,
            sub_category,
            maintenance
        FROM bronze.erp_px_cat_G1V2;

        SET @ENDTIME = GETDATE();
        PRINT '>>> TOTAL LOADING TIME: ' + CAST(DATEDIFF(SECOND, @STARTTIME, @ENDTIME) AS NVARCHAR) + ' SECONDS';

        PRINT '==============================================';
        PRINT 'SILVER LAYER LOAD COMPLETED SUCCESSFULLY';
        PRINT '==============================================';
    END TRY
    BEGIN CATCH
        PRINT '==============================================';
        PRINT 'ERROR OCCURRED DURING LOADING SILVER LAYER';
        PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
        PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'ERROR STATE: ' + CAST(ERROR_STATE() AS NVARCHAR);
    END CATCH
END;
GO

-- Execute the procedure
EXEC silver.load_silver;
