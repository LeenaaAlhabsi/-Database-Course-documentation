--
--                                                                                1. Standard View
--What is it?
--Standard View is a virtual table created using a SELECT statement. It does not store data physically but shows data dynamically from underlying tables.

--Key Differences:
-- * No physical storage of data.
-- * Cannot have indexes (unless certain conditions are met).
-- * Used for abstraction and simplifying complex queries.

--Real-Life Use Case:
-- * University System: A view that shows all active students by joining student and enrollment tables, simplifying access for academic staff.

--Limitations & Performance:
-- * Cannot be used for high-performance querying across large data sets.
-- * Some views (with joins, aggregations) are not updatable.
-- * Changes in the base tables immediately reflect in the view.
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--                                                                      2. Indexed View (Also known as Materialized View)
--What is it?
--An Indexed View is a view that has a unique clustered index, which means SQL Server stores the result set physically. This improves performance for read-heavy workloads.

--Key Differences:
-- * Stores data physically (unlike standard views).
-- * Faster query performance.
-- * Has strict rules for creation (e.g., deterministic functions, schema binding).

--Real-Life Use Case:
-- * E-Commerce: A summary view of daily sales per product, improving dashboard load times and reporting.

--Limitations & Performance:
-- * Slower write performance (inserts/updates) due to index maintenance.
-- * Complex to manage and create.
-- * Not suitable for frequently changing data with high transaction rates.
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--                                                                          3. Partitioned View (Union View)
--What is it?
--A Partitioned View combines data from multiple tables (usually identical in structure) using UNION ALL. Useful for distributing data horizontally (e.g., across years or regions).

--Key Differences:
-- * Designed for horizontal partitioning.
-- * Often used with check constraints to optimize query execution.
-- * Can be local (one server) or distributed (across servers).

--Real-Life Use Case:
-- * Banking: Different transaction tables for each year (Transactions2023, Transactions2024, etc.) combined into a view for historical reporting.

--Limitations & Performance:
-- * Complexity increases with more partitions.
-- * Manual setup and maintenance (SQL Server doesn't auto-partition for you).
-- * Can affect query optimization if not well-designed with constraints.
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--                                                                   Can We Use DML (INSERT, UPDATE, DELETE) on Views in SQL Server?

--Yes, DML operations are allowed on some views, but there are important restrictions depending on the view type and structure.

--1. Which Types of Views Allow DML Operations?
-- * Standard Views – DML operations (INSERT, UPDATE, DELETE) are allowed if the view meets certain conditions.
-- * Indexed Views – DML is also allowed, but with very strict rules.
-- * Partitioned Views – DML operations are allowed only if all underlying tables follow specific partitioning and constraint rules.

--2.Restrictions and Limitations on DML with Views
--To perform INSERT, UPDATE, or DELETE operations on a view in SQL Server, several conditions must be met. Here are the key restrictions explained clearly:
-- * No GROUP BY or aggregate functions:
--   You cannot perform DML on views that include GROUP BY, SUM(), COUNT(), AVG(), or any other aggregate functions.
-- * No joins (in most cases):
--   Views based on joins across multiple tables are typically not updatable, unless you use INSTEAD OF triggers to handle the logic manually.
-- * No DISTINCT or TOP:
--   If a view uses DISTINCT or TOP, it becomes read-only, meaning you cannot modify data through the view.
-- * All affected columns must come from one base table:
--   DML is allowed only if all columns being modified belong to a single base table. You can't update calculated fields or fields that come from multiple tables.
-- * Schema-bound views have stricter rules:
--   Indexed views, which are schema-bound, must follow very strict rules such as using deterministic expressions and avoiding outer joins, subqueries, and non-deterministic functions.

--3. Real-Life Example: Updating a View in an HR System
--Use Case:
--An HR system has a view named ActiveEmployees that filters out inactive employees from the Employee table:

-- CREATE VIEW HR.ActiveEmployees AS
-- SELECT EmployeeID, FullName, Position
-- FROM HR.Employee
-- WHERE Status = 'Active';

--If the base table HR.Employee allows updates, the following UPDATE on the view will also update the base table:

-- UPDATE HR.ActiveEmployees
-- SET Position = 'Manager'
-- WHERE EmployeeID = 1;
-- This is useful for HR staff who only work with active employees and don't need to access or even know about inactive ones.
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--                                                                   How Can Views Simplify Complex Queries?

--How Views Help Simplify JOIN-Heavy Queries
-- In a complex system (like banking), data is often spread across multiple related tables. Writing queries with multiple JOINs repeatedly can be:
-- * Time-consuming
-- * Error-prone
-- * Hard to read and maintain
-- A view helps by wrapping a complex query (with all the necessary joins) into a single reusable object.
-- This way, users or apps can query the view as if it's a table, without writing the full join logic each time.

--Example Scenario: Bank Call Center Agents
--Goal: Call center agents need to quickly see customer names, account numbers, and current balances.
--Instead of always writing a long JOIN query, we create a view to simplify their work.
--CREATE TABLE Customer (
--   CustomerID INT PRIMARY KEY,
--    FullName VARCHAR(100),
--    PhoneNumber VARCHAR(20)
--);
--CREATE TABLE Account (
--    AccountID INT PRIMARY KEY,
--    CustomerID INT,
--    AccountNumber VARCHAR(20),
--    Balance DECIMAL(12,2)
--);

--CREATE VIEW Banking.CustomerAccountSummary AS
--SELECT 
--    c.CustomerID,
--    c.FullName,
--    c.PhoneNumber,
--    a.AccountID,
--    a.AccountNumber,
--    a.Balance
--FROM Customer c
--JOIN Account a ON c.CustomerID = a.CustomerID;

--Without the view:                                                                With the view:
--SELECT c.FullName, c.PhoneNumber, a.AccountNumber, a.Balance                     SELECT FullName, PhoneNumber, AccountNumber, Balance
--FROM Customer c                                                                  FROM Banking.CustomerAccountSummary
--JOIN Account a ON c.CustomerID = a.CustomerID                                    WHERE CustomerID = 101;
--WHERE c.CustomerID = 101;

--The second query is shorter, easier to read, and doesn't repeat the join logic — perfect for frequent use by call center agents or reporting tools.
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

use view_task

CREATE TABLE Customer ( 
CustomerID INT PRIMARY KEY, 
FullName NVARCHAR(100), 
Email NVARCHAR(100), 
Phone NVARCHAR(15), 
SSN CHAR(9) 
); 
CREATE TABLE Account ( 
    AccountID INT PRIMARY KEY, 
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID), 
    Balance DECIMAL(10, 2), 
    AccountType VARCHAR(50), 
    Status VARCHAR(20) 
); 
 
CREATE TABLE Transactions( 
    TransactionID INT PRIMARY KEY, 
    AccountID INT FOREIGN KEY REFERENCES Account(AccountID), 
    Amount DECIMAL(10, 2), 
    Type VARCHAR(10), -- Deposit, Withdraw 
    TransactionDate DATETIME 
); 
 
CREATE TABLE Loan ( 
    LoanID INT PRIMARY KEY, 
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID), 
    LoanAmount DECIMAL(12, 2), 
    LoanType VARCHAR(50), 
    Status VARCHAR(20) 
); 

CREATE SCHEMA Banking;

CREATE VIEW Banking.CustomerServiceView AS
SELECT 
    c.FullName,
    c.Phone,
    a.Status AS AccountStatus
FROM Customer c
JOIN Account a ON c.CustomerID = a.CustomerID;

CREATE VIEW Banking.FinanceAccountView AS
SELECT 
    AccountID,
    Balance,
    AccountType
FROM Account;

CREATE VIEW Banking.LoanOfficerView AS
SELECT 
    LoanID,
    CustomerID,
    LoanAmount,
    LoanType,
    Status
FROM Loan;

CREATE VIEW Banking.RecentTransactionSummary AS
SELECT 
    AccountID,
    Amount,
    TransactionDate
FROM Transactions
WHERE TransactionDate >= DATEADD(DAY, -30, GETDATE());


SELECT * FROM Banking.CustomerServiceView;
SELECT * FROM Banking.FinanceAccountView;
SELECT * FROM Banking.LoanOfficerView;
SELECT * FROM Banking.RecentTransactionSummary;
