# Run on Windows Server after SQL Server is installed

$ErrorActionPreference = "Stop"

$SqlInstance = "localhost\SQLEXPRESS"
$DbName      = "labdb"
$SqlUser     = "labuser"
$SqlPassword = "ChangeMe123!"

Write-Host "Creating database and SQL login..."

$query = @"
-- Create database
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = '$DbName')
  CREATE DATABASE [$DbName];
GO

USE [$DbName];

-- Create login
IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = '$SqlUser')
BEGIN
  CREATE LOGIN [$SqlUser] WITH PASSWORD = '$SqlPassword';
END

-- Create user and grant access
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = '$SqlUser')
BEGIN
  CREATE USER [$SqlUser] FOR LOGIN [$SqlUser];
  ALTER ROLE db_datareader ADD MEMBER [$SqlUser];
  ALTER ROLE db_datawriter ADD MEMBER [$SqlUser];
END

-- Create sample table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='products' AND xtype='U')
BEGIN
  CREATE TABLE products (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
  );

  INSERT INTO products (name, price) VALUES
    ('Croissant', 2.50),
    ('Sourdough Loaf', 6.00),
    ('Cinnamon Roll', 3.25);
END
GO
"@

sqlcmd -S $SqlInstance -E -Q $query
Write-Host "Database, user, and sample products table created."
