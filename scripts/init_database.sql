/*
=========================================================================================
Create the database & schemas
=========================================================================================

Script Purpose:
	This script creates a new database called 'bookstore_marketing', after checking if it
	exists prior to the start of this new project. If it does, then it drops the said
	database. If not, it is created.
	
	Additionally, 3 data schemas are created within the database:
		- 'bronze'
		- 'silver'
		- 'gold'

Warning:
	If you have a similar database called 'bookstore_marketing' then it PERMANENTLY deletes
	the said database. Proceed with caution & ensure you have proper backups prior to running
	this script
*/

USE master;
GO

-- If the 'bookstore_marketing' database exists prior to the project, drops the database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'bookstore_marketing')
	BEGIN
		ALTER DATABASE bookstore_marketing SET SINGLE USER WITH ROLLBACK IMMEDIATE
		DROP DATABASE bookstore_marketing
	END;
GO

-- Creates the 'bookstore_marketing' database
CREATE DATABASE bookstore_marketing;
GO

USE bookstore_marketing;
GO

-- Creates the data schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO