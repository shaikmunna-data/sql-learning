/*
===============================================================================
08 - AGGREGATE FUNCTIONS
===============================================================================

DATABASE:
    EcommerceSQL

TOPICS:
    1. What are Aggregate Functions?
    2. COUNT()
    3. SUM()
    4. AVG()
    5. MIN()
    6. MAX()
    7. Aggregate Functions vs Scalar Functions
    8. NULL Handling in Aggregate Functions
    9. Combining Aggregate Functions
    10. Practice Questions
    11. Quick Revision

===============================================================================
*/


USE EcommerceSQL;
GO


/*
===============================================================================
1. WHAT ARE AGGREGATE FUNCTIONS?
===============================================================================

Aggregate functions perform calculations on multiple rows and return
a single result.

Common aggregate functions:

    COUNT() -> counts rows/values
    SUM()   -> calculates total
    AVG()   -> calculates average
    MIN()   -> finds minimum value
    MAX()   -> finds maximum value

Examples:

    Total number of customers
    Total sales
    Average product price
    Cheapest product
    Most expensive product

Aggregate functions are commonly used with:

    GROUP BY
    HAVING

GROUP BY and HAVING will be studied in a later topic.
*/


/*
===============================================================================
2. COUNT()
===============================================================================

COUNT() counts rows or non-NULL values.

There are two commonly used forms:

    COUNT(*)
    COUNT(column)

-------------------------------------------------------------------------------
2.1 COUNT(*)
-------------------------------------------------------------------------------

Counts all rows.

NULL values do not affect COUNT(*).
*/

SELECT
    COUNT(*) AS total_customers
FROM Customers;


/*
Count all products.
*/

SELECT
    COUNT(*) AS total_products
FROM Products;


/*
Count all orders.
*/

SELECT
    COUNT(*) AS total_orders
FROM Orders;


/*
-------------------------------------------------------------------------------
2.2 COUNT(column)
-------------------------------------------------------------------------------

Counts only NON-NULL values in the specified column.

Customers table contains some NULL email values.
*/

SELECT
    COUNT(email) AS customers_with_email
FROM Customers;


/*
Compare COUNT(*) with COUNT(email).
*/

SELECT
    COUNT(*) AS total_customers,
    COUNT(email) AS customers_with_email
FROM Customers;


/*
IMPORTANT:

    COUNT(*)       -> counts every row

    COUNT(column)  -> counts only non-NULL values
*/


/*
===============================================================================
3. SUM()
===============================================================================

SUM() calculates the total of a numeric column.

Syntax:

    SUM(column)
*/


/*
Total order amount.
*/

SELECT
    SUM(total_amount) AS total_order_amount
FROM Orders;


/*
Total product stock.
*/

SELECT
    SUM(stock_quantity) AS total_stock
FROM Products;


/*
Total quantity of products ordered.
*/

SELECT
    SUM(quantity) AS total_quantity_ordered
FROM OrderItems;


/*
===============================================================================
4. AVG()
===============================================================================

AVG() calculates the average of numeric values.

Syntax:

    AVG(column)
*/


/*
Average product price.
*/

SELECT
    AVG(price) AS average_product_price
FROM Products;


/*
Average employee salary.
*/

SELECT
    AVG(salary) AS average_salary
FROM Employees;


/*
Average order amount.
*/

SELECT
    AVG(total_amount) AS average_order_amount
FROM Orders;


/*
Round the average to 2 decimal places.
*/

SELECT
    ROUND(AVG(total_amount), 2) AS average_order_amount
FROM Orders;


/*
===============================================================================
5. MIN()
===============================================================================

MIN() returns the smallest value.

It can be used with numeric, date, and other comparable data.
*/


/*
Cheapest product price.
*/

SELECT
    MIN(price) AS lowest_product_price
FROM Products;


/*
Lowest employee salary.
*/

SELECT
    MIN(salary) AS lowest_salary
FROM Employees;


/*
Earliest order date.
*/

SELECT
    MIN(order_date) AS first_order_date
FROM Orders;


/*
===============================================================================
6. MAX()
===============================================================================

MAX() returns the largest value.
*/


/*
Most expensive product.
*/

SELECT
    MAX(price) AS highest_product_price
FROM Products;


/*
Highest employee salary.
*/

SELECT
    MAX(salary) AS highest_salary
FROM Employees;


/*
Latest order date.
*/

SELECT
    MAX(order_date) AS latest_order_date
FROM Orders;


/*
===============================================================================
7. USING MULTIPLE AGGREGATE FUNCTIONS
===============================================================================

Multiple aggregate functions can be used in the same SELECT statement.
*/


SELECT
    COUNT(*) AS total_orders,
    SUM(total_amount) AS total_sales,
    AVG(total_amount) AS average_order_amount,
    MIN(total_amount) AS minimum_order_amount,
    MAX(total_amount) AS maximum_order_amount
FROM Orders;


/*
Product price summary.
*/

SELECT
    COUNT(*) AS total_products,
    SUM(price) AS sum_of_prices,
    ROUND(AVG(price), 2) AS average_price,
    MIN(price) AS lowest_price,
    MAX(price) AS highest_price
FROM Products;


/*
Employee salary summary.
*/

SELECT
    COUNT(*) AS total_employees,
    SUM(salary) AS total_salary,
    ROUND(AVG(salary), 2) AS average_salary,
    MIN(salary) AS minimum_salary,
    MAX(salary) AS maximum_salary
FROM Employees;


/*
===============================================================================
8. AGGREGATE FUNCTIONS VS SCALAR FUNCTIONS
===============================================================================

SCALAR FUNCTIONS
----------------

Scalar functions operate on individual values/rows.

They normally return one result for each input row.

Examples:

    UPPER()
    LOWER()
    LEN()
    ROUND()
    ABS()
    ISNULL()


Example:
*/

SELECT
    product_name,
    UPPER(product_name) AS uppercase_product_name
FROM Products;


/*
Each product produces one result.

If Products contains 10 rows,
the query returns 10 rows.


AGGREGATE FUNCTIONS
-------------------

Aggregate functions operate on multiple rows and return one result
for the entire set of rows, unless GROUP BY is used.

Examples:

    COUNT()
    SUM()
    AVG()
    MIN()
    MAX()


Example:
*/

SELECT
    AVG(price) AS average_price
FROM Products;


/*
The query returns one row containing the average price.

-------------------------------------------------------------------------------

Simple comparison:

    Scalar Function
        One row/value -> one result

    Aggregate Function
        Multiple rows -> one result

GROUP BY can later be used to produce one aggregate result
for each group.
*/


/*
===============================================================================
9. NULL HANDLING IN AGGREGATE FUNCTIONS
===============================================================================

Most aggregate functions IGNORE NULL values.

For example:

    AVG(column)
    SUM(column)
    MIN(column)
    MAX(column)

ignore NULL values in that column.

COUNT(column) also ignores NULL values.

COUNT(*) is different because it counts rows,
including rows where individual columns contain NULL.
*/


/*
-------------------------------------------------------------------------------
9.1 COUNT(*) vs COUNT(column)
-------------------------------------------------------------------------------
*/

SELECT
    COUNT(*) AS total_customers,
    COUNT(email) AS customers_with_email
FROM Customers;


/*
There are customers whose email is NULL.

Therefore:

    COUNT(*)      -> counts all customers
    COUNT(email) -> counts only customers with email
*/


/*
-------------------------------------------------------------------------------
9.2 NULL values and AVG()
-------------------------------------------------------------------------------

AVG() ignores NULL values.

Example:
*/

SELECT
    AVG(salary) AS average_salary
FROM Employees;


/*
If a salary were NULL, AVG() would not treat NULL as zero.

It would simply exclude that row from the average calculation.
*/


/*
-------------------------------------------------------------------------------
9.3 NULL values and SUM()
-------------------------------------------------------------------------------

SUM() ignores NULL values.

Example:
*/

SELECT
    SUM(salary) AS total_salary
FROM Employees;


/*
If one employee's salary were NULL,
that NULL value would not be added to the total.
*/


/*
-------------------------------------------------------------------------------
9.4 NULL values and MIN()/MAX()
-------------------------------------------------------------------------------

MIN() and MAX() ignore NULL values.
*/

SELECT
    MIN(salary) AS minimum_salary,
    MAX(salary) AS maximum_salary
FROM Employees;


/*
===============================================================================
10. NULL HANDLING WITH ISNULL()
===============================================================================

ISNULL() can replace NULL before performing calculations.

Example:

    ISNULL(column, replacement_value)


However, be careful:

Replacing NULL with 0 can change the meaning of an aggregate calculation.

For example:

    AVG(salary)

and

    AVG(ISNULL(salary, 0))

do NOT necessarily produce the same result.

The first ignores NULL salaries.

The second treats NULL salaries as 0.

Therefore, understand the business meaning before replacing NULL
with zero.
*/


/*
===============================================================================
11. PRACTICAL EXAMPLES
===============================================================================
*/


/*
Example 1:
How many customers are registered?
*/

SELECT
    COUNT(*) AS total_customers
FROM Customers;


/*
Example 2:
How many active customers are there?

Note:
Filtering will be studied in detail earlier, but aggregate functions
can be combined with WHERE.
*/

SELECT
    COUNT(*) AS active_customers
FROM Customers
WHERE customer_status = 'Active';


/*
Example 3:
What is the total sales amount?
*/

SELECT
    SUM(total_amount) AS total_sales
FROM Orders;


/*
Example 4:
What is the average order value?
*/

SELECT
    ROUND(AVG(total_amount), 2) AS average_order_value
FROM Orders;


/*
Example 5:
What is the cheapest and most expensive product?
*/

SELECT
    MIN(price) AS cheapest_price,
    MAX(price) AS highest_price
FROM Products;


/*
Example 6:
What is the total quantity of products sold?
*/

SELECT
    SUM(quantity) AS total_quantity_sold
FROM OrderItems;


/*
Example 7:
What is the average employee salary?
*/

SELECT
    ROUND(AVG(salary), 2) AS average_salary
FROM Employees;


/*
===============================================================================
12. PRACTICE QUESTIONS
===============================================================================

Try to solve these yourself.

COUNT()
-------

1. Find the total number of customers.

2. Find the total number of products.

3. Find the total number of employees.

4. Find the total number of orders.

5. Find how many customers have an email address.

6. Compare COUNT(*) and COUNT(email).


SUM()
-----

7. Find the total order amount.

8. Find the total product stock quantity.

9. Find the total quantity ordered from OrderItems.

10. Find the total employee salary.


AVG()
-----

11. Find the average product price.

12. Find the average employee salary.

13. Find the average order amount.

14. Round the average order amount to 2 decimal places.


MIN()
-----

15. Find the cheapest product price.

16. Find the lowest employee salary.

17. Find the earliest order date.


MAX()
-----

18. Find the most expensive product price.

19. Find the highest employee salary.

20. Find the latest order date.


COMBINATION
-----------

21. Display the following order statistics in one query:

       Total Orders
       Total Sales
       Average Order Amount
       Minimum Order Amount
       Maximum Order Amount


NULL PRACTICE
-------------

22. Compare:

       COUNT(*)
       COUNT(email)

23. Explain why COUNT(email) can be lower than COUNT(*).

24. Test what happens when a column contains NULL values
    with AVG(), SUM(), MIN(), and MAX().

25. Explain the difference between:

       AVG(salary)

    and

       AVG(ISNULL(salary, 0))


SCALAR VS AGGREGATE
-------------------

26. Is UPPER() a scalar or aggregate function?

27. Is SUM() a scalar or aggregate function?

28. Is ROUND() a scalar or aggregate function?

29. Is COUNT() a scalar or aggregate function?

30. Explain the difference between a scalar function
    and an aggregate function in your own words.


===============================================================================
13. QUICK REVISION
===============================================================================

COUNT()
    Counts rows or non-NULL values.

    COUNT(*)       -> counts all rows
    COUNT(column)  -> counts non-NULL values


SUM()
    Calculates the total of numeric values.


AVG()
    Calculates the average of numeric values.
    Ignores NULL values.


MIN()
    Returns the smallest value.
    Ignores NULL values.


MAX()
    Returns the largest value.
    Ignores NULL values.


SCALAR FUNCTIONS
    Work with individual values/rows.

    Examples:
        UPPER()
        LOWER()
        LEN()
        ROUND()
        ABS()


AGGREGATE FUNCTIONS
    Work with multiple rows.

    Examples:
        COUNT()
        SUM()
        AVG()
        MIN()
        MAX()


NULL HANDLING
    COUNT(*)       -> counts rows even if columns contain NULL
    COUNT(column)  -> ignores NULL
    SUM()          -> ignores NULL
    AVG()          -> ignores NULL
    MIN()          -> ignores NULL
    MAX()          -> ignores NULL


IMPORTANT:
    NULL is not the same as 0.

    Do not automatically replace NULL with 0.
    First understand what NULL means in the data.

===============================================================================
*/