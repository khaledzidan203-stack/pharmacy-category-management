/*
Pharmacy Category Management Portfolio
01_create_schema.sql
Purpose: Create a compact, reviewable SQL Server analytical environment.
Data: Synthetic portfolio data only.
*/

IF DB_ID('PharmacyCategoryPortfolio') IS NULL
BEGIN
    CREATE DATABASE PharmacyCategoryPortfolio;
END;
GO

USE PharmacyCategoryPortfolio;
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'stg')
    EXEC('CREATE SCHEMA stg');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'analytics')
    EXEC('CREATE SCHEMA analytics');
GO
