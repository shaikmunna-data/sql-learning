/*
===============================================================================
25. SQL PERFORMANCE OPTIMIZATION
===============================================================================

What is SQL Performance Optimization?

SQL performance optimization means improving SQL queries so they execute
faster and use fewer database resources.

Why is it important?

- Faster query execution.
- Reduced CPU and memory usage.
- Efficient database operations.
- Better performance when working with large datasets.


===============================================================================
1. QUERY EXECUTION BASICS
===============================================================================

When a SQL query runs, SQL Server generally performs these activities:

1. Parsing and validation
   Checks SQL syntax and object references.

2. Optimization
   The Query Optimizer evaluates possible execution strategies.

3. Execution plan selection
   SQL Server chooses an execution plan based on estimated costs.

4. Execution
   SQL Server executes the selected plan and returns the result.

Important:
SQL Server does not necessarily execute SQL clauses in the order written.
The Query Optimizer chooses an efficient execution strategy.


Example:

*/

SELECT
    customer_id,
    COUNT(*) AS total_orders
FROM Orders
WHERE order_status = 'Delivered'
GROUP BY customer_id;


/*
===============================================================================
2. EXECUTION PLANS
===============================================================================

An execution plan shows how SQL Server intends to retrieve and process data.

It helps identify:
- Table scans.
- Index scans.
- Index seeks.
- Expensive operations.
- Join operations.
- Sorting and aggregation operations.

Types:

1. Estimated Execution Plan
   Shows the plan SQL Server expects to use without executing the query.

2. Actual Execution Plan
   Shows the plan used after executing the query, including actual row counts.

In SQL Server Management Studio:

- Press Ctrl + L for Estimated Execution Plan.
- Press Ctrl + M to enable Actual Execution Plan.
- Execute the query to view the Actual Execution Plan.

Example:
*/

SELECT *
FROM Orders
WHERE customer_id = 1;


/*
Open the execution plan and look for:

- Index Seek: Retrieves matching rows using an index.
- Index Scan: Reads index pages to find matching rows.
- Table Scan: Reads the table's data pages.
- Key Lookup: Retrieves additional columns from the base table.

Note:
A scan is not always bad. For example, reading most rows may make a scan
more efficient than using an index.


===============================================================================
3. INDEX USAGE
===============================================================================

Indexes help SQL Server find rows without reading the entire table.

Example:

*/

-- Create an index on the frequently filtered column.
CREATE NONCLUSTERED INDEX IX_Orders_CustomerID
ON Orders(customer_id);

-- Query that can benefit from the index.
SELECT
    order_id,
    order_date,
    total_amount
FROM Orders
WHERE customer_id = 1;


/*
Important:

- Indexes can improve SELECT performance.
- Too many indexes can slow down INSERT, UPDATE and DELETE operations.
- Indexes require additional storage.
- An index does not guarantee that SQL Server will use it.

Check index usage through execution plans and performance statistics.


===============================================================================
4. SARGABILITY
===============================================================================

SARGability means writing conditions that allow SQL Server to efficiently
use indexes to search for matching rows.

Avoid applying functions or calculations to indexed columns in WHERE
conditions when an equivalent search condition is possible.

Example 1: Avoid functions on columns.

Less efficient:
*/

SELECT *
FROM Orders
WHERE YEAR(order_date) = 2025;

/*
Better:
*/

SELECT *
FROM Orders
WHERE order_date >= '20250101'
  AND order_date < '20260101';


/*
Example 2: Avoid calculations on columns.

Less efficient:
*/

SELECT *
FROM Products
WHERE price * 2 > 1000;

/*
Better:
*/

SELECT *
FROM Products
WHERE price > 500;


/*
Example 3: Avoid leading wildcards when possible.

May prevent an index seek:
*/

SELECT *
FROM Customers
WHERE customer_name LIKE '%Kumar';

/*
Can be more index-friendly:
*/

SELECT *
FROM Customers
WHERE customer_name LIKE 'Kumar%';


/*
Note:
SARGability improves the possibility of index seeks, but actual performance
depends on the query, indexes, data distribution and execution plan.


===============================================================================
5. AVOIDING UNNECESSARY COLUMNS
===============================================================================

Avoid SELECT * when you only need a few columns.

Why?

- Reads unnecessary data.
- Increases network traffic.
- Uses more memory in some operations.
- Can prevent a query from being covered by an index.

Less efficient:
*/

SELECT *
FROM Orders;

/*
Better:
*/

SELECT
    order_id,
    order_date,
    total_amount
FROM Orders;


/*
===============================================================================
6. AVOIDING UNNECESSARY JOINS
===============================================================================

Only join tables when you need information from them or need them to filter
the results.

Unnecessary join:
*/

SELECT
    o.order_id,
    o.order_date,
    o.total_amount
FROM Orders AS o
INNER JOIN Customers AS c
    ON o.customer_id = c.customer_id;

/*
The Customers table is not needed because no customer columns or customer
filters are being used.

Better:
*/

SELECT
    order_id,
    order_date,
    total_amount
FROM Orders;


/*
===============================================================================
7. FILTERING EFFICIENTLY
===============================================================================

Filter rows as early as practical and retrieve only the required records.

Example 1: Select only required columns and rows.
*/

SELECT
    order_id,
    order_date,
    total_amount
FROM Orders
WHERE order_status = 'Delivered'
  AND order_date >= '20250101';


/*
Example 2: Use EXISTS when you only need to check whether matching rows exist.
*/

SELECT
    c.customer_id,
    c.customer_name
FROM Customers AS c
WHERE EXISTS
(
    SELECT 1
    FROM Orders AS o
    WHERE o.customer_id = c.customer_id
);

/*
Example 3: Use appropriate data types for filter values.

Avoid unnecessary conversions on indexed columns.

For example, compare a DATE column with a DATE value rather than converting
the column to a string.
*/


/*
===============================================================================
8. CTE VS SUBQUERY CONSIDERATIONS
===============================================================================

CTEs and subqueries are ways to organize SQL logic.

Neither is automatically faster than the other.

CTE:
- Improves readability.
- Useful for breaking complex queries into steps.
- A normal CTE is not automatically stored as a temporary result.

Subquery:
- Useful for filtering and retrieving related values.
- Can be written directly inside another query.

Example: CTE
*/

WITH CustomerOrders AS
(
    SELECT
        customer_id,
        COUNT(*) AS total_orders
    FROM Orders
    GROUP BY customer_id
)
SELECT *
FROM CustomerOrders
WHERE total_orders > 2;


/*
Example: Subquery
*/

SELECT *
FROM
(
    SELECT
        customer_id,
        COUNT(*) AS total_orders
    FROM Orders
    GROUP BY customer_id
) AS CustomerOrders
WHERE total_orders > 2;

/*
Important:
- Choose based on readability and maintainability.
- Compare execution plans when performance matters.
- A CTE is not necessarily faster than a subquery.


===============================================================================
9. TEMPORARY TABLES
===============================================================================

Temporary tables store intermediate results.

They can be useful when:
- Intermediate results are reused.
- A complex query needs to be divided into steps.
- You need to index intermediate data.
- You want to inspect intermediate results.

Example:
*/

DROP TABLE IF EXISTS #CustomerOrders;

SELECT
    customer_id,
    COUNT(*) AS total_orders,
    SUM(total_amount) AS total_sales
INTO #CustomerOrders
FROM Orders
GROUP BY customer_id;

-- Reuse the stored intermediate results.
SELECT *
FROM #CustomerOrders
WHERE total_orders > 2;

-- Temporary table can be indexed when useful.
CREATE INDEX IX_CustomerOrders_TotalOrders
ON #CustomerOrders(total_orders);

SELECT *
FROM #CustomerOrders
WHERE total_orders > 2;

DROP TABLE IF EXISTS #CustomerOrders;

/*
Important:
- Temporary tables are stored in tempdb.
- They can have indexes.
- They are useful for multi-step queries.
- They also have storage and maintenance overhead.
- Do not use them automatically for every query.


===============================================================================
10. QUERY OPTIMIZATION BASICS
===============================================================================

Follow these practices when writing SQL queries:

1. Avoid SELECT * when unnecessary.
2. Filter records using appropriate WHERE conditions.
3. Create indexes on frequently searched columns when justified.
4. Avoid unnecessary joins.
5. Write SARGable conditions.
6. Use appropriate data types.
7. Avoid unnecessary sorting with ORDER BY.
8. Avoid retrieving more rows than required.
9. Check execution plans for expensive operations.
10. Avoid creating too many indexes.
11. Compare query performance before and after changes.
12. Use temporary tables only when they provide a benefit.

Measure performance in SQL Server:

*/

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT
    order_id,
    order_date,
    total_amount
FROM Orders
WHERE customer_id = 1;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

/*
STATISTICS TIME:
Shows CPU time and elapsed execution time.

STATISTICS IO:
Shows logical and physical read information.

Compare these statistics before and after optimization.

Note:
Run comparisons under similar conditions. Cached data and other workload
activity can affect measurements.


===============================================================================
QUICK REVISION
===============================================================================

1. Query Execution:
   SQL Server parses, optimizes and executes SQL queries.

2. Execution Plan:
   Shows how SQL Server retrieves and processes data.

3. Index Usage:
   Helps retrieve matching records efficiently.

4. SARGability:
   Write searchable conditions that allow efficient index access.

5. Avoid SELECT *:
   Retrieve only required columns.

6. Avoid Unnecessary Joins:
   Join only when required.

7. Efficient Filtering:
   Use appropriate WHERE conditions and data types.

8. CTE vs Subquery:
   Choose based on readability; neither is automatically faster.

9. Temporary Tables:
   Store intermediate results when useful.

10. Query Optimization:
    Measure performance and use execution plans to identify bottlenecks.
===============================================================================
*/