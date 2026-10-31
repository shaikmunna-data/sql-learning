/*
===============================================================================
07 - SQL FUNCTIONS
===============================================================================

DATABASE:
    EcommerceSQL

TOPICS:
    1. What are SQL Functions?
    2. Scalar Functions vs Aggregate Functions
    3. String Functions
       - LEN()
       - UPPER()
       - LOWER()
       - TRIM()
       - LEFT()
       - RIGHT()
       - SUBSTRING()
       - REPLACE()
       - CONCAT()
    4. Numeric Functions
       - ROUND()
       - CEILING()
       - FLOOR()
       - ABS()
    5. Date Functions
       - GETDATE()
       - DATEADD()
       - DATEDIFF()
       - DATEPART()
       - DATENAME()
       - EOMONTH()
    6. NULL Functions
       - ISNULL()
       - COALESCE()
       - NULLIF()

===============================================================================
*/


USE EcommerceSQL;
GO


/*
===============================================================================
1. WHAT ARE SQL FUNCTIONS?
===============================================================================

A SQL function is a built-in operation that performs a specific task
and returns a value.

Examples:

    UPPER()       -> converts text to uppercase
    ROUND()       -> rounds a number
    GETDATE()     -> returns the current date and time
    ISNULL()      -> replaces NULL with another value

SQL Server provides many built-in functions.
*/


/*
===============================================================================
2. SCALAR FUNCTIONS VS AGGREGATE FUNCTIONS
===============================================================================

SCALAR FUNCTIONS
----------------
A scalar function works on individual values and returns one value
for each input row.

Examples:

    UPPER()
    LOWER()
    LEN()
    ROUND()
    GETDATE()
    ISNULL()

Example:

    SELECT
        customer_name,
        UPPER(customer_name) AS uppercase_name
    FROM Customers;

Each customer row produces one result.

AGGREGATE FUNCTIONS
-------------------
Aggregate functions work on multiple rows and return a single result
for the group of rows.

Common aggregate functions:

    COUNT()
    SUM()
    AVG()
    MIN()
    MAX()

Example:

    SELECT SUM(total_amount) AS total_sales
    FROM Orders;

Multiple order rows are combined into one result.

NOTE:
Aggregate functions will be studied in more detail in the
Aggregate Functions topic.


===============================================================================
3. STRING FUNCTIONS
===============================================================================
*/


/*
-------------------------------------------------------------------------------
3.1 LEN()
-------------------------------------------------------------------------------

Returns the number of characters in a string.

Syntax:

    LEN(string)

Example:
*/

SELECT
    customer_name,
    LEN(customer_name) AS name_length
FROM Customers;


/*
-------------------------------------------------------------------------------
3.2 UPPER()
-------------------------------------------------------------------------------

Converts text to uppercase.

Syntax:

    UPPER(string)
*/

SELECT
    customer_name,
    UPPER(customer_name) AS uppercase_name
FROM Customers;


/*
-------------------------------------------------------------------------------
3.3 LOWER()
-------------------------------------------------------------------------------

Converts text to lowercase.

Syntax:

    LOWER(string)
*/

SELECT
    customer_name,
    LOWER(customer_name) AS lowercase_name
FROM Customers;


/*
-------------------------------------------------------------------------------
3.4 TRIM()
-------------------------------------------------------------------------------

Removes leading and trailing spaces from a string.

Syntax:

    TRIM(string)

Useful when data contains unwanted spaces.

Example:
*/

SELECT
    TRIM('   Rahul Sharma   ') AS cleaned_name;


/*
-------------------------------------------------------------------------------
3.5 LEFT()
-------------------------------------------------------------------------------

Returns a specified number of characters from the left side.

Syntax:

    LEFT(string, number_of_characters)
*/

SELECT
    customer_name,
    LEFT(customer_name, 5) AS first_five_characters
FROM Customers;


/*
-------------------------------------------------------------------------------
3.6 RIGHT()
-------------------------------------------------------------------------------

Returns a specified number of characters from the right side.

Syntax:

    RIGHT(string, number_of_characters)
*/

SELECT
    customer_name,
    RIGHT(customer_name, 5) AS last_five_characters
FROM Customers;


/*
-------------------------------------------------------------------------------
3.7 SUBSTRING()
-------------------------------------------------------------------------------

Extracts part of a string.

Syntax:

    SUBSTRING(string, start_position, length)

Example:
*/

SELECT
    customer_name,
    SUBSTRING(customer_name, 1, 5) AS extracted_text
FROM Customers;


/*
-------------------------------------------------------------------------------
3.8 REPLACE()
-------------------------------------------------------------------------------

Replaces one piece of text with another.

Syntax:

    REPLACE(string, old_value, new_value)

Example:
*/

SELECT
    customer_name,
    REPLACE(customer_name, ' ', '_') AS modified_name
FROM Customers;


/*
Another practical example:

Change a product category name in the result.
*/

SELECT
    product_name,
    REPLACE(category, 'Electronics', 'Electronic Products') AS category_name
FROM Products;


/*
-------------------------------------------------------------------------------
3.9 CONCAT()
-------------------------------------------------------------------------------

Combines two or more values into one string.

Syntax:

    CONCAT(value1, value2, ...)

Example:
*/

SELECT
    customer_name,
    city,
    CONCAT(customer_name, ' - ', city) AS customer_location
FROM Customers;


/*
Practical example:
Create a readable customer description.
*/

SELECT
    CONCAT(
        customer_name,
        ' lives in ',
        city,
        ', ',
        state
    ) AS customer_description
FROM Customers;


/*
===============================================================================
4. NUMERIC FUNCTIONS
===============================================================================
*/


/*
-------------------------------------------------------------------------------
4.1 ROUND()
-------------------------------------------------------------------------------

Rounds a number to a specified number of decimal places.

Syntax:

    ROUND(number, decimal_places)

Example:
*/

SELECT
    product_name,
    price,
    ROUND(price * 1.18, 2) AS price_with_tax
FROM Products;


/*
-------------------------------------------------------------------------------
4.2 CEILING()
-------------------------------------------------------------------------------

Returns the smallest integer greater than or equal to a number.

Example:

    10.2 -> 11
    10.0 -> 10
*/

SELECT
    CEILING(10.2) AS ceiling_value;


/*
Practical example:
*/

SELECT
    product_name,
    price,
    CEILING(price / 1000.0) AS price_in_thousands
FROM Products;


/*
-------------------------------------------------------------------------------
4.3 FLOOR()
-------------------------------------------------------------------------------

Returns the largest integer less than or equal to a number.

Example:

    10.8 -> 10
    10.2 -> 10
*/

SELECT
    FLOOR(10.8) AS floor_value;


/*
Practical example:
*/

SELECT
    product_name,
    price,
    FLOOR(price / 1000.0) AS price_in_thousands
FROM Products;


/*
-------------------------------------------------------------------------------
4.4 ABS()
-------------------------------------------------------------------------------

Returns the absolute (positive) value of a number.

Examples:

    ABS(10)  -> 10
    ABS(-10) -> 10
*/

SELECT
    ABS(-250) AS absolute_value;


/*
Practical example:
*/

SELECT
    product_name,
    price - 30000 AS price_difference,
    ABS(price - 30000) AS absolute_difference
FROM Products;


/*
===============================================================================
5. DATE FUNCTIONS
===============================================================================
*/


/*
-------------------------------------------------------------------------------
5.1 GETDATE()
-------------------------------------------------------------------------------

Returns the current date and time of the SQL Server.

Syntax:

    GETDATE()
*/

SELECT GETDATE() AS current_date_time;


/*
You can also use GETDATE() when comparing dates.

Example:
*/

SELECT
    order_id,
    order_date
FROM Orders
WHERE order_date <= GETDATE();


/*
-------------------------------------------------------------------------------
5.2 DATEADD()
-------------------------------------------------------------------------------

Adds a specified number of date/time units to a date.

Syntax:

    DATEADD(datepart, number, date)

Examples of datepart:

    YEAR
    MONTH
    DAY
*/

SELECT
    order_date,
    DATEADD(DAY, 7, order_date) AS date_after_7_days
FROM Orders;


/*
Add one month:
*/

SELECT
    order_date,
    DATEADD(MONTH, 1, order_date) AS next_month
FROM Orders;


/*
Add one year:
*/

SELECT
    order_date,
    DATEADD(YEAR, 1, order_date) AS next_year
FROM Orders;


/*
-------------------------------------------------------------------------------
5.3 DATEDIFF()
-------------------------------------------------------------------------------

Returns the difference between two dates.

Syntax:

    DATEDIFF(datepart, start_date, end_date)

Example:
*/

SELECT
    order_id,
    order_date,
    shipping_date,
    DATEDIFF(DAY, order_date, shipping_date) AS shipping_days
FROM Orders
WHERE shipping_date IS NOT NULL;


/*
Calculate how many days a customer has been registered
up to the current date.
*/

SELECT
    customer_name,
    registration_date,
    DATEDIFF(DAY, registration_date, GETDATE()) AS days_since_registration
FROM Customers;


/*
-------------------------------------------------------------------------------
5.4 DATEPART()
-------------------------------------------------------------------------------

Returns a specific numeric part of a date.

Examples:

    YEAR
    MONTH
    DAY
    QUARTER
    WEEK
*/

SELECT
    order_id,
    order_date,
    DATEPART(YEAR, order_date) AS order_year,
    DATEPART(MONTH, order_date) AS order_month,
    DATEPART(DAY, order_date) AS order_day
FROM Orders;


/*
Get the quarter in which each order was placed.
*/

SELECT
    order_id,
    order_date,
    DATEPART(QUARTER, order_date) AS order_quarter
FROM Orders;


/*
-------------------------------------------------------------------------------
5.5 DATENAME()
-------------------------------------------------------------------------------

Returns the name of a specified date part.

Unlike DATEPART(), DATENAME() returns text for parts such as
month and weekday.

Example:
*/

SELECT
    order_id,
    order_date,
    DATENAME(MONTH, order_date) AS order_month_name,
    DATENAME(WEEKDAY, order_date) AS order_day_name
FROM Orders;


/*
DATEPART() -> numeric value

DATENAME() -> text value

Example:

    DATEPART(MONTH, order_date)
        -> 1

    DATENAME(MONTH, order_date)
        -> January
*/


/*
-------------------------------------------------------------------------------
5.6 EOMONTH()
-------------------------------------------------------------------------------

Returns the last day of the month containing a specified date.

Syntax:

    EOMONTH(date)

Example:
*/

SELECT
    order_date,
    EOMONTH(order_date) AS month_end_date
FROM Orders;


/*
You can also find the end of the next month.
*/

SELECT
    order_date,
    EOMONTH(order_date, 1) AS next_month_end
FROM Orders;


/*
===============================================================================
6. NULL FUNCTIONS
===============================================================================

NULL means that a value is unknown, missing, or not available.

Important:

    NULL is NOT:
        0
        ''
        'NULL'

Use NULL functions when you need to handle missing values.
*/


/*
-------------------------------------------------------------------------------
6.1 ISNULL()
-------------------------------------------------------------------------------

ISNULL() replaces NULL with a specified replacement value.

Syntax:

    ISNULL(expression, replacement_value)

Example:
*/

SELECT
    customer_name,
    email,
    ISNULL(email, 'Email Not Available') AS email_status
FROM Customers;


/*
Practical example with Employees:

Some employees do not have a manager.
*/

SELECT
    employee_name,
    ISNULL(manager_id, 0) AS manager_id
FROM Employees;


/*
-------------------------------------------------------------------------------
6.2 COALESCE()
-------------------------------------------------------------------------------

COALESCE() returns the first non-NULL value from a list of expressions.

Syntax:

    COALESCE(value1, value2, value3, ...)

Example:
*/

SELECT
    customer_name,
    COALESCE(email, 'Email Not Available') AS email_status
FROM Customers;


/*
Example with multiple possible values:

If the first value is NULL, SQL Server checks the next value.
*/

SELECT
    COALESCE(NULL, NULL, 'Available Value') AS result;


/*
ISNULL() vs COALESCE()

ISNULL():
    ISNULL(value, replacement)

COALESCE():
    COALESCE(value1, value2, value3, ...)

COALESCE() is useful when you have multiple possible fallback values.
*/


/*
-------------------------------------------------------------------------------
6.3 NULLIF()
-------------------------------------------------------------------------------

NULLIF() returns NULL when two expressions are equal.

Syntax:

    NULLIF(expression1, expression2)

Example:

    NULLIF(10, 10) -> NULL
    NULLIF(10, 20) -> 10
*/

SELECT
    NULLIF(10, 10) AS result_1,
    NULLIF(10, 20) AS result_2;


/*
A common practical use is avoiding division by zero.

Example:

    value / NULLIF(denominator, 0)

If denominator is 0, NULLIF() changes it to NULL,
preventing a divide-by-zero error.
*/


/*
===============================================================================
7. COMBINING FUNCTIONS
===============================================================================

SQL functions can be combined to solve real-world problems.
*/


/*
Example 1:
Convert customer names to uppercase and remove unwanted spaces.
*/

SELECT
    customer_name,
    UPPER(TRIM(customer_name)) AS cleaned_uppercase_name
FROM Customers;


/*
Example 2:
Create a customer label using CONCAT() and UPPER().
*/

SELECT
    CONCAT(
        UPPER(customer_name),
        ' - ',
        city
    ) AS customer_label
FROM Customers;


/*
Example 3:
Calculate delivery days and create a readable result.
*/

SELECT
    order_id,
    order_date,
    shipping_date,
    DATEDIFF(DAY, order_date, shipping_date) AS delivery_days
FROM Orders
WHERE shipping_date IS NOT NULL;


/*
Example 4:
Calculate product price with 18% tax and round it to 2 decimals.
*/

SELECT
    product_name,
    price,
    ROUND(price * 1.18, 2) AS price_with_tax
FROM Products;


/*
Example 5:
Handle missing supplier names.
*/

SELECT
    product_name,
    COALESCE(supplier, 'Supplier Not Available') AS supplier_name
FROM Products;


/*
===============================================================================
8. PRACTICE QUESTIONS
===============================================================================

Try solving these yourself before looking for the answer.

STRING FUNCTIONS
----------------

1. Display each customer name and its length.

2. Display all product names in uppercase.

3. Display all customer names in lowercase.

4. Display the first 3 characters of each product name.

5. Display the last 4 characters of each product name.

6. Extract the first 5 characters from each customer name.

7. Replace spaces in customer names with hyphens.

8. Create a column containing:
       customer_name - city

   using CONCAT().


NUMERIC FUNCTIONS
-----------------

9. Display product price with 18% tax, rounded to 2 decimal places.

10. Display the CEILING value of each product price divided by 1000.

11. Display the FLOOR value of each product price divided by 1000.

12. Find the absolute difference between each product price
    and 20,000.


DATE FUNCTIONS
--------------

13. Display the current date and time.

14. Add 30 days to each order date.

15. Find the number of days between order date and shipping date.

16. Display the year and month number of each order.

17. Display the month name for each order.

18. Display the day name for each order.

19. Display the last day of the month for each order.


NULL FUNCTIONS
--------------

20. Display "Email Not Available" when a customer's email is NULL.

21. Display "Supplier Not Available" when a product's supplier is NULL.

22. Use COALESCE() to return the first available value.

23. Use NULLIF() to prevent division by zero in a calculation.


COMBINATION PRACTICE
--------------------

24. Display customer names in uppercase and combine them with their city.

25. Display each order's delivery time in days.

26. Display product price including 18% tax, rounded to 2 decimals.

27. Display product names and replace NULL suppliers with
    "Unknown Supplier".

28. Display the order month name and order year together.

===============================================================================
9. QUICK REVISION
===============================================================================

SCALAR FUNCTION
    Works with individual values/rows.
    Example: UPPER(), LEN(), ROUND()

AGGREGATE FUNCTION
    Works with multiple rows.
    Example: SUM(), AVG(), COUNT()

STRING FUNCTIONS
    LEN()         -> number of characters
    UPPER()       -> uppercase
    LOWER()       -> lowercase
    TRIM()        -> removes leading/trailing spaces
    LEFT()        -> characters from left
    RIGHT()       -> characters from right
    SUBSTRING()   -> extracts part of a string
    REPLACE()     -> replaces text
    CONCAT()      -> combines values

NUMERIC FUNCTIONS
    ROUND()       -> rounds a number
    CEILING()     -> rounds upward
    FLOOR()       -> rounds downward
    ABS()         -> absolute value

DATE FUNCTIONS
    GETDATE()     -> current date and time
    DATEADD()     -> adds date/time
    DATEDIFF()    -> difference between dates
    DATEPART()    -> numeric date part
    DATENAME()    -> name of date part
    EOMONTH()     -> last day of month

NULL FUNCTIONS
    ISNULL()      -> replaces NULL with a value
    COALESCE()    -> returns first non-NULL value
    NULLIF()      -> returns NULL when two values are equal

IMPORTANT:
    NULL is not 0.
    NULL is not an empty string.
    Use IS NULL / IS NOT NULL for NULL comparisons.

===============================================================================
*/