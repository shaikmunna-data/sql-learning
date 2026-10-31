/*
===============================================================================
10 - CASE EXPRESSIONS
===============================================================================

DATABASE:
    EcommerceSQL

TOPICS:
    1. What is CASE?
    2. CASE Syntax
    3. WHEN
    4. THEN
    5. ELSE
    6. END
    7. Simple CASE
    8. Searched CASE
    9. CASE with Aggregate Functions
    10. CASE with GROUP BY
    11. CASE with ORDER BY
    12. Practical Data Analysis Examples
    13. Practice Questions
    14. Quick Revision

===============================================================================
*/


USE EcommerceSQL;
GO


/*
===============================================================================
1. WHAT IS CASE?
===============================================================================

CASE is a SQL expression used to apply conditional logic.

It is similar to:

    if
    elif
    else

in programming languages.

CASE allows us to create:

    Categories
    Labels
    Flags
    Business rules
    Conditional calculations

Example:

    If price >= 50000
        -> 'Expensive'

    Otherwise
        -> 'Affordable'


===============================================================================
2. BASIC CASE SYNTAX
===============================================================================

Searched CASE syntax:

    CASE
        WHEN condition THEN result
        WHEN condition THEN result
        ELSE result
    END


Important keywords:

    CASE  -> starts the expression

    WHEN  -> specifies a condition

    THEN  -> specifies the result when the condition is true

    ELSE  -> specifies the result when no condition is true

    END   -> ends the CASE expression


===============================================================================
3. SIMPLE CASE
===============================================================================

Simple CASE compares one expression with multiple values.

Syntax:

    CASE expression
        WHEN value1 THEN result1
        WHEN value2 THEN result2
        ELSE result
    END


Example:
*/


SELECT
    customer_name,
    customer_status,
    CASE customer_status
        WHEN 'Active' THEN 'Currently Active'
        WHEN 'Inactive' THEN 'Currently Inactive'
        ELSE 'Unknown Status'
    END AS status_description
FROM Customers;


/*
Here:

    CASE customer_status

compares customer_status with:

    'Active'
    'Inactive'

This is called a SIMPLE CASE.
*/


/*
===============================================================================
4. SIMPLE CASE WITH ORDER STATUS
===============================================================================
*/

SELECT
    order_id,
    order_status,
    CASE order_status
        WHEN 'Delivered' THEN 'Completed Order'
        WHEN 'Pending' THEN 'Waiting for Delivery'
        WHEN 'Cancelled' THEN 'Order Cancelled'
        ELSE 'Other'
    END AS order_description
FROM Orders;


/*
===============================================================================
5. SEARCHED CASE
===============================================================================

Searched CASE evaluates conditions.

Syntax:

    CASE
        WHEN condition1 THEN result1
        WHEN condition2 THEN result2
        ELSE result
    END

Unlike Simple CASE, it does NOT compare one expression
against specific values.

Instead, each WHEN contains a condition.

This is the most commonly used form of CASE in data analysis.
*/


/*
Example:
Categorize products based on price.
*/

SELECT
    product_name,
    price,
    CASE
        WHEN price >= 50000 THEN 'High'
        WHEN price >= 10000 THEN 'Medium'
        ELSE 'Low'
    END AS price_category
FROM Products;


/*
The conditions are evaluated from TOP to BOTTOM.

For example:

    price = 65000

First condition:

    price >= 50000
        TRUE

Result:

    High

SQL does not continue checking the remaining WHEN conditions.
*/


/*
===============================================================================
6. CASE WITH MULTIPLE CONDITIONS
===============================================================================
*/


/*
Categorize orders based on their total amount.
*/

SELECT
    order_id,
    total_amount,
    CASE
        WHEN total_amount >= 50000 THEN 'Large Order'
        WHEN total_amount >= 20000 THEN 'Medium Order'
        ELSE 'Small Order'
    END AS order_category
FROM Orders;


/*
===============================================================================
7. CASE WITH AND
===============================================================================

CASE conditions can contain logical operators.
*/


SELECT
    order_id,
    order_status,
    total_amount,
    CASE
        WHEN order_status = 'Delivered'
             AND total_amount >= 20000
            THEN 'High Value Delivered'

        WHEN order_status = 'Delivered'
            THEN 'Standard Delivered'

        WHEN order_status = 'Pending'
            THEN 'Pending Order'

        ELSE 'Other'
    END AS order_category
FROM Orders;


/*
===============================================================================
8. CASE WITH OR
===============================================================================
*/


SELECT
    customer_name,
    city,
    CASE
        WHEN city = 'Hyderabad'
             OR city = 'Bengaluru'
            THEN 'Major Tech City'

        ELSE 'Other City'
    END AS city_category
FROM Customers;


/*
===============================================================================
9. CASE WITH NULL
===============================================================================

CASE can also check NULL values.

Use:

    IS NULL
    IS NOT NULL

Do NOT use:

    = NULL
*/


/*
Example:
*/

SELECT
    customer_name,
    email,
    CASE
        WHEN email IS NULL THEN 'Email Missing'
        ELSE 'Email Available'
    END AS email_status
FROM Customers;


/*
Another example:
*/

SELECT
    product_name,
    supplier,
    CASE
        WHEN supplier IS NULL THEN 'Supplier Missing'
        ELSE 'Supplier Available'
    END AS supplier_status
FROM Products;


/*
===============================================================================
10. CASE WITH CALCULATIONS
===============================================================================

CASE can return calculated values.
*/


/*
Apply different discounts based on product price.

This example only calculates a discount amount;
it does not modify the actual Products table.
*/

SELECT
    product_name,
    price,
    CASE
        WHEN price >= 50000 THEN price * 0.10
        WHEN price >= 20000 THEN price * 0.05
        ELSE 0
    END AS discount_amount
FROM Products;


/*
Calculate the final price after discount.
*/

SELECT
    product_name,
    price,
    CASE
        WHEN price >= 50000 THEN price * 0.90
        WHEN price >= 20000 THEN price * 0.95
        ELSE price
    END AS final_price
FROM Products;


/*
===============================================================================
11. CASE WITH AGGREGATE FUNCTIONS
===============================================================================

CASE can be used inside aggregate functions.

This is extremely useful for data analysis.

Example:

Count delivered orders.
*/

SELECT
    SUM(
        CASE
            WHEN order_status = 'Delivered' THEN 1
            ELSE 0
        END
    ) AS delivered_orders
FROM Orders;


/*
Count pending orders.
*/

SELECT
    SUM(
        CASE
            WHEN order_status = 'Pending' THEN 1
            ELSE 0
        END
    ) AS pending_orders
FROM Orders;


/*
Count cancelled orders.
*/

SELECT
    SUM(
        CASE
            WHEN order_status = 'Cancelled' THEN 1
            ELSE 0
        END
    ) AS cancelled_orders
FROM Orders;


/*
Get all three in one query.
*/

SELECT
    SUM(CASE
            WHEN order_status = 'Delivered' THEN 1
            ELSE 0
        END) AS delivered_orders,

    SUM(CASE
            WHEN order_status = 'Pending' THEN 1
            ELSE 0
        END) AS pending_orders,

    SUM(CASE
            WHEN order_status = 'Cancelled' THEN 1
            ELSE 0
        END) AS cancelled_orders
FROM Orders;

/*
===============================================================================
12. CONDITIONAL SALES USING CASE
===============================================================================

Calculate sales only for delivered orders.
*/


SELECT
    SUM(
        CASE
            WHEN order_status = 'Delivered'
            THEN total_amount
            ELSE 0
        END
    ) AS delivered_sales
FROM Orders;


/*
Calculate sales for each order status in one result.
*/

SELECT
    SUM(CASE
            WHEN order_status = 'Delivered'
            THEN total_amount
            ELSE 0
        END) AS delivered_sales,

    SUM(CASE
            WHEN order_status = 'Pending'
            THEN total_amount
            ELSE 0
        END) AS pending_sales,

    SUM(CASE
            WHEN order_status = 'Cancelled'
            THEN total_amount
            ELSE 0
        END) AS cancelled_sales
FROM Orders;




/*
===============================================================================
13. CASE WITH GROUP BY
===============================================================================

CASE can create a category and then that category can be used
for grouping.

Example:
*/


SELECT
    CASE
        WHEN price >= 50000 THEN 'High'
        WHEN price >= 10000 THEN 'Medium'
        ELSE 'Low'
    END AS price_category,

    COUNT(*) AS product_count
FROM Products
GROUP BY
    CASE
        WHEN price >= 50000 THEN 'High'
        WHEN price >= 10000 THEN 'Medium'
        ELSE 'Low'
    END;

/*
This groups products into:

    High
    Medium
    Low
*/


/*
===============================================================================
14. CASE WITH ORDER BY
===============================================================================

CASE can also control sorting.

Example:

Show Pending orders first, then Delivered, then Cancelled.
*/


SELECT
    order_id,
    order_status,
    total_amount
FROM Orders
ORDER BY
    CASE order_status
        WHEN 'Pending' THEN 1
        WHEN 'Delivered' THEN 2
        WHEN 'Cancelled' THEN 3
        ELSE 4
    END;


/*
This is useful when business priority is different from
normal alphabetical sorting.
*/


/*
===============================================================================
15. SIMPLE CASE VS SEARCHED CASE
===============================================================================

SIMPLE CASE
-----------

Compares one expression against specific values.

Example:

    CASE customer_status
        WHEN 'Active' THEN 'A'
        WHEN 'Inactive' THEN 'I'
        ELSE 'Unknown'
    END


SEARCHED CASE
-------------

Evaluates conditions.

Example:

    CASE
        WHEN price >= 50000 THEN 'High'
        WHEN price >= 10000 THEN 'Medium'
        ELSE 'Low'
    END


Main difference:

    SIMPLE CASE
        Compare one expression with values.

    SEARCHED CASE
        Evaluate conditions.


===============================================================================
16. CASE EVALUATION ORDER
===============================================================================

WHEN conditions are checked from top to bottom.

The first TRUE condition is used.

Example:

    CASE
        WHEN price >= 10000 THEN 'Medium'
        WHEN price >= 50000 THEN 'High'
        ELSE 'Low'
    END

This is WRONG for the intended categories.

Why?

A price of 65000 satisfies:

    price >= 10000

So it will immediately return:

    Medium

Correct order:

    CASE
        WHEN price >= 50000 THEN 'High'
        WHEN price >= 10000 THEN 'Medium'
        ELSE 'Low'
    END


IMPORTANT:

Put more specific / higher-priority conditions first.
*/


/*
===============================================================================
17. PRACTICAL DATA ANALYSIS EXAMPLES
===============================================================================
*/


/*
-------------------------------------------------------------------------------
17.1 Product price classification
-------------------------------------------------------------------------------
*/

SELECT
    product_name,
    price,
    CASE
        WHEN price >= 50000 THEN 'Premium'
        WHEN price >= 10000 THEN 'Standard'
        ELSE 'Budget'
    END AS product_segment
FROM Products;


/*
-------------------------------------------------------------------------------
17.2 Customer status label
-------------------------------------------------------------------------------
*/

SELECT
    customer_name,
    customer_status,
    CASE customer_status
        WHEN 'Active' THEN 'Customer'
        WHEN 'Inactive' THEN 'Inactive Customer'
        ELSE 'Unknown'
    END AS customer_category
FROM Customers;


/*
-------------------------------------------------------------------------------
17.3 Order value classification
-------------------------------------------------------------------------------
*/

SELECT
    order_id,
    total_amount,
    CASE
        WHEN total_amount >= 50000 THEN 'High Value'
        WHEN total_amount >= 20000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS order_value_category
FROM Orders;


/*
-------------------------------------------------------------------------------
17.4 Delivery status
-------------------------------------------------------------------------------
*/

SELECT
    order_id,
    order_status,
    shipping_date,
    CASE
        WHEN order_status = 'Cancelled'
            THEN 'Cancelled'

        WHEN shipping_date IS NULL
            THEN 'Not Shipped'

        ELSE 'Shipped'
    END AS delivery_status
FROM Orders;


/*
-------------------------------------------------------------------------------
17.5 Customer email availability
-------------------------------------------------------------------------------
*/

SELECT
    customer_name,
    CASE
        WHEN email IS NULL THEN 'Missing'
        ELSE 'Available'
    END AS email_status
FROM Customers;


/*
===============================================================================
18. CASE WITH DATES
===============================================================================

CASE can be combined with date functions.

Example:
Classify orders by quarter.
*/


SELECT
    order_id,
    order_date,
    CASE
        WHEN MONTH(order_date) BETWEEN 1 AND 3 THEN 'Q1'
        WHEN MONTH(order_date) BETWEEN 4 AND 6 THEN 'Q2'
        WHEN MONTH(order_date) BETWEEN 7 AND 9 THEN 'Q3'
        WHEN MONTH(order_date) BETWEEN 10 AND 12 THEN 'Q4'
    END AS order_quarter
FROM Orders;


/*
===============================================================================
19. PRACTICE QUESTIONS
===============================================================================

BASIC CASE
----------

1. Display customer status as:

       Active    -> 'Active Customer'
       Inactive  -> 'Inactive Customer'


2. Display order status as:

       Delivered -> 'Completed'
       Pending   -> 'In Progress'
       Cancelled -> 'Cancelled'


SIMPLE CASE
-----------

3. Use Simple CASE to classify customer_status.

4. Use Simple CASE to classify order_status.


SEARCHED CASE
-------------

5. Categorize products:

       price >= 50000 -> 'High'
       price >= 10000 -> 'Medium'
       otherwise      -> 'Low'


6. Categorize orders:

       total_amount >= 50000 -> 'High Value'
       total_amount >= 20000 -> 'Medium Value'
       otherwise             -> 'Low Value'


7. Categorize customers based on their city:

       Hyderabad/Bengaluru -> 'Major City'
       otherwise           -> 'Other City'


CASE + NULL
-----------

8. Create an email status:

       NULL     -> 'Missing'
       NOT NULL -> 'Available'


9. Create a supplier status:

       NULL     -> 'Missing'
       NOT NULL -> 'Available'


CASE + CALCULATIONS
-------------------

10. Apply a 10% discount to products priced at 50,000 or more.

11. Apply a 5% discount to products priced between 20,000 and 49,999.

12. Calculate final price after discount.


CASE + AGGREGATES
-----------------

13. Count delivered orders using CASE.

14. Count pending orders using CASE.

15. Count cancelled orders using CASE.

16. Calculate delivered sales using CASE.

17. Calculate delivered, pending, and cancelled sales
    in one query.


CASE + GROUP BY
---------------

18. Group products into High, Medium, and Low price categories
    and count products in each category.


CASE + ORDER BY
---------------

19. Display Pending orders first, Delivered second,
    and Cancelled last.


DATA ANALYSIS
-------------

20. Create a product segmentation:

       price >= 50000 -> Premium
       price >= 20000 -> Standard
       otherwise      -> Budget


21. Create an order segmentation:

       >= 50000 -> High Value
       >= 20000 -> Medium Value
       otherwise -> Low Value


22. Create a delivery status:

       Cancelled order -> Cancelled
       No shipping date -> Not Shipped
       Otherwise        -> Shipped


23. Classify orders into Q1, Q2, Q3, and Q4 based on order_date.


===============================================================================
20. QUICK REVISION
===============================================================================

CASE
    Starts a conditional expression.

WHEN
    Specifies a condition/value to check.

THEN
    Specifies the result when the condition is true.

ELSE
    Specifies the result when no WHEN condition is true.

END
    Ends the CASE expression.


SIMPLE CASE
    Compares one expression against specific values.

Example:

    CASE customer_status
        WHEN 'Active' THEN 'A'
        WHEN 'Inactive' THEN 'I'
        ELSE 'Unknown'
    END


SEARCHED CASE
    Evaluates conditions.

Example:

    CASE
        WHEN price >= 50000 THEN 'High'
        WHEN price >= 10000 THEN 'Medium'
        ELSE 'Low'
    END


IMPORTANT RULE:

    CASE checks WHEN conditions from top to bottom.

    The first TRUE condition wins.


CASE IS USEFUL FOR:

    Categories
    Segmentation
    Flags
    Business rules
    Conditional calculations
    Conditional aggregation
    Custom sorting


COMMON DATA ANALYSIS PATTERN:

    SUM(
        CASE
            WHEN condition THEN value
            ELSE 0
        END
    )


Example:

    SELECT
        SUM(
            CASE
                WHEN order_status = 'Delivered'
                THEN total_amount
                ELSE 0
            END
        ) AS delivered_sales
    FROM Orders;


===============================================================================
*/