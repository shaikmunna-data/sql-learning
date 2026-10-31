/*
===============================================================================
                     06 - SORTING AND LIMITING
===============================================================================

Sorting controls the order in which rows are returned.

Limiting controls how many rows are returned.

Topics:
1. ORDER BY
2. ASC
3. DESC
4. Sorting by Multiple Columns
5. TOP
6. TOP ... PERCENT
7. WITH TIES
===============================================================================
*/


/*
===============================================================================
1. ORDER BY
===============================================================================

ORDER BY is used to sort the result.

Syntax:

SELECT columns
FROM table
ORDER BY column_name;


By default, ORDER BY sorts in ascending order.

Example:
*/

SELECT
    product_name,
    price
FROM Products
ORDER BY price;


/*
The following produces the same result:

ORDER BY price ASC
*/


/*
===============================================================================
2. ASC
===============================================================================

ASC means ascending order.

For numbers:

Lowest -> Highest

For text:

A -> Z

For dates:

Oldest -> Newest


Example:
*/

SELECT
    product_name,
    price
FROM Products
ORDER BY price ASC;


/*
Sort customers alphabetically by name.
*/

SELECT
    customer_name,
    city
FROM Customers
ORDER BY customer_name ASC;


/*
Sort orders from oldest to newest.
*/

SELECT
    order_id,
    order_date
FROM Orders
ORDER BY order_date ASC;


/*
===============================================================================
3. DESC
===============================================================================

DESC means descending order.

For numbers:

Highest -> Lowest

For text:

Z -> A

For dates:

Newest -> Oldest


Example:
*/

SELECT
    product_name,
    price
FROM Products
ORDER BY price DESC;


/*
Find the newest orders first.
*/

SELECT
    order_id,
    order_date
FROM Orders
ORDER BY order_date DESC;


/*
Sort customers from Z to A.
*/

SELECT
    customer_name,
    city
FROM Customers
ORDER BY customer_name DESC;


/*
===============================================================================
4. SORTING BY MULTIPLE COLUMNS
===============================================================================

ORDER BY can contain multiple columns.

Syntax:

ORDER BY column1 ASC,
         column2 DESC;


SQL sorts by the first column.

If multiple rows have the same value in the first column,
SQL uses the second column to sort those rows.


Example:

Sort products first by category alphabetically,
then by price from highest to lowest.
*/

SELECT
    product_name,
    category,
    price
FROM Products
ORDER BY
    category ASC,
    price DESC;


/*
Example:

Sort customers first by state,
then by customer name.
*/

SELECT
    customer_name,
    city,
    state
FROM Customers
ORDER BY
    state ASC,
    customer_name ASC;


/*
Example:

Sort employees by department alphabetically,
then salary from highest to lowest.
*/

SELECT
    employee_name,
    department,
    salary
FROM Employees
ORDER BY
    department ASC,
    salary DESC;


/*
IMPORTANT:

The order of columns in ORDER BY matters.

This:

ORDER BY category, price DESC

is different from:

ORDER BY price DESC, category
*/


/*
===============================================================================
5. TOP
===============================================================================

TOP limits the number of rows returned.

Syntax:

SELECT TOP (number)
    columns
FROM table;


Example:
*/

SELECT TOP (5)
    product_name,
    price
FROM Products;


/*
TOP becomes especially useful with ORDER BY.


Example:

Find the 5 most expensive products.
*/

SELECT TOP (5)
    product_name,
    category,
    price
FROM Products
ORDER BY price DESC;


/*
Find the 3 cheapest products.
*/

SELECT TOP (3)
    product_name,
    category,
    price
FROM Products
ORDER BY price ASC;


/*
Find the 5 most recent orders.
*/

SELECT TOP (5)
    order_id,
    customer_id,
    order_date,
    total_amount
FROM Orders
ORDER BY order_date DESC;


/*
===============================================================================
6. TOP ... PERCENT
===============================================================================

TOP can return a percentage of the rows.

Syntax:

SELECT TOP (percentage) PERCENT
    columns
FROM table;


Example:

Return approximately 20% of the Products rows.
*/

SELECT TOP (20) PERCENT
    product_id,
    product_name,
    price
FROM Products
ORDER BY price DESC;


/*
Example:

Return approximately 30% of the customers.
*/

SELECT TOP (30) PERCENT
    customer_id,
    customer_name
FROM Customers
ORDER BY customer_id;


/*
TOP ... PERCENT is useful when you want a portion of
the result instead of a fixed number of rows.


IMPORTANT:

TOP (20) PERCENT

means 20 percent of the result set.

It does NOT mean:

TOP 20 rows.
*/


/*
===============================================================================
7. WITH TIES
===============================================================================

WITH TIES is used with TOP.

It returns additional rows that have the same ORDER BY
value as the last row included by TOP.


Syntax:

SELECT TOP (number) WITH TIES
    columns
FROM table
ORDER BY column;


Example:

Suppose we want the top 3 products by price.
*/

SELECT TOP (3)
    product_name,
    price
FROM Products
ORDER BY price DESC;


/*
TOP (3) returns exactly 3 rows.

WITH TIES:

*/

SELECT TOP (3) WITH TIES
    product_name,
    price
FROM Products
ORDER BY price DESC;


/*
WITH TIES can return MORE than 3 rows if another product
has the same price as the third product.


IMPORTANT:

WITH TIES only considers the ORDER BY expression(s).

It is most useful when the ranking column contains
duplicate values.
*/


/*
===============================================================================
8. TOP + ORDER BY + WITH TIES
===============================================================================

Example:

Find the top 3 product prices, including products tied
with the third-highest price.
*/

SELECT TOP (3) WITH TIES
    product_name,
    category,
    price
FROM Products
ORDER BY price DESC;


/*
Example with employees:

Find the top 2 salaries, including employees tied
with the second-highest salary.
*/

SELECT TOP (2) WITH TIES
    employee_name,
    department,
    salary
FROM Employees
ORDER BY salary DESC;


/*
===============================================================================
9. TOP WITH MULTIPLE COLUMNS IN ORDER BY
===============================================================================

Be careful when using WITH TIES with multiple ORDER BY columns.

WITH TIES considers the complete ORDER BY combination.

Example:
*/

SELECT TOP (3) WITH TIES
    product_name,
    category,
    price
FROM Products
ORDER BY
    price DESC,
    product_name ASC;


/*
Here, the tie is determined using the ORDER BY expressions,
not just the price column.
*/


/*
===============================================================================
10. ORDER BY WITH EXPRESSIONS
===============================================================================

ORDER BY can also sort using expressions.

Example:

Sort products by total inventory value.

Inventory Value = price * stock_quantity
*/

SELECT
    product_name,
    price,
    stock_quantity,
    price * stock_quantity AS InventoryValue
FROM Products
ORDER BY
    price * stock_quantity DESC;


/*
The alias can also be used:

*/

SELECT
    product_name,
    price,
    stock_quantity,
    price * stock_quantity AS InventoryValue
FROM Products
ORDER BY
    InventoryValue DESC;


/*
===============================================================================
PRACTICE QUESTIONS
===============================================================================

Try solving these yourself.

1. Display all products sorted by price from lowest to highest.

2. Display all products sorted by price from highest to lowest.

3. Display customers alphabetically by name.

4. Display customers from newest registration to oldest.

5. Display employees by salary from highest to lowest.

6. Sort employees by department and then salary from highest
   to lowest.

7. Sort products by category and then price from highest
   to lowest.

8. Display the 5 most expensive products.

9. Display the 3 cheapest products.

10. Display the 5 most recent orders.

11. Display the top 30 percent of products by price.

12. Display the top 20 percent of customers by registration date.

13. Find the top 3 highest-paid employees.

14. Find the top 3 highest-paid employees including ties.

15. Find the top 3 products by price including ties.

16. Sort products by calculated inventory value
    (price * stock_quantity) from highest to lowest.


===============================================================================
QUICK REVISION
===============================================================================

ORDER BY
-> Sorts query results.


ASC
-> Ascending.

Numbers: Low -> High
Text: A -> Z
Dates: Old -> New


DESC
-> Descending.

Numbers: High -> Low
Text: Z -> A
Dates: New -> Old


Multiple-column sorting:

ORDER BY column1 ASC,
         column2 DESC;


TOP
-> Returns a specified number of rows.

TOP (5)
-> First 5 rows.


TOP PERCENT
-> Returns a percentage of rows.

TOP (20) PERCENT
-> Approximately 20% of rows.


WITH TIES
-> Includes additional rows tied with the last
   row selected by TOP.


===============================================================================
IMPORTANT
===============================================================================

TOP without ORDER BY:

SELECT TOP (5) *
FROM Products;

This does NOT mean "5 highest" or "5 lowest".

It only limits the result to 5 rows.

For meaningful top/bottom results, use:

TOP + ORDER BY


Example:

SELECT TOP (5) *
FROM Products
ORDER BY price DESC;


===============================================================================
*/