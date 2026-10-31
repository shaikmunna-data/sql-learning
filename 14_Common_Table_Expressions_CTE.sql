/*
===============================================================================
14. COMMON TABLE EXPRESSIONS (CTE)
===============================================================================

A Common Table Expression (CTE) is a temporary named result set that can be
referenced by a SELECT, INSERT, UPDATE, or DELETE statement.

A CTE improves readability by breaking complex queries into smaller,
understandable parts.

A CTE exists only for the single statement immediately following its definition.

Syntax:

    WITH CTE_Name AS
    (
        SELECT ...
    )
    SELECT *
    FROM CTE_Name;

Important points:
    - WITH defines the CTE.
    - AS introduces the query that defines the CTE.
    - A CTE is not a permanent database object.
    - A CTE must be followed by a statement that uses it.
    - In SQL Server, if another statement precedes WITH in the same batch,
      terminate the previous statement with a semicolon.
    - A CTE does not automatically store its result or guarantee better
      performance than an equivalent subquery.
*/

USE EcommerceSQL;
GO


/*
===============================================================================
1. SIMPLE CTE
===============================================================================

A simple CTE defines one named result set and uses it in the next statement.

Example:
    Find products priced above 10,000.
*/

;WITH ExpensiveProducts AS
(
    SELECT
        product_id,
        product_name,
        category,
        price
    FROM Products
    WHERE price > 10000
)
SELECT *
FROM ExpensiveProducts
ORDER BY price DESC;


/*
Example:
    Find customers from Hyderabad.
*/

;WITH HyderabadCustomers AS
(
    SELECT
        customer_id,
        customer_name,
        city,
        state
    FROM Customers
    WHERE city = 'Hyderabad'
)
SELECT *
FROM HyderabadCustomers
ORDER BY customer_name;


/*
Example:
    Find orders with an amount greater than 20,000.
*/

;WITH HighValueOrders AS
(
    SELECT
        order_id,
        customer_id,
        order_date,
        order_status,
        total_amount
    FROM Orders
    WHERE total_amount > 20000
)
SELECT *
FROM HighValueOrders
ORDER BY total_amount DESC;


/*
===============================================================================
2. CTE WITH AGGREGATE FUNCTIONS
===============================================================================

A CTE can contain aggregate functions and GROUP BY.

Example:
    Calculate the total spending of each customer.
*/

;WITH CustomerSpending AS
(
    SELECT
        customer_id,
        COUNT(*) AS total_orders,
        SUM(total_amount) AS total_spending,
        AVG(total_amount) AS average_order_amount
    FROM Orders
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.customer_name,
    cs.total_orders,
    cs.total_spending,
    cs.average_order_amount
FROM Customers AS c
INNER JOIN CustomerSpending AS cs
    ON c.customer_id = cs.customer_id
ORDER BY cs.total_spending DESC;


/*
Example:
    Find product categories with an average price above 10,000.
*/

;WITH CategoryStatistics AS
(
    SELECT
        category,
        COUNT(*) AS total_products,
        AVG(price) AS average_price
    FROM Products
    GROUP BY category
)
SELECT
    category,
    total_products,
    average_price
FROM CategoryStatistics
WHERE average_price > 10000
ORDER BY average_price DESC;


/*
===============================================================================
3. MULTIPLE CTEs
===============================================================================

Multiple CTEs can be defined in one WITH clause.

Separate CTE definitions with commas.

A later CTE can reference an earlier CTE defined in the same WITH clause.

Syntax:

    WITH FirstCTE AS
    (
        SELECT ...
    ),
    SecondCTE AS
    (
        SELECT ...
        FROM FirstCTE
    )
    SELECT ...
    FROM SecondCTE;

Example:
    Calculate each customer's spending and identify high-spending customers.
*/

;WITH CustomerSpending AS
(
    SELECT
        customer_id,
        COUNT(*) AS total_orders,
        SUM(total_amount) AS total_spending
    FROM Orders
    GROUP BY customer_id
),
HighSpendingCustomers AS
(
    SELECT
        customer_id,
        total_orders,
        total_spending
    FROM CustomerSpending
    WHERE total_spending > 40000
)
SELECT
    c.customer_id,
    c.customer_name,
    h.total_orders,
    h.total_spending
FROM HighSpendingCustomers AS h
INNER JOIN Customers AS c
    ON h.customer_id = c.customer_id
ORDER BY h.total_spending DESC;


/*
Example:
    Calculate department salary statistics and identify employees earning
    more than their department's average salary.
*/

;WITH DepartmentSalary AS
(
    SELECT
        department,
        AVG(salary) AS average_salary
    FROM Employees
    GROUP BY department
),
EmployeeSalaryComparison AS
(
    SELECT
        e.employee_id,
        e.employee_name,
        e.department,
        e.salary,
        ds.average_salary
    FROM Employees AS e
    INNER JOIN DepartmentSalary AS ds
        ON e.department = ds.department
)
SELECT
    employee_id,
    employee_name,
    department,
    salary,
    average_salary
FROM EmployeeSalaryComparison
WHERE salary > average_salary
ORDER BY department, salary DESC;


/*
===============================================================================
4. CTE WITH JOINS
===============================================================================

A CTE can join multiple tables to prepare a result set for the main query.

Example:
    Display orders with customer names and employee names.
*/

;WITH OrderDetails AS
(
    SELECT
        o.order_id,
        o.customer_id,
        c.customer_name,
        o.employee_id,
        e.employee_name,
        o.order_date,
        o.order_status,
        o.total_amount
    FROM Orders AS o
    INNER JOIN Customers AS c
        ON o.customer_id = c.customer_id
    LEFT JOIN Employees AS e
        ON o.employee_id = e.employee_id
)
SELECT *
FROM OrderDetails
ORDER BY order_date DESC, order_id;


/*
===============================================================================
5. CTE VS SUBQUERY
===============================================================================

A subquery is a query nested inside another SQL statement.

A CTE gives a name to a query result and can make complex queries easier
to read.

Both can express similar logic. Neither is automatically faster in every case.

Example using a subquery:
    Find products priced above the average product price.
*/

SELECT
    product_id,
    product_name,
    price
FROM Products
WHERE price >
(
    SELECT AVG(price)
    FROM Products
)
ORDER BY price DESC;


/*
The same logic using a CTE:
*/

;WITH AverageProductPrice AS
(
    SELECT AVG(price) AS average_price
    FROM Products
)
SELECT
    p.product_id,
    p.product_name,
    p.price
FROM Products AS p
CROSS JOIN AverageProductPrice AS a
WHERE p.price > a.average_price
ORDER BY p.price DESC;


/*
Comparison:

    CTE:
        - Has a name.
        - Can improve readability for complex queries.
        - Can reference an earlier CTE in the same WITH clause.
        - Can be used for recursive queries.

    Subquery:
        - Is nested inside another query.
        - Can be concise for simple calculations and filters.
        - Can be correlated with the outer query.

    Performance:
        - A CTE is not automatically faster than a subquery.
        - SQL Server's optimizer determines the execution plan.
        - A CTE is not automatically materialized or stored as a table.
*/


/*
===============================================================================
6. RECURSIVE CTE
===============================================================================

A recursive CTE refers to itself to process hierarchical or sequential data.

A recursive CTE has two main parts:

    1. Anchor member:
       The initial query that starts the recursion.

    2. Recursive member:
       The query that references the CTE and generates the next result.

The anchor and recursive members are normally combined using UNION ALL.

Example:
    Generate numbers from 1 to 10.
*/

;WITH NumberSequence AS
(
    -- Anchor member
    SELECT 1 AS number

    UNION ALL

    -- Recursive member
    SELECT number + 1
    FROM NumberSequence
    WHERE number < 10
)
SELECT number
FROM NumberSequence
ORDER BY number;


/*
Example:
    Display an employee hierarchy starting from employee 101.

    This example assumes manager_id identifies an employee's manager.
    Employee 101 is the starting employee; the query finds employees who
    report directly or indirectly to that employee.
*/

;WITH EmployeeHierarchy AS
(
    -- Anchor member: employees who have no recorded manager.
    SELECT
        employee_id,
        employee_name,
        manager_id,
        department,
        1 AS hierarchy_level
    FROM Employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive member: find employees reporting to the current employees.
    SELECT
        e.employee_id,
        e.employee_name,
        e.manager_id,
        e.department,
        eh.hierarchy_level + 1
    FROM Employees AS e
    INNER JOIN EmployeeHierarchy AS eh
        ON e.manager_id = eh.employee_id
)
SELECT
    employee_id,
    employee_name,
    manager_id,
    department,
    hierarchy_level
FROM EmployeeHierarchy
ORDER BY hierarchy_level, manager_id, employee_id
OPTION (MAXRECURSION 100);

/*
Important:
    - The anchor member determines where recursion starts.
    - The recursive member determines how the next level is found.
    - The recursion must have a stopping condition or otherwise terminate.
    - SQL Server's default recursion limit is 100 levels.
    - OPTION (MAXRECURSION n) can change the limit for a query.
    - OPTION (MAXRECURSION 0) removes the limit; use it carefully.
    - Incorrect recursive logic can produce excessive rows or run until
      the recursion limit is reached.
*/


/*
===============================================================================
7. CTE WITH DML STATEMENTS
===============================================================================

A CTE can also be used with UPDATE, DELETE, and INSERT statements.

Be careful when running data-modification examples. The following UPDATE
example is commented out so it does not modify your practice data.

Example:
    Update the status of pending orders with an amount greater than 20,000.
*/

/*
;WITH PendingHighValueOrders AS
(
    SELECT *
    FROM Orders
    WHERE order_status = 'Pending'
      AND total_amount > 20000
)
UPDATE PendingHighValueOrders
SET order_status = 'Reviewed';
*/


/*
===============================================================================
8. CTE LIMITATIONS AND COMMON MISTAKES
===============================================================================

1. A CTE is available only to the immediately following statement.

   Incorrect:
       WITH ProductCTE AS (...)
       SELECT * FROM ProductCTE;
       SELECT * FROM ProductCTE;  -- CTE is no longer in scope.

2. A CTE is not a permanent table or view.

3. A CTE does not automatically store or materialize its result.

4. Use a semicolon before WITH when the previous statement in the batch
   is not already terminated.

5. Multiple CTEs are separated by commas, not additional WITH keywords.

   Correct:
       WITH FirstCTE AS (...),
            SecondCTE AS (...)
       SELECT ...

6. A recursive CTE needs an anchor member and a recursive member.

7. The anchor and recursive members must return compatible columns:
   the same number of columns, in the same order, with compatible data types.

8. Recursive CTEs can hit SQL Server's default 100-level recursion limit.

9. A CTE does not guarantee that the query will be faster than a subquery.

10. ORDER BY is generally not allowed inside a CTE definition unless used
    with constructs such as TOP or OFFSET/FETCH. Put the final ORDER BY
    in the statement that reads from the CTE.

11. A CTE name should not be confused with a permanent database object.

12. If a result must be reused across multiple statements, consider a
    temporary table or another suitable database object instead of a CTE.
*/


/*
===============================================================================
9. PRACTICE QUESTIONS
===============================================================================

SIMPLE CTE
----------

Q1. Create a CTE to display products with a price below 5,000.

Q2. Create a CTE to display orders with the status 'Delivered'.

Q3. Create a CTE to find customers registered after 2024-01-01.


AGGREGATION AND JOINS
--------------------

Q4. Use a CTE to calculate the number of orders placed by each customer.

Q5. Use a CTE to calculate total sales for each order status.

Q6. Use a CTE to find products whose stock quantity is below 20.

Q7. Use a CTE to calculate total quantity sold for each product by joining
    Products and OrderItems.

Q8. Use a CTE to find employees earning more than their department's average
    salary.


MULTIPLE CTEs
-------------

Q9. Create one CTE for customer order totals and another CTE to identify
    customers whose total spending exceeds 30,000.

Q10. Create a CTE for department average salaries and another CTE to list
     employees earning above their department average.


SUBQUERY COMPARISON
-------------------

Q11. Find products priced above the average product price using a CTE.

Q12. Write the same query using a subquery and compare readability.


RECURSIVE CTE
-------------

Q13. Generate numbers from 1 to 20 using a recursive CTE.

Q14. Generate numbers from 10 down to 1 using a recursive CTE.

Q15. Display an employee hierarchy starting from a selected manager.


CONCEPTUAL QUESTIONS
--------------------

Q16. What is a Common Table Expression?

Q17. What is the purpose of the WITH keyword?

Q18. What is the difference between a CTE and a subquery?

Q19. What are the anchor member and recursive member?

Q20. Why can a CTE not normally be referenced by a second, separate statement?

Q21. Does using a CTE guarantee better query performance?

Q22. What is the default recursion limit in SQL Server?


===============================================================================
10. QUICK REVISION
===============================================================================

CTE:
    A named result set defined using WITH.

Basic syntax:
    WITH CTE_Name AS (SELECT ...)
    SELECT * FROM CTE_Name;

Simple CTE:
    One CTE definition.

Multiple CTEs:
    Multiple definitions separated by commas.

CTE vs subquery:
    Similar results can often be written either way.
    Choose the form that makes the query clear; performance is not guaranteed.

Recursive CTE:
    Uses an anchor member and a recursive member.

CTE scope:
    Available only to the single statement immediately following its definition.

Default recursion limit:
    100 levels in SQL Server.

MAXRECURSION:
    Query option used to control the recursion limit.

Common mistakes:
    - Forgetting the semicolon before WITH when needed.
    - Using multiple WITH keywords for multiple CTEs.
    - Trying to reuse a CTE in a separate statement.
    - Writing recursive logic without a proper stopping condition.
    - Assuming a CTE is automatically faster or materialized.
===============================================================================
*/