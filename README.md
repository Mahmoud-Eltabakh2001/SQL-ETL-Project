# SQL-ETL-Project

Overview

This project demonstrates a basic ETL (Extract, Transform, Load) process using SQL. The goal is to extract data from a CSV file, transform and clean the data, and load it into a database.

Tools and Technologies
- SQL Server
- CSV file

Methodology
1. Data Extraction: The project uses the BULK INSERT command to extract data from a CSV file into a temporary table.
2. Data Transformation and Cleaning: The project applies various data transformation and cleaning techniques, such as  data type conversions, standardize columns and generate new columns.
3. Data Loading: The transformed and cleaned data is loaded into a database table.

Database Design
The project creates a database with a single table to store the transformed and cleaned data. The table schema is designed to accommodate the extracted data.

Code Structure
The project consists of several SQL Queries:

1. Data Extraction Script: This script uses the BULK INSERT command to extract data from the CSV file.
2. Data Transformation and Cleaning Script: This script applies various data transformation and cleaning techniques to the extracted data.
3. Data Loading Script: This script loads the transformed and cleaned data into the database table.

Results
The project demonstrates a successful ETL process, with the transformed and cleaned data loaded into the database table.
