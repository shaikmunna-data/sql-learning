/*
===============================================================================
15. WINDOW FUNCTIONS
===============================================================================

DATABASE: EcommerceSQL
PURPOSE: Learn SQL Server window functions with practical examples.

TOPICS
------
1. What Is a Window Function?
2. Window Basics
3. OVER() Clause
4. PARTITION BY Clause
5. ORDER BY Clause
6. Window FRAME Clause
7. Window Function Rules
8. Window Functions with GROUP BY
9. Ranking Functions
10. Value Functions
11. Aggregate Window Functions
12. Running Total
13. Moving Average
14. Previous and Next Row Comparison
15. Top N Per Group
16. Percentage of Total
17. Practice Questions
18. Quick Revision

===============================================================================
1. WHAT IS A WINDOW FUNCTION?
===============================================================================

A window function performs a calculation across a set of related rows without
collapsing those rows into a single row.

It allows us to display individual records alongside calculated values.

Common uses:
- Ranking employees by salary.
- Calculating department salary averages.
- Calculating running totals.
- Comparing current and previous orders.
- Finding the top N employees in each department.
- Calculating each order's percentage of total sales.

Unlike GROUP BY, window functions normally preserve the detail rows.

===============================================================================
2. WINDOW BASICS
===============================================================================

A window is the set of rows used by a window function to calculate its result.

A window can include:
- All rows returned by the query.
- Rows belonging to the same partition.
- Rows arranged according to a specified order.
- A specific frame of rows around the current row.

General syntax:

    window_function() OVER
    (
        PARTITION BY column_name
        ORDER BY column_name
        ROWS BETWEEN ... AND ...
    )

PARTITION BY and ORDER BY are optional for many window functions.
The frame clause is optional and is supported only for applicable functions.

===============================================================================
3. OVER() CLAUSE
===============================================================================

OVER() defines the window used by the function.

OVER() with no PARTITION BY or ORDER BY applies an aggregate calculation
across all rows in the query result.

Example 1: Show every employee with the total salary of all employees.
*/

USE EcommerceSQL;
GO

SELECT
    employee_id,
    employee_name,
    department,
    salary,
    SUM(salary) OVER () AS total_salary
FROM Employees
ORDER BY employee_id;
GO

/*
Explanation:
- SUM(salary) calculates the total salary.
- OVER() calculates it across all employees returned by the query.
- Every employee remains a separate row.

===============================================================================
4. PARTITION BY CLAUSE
===============================================================================

PARTITION BY divides rows into separate groups called partitions.

The window function calculates a result independently for each partition.

Unlike GROUP BY, PARTITION BY does not normally collapse each group into one row.

Example 2: Show each employee and their department's total salary.
*/

SELECT
    employee_id,
    employee_name,
    department,
    salary,
    SUM(salary) OVER (
        PARTITION BY department
    ) AS department_total_salary
FROM Employees
ORDER BY department, employee_id;
GO

/*
Explanation:
- Employees are separated by department.
- Each department receives its own salary total.
- Individual employee rows remain visible.

===============================================================================
5. ORDER BY CLAUSE INSIDE OVER()
===============================================================================

ORDER BY inside OVER() defines the logical ordering used by the window function.

It is different from the final ORDER BY clause:
- ORDER BY inside OVER() controls calculation order.
- Final ORDER BY controls the order of displayed rows.

For ranking functions, ORDER BY determines the ranking.
For running calculations, ORDER BY determines how rows accumulate.

Use a unique tie-breaker when the order of individual rows must be deterministic.

Example 3: Assign employee numbers by descending salary.
*/

SELECT
    employee_id,
    employee_name,
    department,
    salary,
    ROW_NUMBER() OVER (
        ORDER BY salary DESC, employee_id
    ) AS employee_number
FROM Employees
ORDER BY salary DESC, employee_id;
GO

/*
===============================================================================
6. WINDOW FRAME CLAUSE
===============================================================================

A window frame defines which rows within the ordered partition participate
in the calculation for the current row.

Common frame boundaries:

UNBOUNDED PRECEDING
-------------------
    Starts at the first row of the partition.

n PRECEDING
-------------------
    Includes a row n positions before the current row.

CURRENT ROW
-------------------
    Refers to the current row or its peer group, depending on the frame type.

n FOLLOWING
-------------------
    Includes a row n positions after the current row.

UNBOUNDED FOLLOWING
-------------------
    Ends at the last row of the partition.

ROWS
------
Uses physical row positions in the ordered partition.

RANGE:
------
Uses logical peer groups based on the ORDER BY values. Its behavior can differ
from ROWS when multiple rows have equal ordering values.

A common running-total frame is:

    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

A full-partition frame is:

    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING

Example 4: Calculate Total Sales by Payment Method for current and next two orders
*/

SELECT
    order_id,
    order_date,
    payment_method,
    total_amount,
    SUM(total_amount) OVER(
        PARTITION BY payment_method
        ORDER BY order_date
        ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) total_sales
FROM Orders;

/*
Example 5:Calculate Total Sales by Payment Method for current and previous two orders 
*/

SELECT
    order_id,
    order_date,
    payment_method,
    total_amount,
    SUM(total_amount) OVER(
        PARTITION BY payment_method
        ORDER BY order_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) total_sales
FROM Orders;


 
--Example 5.1:Total Sales by Payment Method from previous two orders only (Same as above)
SELECT
    order_id,
    order_date,
    payment_method,
    total_amount,
    SUM(total_amount) OVER(
        PARTITION BY payment_method
        ORDER BY order_date
        ROWS 2 PRECEDING) total_sales
FROM Orders;

-- Example 6:Calculate cumulative Total Sales by Payment Method up to the current order(Default Frame)
SELECT
    order_id,
    order_date,
    payment_method,
    total_amount,
    SUM(total_amount) OVER(
        PARTITION BY payment_method
        ORDER BY order_date) total_sales
FROM Orders;

-- Example 6.1:Calculate cumulative Total Sales by Payment Method up to the current order(Sames as Example 6)
SELECT
    order_id,
    order_date,
    payment_method,
    total_amount,
    SUM(total_amount) OVER(
        PARTITION BY payment_method
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) total_sales
FROM Orders;

/*
===============================================================================
7. WINDOW FUNCTION RULES
===============================================================================

1. Window functions use the OVER() clause.

2. Window functions can appear in SELECT and ORDER BY when supported by the
   particular function and query.

3. In SQL Server, window functions cannot be used directly in WHERE, GROUP BY,
   or HAVING. Use a CTE or derived table to calculate the window result first,
   then filter or group the outer query as needed.

4. Window functions generally cannot be nested directly inside other window
   functions at the same query level. Use a CTE or derived table to separate
   calculation steps.

5. PARTITION BY is optional. Without it, the rows belong to one partition.

6. ORDER BY is required for ranking functions and for LAG()/LEAD().

7. A frame clause is available only for applicable functions. Ranking functions
   do not use ROWS/RANGE frames.

8. A window function does not automatically sort the final displayed result.
   Use the outer ORDER BY clause when output order matters.

9. For repeatable row-by-row calculations, make the window ORDER BY unique
   where possible.

10. For running totals and moving averages, explicitly define the ROWS frame
    to avoid unintended peer-group behavior.

===============================================================================
8. WINDOW FUNCTIONS WITH GROUP BY
===============================================================================

GROUP BY aggregates detail rows into groups.

Window functions calculate across rows in the result set or across partitions
of that result.

They can be combined in the same query when the grouped result is the input
to the window function.

===============================================================================
APPROACH 1: USING A CTE (COMMON TABLE EXPRESSION)
===============================================================================
Example 7: Calculate total order value per customer, then rank customers
by their spending.

The CTE first produces one row per customer.
The outer query ranks those grouped customer totals.
*/

;WITH CustomerSpending AS
(
    SELECT
        customer_id,
        SUM(total_amount) AS total_spending
    FROM Orders
    GROUP BY customer_id
)
SELECT
    customer_id,
    total_spending,
    RANK() OVER (
        ORDER BY total_spending DESC
    ) AS spending_rank
FROM CustomerSpending
ORDER BY spending_rank, customer_id;
GO

/*
Important:
You cannot directly place SUM(total_amount) OVER (...) inside GROUP BY.
Choose the correct calculation level and use a CTE or derived table when
one calculation depends on the result of another.
*/
/*
===============================================================================
APPROACH 2: DIRECT APPROACH (WITHOUT A CTE)
===============================================================================
*/
SELECT
    customer_id,
    SUM(total_amount) total_spending,
    RANK() OVER(ORDER BY SUM(total_amount) DESC) spending_rank
FROM Orders
GROUP BY customer_id;
/*
WHEN TO USE?
------------
Use the direct approach when the calculation is straightforward and the
query is easy to understand without an intermediate result set.
*/

/*
===============================================================================
9. RANKING FUNCTIONS
===============================================================================

Ranking functions assign row numbers, ranks, or group numbers based on ordering.

ROW_NUMBER():
Assigns a unique sequential number to each row.

RANK():
Tied rows share the same rank, and gaps appear after ties.

DENSE_RANK():
Tied rows share the same rank, without gaps after ties.

NTILE(n):
Divides ordered rows into n approximately equal-sized groups.

===============================================================================
9.1 ROW_NUMBER()
===============================================================================
*/

-- Example 8: Number employees by salary within each department.

SELECT
    employee_id,
    employee_name,
    department,
    salary,
    ROW_NUMBER() OVER (
        PARTITION BY department
        ORDER BY salary DESC, employee_id
    ) AS row_number
FROM Employees
ORDER BY department, row_number;
GO

/*
===============================================================================
9.2 RANK()
===============================================================================
*/

-- Example 9: Rank employees by salary within each department.

SELECT
    employee_id,
    employee_name,
    department,
    salary,
    RANK() OVER (
        PARTITION BY department
        ORDER BY salary DESC
    ) AS salary_rank
FROM Employees
ORDER BY department, salary_rank, employee_id;
GO

/*
===============================================================================
9.3 DENSE_RANK()
===============================================================================
*/

-- Example 10: Rank employees by distinct salary positions within each department.

SELECT
    employee_id,
    employee_name,
    department,
    salary,
    DENSE_RANK() OVER (
        PARTITION BY department
        ORDER BY salary DESC
    ) AS dense_salary_rank
FROM Employees
ORDER BY department, dense_salary_rank, employee_id;
GO

/*
For values 90000, 90000, 80000:

Value       ROW_NUMBER   RANK   DENSE_RANK
90000           1          1        1
90000           2          1        1
80000           3          3        2

============================================================
   SQL WINDOW RANKING | ROW_NUMBER, RANK, DENSE_RANK
============================================================

Example 11:Rank Employees Based on their Salaries from Highest to Lowest within each Department
*/
SELECT
    employee_id,
    employee_name,
    department,
    salary,
    ROW_NUMBER() OVER(
        PARTITION BY department
        ORDER BY salary DESC) salary_row_number,
    RANK() OVER(
        PARTITION BY department
        ORDER BY salary DESC) salary_rank,
    DENSE_RANK() OVER(
        PARTITION BY department
        ORDER BY salary DESC) salary_dense_rank
FROM Employees
WHERE department = 'Sales';
/*
===============================================================================
9.4 NTILE()
===============================================================================
*/

-- Example 12: Divide employees into four salary groups.

SELECT
    employee_id,
    employee_name,
    salary,
    NTILE(4) OVER (
        ORDER BY salary DESC, employee_id
    ) AS salary_group
FROM Employees
ORDER BY salary DESC, employee_id;
GO

/*
NTILE(4) creates four groups based on row count, not equal salary ranges.

===============================================================================
9.5 CUME_DIST()
===============================================================================

CUME_DIST() stands for Cumulative Distribution.

It calculates the cumulative distribution of a row within a partition.

Formula:

    Number of rows with values less than or equal to the current row's value
    ------------------------------------------------------------------------
                         Total number of rows

The result ranges from greater than 0 to 1.

Rows with the same ORDER BY value receive the same CUME_DIST() value.

Common use:
- Understand the relative distribution of salaries.
- Identify employees within the top or bottom percentage of a group.
*/

-- Example 13: Calculate the cumulative salary distribution of employees.

SELECT
    employee_id,
    employee_name,
    department,
    salary,
    CUME_DIST() OVER (
        ORDER BY salary
    )AS cumulative_distribution
FROM Employees
ORDER BY salary, employee_id;
GO

-- Example 14: Calculate cumulative salary distribution within each department.

SELECT
    employee_id,
    employee_name,
    department,
    salary,
    CUME_DIST() OVER (
        PARTITION BY department
        ORDER BY salary
    ) AS department_cumulative_distribution
FROM Employees
ORDER BY department, salary, employee_id;
GO

/*
===============================================================================
9.6 PERCENT_RANK()
===============================================================================

PERCENT_RANK() calculates the relative rank of a row within a partition.

Formula:

    (RANK() - 1) / (Total number of rows - 1)

The result ranges from 0 to 1.

The first ranked row has a PERCENT_RANK() of 0.
The last ranked row generally has a PERCENT_RANK() of 1 when there are
at least two rows and the last row has the highest rank.

Rows with tied ORDER BY values receive the same PERCENT_RANK() value.

For a partition containing only one row, PERCENT_RANK() returns 0.

Common use:
- Compare an employee's salary position relative to other employees.
- Analyze relative ranking within departments.
*/

-- Example 15: Calculate the relative salary rank of all employees.

SELECT
    employee_id,
    employee_name,
    department,
    salary,
    PERCENT_RANK() OVER (
        ORDER BY salary
    ) AS salary_percent_rank
FROM Employees
ORDER BY salary, employee_id;
GO

-- Example 16: Calculate relative salary rank within each department.

SELECT
    employee_id,
    employee_name,
    department,
    salary,
    PERCENT_RANK() OVER (
        PARTITION BY department
        ORDER BY salary
    ) AS department_percent_rank
FROM Employees
ORDER BY department, salary, employee_id;
GO

/*
===============================================================================
9.7 CUME_DIST() VS PERCENT_RANK()
===============================================================================

CUME_DIST():
- Measures the proportion of rows whose ORDER BY values are less than
  or equal to the current row's value.
- Its result is greater than 0 and at most 1 for a nonempty partition.

PERCENT_RANK():
- Measures the relative rank using the RANK() function.
- Its result ranges from 0 to 1.
- The first ranked row has a value of 0.

Example:
For ordered values 10, 20, 30, 40:

Value   CUME_DIST()   PERCENT_RANK()
10         0.25           0.00
20         0.50           0.33
30         0.75           0.67
40         1.00           1.00

===============================================================================
10. VALUE FUNCTIONS
===============================================================================

LAG():
Retrieves a value from a preceding row.

LEAD():
Retrieves a value from a following row.

LAG(expression, offset, default_value) 
LEAD(expression, offset, default_value)

PARAMETERS:
-----------
1. expression
-----------
   The column or expression whose value you want to retrieve.

2. offset
-----------
   Optional. Specifies how many rows backward (LAG) or forward (LEAD)
   to look.
   Default: 1

3. default_value
-----------
   Optional. The value returned when the requested row does not exist.
   Default: NULL

FIRST_VALUE():
Retrieves the first value in the current window frame.

LAST_VALUE():
Retrieves the last value in the current window frame.

===============================================================================
10.1 LAG()
===============================================================================
*/

-- Example 13: Retrieve the previous employee salary within each department.

SELECT
    employee_id,
    employee_name,
    department,
    salary,
    LAG(salary) OVER (
        PARTITION BY department
        ORDER BY salary, employee_id
    ) AS previous_salary
FROM Employees
ORDER BY department, salary, employee_id;
GO

/*
===============================================================================
10.2 LEAD()
===============================================================================
*/

-- Example 14: Retrieve the next employee salary within each department.

SELECT
    employee_id,
    employee_name,
    department,
    salary,
    LEAD(salary) OVER (
        PARTITION BY department
        ORDER BY salary, employee_id
    ) AS next_salary
FROM Employees
ORDER BY department, salary, employee_id;
GO

/*
===============================================================================
10.3 FIRST_VALUE()
===============================================================================
*/

-- Example 15: Show the lowest salary within each department on every row.

SELECT
    employee_id,
    employee_name,
    department,
    salary,
    FIRST_VALUE(salary) OVER (
        PARTITION BY department
        ORDER BY salary, employee_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS lowest_department_salary
FROM Employees
ORDER BY department, salary, employee_id;
GO

/*
===============================================================================
10.4 LAST_VALUE()
===============================================================================
*/

-- Example 16: Show the highest salary within each department on every row.

SELECT
    employee_id,
    employee_name,
    department,
    salary,
    LAST_VALUE(salary) OVER (
        PARTITION BY department
        ORDER BY salary, employee_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS highest_department_salary
FROM Employees
ORDER BY department, salary, employee_id;
GO

/*
===============================================================================
11. AGGREGATE WINDOW FUNCTIONS
===============================================================================

Aggregate functions can be used with OVER() to calculate values across a
window without collapsing detail rows.

Common aggregate window functions:
- SUM() OVER()
- AVG() OVER()
- COUNT() OVER()
- MIN() OVER()
- MAX() OVER()

===============================================================================
11.1 SUM() OVER()
===============================================================================
*/

/*Example 17:  - Find the Total Sales Across All Orders 
                - Find the Total Sales for Each Customer.*/

SELECT
    order_id,
    customer_id,
    total_amount,
    SUM(total_amount) OVER () AS all_orders_total,
    SUM(total_amount) OVER(PARTITION BY customer_id) AS total_sales_by_customer
FROM Orders;
GO

/*
===============================================================================
11.2 AVG() OVER()
===============================================================================
*/

/*Example 18:   - Find the Average Salary Across Employees 
                - Find the Average Salary for Each Department*/

SELECT
    employee_id,
    employee_name,
    department,
    salary,
    AVG(salary) OVER() AS avg_emp_salary,
    AVG(salary) OVER (
        PARTITION BY department
    ) AS department_average_salary
FROM Employees
ORDER BY department, employee_id;
GO

/*
===============================================================================
11.3 COUNT() OVER()
===============================================================================
*/

/*Example 19:
   Find the Total Number of Orders and the Total Number of Orders for Each Customer
*/

SELECT
    order_id,
    customer_id,
    COUNT(*) OVER() AS total_orders,
    COUNT(*) OVER(PARTITION BY customer_id) AS total_orders_by_customers
FROM Orders;

/*
COUNT(*) counts rows.
COUNT(column_name) counts only rows where that expression is not NULL.

===============================================================================
11.4 MIN() OVER() AND MAX() OVER()
===============================================================================
*/

-- Example 20: Display minimum and maximum salary by department.

SELECT
    employee_id,
    employee_name,
    department,
    salary,
    MIN(salary) OVER (
        PARTITION BY department
    ) AS minimum_department_salary,
    MAX(salary) OVER (
        PARTITION BY department
    ) AS maximum_department_salary
FROM Employees
ORDER BY department, employee_id;
GO

/*
===============================================================================
12. RUNNING TOTAL
===============================================================================

A running total accumulates values row by row in a specified order.

Use:
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

Include a unique tie-breaker in ORDER BY for deterministic row ordering.
*/

-- Example 21: Calculate a running total of order values by date.

SELECT
    order_id,
    customer_id,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        ORDER BY order_date, order_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM Orders
ORDER BY order_date, order_id;
GO

-- Example 22: Calculate a separate running total for each customer.

SELECT
    order_id,
    customer_id,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date, order_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS customer_running_total
FROM Orders
ORDER BY customer_id, order_date, order_id;
GO

/*
===============================================================================
13. MOVING AVERAGE
===============================================================================

A moving average calculates an average over a moving frame of rows.

ROWS BETWEEN 2 PRECEDING AND CURRENT ROW includes up to three rows:
the current row and the two preceding rows.

At the beginning of a partition, fewer than three rows may be available.
*/

-- Example 23: Calculate a three-order moving average.

SELECT
    order_id,
    customer_id,
    order_date,
    total_amount,
    AVG(CAST(total_amount AS DECIMAL(12, 2))) OVER (
        ORDER BY order_date, order_id
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_average_3_orders
FROM Orders
ORDER BY order_date, order_id;
GO

/*
===============================================================================
14. PREVIOUS AND NEXT ROW COMPARISON
===============================================================================

LAG() and LEAD() help compare the current row with a preceding or following row.

Applications:
- Compare an order with the customer's previous order.
- Measure changes between orders.
- Compare current and previous sales values.
- Identify changes in a sequence.

===============================================================================
14.1 COMPARE CURRENT AND PREVIOUS ORDER
===============================================================================

Example 24: Analyze the Month-over-Month Performance by Finding the Percentage Change in Sales
Between the Current and Previous Months
*/

SELECT
    order_year,
    order_month,
    current_month_sales,
    previous_month_sales,
    current_month_sales - previous_month_sales AS month_over_month_change,
    ROUND(CAST((current_month_sales - previous_month_sales) AS FLOAT) 
          / NULLIF(previous_month_sales, 0) * 100, 1) AS month_over_month_percent_change
FROM (
    SELECT
        YEAR(order_date) AS order_year,
        MONTH(order_date) AS order_month,
        SUM(total_amount) AS current_month_sales,
        LAG(SUM(total_amount)) OVER(ORDER BY YEAR(order_date), MONTH(order_date)) AS previous_month_sales
    FROM Orders
    GROUP BY YEAR(order_date), MONTH(order_date)
) monthly_sales;

/*
The first order for each customer has no previous order, so LAG() returns NULL.

===============================================================================
14.2 COMPARE WITH NEXT ORDER
===============================================================================
*/

/* Example 25:
   Customer Loyalty Analysis - Rank Customers Based on the Average Days Between Their Orders
*/

SELECT
    customer_id,
    AVG(days_until_next_order) AS avg_days,
    RANK() OVER (ORDER BY COALESCE(AVG(days_until_next_order), 999999)) AS RankAvg
FROM
    (SELECT
        order_id,
        customer_id,
        order_date AS current_order_date,
        LEAD(order_date) OVER(
            PARTITION BY customer_id
            ORDER BY order_date) next_order_date,
        DATEDIFF(
            DAY,
            order_date,
            LEAD(order_date) OVER(
                PARTITION BY customer_id
                ORDER BY order_date)
            ) AS days_until_next_order
    FROM Orders
    ) AS customers_orders
GROUP BY customer_id;
GO

/*
===============================================================================
15. TOP N PER GROUP
===============================================================================

Top N per group means selecting the highest-ranking rows within each group.

ROW_NUMBER():
Useful when you need at most N rows per group.

RANK() / DENSE_RANK():
Useful when tied values should share a rank. These can return more than N rows
when ties occur at the cutoff.

===============================================================================
15.1 TOP THREE EMPLOYEES BY SALARY IN EACH DEPARTMENT
===============================================================================
*/

;WITH EmployeeRanking AS
(
    SELECT
        employee_id,
        employee_name,
        department,
        salary,
        ROW_NUMBER() OVER (
            PARTITION BY department
            ORDER BY salary DESC, employee_id
        ) AS salary_row_number
    FROM Employees
)
SELECT
    employee_id,
    employee_name,
    department,
    salary,
    salary_row_number
FROM EmployeeRanking
WHERE salary_row_number <= 3
ORDER BY department, salary_row_number;
GO

/*
===============================================================================
15.2 TOP THREE CUSTOMERS BY TOTAL ORDER VALUE
===============================================================================
*/

;WITH CustomerSpending AS
(
    SELECT
        customer_id,
        SUM(total_amount) AS total_spending
    FROM Orders
    GROUP BY customer_id
),
CustomerRanking AS
(
    SELECT
        customer_id,
        total_spending,
        DENSE_RANK() OVER (
            ORDER BY total_spending DESC
        ) AS spending_rank
    FROM CustomerSpending
)
SELECT
    c.customer_id,
    c.customer_name,
    cr.total_spending,
    cr.spending_rank
FROM CustomerRanking AS cr
INNER JOIN Customers AS c
    ON c.customer_id = cr.customer_id
WHERE cr.spending_rank <= 3
ORDER BY cr.spending_rank, c.customer_id;
GO

/*
===============================================================================
16. PERCENTAGE OF TOTAL
===============================================================================

Percentage of total shows how much a value contributes to the overall total.


Formula:
----------
    Individual Value / Overall Total * 100

Example:
----------
    Order value = 1,000
    Overall order value = 6,000

    Percentage = 1,000 / 6,000 * 100
               = 16.67%

Use decimal arithmetic to avoid integer division.
NULLIF prevents division by zero.
*/

-- Example 26: Calculate each order's percentage of total order value.

SELECT
    order_id,
    customer_id,
    total_amount,
    CAST(
        100.0 * total_amount
        / NULLIF(SUM(total_amount) OVER (), 0)
        AS DECIMAL(10, 2)
    ) AS percentage_of_total
FROM Orders
ORDER BY percentage_of_total DESC;
GO

/*
===============================================================================
16.1 DEPARTMENT PERCENTAGE OF TOTAL SALARY
===============================================================================
*/

;WITH DepartmentSalary AS
(
    SELECT
        department,
        SUM(salary) AS department_total_salary
    FROM Employees
    GROUP BY department
)
SELECT
    department,
    department_total_salary,
    CAST(
        100.0 * department_total_salary
        / NULLIF(SUM(department_total_salary) OVER (), 0)
        AS DECIMAL(10, 2)
    ) AS percentage_of_total_salary
FROM DepartmentSalary
ORDER BY department_total_salary DESC;
GO
/*
===============================================================================
Calculate each customer's percentage of total spending.
===============================================================================
*/
;WITH customer_spending AS
(
	SELECT
		customer_id,
		SUM(total_amount) total_spending
	FROM Orders
	GROUP BY customer_id
),customer_spending_percentage AS
(
	SELECT
		customer_id,
		total_spending,
		CAST(100 * total_spending / NULLIF(SUM(total_spending) OVER(),0) AS DECIMAL(10,2)) cust_spend_per
	FROM customer_spending
)
SELECT
	csp.customer_id,
	c.customer_name,
	csp.total_spending,
	csp.cust_spend_per customer_spending_percentage
FROM customer_spending_percentage csp
INNER JOIN Customers c
	ON csp.customer_id = c.customer_id
ORDER BY csp.cust_spend_per DESC;

/*
===============================================================================
17. PRACTICE QUESTIONS
===============================================================================

WINDOW BASICS
-------------
1. Display every employee alongside the total salary of all employees.
2. Display every employee alongside the average salary of their department.
3. Count employees in each department without collapsing individual rows.

RANKING
-------
4. Assign ROW_NUMBER() to employees ordered by hire_date.
5. Rank employees by salary within each department using RANK().
6. Compare RANK() and DENSE_RANK() using employee salaries.
7. Divide employees into three groups using NTILE(3).

VALUE FUNCTIONS
---------------
8. Show the previous salary within each department using LAG().
9. Show the next salary within each department using LEAD().
10. Show the lowest salary in each department using FIRST_VALUE().
11. Show the highest salary in each department using LAST_VALUE().

AGGREGATE WINDOW FUNCTIONS
--------------------------
12. Show each order's amount and the total amount of all orders.
13. Show each employee's salary and department average.
14. Display the minimum and maximum salary by department.

RUNNING TOTAL AND MOVING AVERAGE
--------------------------------
15. Calculate a running total of orders by date.
16. Calculate a separate running total for each customer.
17. Calculate a three-order moving average.

PREVIOUS/NEXT ROW COMPARISON
----------------------------
18. Analyze the Month-over-Month Performance by Finding the Percentage Change in Sales
Between the Current and Previous Months
19. Customer Loyalty Analysis - Rank Customers Based on the Average Days Between Their Orders

TOP N PER GROUP
---------------
20. Find the top two highest-paid employees in each department.
21. Find the three customers with the highest total spending.
22. Find the top two products by revenue within each product category.

PERCENTAGE OF TOTAL
-------------------
23. Calculate each order's percentage of total order value.
24. Calculate each customer's percentage of total spending.
25. Calculate each department's percentage of total employee salary.

WINDOW FRAMES AND GROUP BY
-------------------------
26. Calculate a running total using an explicit ROWS frame.
27. Compare ROWS and RANGE behavior when ORDER BY values contain ties.
28. Aggregate order values by customer, then rank customers using a window
    function over the grouped result.

CUME_DIST()
-----------
1. Calculate CUME_DIST() for employee salaries from lowest to highest.
2. Calculate CUME_DIST() separately for each department.
3. Find employees whose CUME_DIST() is greater than or equal to 0.75.

PERCENT_RANK()
--------------
4. Calculate PERCENT_RANK() for employee salaries from lowest to highest.
5. Compare PERCENT_RANK() across departments.
6. Compare PERCENT_RANK() and CUME_DIST() for the same salary ordering.

===============================================================================
18. QUICK REVISION
===============================================================================

OVER():
Defines the window used for the calculation.

PARTITION BY:
Divides rows into independent partitions.

ORDER BY inside OVER():
Defines the order used by the window function.

ROWS / RANGE:
Defines the window frame for applicable functions.

ROW_NUMBER():
Assigns a unique sequential number to each row.

RANK():
Tied rows share a rank; gaps follow ties.

DENSE_RANK():
Tied rows share a rank; no gaps follow ties.

NTILE(n):
Divides ordered rows into approximately equal-sized groups.

LAG() / LEAD():
Retrieve values from preceding or following rows.

FIRST_VALUE() / LAST_VALUE():
Retrieve values from the first or last row in the current frame.

SUM(), AVG(), COUNT(), MIN(), MAX() OVER():
Calculate aggregate values while preserving detail rows.

Running total:
An ordered SUM() with a frame ending at the current row.

Moving average:
An AVG() over a defined frame of preceding and current rows.

Top N per group:
Rank rows with PARTITION BY, then filter the rank in an outer query.

Percentage of total:
Divide a value by a window total and multiply by 100.

GROUP BY vs window functions:
GROUP BY normally reduces rows to one row per group.
Window functions calculate across rows while preserving the rows of their input.

Important:
Window functions generally cannot be filtered directly in WHERE.
Use a CTE or derived table, then filter in the outer query.

===============================================================================
END OF 15. WINDOW FUNCTIONS
===============================================================================
*/