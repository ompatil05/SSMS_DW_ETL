# SSMS_DW_ETL
Modern Data Warehouse project demonstrating ETL workflow , data extraction , data cleaning , data loading and a three- Layer architecture using SQL Server.

## 🏗️ Data Architecture

The data architecture for this project follows Medallion Architecture Bronze, Silver, and Gold layers: Data Architecture

<div style="margin: 0; padding: 0;">
  <img src="https://github.com/ompatil05/SSMS_DW_ETL/blob/main/docs/High_Level_Architecture.drawio.png?raw=true"
       alt="Data Architecture"
       style="display: block; width: 100vw; height: auto; margin: 0; padding: 0;"/>
</div>

1. **Bronze Layer**:Stores Raw Data as-in from the source systems. Data is ingested from CSV Files into SQL Database
2. **Silver Layer**:This Layer involves Data Transformation like Data Cleaning ,Standardization and normalization processes to prepare data for analysis.
3. **Gold Layer**:This layer contains Buisness Ready data for Analysis and Model Devlopment


## sql-data-analytics

A comprehensive collection of SQL scripts for data exploration, analytics, and reporting. These scripts cover various analyses such as database exploration, measures and metrics, time-based trends, cumulative analytics, segmentation, and more. This repository contains SQL queries designed to help data analysts and BI professionals quickly explore, segment, and analyze data within a relational database. Each script focuses on a specific analytical theme and demonstrates best practices for SQL queries.



## 📖 Project Overview

This Project involves :

1) **Data Architecture:** Designing a Modern Datawarhouse Using Medallion Architecture Bronze , Silver and Gold Layers
2) **ETL Pipelines:** Extracting , transforming and loading data from source systems into the  warehouse.
3) **Data Modeling:** Developing fact and dimension tables optimized for analytical queries.
4) **Analytics & Reporting:** Creating SQL-based reports and dashboards for actionable insights.

🚀 This repository showcase expertise in:
- SQL Development
- Data Architect
- Data Engineering
- ETL Pipeline Developer
- Data Modeling
- Data Analytics

## 📂 Repository Structure

  data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (ERP and CRM data)
│
├── docs/                               # Project documentation and architecture details
│   ├── etl.drawio                      # Draw.io file shows all different techniquies and methods of ETL
│   ├── data_architecture.drawio        # Draw.io file shows the project's architecture
│   ├── data_catalog.md                 # Catalog of datasets, including field descriptions and metadata
│   ├── data_flow.drawio                # Draw.io file for the data flow diagram
│   ├── data_models.drawio              # Draw.io file for data models (star schema)
│   ├── naming-conventions.md           # Consistent naming guidelines for tables, columns, and files
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   ├── gold/                           # Scripts for creating analytical models
│
├── tests/                              # Test scripts and quality files
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
├── .gitignore                          # Files and directories to be ignored by Git
└── requirements.txt                    # Dependencies and requirements for the project
