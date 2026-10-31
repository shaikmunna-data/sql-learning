/*
===============================================================================
                         03 - SELECT STATEMENT
===============================================================================

The SELECT statement is used to retrieve data from database tables.

Topics:
1. SELECT
2. FROM
3. DISTINCT
4. Column Aliases
5. Expressions
6. TOP
===============================================================================
*/


/*
===============================================================================
1. SELECT
===============================================================================

SELECT is used to retrieve data from one or more columns.

Syntax:

SELECT column_name
FROM table_name;


Example:
*/

SELECT customer_name
FROM Customers;


/*
Select multiple columns.
*/

SELECT
    customer_id,
    customer_name,
    city,
    state
FROM Customers;


/*
Select all columns using *.
*/

SELECT *
FROM Customers;


/*
===============================================================================
2. FROM
===============================================================================

FROM specifies the table from which data should be retrieved.

Syntax:

SELECT column_name
FROM table_name;


Example:
*/

SELECT
    product_name,
    price
FROM Products;


/*
Here:

SELECT -> columns to retrieve
FROM   -> table to retrieve data from
Products -> source table
*/


/*
===============================================================================
3. DISTINCT
===============================================================================

DISTINCT removes duplicate values from the result.

Syntax:

SELECT DISTINCT column_name
FROM table_name;


Example:
*/

SELECT DISTINCT city
FROM Customers;


/*
Get unique customer states.
*/

SELECT DISTINCT state
FROM Customers;


/*
DISTINCT can be applied to multiple columns.

The combination of values must be unique.
*/

SELECT DISTINCT
    city,
    state
FROM Customers;


/*
===============================================================================
4. COLUMN ALIASES
===============================================================================

An alias gives a temporary name to a column in the result.

It does NOT change the actual column name in the table.

Syntax:

SELECT column_name AS alias_name
FROM table_name;


Example:
*/

SELECT
    customer_name AS CustomerName,
    city AS CustomerCity
FROM Customers;


/*
AS is optional in SQL Server.

The following also works:

SELECT
    customer_name CustomerName,
    city CustomerCity
FROM Customers;
*/


/*
Alias can make calculated columns easier to understand.
*/

SELECT
    product_name,
    price AS ProductPrice
FROM Products;


/*
===============================================================================
5. EXPRESSIONS
===============================================================================

An expression performs a calculation or combines values.

Expressions can be used inside SELECT.

Example:

Calculate price after adding 18% tax.
*/

SELECT
    product_name,
    price,
    price * 1.18 AS PriceWithTax
FROM Products;


/*
Calculate the value of available stock.

Stock Value = Price × Stock Quantity
*/

SELECT
    product_name,
    price,
    stock_quantity,
    price * stock_quantity AS StockValue
FROM Products;


/*
Calculate order item value.

Quantity × Unit Price
*/

SELECT
    order_id,
    product_id,
    quantity,
    unit_price,
    quantity * unit_price AS ItemTotal
FROM OrderItems;


/*
Expressions can use arithmetic operators:

+
-
*
/
%
*/


/*
===============================================================================
6. TOP
===============================================================================

TOP limits the number of rows returned by SELECT.

Syntax:

SELECT TOP (number)
    columns
FROM table_name;


Example:
*/

SELECT TOP (5)
    *
FROM Products;


/*
Get the first 3 customers.
*/

SELECT TOP (3)
    customer_id,
    customer_name,
    city
FROM Customers;


/*
TOP with ORDER BY is more useful because it allows us to
control which rows are returned.

Example:

Get the 5 most expensive products.
*/

SELECT TOP (5)
    product_name,
    category,
    price
FROM Products
ORDER BY price DESC;


/*
Get the 3 cheapest products.
*/

SELECT TOP (3)
    product_name,
    category,
    price
FROM Products
ORDER BY price ASC;


/*
===============================================================================
COMBINING SELECT CONCEPTS
===============================================================================

SELECT can be combined with:

SELECT
DISTINCT
Aliases
Expressions
TOP
FROM


Example:
*/

SELECT DISTINCT TOP (5)
    category
FROM Products;


/*
NOTE:
TOP + DISTINCT is valid, but TOP is applied to the
distinct result set.
*/


/*
Another example:

Get unique cities and rename the output column.
*/

SELECT DISTINCT
    city AS CustomerCity
FROM Customers;


/*
Example using multiple concepts:

Get the 5 most expensive products and calculate
their stock value.
*/

SELECT TOP (5)
    product_name AS Product,
    price AS Price,
    stock_quantity AS Stock,
    price * stock_quantity AS StockValue
FROM Products
ORDER BY price DESC;


/*
===============================================================================
PRACTICE QUESTIONS
===============================================================================

Try solving these yourself before looking for the answer.

1. Display all columns from Customers.

2. Display only customer_name and city.

3. Display unique cities from Customers.

4. Display unique states from Customers.

5. Display product_name and price.

6. Rename product_name as ProductName.

7. Rename price as ProductPrice.

8. Display product_name and calculate price after a 10% increase.

9. Calculate stock value for every product.

10. Display the first 5 products.

11. Display the 5 most expensive products.

12. Display the 3 cheapest products.

13. Display order_id, product_id, quantity, unit_price,
    and calculate the total item value.


===============================================================================
QUICK REVISION
===============================================================================

SELECT
-> Retrieves data.

FROM
-> Specifies the source table.

DISTINCT
-> Removes duplicate results.

ALIAS
-> Gives a temporary name to a column/result.

EXPRESSION
-> Performs calculations using values.

TOP
-> Limits the number of rows returned.


Basic syntax:

SELECT columns
FROM table;


With DISTINCT:

SELECT DISTINCT column
FROM table;


With alias:

SELECT column AS alias
FROM table;


With expression:

SELECT price * quantity AS Total
FROM OrderItems;


With TOP:

SELECT TOP (5) *
FROM Products;


With TOP + ORDER BY:

SELECT TOP (5) *
FROM Products
ORDER BY price DESC;

===============================================================================
*/