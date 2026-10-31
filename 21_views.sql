/*
===============================================================================
20. SQL VIEWS
===============================================================================

WHAT IS A VIEW?

A view is a virtual table created using a SELECT query.

It stores the query definition, not a separate copy of the result data
in a standard SQL Server view.

WHY USE VIEWS?
    - Simplify complex queries.
    - Hide unnecessary columns.
    - Reuse frequently used queries.
    - Help control access to data.


===============================================================================
1. CREATE A VIEW
===============================================================================

Example:
Create a view that displays basic customer information.
*/

USE EcommerceSQL;
GO

CREATE OR ALTER VIEW dbo.vw_Customers
AS
SELECT
    customer_id,
    customer_name,
    city,
    customer_status
FROM dbo.Customers;
GO

/*
===============================================================================
2. QUERY A VIEW
===============================================================================

Query a view just like a table.
*/

SELECT *
FROM dbo.vw_Customers;


-- Filter the view.
SELECT *
FROM dbo.vw_Customers
WHERE city = 'Hyderabad';


-- Sort the view.
SELECT *
FROM dbo.vw_Customers
ORDER BY customer_name;


/*
===============================================================================
3. CREATE A VIEW USING JOIN
===============================================================================

Example:
Display customer names along with their order details.
*/
GO
CREATE OR ALTER VIEW dbo.vw_CustomerOrders
AS
SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_date,
    o.order_status,
    o.total_amount
FROM dbo.Customers AS c
INNER JOIN dbo.Orders AS o
    ON c.customer_id = o.customer_id;
GO

-- Query the view.
SELECT *
FROM dbo.vw_CustomerOrders;


-- Find delivered orders.
SELECT *
FROM dbo.vw_CustomerOrders
WHERE order_status = 'Delivered';


/*
===============================================================================
4. CREATE A VIEW USING AGGREGATION
===============================================================================

Example:
Calculate total spending and number of orders for each customer.
*/
GO
CREATE OR ALTER VIEW dbo.vw_CustomerSpending
AS
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_spending
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name;
GO


SELECT *
FROM dbo.vw_CustomerSpending
ORDER BY total_spending DESC;


/*
===============================================================================
5. UPDATING A VIEW - CONCEPT
===============================================================================

Some simple views allow INSERT, UPDATE, and DELETE operations.

For example, this view selects columns from one table without joins
or aggregation.
*/
GO
CREATE OR ALTER VIEW dbo.vw_ProductPrices
AS
SELECT
    product_id,
    product_name,
    price
FROM dbo.Products;
GO


-- Update a product through the view.
-- This changes the underlying Products table.
-- Run only after verifying the product ID.

-- UPDATE dbo.vw_ProductPrices
-- SET price = 999.00
-- WHERE product_id = 201;


/*
IMPORTANT:
    - Changes made through an updatable view affect the base table.
    - Views containing joins, GROUP BY, aggregate functions, or DISTINCT
      often have restrictions on data modification.
    - A view is not automatically updatable in every situation.
    - WITH CHECK OPTION can restrict modifications made through a view
      so rows must continue to satisfy the view's filter condition.


===============================================================================
6. ADVANTAGES OF VIEWS
===============================================================================

1. SIMPLICITY:
   Hide complicated joins behind a simple SELECT from a view.

2. REUSABILITY:
   Use the same query definition in multiple reports.

3. SECURITY:
   Grant access to selected view columns instead of the whole table,
   when permissions are configured appropriately.

4. MAINTAINABILITY:
   Keep commonly used query logic in one place.


===============================================================================
7. DISADVANTAGES OF VIEWS
===============================================================================

1. COMPLEX VIEWS:
   Views with many joins and calculations can be difficult to maintain.

2. PERFORMANCE:
   Ordinary views do not automatically make queries faster.
   Performance depends on the underlying query, indexes, and execution plan.

3. MODIFICATION LIMITATIONS:
   Some views cannot be directly updated.

4. DEPENDENCIES:
   Changes to underlying tables can break views or change their behavior.


===============================================================================
8. VIEW VS TABLE
===============================================================================

TABLE:
    Stores data in the database.

VIEW:
    Stores a query definition that returns data from underlying objects.

TABLE:
    Data is inserted, updated, or deleted directly.

VIEW:
    Usually retrieves data from its underlying tables.
    Some views also allow data modification.

TABLE:
    Can have its own indexes and constraints.

VIEW:
    An ordinary view has no separate stored result or ordinary table indexes.
    SQL Server also supports indexed views, which have additional requirements.

===============================================================================
QUICK REVISION
===============================================================================

CREATE OR ALTER VIEW:
    Create a view or update its definition.

SELECT FROM VIEW:
    Query a view like a table.

UPDATABLE VIEW:
    A view through which certain data modifications are allowed.

VIEW:
    Stores the query definition.

TABLE:
    Stores the actual data.
===============================================================================
OTHER DBMS DIFFERENCES: VIEWS
===============================================================================

1. SQL SERVER
-------------
Create or update a view:
    CREATE OR ALTER VIEW view_name AS
    SELECT ...;

Delete a view:
    DROP VIEW view_name;

2. MYSQL
--------
Create or replace a view:
    CREATE OR REPLACE VIEW view_name AS
    SELECT ...;

Delete a view:
    DROP VIEW view_name;

3. POSTGRESQL
-------------
Create or replace a view:
    CREATE OR REPLACE VIEW view_name AS
    SELECT ...;

Delete a view:
    DROP VIEW view_name;

4. ORACLE
---------
Create or replace a view:
    CREATE OR REPLACE VIEW view_name AS
    SELECT ...;

Delete a view:
    DROP VIEW view_name;


===============================================================================
IMPORTANT DIFFERENCES
===============================================================================

- All four databases support views.
- A normal view stores a query definition, not a separate copy of its data.
- Changes to the underlying tables are reflected when the view is queried.
- Simple views may allow INSERT, UPDATE, or DELETE operations.
- Views containing joins, GROUP BY, or aggregate functions may have
  restrictions on data modification.
- SQL Server uses GO to separate batches in client tools.
- GO is not standard SQL.
- CREATE OR REPLACE VIEW is not supported in the same form by SQL Server;
  SQL Server uses CREATE OR ALTER VIEW instead.
- Materialized views differ: PostgreSQL and Oracle support them, while
  SQL Server uses indexed views for a similar purpose. MySQL does not
  provide native materialized views in the same way.

===============================================================================
QUICK REVISION
===============================================================================

SQL Server:  CREATE OR ALTER VIEW
MySQL:       CREATE OR REPLACE VIEW
PostgreSQL:  CREATE OR REPLACE VIEW
Oracle:      CREATE OR REPLACE VIEW

All four support DROP VIEW.

===============================================================================
===============================================================================
END OF SQL VIEWS
===============================================================================
*/