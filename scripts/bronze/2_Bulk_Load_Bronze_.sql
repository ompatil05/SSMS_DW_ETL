CREATE OR ALTER PROCEDURE bronze.load_bronze
AS 
BEGIN

	BEGIN TRY
		DECLARE @STARTTIME DATETIME , @ENDTIME DATETIME;

		SET @STARTTIME = GETDATE();
		PRINT '==============================================';
		PRINT 'LOADING BRONZE LAYER';
		PRINT '==============================================';

		-- CRM CUST INFO
		PRINT '-----------------------------------------------';
		PRINT 'LOADING CRM CUSTOMER INFO TABLE';
		PRINT '-----------------------------------------------';

		SET @STARTTIME = GETDATE();
		PRINT '>>> TRUNCATE TABLE: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>>> INSERT DATA INTO: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info 
		FROM 'F:\1_Data_Warehouse_Project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @ENDTIME = GETDATE();
		PRINT'>>> LOADING TIME FOR bronze.crm_cust_info:'+ CAST(DATEDIFF(SECOND , @STARTTIME , @ENDTIME) AS NVARCHAR) + 'SECONDS';

		-- CRM PRODUCT INFO
		PRINT '-----------------------------------------------';
		PRINT 'LOADING CRM PRODUCT INFO TABLE';
		PRINT '-----------------------------------------------';

		SET @STARTTIME = GETDATE();
		PRINT '>>> TRUNCATE TABLE: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>>> INSERT DATA INTO:bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'F:\1_Data_Warehouse_Project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @ENDTIME = GETDATE();
		PRINT'>>> LOADING TIME FOR bronze.crm_prd_info:' + CAST(DATEDIFF(SECOND ,@STARTTIME , @ENDTIME)AS NVARCHAR) + 'SECONDS';

	-- CRM SALES DETAILS
		PRINT '-----------------------------------------------';
		PRINT 'LOADING CRM SALES DETAILS TABLE';
		PRINT '-----------------------------------------------';

		SET @STARTTIME = GETDATE();
		PRINT '>>> TRUNCATE TABLE: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>>> INSERT DATA INTO: bronze.crm_sls_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'F:\1_Data_Warehouse_Project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @ENDTIME = GETDATE();
		PRINT'>>> LOADING TIME FOR bronze.crm_sales_details:' + CAST(DATEDIFF(SECOND ,@STARTTIME , @ENDTIME)AS NVARCHAR) + 'SECONDS';


		-- ERP CUSTOMER AZ12
		PRINT '-----------------------------------------------';
		PRINT 'LOADING ERP CUST AZ12 TABLE';
		PRINT '-----------------------------------------------';

		SET @STARTTIME = GETDATE();
		PRINT '>>> TRUNCATE TABLE: bronze.erp_cust_AZ12';
		TRUNCATE TABLE bronze.erp_cust_AZ12;

		PRINT '>>> INSERT DATA INTO: bronze.erp_cust_AZ12';
		BULK INSERT bronze.erp_cust_AZ12
		FROM 'F:\1_Data_Warehouse_Project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @ENDTIME = GETDATE();
		PRINT'>>> LOADING TIME FOR bronze.erp_cust_AZ12:' + CAST(DATEDIFF(SECOND ,@STARTTIME , @ENDTIME)AS NVARCHAR) + 'SECONDS';


		-- ERP LOCATION A101
		PRINT '-----------------------------------------------';
		PRINT 'LOADING ERP LOC A101 TABLE';
		PRINT '-----------------------------------------------';

		SET @STARTTIME = GETDATE();
		PRINT '>>> TRUNCATE TABLE: bronze.erp_loc_A101';
		TRUNCATE TABLE bronze.erp_loc_A101;

		PRINT '>>> INSERT DATA INTO: bronze.erp_cust_AZ12';
		BULK INSERT bronze.erp_loc_A101
		FROM 'F:\1_Data_Warehouse_Project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @ENDTIME = GETDATE();
		PRINT'>>> LOADING TIME FOR bronze.erp_loc_A101:' + CAST(DATEDIFF(SECOND ,@STARTTIME , @ENDTIME)AS NVARCHAR) + 'SECONDS';

		-- ERP PX CATEGORY G1V2
		PRINT '-----------------------------------------------';
		PRINT 'LOADING ERP PX CAT G1V2 TABLE';
		PRINT '-----------------------------------------------';

		SET @STARTTIME = GETDATE();
		PRINT '>>> TRUNCATE TABLE: bronze.erp_px_cat_G1V2';
		TRUNCATE TABLE bronze.erp_px_cat_G1V2;

		PRINT '>>> INSERT DATA INTO: bronze.erp_px_cat_G1V2';
		BULK INSERT bronze.erp_px_cat_G1V2
		FROM 'F:\1_Data_Warehouse_Project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @ENDTIME = GETDATE();
		PRINT'>>> TOTAL LOADING TIME  FOR BRONZE LAYER :' + CAST(DATEDIFF(SECOND ,@STARTTIME , @ENDTIME)AS NVARCHAR) + 'SECONDS';

		PRINT '==============================================';
		PRINT 'BRONZE LAYER LOAD COMPLETED SUCCESSFULLY';
		PRINT '==============================================';
	END TRY 
	BEGIN CATCH 
		PRINT '==============================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'ERROR MESSAGE' + ERROR_MESSAGE();
		PRINT 'ERROR MESSAGE' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'ERROR MESSAGE' + CAST(ERROR_STATE() AS NVARCHAR);
	END CATCH
END
GO

-- EXECUTE the procedure
EXEC bronze.load_bronze;