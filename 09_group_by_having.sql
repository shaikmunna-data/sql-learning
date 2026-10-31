/*
===============================================================================
09 - GROUP BY AND HAVING
===============================================================================

DATABASE:
    EcommerceSQL

TOPICS:
    1. What is GROUP BY?
    2. GROUP BY with Aggregate Functions
    3. GROUP BY with WHERE
    4. Multiple-Column Grouping
    5. HAVING
    6. WHERE vs HAVING
    7. GROUP BY with ORDER BY
    8. Practical Data Analysis Examples
    9. Practice Questions
    10. Quick Revision

===============================================================================
*/


USE EcommerceSQL;
GO


/*
===============================================================================
1. WHAT IS GROUP BY?
===============================================================================

GROUP BY groups rows that have the same values in one or more columns.

It is mainly used with aggregate functions such as:

    COUNT()
    SUM()
    AVG()
    MIN()
    MAX()

Without GROUP BY:

    SELECT SUM(total_amount)
    FROM Orders;

This returns one total for all orders.

With GROUP BY:

    SELECT
        payment_method,
        SUM(total_amount)
    FROM Orders
    GROUP BY payment_method;

This returns a separate total for each payment method.


===============================================================================
2. BASIC GROUP BY
===============================================================================
*/


/*
-------------------------------------------------------------------------------
2.1 Count customers by city
-------------------------------------------------------------------------------
*/

SELECT
    city,
    COUNT(*) AS customer_count
FROM Customers
GROUP BY city;


/*
Result concept:

    city          customer_count
    ----------------------------
    Hyderabad     ...
    Chennai       ...
    Mumbai        ...
    etc.


Each unique city becomes one group.
*/


/*
-------------------------------------------------------------------------------
2.2 Count customers by state
-------------------------------------------------------------------------------
*/

SELECT
    state,
    COUNT(*) AS customer_count
FROM Customers
GROUP BY state;


/*
-------------------------------------------------------------------------------
2.3 Count products by category
-------------------------------------------------------------------------------
*/

SELECT
    category,
    COUNT(*) AS product_count
FROM Products
GROUP BY category;


/*
-------------------------------------------------------------------------------
2.4 Total stock by category
-------------------------------------------------------------------------------
*/

SELECT
    category,
    SUM(stock_quantity) AS total_stock
FROM Products
GROUP BY category;


/*
-------------------------------------------------------------------------------
2.5 Average product price by category
-------------------------------------------------------------------------------
*/

SELECT
    category,
    AVG(price) AS average_price
FROM Products
GROUP BY category;


/*
Round the average price.
*/

SELECT
    category,
    ROUND(AVG(price), 2) AS average_price
FROM Products
GROUP BY category;


/*
===============================================================================
3. GROUP BY WITH DIFFERENT AGGREGATE FUNCTIONS
===============================================================================

You can use multiple aggregate functions for each group.
*/


SELECT
    category,
    COUNT(*) AS product_count,
    SUM(stock_quantity) AS total_stock,
    ROUND(AVG(price), 2) AS average_price,
    MIN(price) AS lowest_price,
    MAX(price) AS highest_price
FROM Products
GROUP BY category;


/*
This is a typical data-analysis summary.

For every product category we get:

    Number of products
    Total stock
    Average price
    Minimum price
    Maximum price
*/


/*
===============================================================================
4. GROUP BY WITH ORDERS
===============================================================================
*/


/*
-------------------------------------------------------------------------------
4.1 Number of orders by payment method
-------------------------------------------------------------------------------
*/

SELECT
    payment_method,
    COUNT(*) AS order_count
FROM Orders
GROUP BY payment_method;


/*
-------------------------------------------------------------------------------
4.2 Total sales by payment method
-------------------------------------------------------------------------------
*/

SELECT
    payment_method,
    SUM(total_amount) AS total_sales
FROM Orders
GROUP BY payment_method;


/*
-------------------------------------------------------------------------------
4.3 Average order value by payment method
-------------------------------------------------------------------------------
*/

SELECT
    payment_method,
    ROUND(AVG(total_amount), 2) AS average_order_value
FROM Orders
GROUP BY payment_method;


/*
-------------------------------------------------------------------------------
4.4 Order count by order status
-------------------------------------------------------------------------------
*/

SELECT
    order_status,
    COUNT(*) AS order_count
FROM Orders
GROUP BY order_status;


/*
-------------------------------------------------------------------------------
4.5 Total sales by order status
-------------------------------------------------------------------------------
*/

SELECT
    order_status,
    SUM(total_amount) AS total_sales
FROM Orders
GROUP BY order_status;


/*
===============================================================================
5. GROUP BY WITH WHERE
===============================================================================

WHERE filters individual rows BEFORE GROUP BY creates groups.

Example:

Find the number of delivered orders for each payment method.
*/


SELECT
    payment_method,
    COUNT(*) AS delivered_orders
FROM Orders
WHERE order_status = 'Delivered'
GROUP BY payment_method;


/*
Execution concept:

    FROM
      ?
    WHERE
      ?
    GROUP BY
      ?
    Aggregate Function
      ?
    SELECT


First SQL Server selects only Delivered orders.

Then it groups those rows by payment_method.

Then COUNT() counts the rows in each group.
*/


/*
Another example:

Find total sales by payment method,
but only for delivered orders.
*/

SELECT
    payment_method,
    SUM(total_amount) AS delivered_sales
FROM Orders
WHERE order_status = 'Delivered'
GROUP BY payment_method;


/*
===============================================================================
6. MULTIPLE-COLUMN GROUPING
===============================================================================

GROUP BY can contain more than one column.

Syntax:

    GROUP BY column1, column2

SQL Server creates a group for every UNIQUE COMBINATION
of the specified columns.
*/


/*
-------------------------------------------------------------------------------
6.1 Group customers by state and city
-------------------------------------------------------------------------------
*/

SELECT
    state,
    city,
    COUNT(*) AS customer_count
FROM Customers
GROUP BY state, city;


/*
Example concept:

    state       city          customer_count
    ----------------------------------------
    Telangana   Hyderabad     ...
    Karnataka   Bengaluru     ...
    Tamil Nadu  Chennai       ...
*/


/*
-------------------------------------------------------------------------------
6.2 Group orders by status and payment method
-------------------------------------------------------------------------------
*/

SELECT
    order_status,
    payment_method,
    COUNT(*) AS order_count
FROM Orders
GROUP BY order_status, payment_method;


/*
-------------------------------------------------------------------------------
6.3 Total sales by status and payment method
-------------------------------------------------------------------------------
*/

SELECT
    order_status,
    payment_method,
    SUM(total_amount) AS total_sales
FROM Orders
GROUP BY order_status, payment_method;


/*
-------------------------------------------------------------------------------
6.4 Product category and supplier
-------------------------------------------------------------------------------

NULL supplier values form their own group.
*/

SELECT
    category,
    supplier,
    COUNT(*) AS product_count
FROM Products
GROUP BY category, supplier;


/*
===============================================================================
7. WHAT IS HAVING?
===============================================================================

HAVING filters GROUPS after GROUP BY.

WHERE filters individual rows.

HAVING filters the results of aggregate calculations.

Example:

Find product categories having more than 2 products.
*/


SELECT
    category,
    COUNT(*) AS product_count
FROM Products
GROUP BY category
HAVING COUNT(*) > 2;


/*
The important difference:

    WHERE
        Filters rows.

    HAVING
        Filters groups.


===============================================================================
8. HAVING WITH SUM()
===============================================================================
*/


/*
Find payment methods whose total sales are greater than 100,000.
*/

SELECT
    payment_method,
    SUM(total_amount) AS total_sales
FROM Orders
GROUP BY payment_method
HAVING SUM(total_amount) > 100000;


/*
===============================================================================
9. HAVING WITH AVG()
===============================================================================
*/


/*
Find product categories whose average price is greater than 10,000.
*/

SELECT
    category,
    ROUND(AVG(price), 2) AS average_price
FROM Products
GROUP BY category
HAVING AVG(price) > 10000;


/*
===============================================================================
10. HAVING WITH COUNT()
===============================================================================
*/


/*
Find cities having more than one customer.
*/

SELECT
    city,
    COUNT(*) AS customer_count
FROM Customers
GROUP BY city
HAVING COUNT(*) > 1;


/*
Find customers who have placed more than one order.

This uses customer_id to group orders.
*/

SELECT
    customer_id,
    COUNT(*) AS order_count
FROM Orders
GROUP BY customer_id
HAVING COUNT(*) > 1;


/*
===============================================================================
11. WHERE VS HAVING
===============================================================================

WHERE and HAVING are NOT interchangeable.

WHERE:
    Filters individual rows.

HAVING:
    Filters groups after aggregation.


Example:

Find delivered orders and then show only payment methods
with more than 2 delivered orders.
*/

SELECT
    payment_method,
    COUNT(*) AS delivered_order_count
FROM Orders
WHERE order_status = 'Delivered'
GROUP BY payment_method
HAVING COUNT(*) > 2;


/*
Here:

    WHERE order_status = 'Delivered'
        ?
    removes non-delivered rows

    GROUP BY payment_method
        ?
    creates payment method groups

    HAVING COUNT(*) > 2
        ?
    keeps only groups with more than 2 orders
*/


/*
===============================================================================
12. WHERE VS HAVING - SIMPLE COMPARISON
===============================================================================

WHERE:

    Works on rows
    Comes before GROUP BY
    Usually does not use aggregate functions

Example:

    WHERE price > 10000


HAVING:

    Works on groups
    Comes after GROUP BY
    Commonly uses aggregate functions

Example:

    HAVING AVG(price) > 10000


Remember:

    WHERE -> ROWS
    HAVING -> GROUPS
*/


/*
===============================================================================
13. GROUP BY WITH ORDER BY
===============================================================================

ORDER BY can be used after GROUP BY and HAVING.

Example:
*/


SELECT
    category,
    SUM(stock_quantity) AS total_stock
FROM Products
GROUP BY category
ORDER BY total_stock DESC;


/*
Find product categories from highest average price to lowest.
*/

SELECT
    category,
    ROUND(AVG(price), 2) AS average_price
FROM Products
GROUP BY category
ORDER BY average_price DESC;


/*
Find payment methods from highest sales to lowest.
*/

SELECT
    payment_method,
    SUM(total_amount) AS total_sales
FROM Orders
GROUP BY payment_method
ORDER BY total_sales DESC;


/*
===============================================================================
14. PRACTICAL DATA ANALYSIS EXAMPLES
===============================================================================

These are closer to the type of questions asked in real data analysis.
*/


/*
-------------------------------------------------------------------------------
14.1 Which product category has the most products?
-------------------------------------------------------------------------------
*/

SELECT TOP (1)
    category,
    COUNT(*) AS product_count
FROM Products
GROUP BY category
ORDER BY product_count DESC;


/*
-------------------------------------------------------------------------------
14.2 Which payment method generates the highest sales?
-------------------------------------------------------------------------------
*/

SELECT TOP (1)
    payment_method,
    SUM(total_amount) AS total_sales
FROM Orders
GROUP BY payment_method
ORDER BY total_sales DESC;


/*
-------------------------------------------------------------------------------
14.3 Which customer has placed the most orders?
-------------------------------------------------------------------------------
*/

SELECT TOP (1)
    customer_id,
    COUNT(*) AS order_count
FROM Orders
GROUP BY customer_id
ORDER BY order_count DESC;


/*
-------------------------------------------------------------------------------
14.4 Which category has the highest average product price?
-------------------------------------------------------------------------------
*/

SELECT TOP (1)
    category,
    ROUND(AVG(price), 2) AS average_price
FROM Products
GROUP BY category
ORDER BY average_price DESC;


/*
-------------------------------------------------------------------------------
14.5 Find categories with total stock greater than 50.
-------------------------------------------------------------------------------
*/

SELECT
    category,
    SUM(stock_quantity) AS total_stock
FROM Products
GROUP BY category
HAVING SUM(stock_quantity) > 50;


/*
-------------------------------------------------------------------------------
14.6 Find cities with more than one customer.
-------------------------------------------------------------------------------
*/

SELECT
    city,
    COUNT(*) AS customer_count
FROM Customers
GROUP BY city
HAVING COUNT(*) > 1
ORDER BY customer_count DESC;


/*
-------------------------------------------------------------------------------
14.7 Delivered sales by payment method.
-------------------------------------------------------------------------------
*/

SELECT
    payment_method,
    COUNT(*) AS delivered_orders,
    SUM(total_amount) AS delivered_sales,
    ROUND(AVG(total_amount), 2) AS average_order_value
FROM Orders
WHERE order_status = 'Delivered'
GROUP BY payment_method
ORDER BY delivered_sales DESC;


/*
===============================================================================
15. GROUP BY WITH MULTIPLE COLUMNS + HAVING
===============================================================================

Find order status/payment method combinations
having more than one order.
*/


SELECT
    order_status,
    payment_method,
    COUNT(*) AS order_count
FROM Orders
GROUP BY order_status, payment_method
HAVING COUNT(*) > 1
ORDER BY order_count DESC;


/*
===============================================================================
16. SQL QUERY PROCESSING ORDER
===============================================================================

A simplified logical processing order is:

    FROM
      ?
    WHERE
      ?
    GROUP BY
      ?
    HAVING
      ?
    SELECT
      ?
    ORDER BY

This explains why WHERE and HAVING have different purposes.

Example:

SELECT
    payment_method,
    SUM(total_amount) AS total_sales
FROM Orders
WHERE order_status = 'Delivered'
GROUP BY payment_method
HAVING SUM(total_amount) > 50000
ORDER BY total_sales DESC;


Process:

    1. FROM Orders
    2. WHERE Delivered orders
    3. GROUP BY payment_method
    4. Calculate SUM()
    5. HAVING total sales > 50,000
    6. SELECT results
    7. ORDER BY total sales


===============================================================================
17. PRACTICE QUESTIONS
===============================================================================

GROUP BY
--------

1. Count customers by city.

2. Count customers by state.

3. Count products by category.

4. Calculate total stock by category.

5. Calculate average product price by category.

6. Find the minimum and maximum product price for each category.

7. Count orders by payment method.

8. Calculate total sales by payment method.

9. Calculate average order amount by payment method.

10. Count orders by order status.


MULTIPLE-COLUMN GROUPING
------------------------

11. Count customers by state and city.

12. Count orders by order status and payment method.

13. Calculate total sales by order status and payment method.

14. Count products by category and supplier.


WHERE + GROUP BY
----------------

15. Count delivered orders by payment method.

16. Calculate delivered sales by payment method.

17. Find the average order amount for delivered orders
    grouped by payment method.


HAVING
------

18. Find cities with more than one customer.

19. Find categories containing more than 2 products.

20. Find payment methods with total sales greater than 100,000.

21. Find categories whose average product price is greater than 10,000.

22. Find customers who have placed more than one order.


WHERE + GROUP BY + HAVING
-------------------------

23. Find payment methods that have more than 2 delivered orders.

24. Find product categories whose total stock is greater than 50.

25. Find payment methods whose delivered sales exceed 50,000.


DATA ANALYSIS
-------------

26. Which payment method generates the highest total sales?

27. Which category has the highest average product price?

28. Which customer has placed the most orders?

29. Which city has the most customers?

30. Show delivered order count, total sales, and average order
    value for each payment method.


===============================================================================
18. QUICK REVISION
===============================================================================

GROUP BY
    Groups rows with the same values.

Example:

    GROUP BY category


MULTIPLE-COLUMN GROUP BY
    Groups by unique combinations of multiple columns.

Example:

    GROUP BY state, city


HAVING
    Filters groups after aggregation.

Example:

    HAVING COUNT(*) > 2


WHERE
    Filters individual rows before grouping.

Example:

    WHERE order_status = 'Delivered'


KEY DIFFERENCE:

    WHERE  -> filters ROWS
    HAVING -> filters GROUPS


COMMON PATTERN:

    SELECT
        column,
        AGGREGATE_FUNCTION(column)
    FROM table
    WHERE row_condition
    GROUP BY column
    HAVING aggregate_condition
    ORDER BY column;


EXAMPLE:

    SELECT
        payment_method,
        COUNT(*) AS order_count,
        SUM(total_amount) AS total_sales
    FROM Orders
    WHERE order_status = 'Delivered'
    GROUP BY payment_method
    HAVING COUNT(*) > 2
    ORDER BY total_sales DESC;


IMPORTANT:

    WHERE comes before GROUP BY.

    HAVING comes after GROUP BY.

    WHERE filters rows.

    HAVING filters groups.

===============================================================================
*/