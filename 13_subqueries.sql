/*
===============================================================================
13. SUBQUERIES
===============================================================================

TOPICS COVERED
--------------
1. What Is a Subquery?
2. Scalar Subquery
3. Single-Row Subquery
4. Multi-Row Subquery
5. Subquery with IN
6. Subquery with EXISTS
7. Correlated Subquery
8. Subquery in SELECT
9. Subquery in FROM
10. Subquery in WHERE
11. Common Mistakes
12. Practice Section
13. Quick Revision

Database: EcommerceSQL
*/

USE EcommerceSQL;
GO


/*
===============================================================================
1. WHAT IS A SUBQUERY?
===============================================================================

A subquery is a SELECT statement written inside another SQL statement.

The outer query uses the result returned by the inner query.

A subquery can be used inside:
    - SELECT
    - FROM
    - WHERE
    - HAVING

Subqueries can return:
    - A single value
    - A single row
    - Multiple rows
    - A table-like result

Types and techniques covered:
    - Scalar subquery
    - Single-row subquery
    - Multi-row subquery
    - Subquery with IN
    - Subquery with EXISTS
    - Correlated subquery

Example:

Find products priced above the average product price.

The inner query calculates the average price.
The outer query returns products priced above that average.
*/

SELECT product_id, product_name, price
FROM Products
WHERE price > (
    SELECT AVG(price)
    FROM Products
);


/*
===============================================================================
2. SCALAR SUBQUERY
===============================================================================

A scalar subquery returns exactly one value:
one row and one column.

Scalar subqueries are commonly used with:
    =, >, <, >=, <=, <>

If the subquery returns more than one value where one value is required,
SQL Server raises an error.

Example 1: Find products priced above the average product price.
*/

SELECT product_name, price
FROM Products
WHERE price > (
    SELECT AVG(price)
    FROM Products
)
ORDER BY price DESC;

/*
Expected products:
Laptop       65000.00
Smartphone   30000.00
Tablet       25000.00
Monitor      18000.00
*/


-- Example 2: Find employees earning more than the average employee salary.

SELECT employee_name, department, salary
FROM Employees
WHERE salary > (
    SELECT AVG(salary)
    FROM Employees
)
ORDER BY salary DESC;

/*
Expected employees:
Kavya Reddy    IT       80000.00
Suresh Kumar   Sales    65000.00
Pooja Sharma   Support  60000.00
*/


/*
===============================================================================
3. SINGLE-ROW SUBQUERY
===============================================================================

A single-row subquery returns one row.
It may return one or more columns, although comparison examples commonly
use one column.

Use operators such as:
    =, >, <, >=, <=, <>

Example: Find employees earning more than Suresh Kumar.

The inner query returns Suresh Kumar's salary as one row and one column.
*/

SELECT employee_name, department, salary
FROM Employees
WHERE salary > (
    SELECT salary
    FROM Employees
    WHERE employee_id = 101
)
ORDER BY salary DESC;

/*
Expected result:
Kavya Reddy    IT    80000.00

Suresh Kumar's salary is 65000.00.
Only Kavya Reddy earns more than that amount.
*/


-- Example 2: Find products costing more than the Headphones product.

SELECT product_name, price
FROM Products
WHERE price > (
    SELECT price
    FROM Products
    WHERE product_id = 203
)
ORDER BY price DESC;

/*
The subquery returns the price of Headphones: 2500.00.
The outer query returns products priced above 2500.00.
*/


/*
===============================================================================
4. MULTI-ROW SUBQUERY
===============================================================================

A multi-row subquery returns multiple rows.

Operators and keywords commonly used with multi-row subqueries:
    IN
    NOT IN
    EXISTS
    ANY
    ALL

A normal comparison such as = cannot compare a value directly
with a subquery returning multiple values.

Example: Find orders placed by customers from Hyderabad.

The inner query returns the IDs of customers from Hyderabad.
The outer query finds orders belonging to those customers.
*/

SELECT order_id, customer_id, order_date, order_status, total_amount
FROM Orders
WHERE customer_id IN (
    SELECT customer_id
    FROM Customers
    WHERE city = 'Hyderabad'
)
ORDER BY order_id;

/*
Expected order IDs:
1001, 1006, 1009, 1010
*/


/*
===============================================================================
5. SUBQUERY WITH IN
===============================================================================

IN checks whether a value matches any value returned by a subquery.

Syntax:

SELECT columns
FROM table_name
WHERE column_name IN (
    SELECT column_name
    FROM another_table
    WHERE condition
);

Example 1: Find customers who have placed at least one order.
*/

SELECT customer_id, customer_name, city
FROM Customers
WHERE customer_id IN (
    SELECT customer_id
    FROM Orders
)
ORDER BY customer_id;

/*
Expected customer IDs:
1, 2, 3, 4, 5, 6, 7, 8, 9, 10

All ten customers have at least one order in this dataset.
*/


-- Example 2: Find products included in orders with an order total
-- greater than 25000.

SELECT product_id, product_name, price
FROM Products
WHERE product_id IN (
    SELECT product_id
    FROM OrderItems
    WHERE order_id IN (
        SELECT order_id
        FROM Orders
        WHERE total_amount > 25000
    )
)
ORDER BY product_id;

/*
The innermost query identifies qualifying orders.
The middle query identifies products included in those orders.
The outer query returns product details.
*/


-- Example 3: Find customers who have not placed any orders using NOT IN.

SELECT customer_id, customer_name
FROM Customers
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM Orders
)
ORDER BY customer_id;

/*
Expected result: No rows.

Important:
NOT IN can behave unexpectedly if the subquery returns NULL.
The customer_id values in Orders are NOT NULL, so this example is safe.
For general cases, NOT EXISTS is often safer.
*/


/*
===============================================================================
6. SUBQUERY WITH EXISTS
===============================================================================

EXISTS checks whether a subquery returns at least one row.

It returns TRUE when at least one matching row exists.

NOT EXISTS returns TRUE when no matching row exists.

EXISTS is commonly used with correlated subqueries.

Example 1: Find customers who have placed orders.
*/

SELECT c.customer_id, c.customer_name
FROM Customers AS c
WHERE EXISTS (
    SELECT 1
    FROM Orders AS o
    WHERE o.customer_id = c.customer_id
)
ORDER BY c.customer_id;


/*
Example 2: Find customers who have never placed an order.
*/

SELECT c.customer_id, c.customer_name
FROM Customers AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders AS o
    WHERE o.customer_id = c.customer_id
)
ORDER BY c.customer_id;

/*
Expected result: No rows.

SELECT 1 is commonly used with EXISTS because the query checks
whether a matching row exists, not which columns are returned.
*/
/*
===============================================================================
SUBQUERY WITH ANY AND ALL
===============================================================================

ANY:
Returns TRUE if the comparison is true for at least one value returned
by the subquery.

ALL:
Returns TRUE only if the comparison is true for every value returned
by the subquery.

In SQL Server, SOME is a synonym for ANY.

Common comparison operators:
    =, >, <, >=, <=, <>

===============================================================================
1. SUBQUERY WITH ANY
===============================================================================

Example 1: Find products priced higher than ANY product in Accessories.

Meaning:
Return products whose price is greater than at least one
product price in the Accessories category.
*/

SELECT product_name, price
FROM Products
WHERE price > ANY (
    SELECT price
    FROM Products
    WHERE category = 'Accessories'
)
ORDER BY price DESC;

/*
Accessories prices: 1500, 800, 2200

The condition means price > at least one of these values.
A product priced above 800 satisfies the condition.
*/


-- Example 2: Find employees earning less than ANY employee in IT.

SELECT employee_name, department, salary
FROM Employees
WHERE salary < ANY (
    SELECT salary
    FROM Employees
    WHERE department = 'IT'
)
ORDER BY salary;


/*
IT salaries: 80000, 55000

The condition means salary < at least one IT salary.
An employee earning less than 80000 satisfies the condition.
*/


/*
===============================================================================
2. SUBQUERY WITH ALL
===============================================================================

Example 1: Find products priced higher than ALL products in Accessories.

Meaning:
Return products whose price is greater than every product price
in the Accessories category.
*/

SELECT product_name, price
FROM Products
WHERE price > ALL (
    SELECT price
    FROM Products
    WHERE category = 'Accessories'
)
ORDER BY price DESC;

/*
Accessories prices: 1500, 800, 2200

The condition means price > every value.
A product must cost more than 2200 to satisfy the condition.
*/


-- Example 2: Find employees earning more than ALL employees in IT.

SELECT employee_name, department, salary
FROM Employees
WHERE salary > ALL (
    SELECT salary
    FROM Employees
    WHERE department = 'IT'
)
ORDER BY salary DESC;

/*
IT salaries: 80000, 55000

The condition means salary > both 80000 and 55000.
Only employees earning more than 80000 satisfy the condition.

Expected result: No rows.
*/


/*
===============================================================================
3. ANY VS ALL
===============================================================================

ANY:
The comparison must be true for at least one returned value.

ALL:
The comparison must be true for every returned value.

Example:
    Price > ANY (subquery)
    Price > at least one value.

    Price > ALL (subquery)
    Price > every value.
*/

/*
===============================================================================
7. CORRELATED SUBQUERY
===============================================================================

A correlated subquery references a column from the outer query.

It depends on the current row of the outer query.

Unlike a simple independent subquery, it cannot be evaluated
without the outer query's row context.

Example 1: Find employees earning more than the average salary
in their own department.
*/

SELECT
    e.employee_id,
    e.employee_name,
    e.department,
    e.salary
FROM Employees AS e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM Employees AS e2
    WHERE e2.department = e.department
)
ORDER BY e.department, e.salary DESC;

/*
The inner query calculates the average salary for the department
of the current employee.

Expected employees:
Suresh Kumar   Sales    65000.00
Pooja Sharma   Support  60000.00
Kavya Reddy    IT       80000.00
*/


-- Example 2: Find customers who have placed more than one order.

SELECT
    c.customer_id,
    c.customer_name
FROM Customers AS c
WHERE (
    SELECT COUNT(*)
    FROM Orders AS o
    WHERE o.customer_id = c.customer_id
) > 1
ORDER BY c.customer_id;

/*
Expected customers:
Rahul Sharma
Priya Reddy
Sneha Patel
Vikram Singh
Anjali Rao
*/


-- Example 3: Find products priced above the average price
-- of their own category.

SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.price
FROM Products AS p
WHERE p.price > (
    SELECT AVG(p2.price)
    FROM Products AS p2
    WHERE p2.category = p.category
)
ORDER BY p.category, p.price DESC;

/*
The subquery calculates a separate average for each product category.
*/


/*
===============================================================================
8. SUBQUERY IN SELECT
===============================================================================

A subquery can appear in the SELECT list to calculate an additional value.

A scalar subquery used in SELECT must return a single value.

Example: Display each customer and the number of orders they placed.
*/

SELECT
    c.customer_id,
    c.customer_name,
    (
        SELECT COUNT(*)
        FROM Orders AS o
        WHERE o.customer_id = c.customer_id
    ) AS total_orders
FROM Customers AS c
ORDER BY c.customer_id;

/*
The correlated subquery counts orders for each customer.
Customers without orders would receive a count of zero.
*/


-- Example 2: Display each product alongside the average price
-- of all products.

SELECT
    p.product_name,
    p.price,
    (
        SELECT AVG(price)
        FROM Products
    ) AS average_product_price
FROM Products AS p
ORDER BY p.price DESC;

/*
The average product price is repeated for every product row.
*/


/*
===============================================================================
9. SUBQUERY IN FROM
===============================================================================

A subquery in the FROM clause creates a derived table.

A derived table must have an alias in SQL Server.

It can be useful when you want to aggregate data first
and then filter or join the aggregated results.

Example: Calculate total spending by customer and display
customers whose total order amount exceeds 40000.
*/

SELECT
    c.customer_id,
    c.customer_name,
    customer_totals.total_spending
FROM Customers AS c
INNER JOIN (
    SELECT
        customer_id,
        SUM(total_amount) AS total_spending
    FROM Orders
    GROUP BY customer_id
) AS customer_totals
    ON c.customer_id = customer_totals.customer_id
WHERE customer_totals.total_spending > 40000
ORDER BY customer_totals.total_spending DESC;

/*
The derived table calculates each customer's total order amount.
The outer query joins the result to Customers and filters it.
*/


-- Example 2: Find departments whose average salary is greater than 50000.

SELECT
    department_summary.department,
    department_summary.average_salary
FROM (
    SELECT
        department,
        AVG(salary) AS average_salary
    FROM Employees
    GROUP BY department
) AS department_summary
WHERE department_summary.average_salary > 50000
ORDER BY department_summary.average_salary DESC;


/*
===============================================================================
10. SUBQUERY IN WHERE
===============================================================================

A subquery in WHERE filters rows based on another query's result.

Examples:

1. Scalar comparison
2. IN
3. EXISTS
4. NOT EXISTS
5. Correlated subquery

Example 1: Find products priced above the overall average.
*/

SELECT product_id, product_name, price
FROM Products
WHERE price > (
    SELECT AVG(price)
    FROM Products
)
ORDER BY price DESC;


-- Example 2: Find orders placed by customers from Chennai.

SELECT order_id, customer_id, order_date, total_amount
FROM Orders
WHERE customer_id IN (
    SELECT customer_id
    FROM Customers
    WHERE city = 'Chennai'
)
ORDER BY order_id;


-- Example 3: Find products that have never been ordered.

SELECT p.product_id, p.product_name
FROM Products AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM OrderItems AS oi
    WHERE oi.product_id = p.product_id
)
ORDER BY p.product_id;

/*
Expected result:
No rows, because every product in the current dataset appears
in OrderItems at least once.
*/


/*
===============================================================================
11. COMMON MISTAKES
===============================================================================

1. A scalar subquery must return one value.
   Returning multiple rows in a scalar comparison causes an error.

2. A single-row subquery and a scalar subquery are not identical concepts.
   A single-row result may contain multiple columns.
   A scalar result contains exactly one row and one column.

3. IN can handle a list of values returned by a subquery.
   Do not use = when the subquery can return multiple rows.

4. NOT IN can produce unexpected results when the subquery includes NULL.
   Consider NOT EXISTS when NULL values are possible.

5. A correlated subquery must correctly reference the outer query.

6. A derived table in FROM needs an alias in SQL Server.

7. A subquery in SELECT must return a single value for each outer row.

8. Subqueries are not always slower than joins.
   Performance depends on the query, indexes, and execution plan.
*/


/*
===============================================================================
12. PRACTICE SECTION
===============================================================================

-----------------------------------------------------------------------------
12.1 SCALAR SUBQUERY
-----------------------------------------------------------------------------

Q1. Find products priced above the average product price.
Q2. Find employees earning more than the average employee salary.


-----------------------------------------------------------------------------
12.2 SINGLE-ROW SUBQUERY
-----------------------------------------------------------------------------

Q3. Find employees earning more than Suresh Kumar.
Q4. Find products priced higher than Headphones.


-----------------------------------------------------------------------------
12.3 MULTI-ROW SUBQUERY AND IN
-----------------------------------------------------------------------------

Q5. Find orders placed by customers from Hyderabad.
Q6. Find products included in orders with a total amount above 25000.
Q7. Find customers who have placed at least one order.


-----------------------------------------------------------------------------
12.4 EXISTS AND NOT EXISTS
-----------------------------------------------------------------------------

Q8. Find customers who have placed orders using EXISTS.
Q9. Find customers who have never placed orders using NOT EXISTS.
Q10. Find products that have never been ordered using NOT EXISTS.


-----------------------------------------------------------------------------
12.5 CORRELATED SUBQUERY
-----------------------------------------------------------------------------

Q11. Find employees earning more than their department's average salary.
Q12. Find customers who have placed more than one order.
Q13. Find products priced above the average price of their category.


-----------------------------------------------------------------------------
12.6 SUBQUERY IN SELECT
-----------------------------------------------------------------------------

Q14. Display each customer and their total number of orders.
Q15. Display each product and the overall average product price.


-----------------------------------------------------------------------------
12.7 SUBQUERY IN FROM
-----------------------------------------------------------------------------

Q16. Calculate each customer's total spending and return customers
     whose total spending exceeds 40000.
Q17. Calculate average salary by department and return departments
     with an average salary above 50000.


-----------------------------------------------------------------------------
12.8 SUBQUERY IN WHERE
-----------------------------------------------------------------------------

Q18. Find orders placed by customers from Chennai.
Q19. Find products priced above the overall average.
Q20. Find customers who have not placed any orders.


-----------------------------------------------------------------------------
12.9 SUBQUERIES VS OTHER TECHNIQUES
-----------------------------------------------------------------------------

Q21. Explain the difference between IN and EXISTS.
Q22. Explain the difference between a scalar and a correlated subquery.
Q23. Compare a correlated subquery with a JOIN or GROUP BY solution.
Q24. Explain why NOT EXISTS can be safer than NOT IN when NULL is possible.

 Q21. IN vs EXISTS
 ------------------
 IN checks whether a value matches any value returned by a subquery.
 EXISTS checks whether the subquery returns at least one row.


 Q22. Scalar Subquery vs Correlated Subquery
 -------------------------------------------
 A scalar subquery returns a single value.
 A correlated subquery depends on the outer query and references its columns.


 Q23. Correlated Subquery vs JOIN or GROUP BY
 --------------------------------------------
 A correlated subquery can calculate a result for each outer row.
 JOIN combines related rows, while GROUP BY groups rows for calculations.
 JOIN or GROUP BY can sometimes be more efficient, depending on the query.


 Q24. NOT EXISTS vs NOT IN with NULL
 -----------------------------------
 NOT IN can return unexpected results if the subquery contains NULL.
 NOT EXISTS checks for matching rows and avoids this NULL-related problem.

 -- -----------------------------------------------------------------------------
12.10 ANY
-- -----------------------------------------------------------------------------

Q25. Find products priced lower than ANY product in Electronics.
Q26. Find employees earning more than ANY employee in Support.
Q27. Find products priced higher than ANY product in Furniture.


-- -----------------------------------------------------------------------------
12.11 ALL
-- -----------------------------------------------------------------------------

Q28. Find products priced higher than ALL products in Furniture.
Q29 Find employees earning less than ALL employees in Sales.
Q30. Find products priced lower than ALL products in Electronics.
*/

/*
===============================================================================
13. QUICK REVISION
===============================================================================

SUBQUERY:
A query nested inside another SQL statement.

SCALAR SUBQUERY:
Returns one value: one row and one column.

SINGLE-ROW SUBQUERY:
Returns one row, potentially containing multiple columns.

MULTI-ROW SUBQUERY:
Returns multiple rows.

IN:
Checks whether a value matches any value in the returned set.

EXISTS:
Checks whether at least one row exists.

NOT EXISTS:
Checks whether no matching row exists.

CORRELATED SUBQUERY:
References a column from the outer query.

SUBQUERY IN SELECT:
Calculates an additional value for each outer row.

SUBQUERY IN FROM:
Creates a derived table that must have an alias.

SUBQUERY IN WHERE:
Filters rows using another query's result.

IMPORTANT:
- Use = for a single-value comparison.
- Use IN for membership in a set of values.
- Use EXISTS when checking whether matching rows exist.
- Be careful with NULL when using NOT IN.
- Correlated subqueries depend on the outer query's current row.

===============================================================================
END OF TOPIC 13: SUBQUERIES
===============================================================================
*/
