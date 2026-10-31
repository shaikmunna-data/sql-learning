/*
===============================================================================
16. ADVANCED DATA ANALYSIS SQL
===============================================================================

DATABASE: EcommerceSQL
PURPOSE: Practice real-world analytical SQL problems.

Topics:
    1. Top N Records
    2. Top N Per Category
    3. Duplicate Detection
    4. Removing Duplicates
    5. Finding Missing Records
    6. Finding Consecutive Dates
    7. Month-over-Month Growth
    8. Year-over-Year Growth
    9. Running Totals
   10. Moving Averages
   11. Customer Retention
   12. Customer Segmentation
   13. Sales Analysis
   14. Employee Analysis

===============================================================================
SETUP
===============================================================================
*/

USE EcommerceSQL;
GO


/*
===============================================================================
1. TOP N RECORDS
===============================================================================

Problem:
Find the five most expensive products.

Concepts:
    TOP
    ORDER BY
*/

SELECT TOP 5
    product_id,
    product_name,
    category,
    price
FROM Products
ORDER BY price DESC;


/*
Find the three customers who placed the highest-value individual orders.
*/

SELECT TOP 3
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.total_amount
FROM Customers AS c
INNER JOIN Orders AS o
    ON c.customer_id = o.customer_id
ORDER BY o.total_amount DESC;


/*
===============================================================================
2. TOP N PER CATEGORY
===============================================================================

Problem:
Find the two most expensive products in each category.

Concept:
ROW_NUMBER() assigns a sequential number within each category.
PARTITION BY restarts numbering for every category.
*/

WITH RankedProducts AS
(
    SELECT
        product_id,
        product_name,
        category,
        price,
        ROW_NUMBER() OVER
        (
            PARTITION BY category
            ORDER BY price DESC, product_id
        ) AS row_num
    FROM Products
)
SELECT
    product_id,
    product_name,
    category,
    price
FROM RankedProducts
WHERE row_num <= 2
ORDER BY category, price DESC;


/*
INTERVIEW NOTE:
Use ROW_NUMBER() when you need exactly N rows per category, if enough rows
exist. Use RANK() or DENSE_RANK() when ties should affect the result.


===============================================================================
3. DUPLICATE DETECTION
===============================================================================

Problem:
Find email addresses used by more than one customer.

GROUP BY groups matching email addresses.
HAVING filters groups containing more than one row.
*/

SELECT
    email,
    COUNT(*) AS duplicate_count
FROM Customers
WHERE email IS NOT NULL
GROUP BY email
HAVING COUNT(*) > 1;


/*
Find duplicate customer names.

Note:
Customers can legitimately share a name. This query identifies repeated
names, not necessarily duplicate customer records.
*/

SELECT
    customer_name,
    COUNT(*) AS name_count
FROM Customers
GROUP BY customer_name
HAVING COUNT(*) > 1;


/*
===============================================================================
4. REMOVING DUPLICATES
===============================================================================

IMPORTANT:
Preview duplicate rows before deleting anything.

Example scenario:
A staging table named CustomerImport contains imported customer records.
Assume duplicate rows are identified by email and the lowest import_id
should be retained.

The following is an example pattern for a staging table. It does not run
unless CustomerImport exists with the stated columns.
*/

-- Preview duplicate records first.
-- SELECT *
-- FROM
-- (
--     SELECT
--         import_id,
--         email,
--         ROW_NUMBER() OVER
--         (
--             PARTITION BY email
--             ORDER BY import_id
--         ) AS row_num
--     FROM CustomerImport
--     WHERE email IS NOT NULL
-- ) AS d
-- WHERE row_num > 1;


/*
After verifying the preview, duplicates can be deleted from the staging table.

Run only after confirming the table, duplicate definition, and retained row.
*/

-- BEGIN TRANSACTION;
--
-- WITH RankedImports AS
-- (
--     SELECT
--         import_id,
--         ROW_NUMBER() OVER
--         (
--             PARTITION BY email
--             ORDER BY import_id
--         ) AS row_num
--     FROM CustomerImport
--     WHERE email IS NOT NULL
-- )
-- DELETE FROM RankedImports
-- WHERE row_num > 1;
--
-- SELECT * FROM CustomerImport;
--
-- COMMIT TRANSACTION;
-- Use ROLLBACK TRANSACTION instead of COMMIT if verification fails.


/*
IMPORTANT:
Do not delete records from Customers simply because names repeat.
Choose a reliable business key and verify which record should be retained.


===============================================================================
5. FINDING MISSING RECORDS
===============================================================================

Problem:
Find customers who have never placed an order.

LEFT JOIN keeps every customer.
Customers without a matching order have NULL in the Orders columns.
*/

SELECT
    c.customer_id,
    c.customer_name
FROM Customers AS c
LEFT JOIN Orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


/*
Alternative using NOT EXISTS.
*/

SELECT
    c.customer_id,
    c.customer_name
FROM Customers AS c
WHERE NOT EXISTS
(
    SELECT 1
    FROM Orders AS o
    WHERE o.customer_id = c.customer_id
);


/*
Problem:
Find products that have never appeared in any order item.
*/

SELECT
    p.product_id,
    p.product_name
FROM Products AS p
WHERE NOT EXISTS
(
    SELECT 1
    FROM OrderItems AS oi
    WHERE oi.product_id = p.product_id
);


/*
===============================================================================
6. FINDING CONSECUTIVE DATES
===============================================================================

Problem:
Find dates on which an employee's order count was greater than zero
for at least three consecutive calendar days.

First, create one row per order date.
Then compare each date with the date two rows later.

This finds three consecutive dates only when there are no gaps between
the dates in the ordered list.
*/

WITH OrderDates AS
(
    SELECT DISTINCT
        CAST(order_date AS DATE) AS order_date
    FROM Orders
),
DateGroups AS
(
    SELECT
        order_date,
        LEAD(order_date, 1) OVER
        (
            ORDER BY order_date
        ) AS next_date,
        LEAD(order_date, 2) OVER
        (
            ORDER BY order_date
        ) AS third_date
    FROM OrderDates
)
SELECT
    order_date AS first_date,
    next_date AS second_date,
    third_date AS third_date
FROM DateGroups
WHERE DATEDIFF(DAY, order_date, next_date) = 1
  AND DATEDIFF(DAY, next_date, third_date) = 1;

/*
===============================================================================
7. YEAR-OVER-YEAR (YoY) GROWTH
===============================================================================

Problem:
Calculate annual sales and percentage growth compared with the previous year.
*/

WITH YearlySales AS
(
    SELECT
        YEAR(order_date) AS sales_year,
        SUM(total_amount) AS annual_sales
    FROM Orders
    WHERE order_date IS NOT NULL
    GROUP BY YEAR(order_date)
),
YearlySalesWithPrevious AS
(
    SELECT
        sales_year,
        annual_sales,
        LAG(annual_sales) OVER
        (
            ORDER BY sales_year
        ) AS previous_year_sales
    FROM YearlySales
)
SELECT
    sales_year,
    annual_sales,
    previous_year_sales,
    CAST
    (
        (annual_sales - previous_year_sales) * 100.0
        / NULLIF(previous_year_sales, 0)
        AS DECIMAL(10, 2)
    ) AS yoy_growth_percentage
FROM YearlySalesWithPrevious
ORDER BY sales_year;


/*
NOTE:
If a calendar year is missing, LAG() compares with the previous available
year, not necessarily the immediately preceding calendar year.
For strict calendar-year comparisons, build a complete year calendar first.


===============================================================================
8. RUNNING TOTAL
===============================================================================

Problem:
Calculate cumulative sales over time.

SUM() OVER() calculates a running total without collapsing individual rows.
*/

SELECT
    order_id,
    order_date,
    total_amount,
    SUM(total_amount) OVER
    (
        ORDER BY order_date, order_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM Orders
ORDER BY order_date, order_id;


/*
===============================================================================
9. MOVING AVERAGE
===============================================================================

Problem:
Calculate the average sales amount across the current order and previous
two orders.

This is a three-row moving average, not a three-month moving average.
*/

SELECT
    order_id,
    order_date,
    total_amount,
    AVG(total_amount) OVER
    (
        ORDER BY order_date, order_id
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS three_order_moving_average
FROM Orders
ORDER BY order_date, order_id;


/*
For a three-month moving average, first aggregate sales by month and then
apply a window frame over the monthly results.


===============================================================================
10. CUSTOMER RETENTION
===============================================================================

Problem:
Identify customers who made a purchase in both a month and the immediately
following calendar month.

First, keep one row per customer per month.
*/

WITH CustomerMonths AS
(
    SELECT DISTINCT
        customer_id,
        DATEFROMPARTS
        (
            YEAR(order_date),
            MONTH(order_date),
            1
        ) AS order_month
    FROM Orders
    WHERE order_date IS NOT NULL
)
SELECT
    current_month.customer_id,
    current_month.order_month AS first_month,
    DATEADD(MONTH, 1, current_month.order_month) AS following_month
FROM CustomerMonths AS current_month
INNER JOIN CustomerMonths AS next_month
    ON current_month.customer_id = next_month.customer_id
   AND next_month.order_month = DATEADD
       (
           MONTH,
           1,
           current_month.order_month
       )
ORDER BY current_month.order_month, current_month.customer_id;


/*
This identifies customers active in consecutive months. It is not a complete
cohort-retention report, which also groups customers by their first purchase
month and measures how many return in later months.


===============================================================================
11. CUSTOMER SEGMENTATION
===============================================================================

Problem:
Segment customers by their total spending.

Example business rules:
    High Value:  Total spending >= 10000
    Medium Value: Total spending >= 5000 and < 10000
    Low Value:   Total spending < 5000
    No Orders:   No recorded orders

These thresholds are illustrative and should be chosen for the business.
*/

WITH CustomerSpending AS
(
    SELECT
        c.customer_id,
        c.customer_name,
        COALESCE(SUM(o.total_amount), 0) AS total_spending
    FROM Customers AS c
    LEFT JOIN Orders AS o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id,
        c.customer_name
)
SELECT
    customer_id,
    customer_name,
    total_spending,
    CASE
        WHEN total_spending = 0 THEN 'No Orders'
        WHEN total_spending >= 10000 THEN 'High Value'
        WHEN total_spending >= 5000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM CustomerSpending
ORDER BY total_spending DESC;


/*
===============================================================================
12. SALES ANALYSIS
===============================================================================

Problem:
Calculate sales by product category.

Join Orders, OrderItems, and Products to analyze product sales.
Use OrderItems.quantity * OrderItems.unit_price to calculate line-item sales.
*/

SELECT
    p.category,
    SUM(oi.quantity * oi.unit_price) AS category_sales,
    SUM(oi.quantity) AS units_sold,
    COUNT(DISTINCT oi.order_id) AS number_of_orders
FROM OrderItems AS oi
INNER JOIN Products AS p
    ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY category_sales DESC;


/*
Problem:
Find the top five customers by total order value.
*/

SELECT TOP 5
    c.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS total_spending,
    COUNT(o.order_id) AS total_orders
FROM Customers AS c
INNER JOIN Orders AS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_spending DESC;


/*
===============================================================================
13. EMPLOYEE ANALYSIS
===============================================================================

Problem:
Compare employee salaries with their department's average salary.
*/

SELECT
    employee_id,
    employee_name,
    department,
    salary,
    AVG(salary) OVER
    (
        PARTITION BY department
    ) AS department_average_salary,
    salary - AVG(salary) OVER
    (
        PARTITION BY department
    ) AS difference_from_department_average
FROM Employees
ORDER BY department, salary DESC;


/*
Problem:
Rank employees by salary within each department.
*/

SELECT
    employee_id,
    employee_name,
    department,
    salary,
    DENSE_RANK() OVER
    (
        PARTITION BY department
        ORDER BY salary DESC
    ) AS salary_rank
FROM Employees
ORDER BY department, salary_rank;


/*
Problem:
Calculate the number of orders handled by each employee.

LEFT JOIN includes employees who have not handled any orders.
*/

SELECT
    e.employee_id,
    e.employee_name,
    e.department,
    COUNT(o.order_id) AS total_orders_handled,
    COALESCE(SUM(o.total_amount), 0) AS total_order_value
FROM Employees AS e
LEFT JOIN Orders AS o
    ON e.employee_id = o.employee_id
GROUP BY
    e.employee_id,
    e.employee_name,
    e.department
ORDER BY total_order_value DESC;


/*
===============================================================================
QUICK REVISION
===============================================================================

TOP N RECORDS:
    TOP + ORDER BY

TOP N PER CATEGORY:
    ROW_NUMBER() or RANK() + PARTITION BY

DUPLICATE DETECTION:
    GROUP BY + HAVING COUNT(*) > 1

REMOVING DUPLICATES:
    ROW_NUMBER() + careful DELETE after preview

MISSING RECORDS:
    LEFT JOIN ... IS NULL or NOT EXISTS

CONSECUTIVE DATES:
    LEAD() or LAG() + DATEDIFF()

MONTH-OVER-MONTH GROWTH:
    Monthly aggregation + LAG()

YEAR-OVER-YEAR GROWTH:
    Annual aggregation + LAG()

RUNNING TOTAL:
    SUM() OVER (ORDER BY ... ROWS ...)

MOVING AVERAGE:
    AVG() OVER (ORDER BY ... ROWS ...)

CUSTOMER RETENTION:
    Compare customer activity across periods

CUSTOMER SEGMENTATION:
    Aggregate customer metrics + CASE

SALES ANALYSIS:
    JOIN + GROUP BY + aggregate functions

EMPLOYEE ANALYSIS:
    Window functions + GROUP BY + JOIN

===============================================================================
END OF ADVANCED DATA ANALYSIS SQL
===============================================================================
*/