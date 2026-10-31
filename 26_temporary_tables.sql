/*
===============================================================================
26. TEMPORARY TABLES
===============================================================================

1. WHAT IS A TEMPORARY TABLE?
===============================================================================

A temporary table is a table used to store data temporarily.

It works like a regular table, but it is stored in the SQL Server
tempdb database instead of the current user database.

Temporary tables are useful when:
    - Storing intermediate query results.
    - Breaking complex queries into smaller steps.
    - Performing multiple operations on temporary data.
    - Reusing query results within a session or procedure.

Temporary tables are automatically removed based on their scope
and lifetime.


===============================================================================
2. TYPES OF TEMPORARY TABLES
===============================================================================

SQL Server supports two main types:

1. Local Temporary Table (#table)
2. Global Temporary Table (##table)


===============================================================================
3. LOCAL TEMPORARY TABLE (#table)
===============================================================================

A local temporary table starts with a single # symbol.

Example:
    #CustomerOrders

Characteristics:
    - Available only in the current session.
    - Other independent sessions cannot access it.
    - Automatically dropped when the creating session ends.
    - Can also be manually dropped.
    - A local temporary table created inside a stored procedure
      is automatically dropped when that procedure finishes.


EXAMPLE:
*/

-- Create a local temporary table.
CREATE TABLE #CustomerOrders
(
    OrderID INT,
    CustomerID INT,
    TotalAmount DECIMAL(10, 2),
    OrderStatus VARCHAR(30)
);
GO

-- Insert sample data.
INSERT INTO #CustomerOrders
    (OrderID, CustomerID, TotalAmount, OrderStatus)
VALUES
    (101, 1, 2500.00, 'Delivered'),
    (102, 2, 1500.00, 'Pending'),
    (103, 1, 3000.00, 'Delivered');
GO

-- View temporary table data.
SELECT *
FROM #CustomerOrders;
GO

-- Filter temporary table data.
SELECT *
FROM #CustomerOrders
WHERE OrderStatus = 'Delivered';
GO

-- Calculate total order amount.
SELECT SUM(TotalAmount) AS TotalSales
FROM #CustomerOrders;
GO

-- Remove the local temporary table manually.
DROP TABLE IF EXISTS #CustomerOrders;
GO


/*
===============================================================================
4. GLOBAL TEMPORARY TABLE (##table)
===============================================================================

A global temporary table starts with ##.

Example:
    ##SharedOrders

Characteristics:
    - Can be accessed by multiple sessions.
    - Exists until the creating session ends and no other session
      is actively referencing it.
    - Can be manually dropped.
    - Useful when multiple sessions need to access shared temporary data.

EXAMPLE:

Run the CREATE and INSERT statements in Session 1.
Then run the SELECT statement in another session while the global
temporary table still exists.
*/

-- Create a global temporary table.
DROP TABLE IF EXISTS ##SharedOrders;
GO

CREATE TABLE ##SharedOrders
(
    OrderID INT,
    CustomerName VARCHAR(50),
    TotalAmount DECIMAL(10, 2)
);
GO

-- Insert sample data.
INSERT INTO ##SharedOrders
    (OrderID, CustomerName, TotalAmount)
VALUES
    (101, 'Ravi', 2500.00),
    (102, 'Priya', 1500.00),
    (103, 'Arun', 3000.00);
GO

-- Access the global temporary table.
SELECT *
FROM ##SharedOrders;
GO

-- Remove the global temporary table when finished.
DROP TABLE IF EXISTS ##SharedOrders;
GO

/*
IMPORTANT:

A global temporary table is shared across sessions.
Do not use the same global temporary table name for unrelated tasks
because another session may access or modify its data.


===============================================================================
5. CREATING TEMPORARY TABLES USING SELECT INTO
===============================================================================

We can create and populate a temporary table directly using SELECT INTO.

EXAMPLE:

Store delivered orders in a local temporary table.
*/

DROP TABLE IF EXISTS #DeliveredOrders;
GO

SELECT
    order_id,
    customer_id,
    order_date,
    total_amount
INTO #DeliveredOrders
FROM dbo.Orders
WHERE order_status = 'Delivered';
GO

-- View the temporary table.
SELECT *
FROM #DeliveredOrders;
GO

-- Calculate total delivered sales.
SELECT
    SUM(total_amount) AS TotalDeliveredSales
FROM #DeliveredOrders;
GO

DROP TABLE IF EXISTS #DeliveredOrders;
GO


/*
===============================================================================
6. USING TEMPORARY TABLES WITH JOINS
===============================================================================

Temporary tables can be joined with other tables just like regular tables.

EXAMPLE:

Find customer details along with their delivered orders.
*/

DROP TABLE IF EXISTS #DeliveredOrders;
GO

SELECT
    order_id,
    customer_id,
    order_date,
    total_amount
INTO #DeliveredOrders
FROM dbo.Orders
WHERE order_status = 'Delivered';
GO

SELECT
    c.customer_id,
    c.customer_name,
    d.order_id,
    d.order_date,
    d.total_amount
FROM dbo.Customers AS c
INNER JOIN #DeliveredOrders AS d
    ON c.customer_id = d.customer_id;
GO

DROP TABLE IF EXISTS #DeliveredOrders;
GO


/*
===============================================================================
7. TEMPORARY TABLES WITH AGGREGATIONS
===============================================================================

Temporary tables are useful for storing intermediate aggregation results.

EXAMPLE:

Calculate total sales for each customer and store the result.
*/

DROP TABLE IF EXISTS #CustomerSales;
GO

SELECT
    customer_id,
    COUNT(*) AS TotalOrders,
    SUM(total_amount) AS TotalSales
INTO #CustomerSales
FROM dbo.Orders
GROUP BY customer_id;
GO

-- View customer sales.
SELECT *
FROM #CustomerSales;
GO

-- Find customers with total sales above 5000.
SELECT *
FROM #CustomerSales
WHERE TotalSales > 5000;
GO

DROP TABLE IF EXISTS #CustomerSales;
GO


/*
===============================================================================
8. TEMPORARY TABLE VS CTE
===============================================================================

CTE (Common Table Expression):

    - A named temporary result set.
    - Exists only for the single statement immediately following it.
    - Cannot be referenced by unrelated later statements.
    - Useful for making complex queries easier to read.
    - Does not automatically create a stored temporary table.

TEMPORARY TABLE:

    - Stores data in tempdb.
    - Can be used across multiple statements within its scope.
    - Supports indexes and constraints.
    - Useful for intermediate results reused multiple times.

EXAMPLE: CTE
*/

WITH CustomerSales AS
(
    SELECT
        customer_id,
        SUM(total_amount) AS TotalSales
    FROM dbo.Orders
    GROUP BY customer_id
)
SELECT *
FROM CustomerSales
WHERE TotalSales > 5000;
GO

/*
EXAMPLE: TEMPORARY TABLE
*/

DROP TABLE IF EXISTS #CustomerSales;
GO

SELECT
    customer_id,
    SUM(total_amount) AS TotalSales
INTO #CustomerSales
FROM dbo.Orders
GROUP BY customer_id;
GO

-- First use.
SELECT *
FROM #CustomerSales;
GO

-- Second use.
SELECT *
FROM #CustomerSales
WHERE TotalSales > 5000;
GO

DROP TABLE IF EXISTS #CustomerSales;
GO


/*
===============================================================================
9. TEMPORARY TABLE VS TABLE VARIABLE
===============================================================================

TABLE VARIABLE:

A table variable is a variable that stores rows and columns.

It is declared using DECLARE.

Syntax:

    DECLARE @TableName TABLE
    (
        Column1 INT,
        Column2 VARCHAR(50)
    );

TEMPORARY TABLE:

Created using CREATE TABLE and starts with # or ##.

IMPORTANT DIFFERENCES:

TEMPORARY TABLE (#table):

    - Created using CREATE TABLE.
    - Stored in tempdb.
    - Supports indexes and constraints.
    - Can be altered after creation.
    - Statistics are available to help query optimization.
    - Useful for larger or more complex intermediate datasets.

TABLE VARIABLE (@table):

    - Declared using DECLARE.
    - Also uses tempdb-backed storage in SQL Server.
    - Supports PRIMARY KEY, UNIQUE, and CHECK constraints.
    - Cannot be altered using ALTER TABLE.
    - Does not have ordinary column statistics like temporary tables.
    - Useful for smaller, simple intermediate datasets.

NOTE:

SQL Server has introduced improvements to table-variable
cardinality estimation, including deferred compilation in newer versions.
Performance depends on the SQL Server version and query workload.

EXAMPLE: TABLE VARIABLE
*/

DECLARE @CustomerSales TABLE
(
    CustomerID INT,
    TotalSales DECIMAL(12, 2)
);

INSERT INTO @CustomerSales
    (CustomerID, TotalSales)
VALUES
    (1, 5500.00),
    (2, 3000.00),
    (3, 7000.00);

SELECT *
FROM @CustomerSales;

SELECT *
FROM @CustomerSales
WHERE TotalSales > 4000;
GO


/*
EXAMPLE: TEMPORARY TABLE
*/

CREATE TABLE #CustomerSales
(
    CustomerID INT,
    TotalSales DECIMAL(12, 2)
);

INSERT INTO #CustomerSales
    (CustomerID, TotalSales)
VALUES
    (1, 5500.00),
    (2, 3000.00),
    (3, 7000.00);

SELECT *
FROM #CustomerSales;

SELECT *
FROM #CustomerSales
WHERE TotalSales > 4000;

DROP TABLE IF EXISTS #CustomerSales;
GO


/*
===============================================================================
10. INDEXES ON TEMPORARY TABLES
===============================================================================

Temporary tables support indexes just like regular tables.

Indexes can improve searches and joins when the temporary table
contains enough data to justify the additional overhead.

EXAMPLE:
*/

DROP TABLE IF EXISTS #OrderSummary;
GO

SELECT
    customer_id,
    COUNT(*) AS TotalOrders,
    SUM(total_amount) AS TotalSales
INTO #OrderSummary
FROM dbo.Orders
GROUP BY customer_id;
GO

-- Create an index on customer_id.
CREATE NONCLUSTERED INDEX IX_OrderSummary_CustomerID
ON #OrderSummary(customer_id);
GO

-- Search using the indexed column.
SELECT *
FROM #OrderSummary
WHERE customer_id = 1;
GO

DROP TABLE IF EXISTS #OrderSummary;
GO


/*
===============================================================================
11. WHEN SHOULD WE USE TEMPORARY TABLES?
===============================================================================

Use temporary tables when:

    - You need to reuse intermediate results.
    - A query has multiple processing steps.
    - You need to join intermediate data with other tables.
    - You need indexes on intermediate data.
    - You want to break a complex analysis into smaller queries.

Avoid creating temporary tables unnecessarily.

For simple one-statement queries, a CTE or derived table may be sufficient.


===============================================================================
12. QUICK COMPARISON
===============================================================================

LOCAL TEMP TABLE (#table):
    Available in the current session.

GLOBAL TEMP TABLE (##table):
    Available across sessions while it exists.

CTE:
    Used by one following SQL statement.

TABLE VARIABLE (@table):
    A variable that stores a table-like set of data.

TEMPORARY TABLE:
    A temporary database table that can be reused across statements
    within its scope.


===============================================================================
13. QUICK REVISION
===============================================================================

1. What is a temporary table?
   A table used to store intermediate data temporarily.

2. What is a local temporary table?
   A table starting with #, available in the current session.

3. What is a global temporary table?
   A table starting with ##, accessible across sessions.

4. Where are temporary tables stored in SQL Server?
   In tempdb.

5. What is the difference between a CTE and a temporary table?
   A CTE is used by one following statement, while a temporary table
   can be reused across multiple statements.

6. What is the difference between a temporary table and a table variable?
   A temporary table is created using CREATE TABLE, while a table variable
   is declared using DECLARE.

7. Can we create indexes on temporary tables?
   Yes.

===============================================================================
14. INTERVIEW QUESTIONS
===============================================================================

1. What is a temporary table in SQL?
2. Local temporary table vs global temporary table?
3. Where are temporary tables stored in SQL Server?
4. How long does a local temporary table exist?
5. What is the difference between a CTE and a temporary table?
6. Temporary table vs table variable?
7. Can we create indexes on temporary tables?
8. Can multiple sessions access a global temporary table?
9. When should we use temporary tables?
10. Are temporary tables automatically deleted?

===============================================================================
END OF TEMPORARY TABLES
===============================================================================
*/ 