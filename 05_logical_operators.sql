/*
===============================================================================
                         05 - LOGICAL OPERATORS
===============================================================================

Logical operators are used to combine or modify multiple conditions.

Topics:
1. AND
2. OR
3. NOT
4. Operator Precedence
5. Combining Multiple Conditions
===============================================================================
*/


/*
===============================================================================
1. AND
===============================================================================

AND returns a row only when ALL conditions are TRUE.

Syntax:

WHERE condition1
  AND condition2;


Example:
Find Electronics products costing more than 20,000.
*/

SELECT
    product_name,
    category,
    price
FROM Products
WHERE category = 'Electronics'
  AND price > 20000;


/*
Both conditions must be TRUE:

category = 'Electronics'
AND
price > 20000
*/


/*
Example:
Find active customers from Hyderabad.
*/

SELECT
    customer_name,
    city,
    customer_status
FROM Customers
WHERE city = 'Hyderabad'
  AND customer_status = 'Active';


/*
Example with three conditions:
*/

SELECT
    product_name,
    category,
    price,
    stock_quantity
FROM Products
WHERE category = 'Electronics'
  AND price > 10000
  AND stock_quantity > 10;


/*
All three conditions must be TRUE.
*/


/*
===============================================================================
2. OR
===============================================================================

OR returns a row when AT LEAST ONE condition is TRUE.

Syntax:

WHERE condition1
   OR condition2;


Example:
Find customers from Hyderabad or Chennai.
*/

SELECT
    customer_name,
    city
FROM Customers
WHERE city = 'Hyderabad'
   OR city = 'Chennai';


/*
Example:
Find products that are either Electronics or Furniture.
*/

SELECT
    product_name,
    category,
    price
FROM Products
WHERE category = 'Electronics'
   OR category = 'Furniture';


/*
OR can be used with different types of conditions.
*/

SELECT
    product_name,
    price
FROM Products
WHERE price > 50000
   OR stock_quantity < 10;


/*
A row is returned if either condition is TRUE.
*/


/*
===============================================================================
3. NOT
===============================================================================

NOT reverses the result of a condition.

TRUE  -> FALSE
FALSE -> TRUE


Syntax:

WHERE NOT condition;


Example:
Find customers who are NOT from Hyderabad.
*/

SELECT
    customer_name,
    city
FROM Customers
WHERE NOT city = 'Hyderabad';


/*
The following is also commonly used:

WHERE city <> 'Hyderabad'
*/


/*
Example:
Find products that are NOT in the Electronics category.
*/

SELECT
    product_name,
    category
FROM Products
WHERE NOT category = 'Electronics';


/*
NOT can also be used with IN.
*/

SELECT
    customer_name,
    city
FROM Customers
WHERE city NOT IN ('Hyderabad', 'Chennai');


/*
NOT can be used with LIKE.
*/

SELECT
    customer_name
FROM Customers
WHERE customer_name NOT LIKE 'A%';


/*
===============================================================================
4. OPERATOR PRECEDENCE
===============================================================================

When SQL evaluates multiple operators, it follows a specific order.

For the conditions we are learning, an important order is:

1. NOT
2. AND
3. OR


Example:

condition1 OR condition2 AND condition3

SQL evaluates:

condition2 AND condition3

first, then:

condition1 OR result


Example:
*/

SELECT
    product_name,
    category,
    price
FROM Products
WHERE category = 'Electronics'
   OR category = 'Furniture'
  AND price > 10000;


/*
This is evaluated as:

category = 'Electronics'
OR
(
    category = 'Furniture'
    AND price > 10000
)


It does NOT mean:

(
    category = 'Electronics'
    OR
    category = 'Furniture'
)
AND price > 10000


Use parentheses when you want to make the logic explicit.
*/


/*
===============================================================================
5. USING PARENTHESES
===============================================================================

Parentheses allow us to control the order of evaluation.

Example:

Find products that are either:

- Electronics OR Furniture

AND

- cost more than 10,000
*/

SELECT
    product_name,
    category,
    price
FROM Products
WHERE
    (category = 'Electronics' OR category = 'Furniture')
    AND price > 10000;


/*
Without parentheses, the result can be different because
AND is evaluated before OR.
*/


/*
Another example:

Find customers who are from Hyderabad or Chennai
and are Active.
*/

SELECT
    customer_name,
    city,
    customer_status
FROM Customers
WHERE
    (city = 'Hyderabad' OR city = 'Chennai')
    AND customer_status = 'Active';


/*
===============================================================================
6. COMBINING MULTIPLE CONDITIONS
===============================================================================

AND, OR, and NOT can be combined to create more complex filters.


Example 1:
Find Electronics products costing more than 20,000
and having more than 10 units in stock.
*/

SELECT
    product_name,
    category,
    price,
    stock_quantity
FROM Products
WHERE category = 'Electronics'
  AND price > 20000
  AND stock_quantity > 10;


/*
Example 2:
Find customers who are from Hyderabad or Chennai
and are Active.
*/

SELECT
    customer_name,
    city,
    customer_status
FROM Customers
WHERE
    (city = 'Hyderabad' OR city = 'Chennai')
    AND customer_status = 'Active';


/*
Example 3:
Find products that are either Accessories or Furniture
and cost less than 10,000.
*/

SELECT
    product_name,
    category,
    price
FROM Products
WHERE
    (category = 'Accessories' OR category = 'Furniture')
    AND price < 10000;


/*
Example 4:
Find orders that are Delivered and paid using UPI
or Credit Card.
*/

SELECT
    order_id,
    order_status,
    payment_method,
    total_amount
FROM Orders
WHERE
    order_status = 'Delivered'
    AND
    (payment_method = 'UPI' OR payment_method = 'Credit Card');


/*
Example 5:
Find products that are NOT Electronics
and have stock greater than 20.
*/

SELECT
    product_name,
    category,
    stock_quantity
FROM Products
WHERE
    NOT category = 'Electronics'
    AND stock_quantity > 20;


/*
===============================================================================
AND vs OR
===============================================================================

AND:

condition1 AND condition2

Both conditions must be TRUE.


OR:

condition1 OR condition2

At least one condition must be TRUE.


NOT:

NOT condition

Reverses the condition.


===============================================================================
OPERATOR PRECEDENCE
===============================================================================

When using:

NOT
AND
OR

SQL evaluates them in this order:

        NOT
         ?
        AND
         ?
         OR


Example:

A OR B AND C

is evaluated as:

A OR (B AND C)


If you want:

(A OR B) AND C

use parentheses explicitly.


===============================================================================
PRACTICE QUESTIONS
===============================================================================

Try solving these yourself.

1. Find active customers from Hyderabad.

2. Find active customers from Hyderabad or Chennai.

3. Find Electronics products costing more than 25,000.

4. Find products that are Electronics or Accessories.

5. Find products that are Electronics or Accessories
   and cost less than 20,000.

6. Find customers who are NOT from Hyderabad.

7. Find products that are NOT Electronics
   and have stock greater than 20.

8. Find Delivered orders paid using UPI.

9. Find Delivered orders paid using UPI or Credit Card.

10. Find Delivered orders with an amount greater than 20,000.

11. Find customers who are from Hyderabad or Mumbai
    and are Active.

12. Find products that are either:
       - Electronics costing more than 20,000
       OR
       - Furniture costing less than 10,000

13. Find products that are NOT Electronics
    and cost between 1,000 and 10,000.


===============================================================================
QUICK REVISION
===============================================================================

AND
-> All conditions must be TRUE.


OR
-> At least one condition must be TRUE.


NOT
-> Reverses a condition.


Operator precedence:

NOT
 ?
AND
 ?
OR


Use parentheses:

(condition1 OR condition2)
AND condition3


This makes complex conditions easier to understand
and prevents logical mistakes.

===============================================================================
*/