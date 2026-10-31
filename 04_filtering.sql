/*
===============================================================================
                         04 - FILTERING DATA
===============================================================================

Filtering is used to return only the rows that meet a condition.

Main command:

WHERE

Topics:
1. WHERE
2. Comparison Operators
3. BETWEEN
4. IN
5. NOT IN
6. LIKE
7. NOT LIKE
8. IS NULL
9. IS NOT NULL
===============================================================================
*/


/*
===============================================================================
1. WHERE
===============================================================================

WHERE filters rows based on a condition.

Syntax:

SELECT columns
FROM table
WHERE condition;


Example:
*/

SELECT *
FROM Customers
WHERE city = 'Hyderabad';


/*
Get active customers.
*/

SELECT
    customer_id,
    customer_name,
    customer_status
FROM Customers
WHERE customer_status = 'Active';


/*
===============================================================================
2. COMPARISON OPERATORS
===============================================================================

Comparison operators compare two values.

=       Equal to
<>      Not equal to
>       Greater than
<       Less than
>=      Greater than or equal to
<=      Less than or equal to
*/


/*
------------------------------------------------------------------------------
= EQUAL TO
------------------------------------------------------------------------------
*/

SELECT *
FROM Products
WHERE category = 'Electronics';


/*
------------------------------------------------------------------------------
<> NOT EQUAL TO
------------------------------------------------------------------------------
*/

SELECT *
FROM Products
WHERE category <> 'Electronics';


/*
------------------------------------------------------------------------------
> GREATER THAN
------------------------------------------------------------------------------
*/

SELECT
    product_name,
    price
FROM Products
WHERE price > 20000;


/*
------------------------------------------------------------------------------
< LESS THAN
------------------------------------------------------------------------------
*/

SELECT
    product_name,
    price
FROM Products
WHERE price < 5000;


/*
------------------------------------------------------------------------------
>= GREATER THAN OR EQUAL TO
------------------------------------------------------------------------------
*/

SELECT
    product_name,
    price
FROM Products
WHERE price >= 25000;


/*
------------------------------------------------------------------------------
<= LESS THAN OR EQUAL TO
------------------------------------------------------------------------------
*/

SELECT
    product_name,
    price
FROM Products
WHERE price <= 2500;


/*
===============================================================================
3. BETWEEN
===============================================================================

BETWEEN checks whether a value is within a range.

Syntax:

WHERE column BETWEEN lower_value AND upper_value

BETWEEN is inclusive.

Example:
*/

SELECT
    product_name,
    price
FROM Products
WHERE price BETWEEN 5000 AND 20000;


/*
Equivalent to:

WHERE price >= 5000
AND price <= 20000
*/


/*
BETWEEN can also be used with dates.

Example:
*/

SELECT *
FROM Orders
WHERE order_date BETWEEN '2024-03-01' AND '2024-06-30';


/*
===============================================================================
4. IN
===============================================================================

IN checks whether a value matches any value in a list.

Instead of writing:

WHERE city = 'Hyderabad'
   OR city = 'Chennai'
   OR city = 'Mumbai'

We can write:

WHERE city IN ('Hyderabad', 'Chennai', 'Mumbai')


Example:
*/

SELECT
    customer_name,
    city
FROM Customers
WHERE city IN ('Hyderabad', 'Chennai', 'Mumbai');


/*
Another example:
*/

SELECT
    product_name,
    category
FROM Products
WHERE category IN ('Electronics', 'Furniture');


/*
===============================================================================
5. NOT IN
===============================================================================

NOT IN returns rows whose value does not match
any value in the specified list.

Example:
*/

SELECT
    customer_name,
    city
FROM Customers
WHERE city NOT IN ('Hyderabad', 'Chennai');


/*
Another example:
*/

SELECT
    product_name,
    category
FROM Products
WHERE category NOT IN ('Electronics');


/*
===============================================================================
6. LIKE
===============================================================================

LIKE is used for pattern matching.

Common wildcards:

%  -> Zero or more characters

_  -> Exactly one character


Example:

Names starting with 'A'
*/

SELECT
    customer_name
FROM Customers
WHERE customer_name LIKE 'A%';


/*
Names ending with 'a'
*/

SELECT
    customer_name
FROM Customers
WHERE customer_name LIKE '%a';


/*
Names containing 'an'
*/

SELECT
    customer_name
FROM Customers
WHERE customer_name LIKE '%an%';


/*
Names with exactly 5 characters.

_ represents one character.
*/

SELECT
    customer_name
FROM Customers
WHERE customer_name LIKE '_____';


/*
Product names starting with 'M'
*/

SELECT
    product_name
FROM Products
WHERE product_name LIKE 'M%';


/*
===============================================================================
7. NOT LIKE
===============================================================================

NOT LIKE returns rows that do NOT match a pattern.

Example:
*/

SELECT
    customer_name
FROM Customers
WHERE customer_name NOT LIKE 'A%';


/*
Products that do not contain the word 'phone'.
*/

SELECT
    product_name
FROM Products
WHERE product_name NOT LIKE '%phone%';


/*
===============================================================================
8. IS NULL
===============================================================================

NULL represents a missing or unknown value.

We cannot use:

WHERE email = NULL

Instead, use:

IS NULL


Example:
*/

SELECT
    customer_id,
    customer_name,
    email
FROM Customers
WHERE email IS NULL;


/*
Find employees who do not have a manager.
*/

SELECT
    employee_id,
    employee_name,
    manager_id
FROM Employees
WHERE manager_id IS NULL;


/*
Find orders that have not been shipped.
*/

SELECT
    order_id,
    order_date,
    shipping_date,
    order_status
FROM Orders
WHERE shipping_date IS NULL;


/*
Find products without supplier information.
*/

SELECT
    product_id,
    product_name,
    supplier
FROM Products
WHERE supplier IS NULL;


/*
===============================================================================
9. IS NOT NULL
===============================================================================

IS NOT NULL returns rows where the value exists.

Example:
*/

SELECT
    customer_id,
    customer_name,
    email
FROM Customers
WHERE email IS NOT NULL;


/*
Employees who have a manager.
*/

SELECT
    employee_id,
    employee_name,
    manager_id
FROM Employees
WHERE manager_id IS NOT NULL;


/*
Orders that have been shipped.
*/

SELECT
    order_id,
    order_date,
    shipping_date
FROM Orders
WHERE shipping_date IS NOT NULL;


/*
===============================================================================
COMBINING FILTER CONDITIONS
===============================================================================

Multiple conditions can be combined using:

AND
OR
NOT

These will be studied in detail with logical operators.

Example:
*/

SELECT
    product_name,
    category,
    price
FROM Products
WHERE category = 'Electronics'
  AND price > 20000;


/*
Example using OR:
*/

SELECT
    customer_name,
    city
FROM Customers
WHERE city = 'Hyderabad'
   OR city = 'Chennai';


/*
===============================================================================
PRACTICE QUESTIONS
===============================================================================

Try solving these yourself.

1. Find all customers from Hyderabad.

2. Find all customers from Maharashtra.

3. Find products costing more than 20,000.

4. Find products costing less than 5,000.

5. Find products costing 10,000 or more.

6. Find products with price between 5,000 and 25,000.

7. Find orders placed between March 1 and June 30, 2024.

8. Find customers from Hyderabad, Chennai, or Mumbai.

9. Find customers who are NOT from Hyderabad or Chennai.

10. Find customers whose names start with 'R'.

11. Find customers whose names end with 'a'.

12. Find products whose names contain 'o'.

13. Find products whose names do NOT contain 'o'.

14. Find customers whose email is NULL.

15. Find customers whose email is NOT NULL.

16. Find employees who do not have a manager.

17. Find orders that have not been shipped.

18. Find products that do not have a supplier.


===============================================================================
QUICK REVISION
===============================================================================

WHERE
-> Filters rows based on a condition.


COMPARISON OPERATORS

=      -> Equal
<>     -> Not equal
>      -> Greater than
<      -> Less than
>=     -> Greater than or equal
<=     -> Less than or equal


BETWEEN
-> Checks whether a value is within a range.
-> Includes both boundaries.


IN
-> Matches any value from a list.


NOT IN
-> Excludes values from a list.


LIKE
-> Pattern matching.

% -> Zero or more characters
_ -> Exactly one character


NOT LIKE
-> Excludes a pattern.


IS NULL
-> Finds missing/NULL values.


IS NOT NULL
-> Finds non-NULL values.


===============================================================================
IMPORTANT
===============================================================================

Correct:

WHERE email IS NULL

Incorrect:

WHERE email = NULL


Correct:

WHERE email IS NOT NULL

Incorrect:

WHERE email <> NULL

===============================================================================
*/