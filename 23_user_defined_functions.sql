/*
===============================================================================
22. USER-DEFINED FUNCTIONS
===============================================================================

WHAT IS A USER-DEFINED FUNCTION?

A user-defined function (UDF) is a function created by a user to perform
a specific operation and return a value or a table.

Types:
1. Scalar function
2. Table-valued function

Topics:
- CREATE FUNCTION
- Scalar functions
- Table-valued functions
- Function parameters
- Function vs stored procedure

NOTE:
The executable examples use SQL Server syntax.


===============================================================================
1. SCALAR FUNCTION
===============================================================================

A scalar function returns a single value.

Example:
Calculate a discounted product price.

Syntax:
CREATE OR ALTER FUNCTION function_name(parameters)
RETURNS data_type
AS
BEGIN
    RETURN value;
END;
GO
*/

USE EcommerceSQL;
GO

CREATE OR ALTER FUNCTION dbo.CalculateDiscountedPrice
(
    @Price DECIMAL(10, 2),
    @DiscountPercent DECIMAL(5, 2)
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    RETURN @Price - (@Price * @DiscountPercent / 100);
END;
GO

-- Call the function.
SELECT dbo.CalculateDiscountedPrice(1000, 10) AS DiscountedPrice;
GO

-- Use the function with table data.
SELECT
    product_id,
    product_name,
    price,
    dbo.CalculateDiscountedPrice(price, 10) AS DiscountedPrice
FROM dbo.Products;
GO


/*
===============================================================================
2. TABLE-VALUED FUNCTION
===============================================================================

A table-valued function (TVF) returns a table containing rows and columns.

An inline TVF returns the result of a SELECT statement.

Example:
Return orders belonging to a particular customer.

Syntax:
CREATE OR ALTER FUNCTION function_name(parameters)
RETURNS TABLE
AS
RETURN
(
    SELECT ...
);
GO
*/

CREATE OR ALTER FUNCTION dbo.GetCustomerOrders
(
    @CustomerID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        order_id,
        customer_id,
        order_date,
        order_status,
        total_amount
    FROM dbo.Orders
    WHERE customer_id = @CustomerID
);
GO

-- Call the function like a table.
SELECT *
FROM dbo.GetCustomerOrders(1);
GO

-- Filter the returned rows.
SELECT *
FROM dbo.GetCustomerOrders(1)
WHERE total_amount >= 1000;
GO


/*
===============================================================================
3. FUNCTION PARAMETERS
===============================================================================

Parameters allow a function to receive input values.

Example:
    dbo.CalculateDiscountedPrice(1000, 10)

Here:
- 1000 is the product price.
- 10 is the discount percentage.

In SQL Server:
- Function parameters are input parameters.
- Functions do not support stored-procedure-style OUTPUT parameters.
- RETURNS specifies the return type.
- A scalar function returns one value.
- A table-valued function returns a table.


===============================================================================
4. FUNCTION VS STORED PROCEDURE
===============================================================================

FUNCTION:
- Must return a scalar value or a table.
- Can be used in SELECT queries, depending on the function type.
- Can be used in WHERE and JOIN expressions where supported.
- Has restrictions on database modifications.
- Cannot use stored-procedure-style OUTPUT parameters.

STORED PROCEDURE:
- Executed using EXEC or EXECUTE in SQL Server.
- Can return result sets and OUTPUT parameters.
- Can perform INSERT, UPDATE, and DELETE operations.
- Cannot normally be called as a scalar expression in SELECT.

Examples:

Function:
    SELECT dbo.CalculateDiscountedPrice(1000, 10);

Stored procedure:
    EXEC dbo.GetAllCustomers;
*/

/*
===============================================================================
DROP FUNCTION
===============================================================================

DROP FUNCTION permanently removes a user-defined function.

Syntax:
    DROP FUNCTION function_name;

SQL Server supports scalar and table-valued functions.
*/

-- Drop a scalar function.
DROP FUNCTION IF EXISTS dbo.CalculateDiscountedPrice;
GO

-- Drop a table-valued function.
DROP FUNCTION IF EXISTS dbo.GetCustomerOrders;
GO

/*
===============================================================================
5. OTHER DBMS DIFFERENCES
===============================================================================

SQL SERVER:
    CREATE OR ALTER FUNCTION
    Uses @ for parameter and variable names.
    Supports scalar and table-valued functions.

MYSQL:
    CREATE FUNCTION ... RETURNS ...
    Uses IN parameters for functions.
    Functions return a value using RETURN.
    Does not support table-valued functions in the same form as SQL Server.

POSTGRESQL:
    CREATE OR REPLACE FUNCTION
    Supports scalar, set-returning, and table-returning functions.
    Uses LANGUAGE SQL or LANGUAGE plpgsql.

ORACLE:
    CREATE OR REPLACE FUNCTION
    Uses RETURN to return a value.
    Common types include VARCHAR2 and NUMBER.
    Table-like results use Oracle-specific collection or pipelined-function
    techniques.

Function syntax and restrictions vary between database systems.


===============================================================================
6. QUICK REVISION
===============================================================================

Scalar function:
    Returns one value.

Table-valued function:
    Returns rows and columns.

Function parameters:
    Supply input values.

RETURNS:
    Specifies the function's return type.

Function:
    Returns a value or table and can be used in queries.

Stored procedure:
    Executes SQL statements and can return result sets or output values.

IMPORTANT:
- Learn scalar and table-valued functions.
- Understand parameters and function vs stored procedure.
- Built-in functions, joins, subqueries, CTEs, and window functions
  remain higher priorities for Data Analyst interview preparation.
===============================================================================
*/