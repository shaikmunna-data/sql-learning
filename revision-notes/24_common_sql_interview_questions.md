# 24. Common SQL Interview Questions

## 1. SQL Fundamentals

**1. What is SQL?**

SQL (Structured Query Language) is a language used to create, manage, manipulate, and retrieve data from relational databases.

**2. What is a database?**

A database is an organized collection of data that can be stored, accessed, and managed electronically.

**3. What is an RDBMS?**

RDBMS stands for Relational Database Management System. It stores data in related tables consisting of rows and columns.

Examples: SQL Server, MySQL, PostgreSQL, and Oracle.

**4. What is the difference between SQL and MySQL?**

SQL is a query language, whereas MySQL is a relational database management system that uses SQL.

**5. What are the different types of SQL commands?**

- DDL: CREATE, ALTER, DROP, TRUNCATE.
- DML: INSERT, UPDATE, DELETE.
- DQL: SELECT.
- DCL: GRANT, REVOKE.
- TCL: COMMIT, ROLLBACK, SAVEPOINT.

**6. What is a table?**

A table is a database object that stores data in rows and columns.

**7. What is a primary key?**

A primary key uniquely identifies each row in a table. It cannot contain NULL values or duplicate values.

**8. What is a foreign key?**

A foreign key is a column or group of columns that references a candidate key, commonly a primary key, in another or the same table.

**9. What is the difference between PRIMARY KEY and UNIQUE KEY?**

A primary key uniquely identifies rows and does not allow NULL values. A UNIQUE constraint also prevents duplicate values, but NULL handling depends on the database system.

**10. What is NULL in SQL?**

NULL represents missing, unknown, or unavailable information. It is not the same as zero or an empty string.

## 2. SELECT, Filtering and Operators

**11. What is the difference between WHERE and HAVING?**

WHERE filters rows before grouping, while HAVING filters groups after GROUP BY.

**12. What is DISTINCT?**

DISTINCT removes duplicate rows from the query result.

```sql
SELECT DISTINCT city
FROM Customers;
```

**13. What is the difference between DELETE, TRUNCATE, and DROP?**

- DELETE removes selected rows.
- TRUNCATE removes all rows from a table.
- DROP removes the table itself.

**14. What is the difference between BETWEEN and IN?**

BETWEEN checks whether a value falls within a range, while IN checks whether a value matches any value in a specified list.

**15. What is the LIKE operator?**

LIKE is used for pattern matching.

```sql
SELECT *
FROM Customers
WHERE customer_name LIKE 'A%';
```

**16. What are wildcards in SQL?**

Wildcards represent characters in pattern matching.

- `%` matches zero or more characters.
- `_` matches exactly one character.

**17. What is the difference between AND and OR?**

AND requires all specified conditions to be true. OR requires at least one condition to be true.

**18. What is an alias in SQL?**

An alias temporarily assigns another name to a column or table.

```sql
SELECT customer_name AS Name
FROM Customers;
```

**19. What is the difference between ORDER BY and GROUP BY?**

ORDER BY sorts query results, while GROUP BY combines rows into groups for aggregation.

**20. What is the difference between UNION and UNION ALL?**

UNION combines results and removes duplicate rows. UNION ALL combines results and keeps duplicates.

## 3. SQL Functions and Aggregation

**21. What are aggregate functions?**

Aggregate functions perform calculations on multiple rows and return a single result per group or for the entire result set.

Examples: COUNT(), SUM(), AVG(), MIN(), MAX().

**22. What is the difference between COUNT(*) and COUNT(column_name)?**

COUNT(*) counts rows, while COUNT(column_name) counts non-NULL values in that column.

**23. What is the difference between COUNT and DISTINCT?**

COUNT counts values or rows, while DISTINCT removes duplicate result values. They can also be combined:

```sql
SELECT COUNT(DISTINCT city)
FROM Customers;
```

**24. What is the difference between IS NULL and = NULL?**

IS NULL checks whether a value is NULL. Using `= NULL` does not correctly test for NULL because NULL represents an unknown value.

**25. What is COALESCE() in SQL?**

COALESCE() returns the first non-NULL expression.

```sql
SELECT COALESCE(email, 'Not Available')
FROM Customers;
```

**26. What is NULLIF() in SQL?**

NULLIF() returns NULL when two expressions are equal; otherwise, it returns the first expression.

**27. What is the CASE expression?**

CASE performs conditional logic in SQL and returns a value based on matching conditions.

```sql
SELECT
    order_id,
    CASE
        WHEN total_amount >= 10000 THEN 'High'
        WHEN total_amount >= 5000 THEN 'Medium'
        ELSE 'Low'
    END AS order_category
FROM Orders;
```

**28. What is the difference between CHAR and VARCHAR?**

CHAR is fixed-length character storage, while VARCHAR is variable-length character storage. Exact storage behavior depends on the database system.

**29. What is the difference between GETDATE() and CURRENT_TIMESTAMP?**

In SQL Server, both return the current database system timestamp as a datetime value.

**30. What is a scalar function?**

A scalar function returns a single value for each invocation.

Examples include UPPER(), LOWER(), ROUND(), and LEN() in SQL Server.

## 4. SQL Joins and Relationships

**31. What is a JOIN in SQL?**

A JOIN combines rows from two or more tables based on a related column or join condition.

**32. What are the different types of JOINs?**

- INNER JOIN
- LEFT JOIN
- RIGHT JOIN
- FULL OUTER JOIN
- CROSS JOIN
- SELF JOIN

**33. What is INNER JOIN?**

INNER JOIN returns only rows that have matching values in both tables.

**34. What is LEFT JOIN?**

LEFT JOIN returns all rows from the left table and matching rows from the right table. Unmatched right-side columns contain NULL.

**35. What is RIGHT JOIN?**

RIGHT JOIN returns all rows from the right table and matching rows from the left table.

**36. What is FULL OUTER JOIN?**

FULL OUTER JOIN returns matching and non-matching rows from both tables. Unmatched columns contain NULL.

**37. What is CROSS JOIN?**

CROSS JOIN returns the Cartesian product of two tables.

**38. What is SELF JOIN?**

A SELF JOIN joins a table with itself.

Example: Finding employees and their managers.

```sql
SELECT
    e.employee_name AS Employee,
    m.employee_name AS Manager
FROM Employees e
LEFT JOIN Employees m
    ON e.manager_id = m.employee_id;
```

**39. What is the difference between INNER JOIN and LEFT JOIN?**

INNER JOIN returns only matching rows, whereas LEFT JOIN also returns unmatched rows from the left table.

**40. What is the difference between JOIN and UNION?**

JOIN combines columns from related tables, while UNION combines rows from compatible SELECT results.

## 5. Subqueries and CTEs

**41. What is a subquery?**

A subquery is a query written inside another SQL query.

**42. What is a correlated subquery?**

A correlated subquery references columns from the outer query and is logically evaluated for the outer query's rows.

**43. What is the difference between IN and EXISTS?**

IN checks whether a value matches a value in a set. EXISTS checks whether a subquery returns at least one row.

**44. What is the difference between ANY and ALL?**

ANY compares a value against at least one value returned by a subquery. ALL requires the comparison to be true for every returned value.

**45. What is a CTE?**

A Common Table Expression (CTE) is a named temporary result set defined using the WITH clause and used within a single SQL statement.

**46. What is a recursive CTE?**

A recursive CTE references itself to process hierarchical or sequential data.

Example: Employee-manager hierarchy.

**47. What is the difference between CTE and subquery?**

A CTE is a named query expression defined using WITH. A subquery is a query nested inside another query. Both can improve query organization, depending on the situation.

**48. Can we use multiple CTEs in one query?**

Yes. Multiple CTEs can be defined in a single WITH clause, separated by commas.

**49. What is the difference between CTE and temporary table?**

A CTE exists for one statement, while a temporary table can be used across multiple statements during its lifetime.

**50. Can we use ORDER BY inside a CTE?**

Generally, ORDER BY is not allowed inside a CTE unless supported in a context such as TOP or OFFSET/FETCH in SQL Server. The final result order should be specified using the outer query's ORDER BY.

## 6. Window Functions

**51. What is a window function?**

A window function performs calculations across related rows without combining them into a single result row.

**52. What is the difference between GROUP BY and window functions?**

GROUP BY combines rows into groups, while window functions retain individual rows and calculate values across a related set of rows.

**53. What is the OVER() clause?**

OVER() defines the window of rows used by a window function.

**54. What is PARTITION BY?**

PARTITION BY divides rows into separate groups for window calculations without combining the rows.

**55. What is ROW_NUMBER()?**

ROW_NUMBER() assigns a unique sequential number to each row within a specified ordering and partition.

**56. What is the difference between RANK() and DENSE_RANK()?**

RANK() assigns the same rank to tied values and leaves gaps after ties. DENSE_RANK() assigns the same rank to ties without leaving gaps.

**57. What is the difference between ROW_NUMBER(), RANK(), and DENSE_RANK()?**

| Function | Behavior |
|---|---|
| ROW_NUMBER() | Gives every row a unique number. |
| RANK() | Gives tied rows the same rank and leaves gaps. |
| DENSE_RANK() | Gives tied rows the same rank without gaps. |

**58. What is NTILE()?**

NTILE(n) divides ordered rows into approximately equal groups and assigns each row a group number.

**59. What are LAG() and LEAD()?**

LAG() accesses a value from a preceding row, while LEAD() accesses a value from a following row.

**60. What is the difference between aggregate and window functions?**

Aggregate functions generally return one result per group, while window functions calculate across rows and preserve individual result rows.

## 7. Constraints, Views and Database Objects

**61. What are SQL constraints?**

Constraints are rules applied to columns or tables to maintain data accuracy and integrity.

Examples: PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL, CHECK, DEFAULT.

**62. What is a CHECK constraint?**

A CHECK constraint ensures that values satisfy a specified condition.

```sql
CHECK (salary > 0)
```

**63. What is a DEFAULT constraint?**

A DEFAULT constraint supplies a value when an INSERT statement does not provide one for the column.

**64. What is a VIEW?**

A view is a virtual table based on the result of a stored SQL query.

**65. What is the difference between a VIEW and a TABLE?**

A table stores data, while a regular view stores a query definition and retrieves data from its underlying objects when queried.

**66. What is a materialized view?**

A materialized view stores the result of a query physically and requires a refresh or maintenance mechanism. Support and behavior vary across database systems.

**67. What is a stored procedure?**

A stored procedure is a named database program containing SQL statements that can be executed when needed.

**68. What is a user-defined function (UDF)?**

A UDF is a function created by a database user to perform reusable calculations or operations and return a value or table, depending on its type.

**69. What is the difference between a stored procedure and a function?**

A stored procedure is designed to perform database operations and can return result sets or output parameters. A function returns a value or table and is subject to restrictions on side effects and how it can be invoked.

**70. What is a trigger?**

A trigger is a database object that automatically executes in response to specified database events, such as INSERT, UPDATE, or DELETE.

## 8. Transactions, Indexes and Database Design

**71. What is a transaction?**

A transaction is a group of SQL operations treated as a single logical unit of work.

**72. What are ACID properties?**

- Atomicity
- Consistency
- Isolation
- Durability

**73. What is the difference between COMMIT and ROLLBACK?**

COMMIT saves transaction changes, while ROLLBACK cancels uncommitted changes.

**74. What is an index?**

An index is a database structure that helps retrieve records more efficiently.

**75. What is the difference between clustered and non-clustered indexes?**

A clustered index determines the organization of table rows. A non-clustered index is a separate structure containing indexed values and references to table rows.

**76. What is a composite index?**

A composite index is an index created on two or more columns.

**77. What are the disadvantages of indexes?**

Indexes require storage and can increase the cost of INSERT, UPDATE, and DELETE operations because they must be maintained.

**78. What is normalization?**

Normalization organizes database tables to reduce redundancy and prevent data anomalies.

**79. What are 1NF, 2NF, and 3NF?**

- 1NF: Atomic values and no repeating groups.
- 2NF: 1NF plus no partial dependency of non-key attributes on a candidate key.
- 3NF: 2NF plus no transitive dependency of non-key attributes on a candidate key.

**80. What is denormalization?**

Denormalization intentionally introduces redundancy or combines data to improve read performance.

## 9. SQL Security and Performance

**81. What is SQL Injection?**

SQL Injection is an attack in which malicious input manipulates SQL queries.

**82. How can SQL Injection be prevented?**

Use parameterized queries, avoid unsafe string concatenation, validate inputs, and apply least-privilege permissions.

**83. What is GRANT?**

GRANT provides permissions to a database user or role.

**84. What is query optimization?**

Query optimization improves SQL query performance by reducing unnecessary operations and resource usage.

**85. What is an execution plan?**

An execution plan describes the operations the database engine uses to execute a query.

**86. What is an index seek?**

An index seek uses an index to locate specific rows.

**87. What is an index scan?**

An index scan reads through index entries to find matching rows.

**88. What is a table scan?**

A table scan reads table rows to find the required records.

**89. What is SARGable?**

SARGable means Search ARGument ABLE. It describes a condition that allows efficient index-based searching or filtering.

**90. Why should we avoid SELECT *?**

Because it retrieves unnecessary columns, potentially increasing data transfer and resource usage.

## 10. Practical SQL Query Questions

Assume the following tables:

- Employees(employee_id, employee_name, department, salary, manager_id)
- Customers(customer_id, customer_name, city)
- Orders(order_id, customer_id, order_date, order_status, total_amount)
- Products(product_id, product_name, category, price, stock_quantity)

**91. How do you find the second-highest salary?**

```sql
SELECT MAX(salary) AS second_highest_salary
FROM Employees
WHERE salary < (
    SELECT MAX(salary)
    FROM Employees
);
```

This returns the second-highest distinct salary.

**92. How do you find duplicate records based on a column?**

```sql
SELECT customer_name, COUNT(*) AS total
FROM Customers
GROUP BY customer_name
HAVING COUNT(*) > 1;
```

**93. How do you find employees earning more than the average salary?**

```sql
SELECT *
FROM Employees
WHERE salary > (
    SELECT AVG(salary)
    FROM Employees
);
```

**94. How do you find the highest salary in each department?**

```sql
SELECT
    department,
    MAX(salary) AS highest_salary
FROM Employees
GROUP BY department;
```

**95. How do you find the top three highest-paid employees in each department?**

```sql
WITH RankedEmployees AS (
    SELECT
        employee_id,
        employee_name,
        department,
        salary,
        DENSE_RANK() OVER (
            PARTITION BY department
            ORDER BY salary DESC
        ) AS salary_rank
    FROM Employees
)
SELECT *
FROM RankedEmployees
WHERE salary_rank <= 3;
```

This returns the top three distinct salary ranks in each department, including ties.

**96. How do you find customers who have never placed an order?**

```sql
SELECT c.*
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.customer_id = c.customer_id
);
```

**97. How do you find the total sales amount for each customer?**

```sql
SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS total_sales
FROM Customers c
JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name;
```

**98. How do you find the latest order for each customer?**

```sql
WITH LatestOrders AS (
    SELECT
        order_id,
        customer_id,
        order_date,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date DESC, order_id DESC
        ) AS rn
    FROM Orders
)
SELECT *
FROM LatestOrders
WHERE rn = 1;
```

**99. How do you find products that have never been ordered?**

Assuming an OrderItems table with a `product_id` column:

```sql
SELECT p.*
FROM Products p
WHERE NOT EXISTS (
    SELECT 1
    FROM OrderItems oi
    WHERE oi.product_id = p.product_id
);
```

**100. How do you calculate a running total of sales?**

```sql
SELECT
    order_id,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        ORDER BY order_date, order_id
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS running_total
FROM Orders;
```

## 11. Interview Preparation Tips

- Understand concepts instead of memorizing definitions.
- Practice writing SQL queries without looking at notes.
- Explain the logic behind every query.
- Practice JOINs, subqueries, CTEs, and window functions.
- Understand NULL handling and duplicate records.
- Learn to read execution plans.
- Practice using realistic datasets.
- Be prepared to explain the difference between similar SQL concepts.
- Test queries using SQL Server or another relational database system.

## 12. Final Quick Revision

| Area | Important Concepts |
|---|---|
| Fundamentals | SQL, RDBMS, keys, constraints |
| Querying | SELECT, WHERE, DISTINCT, ORDER BY |
| Operators | AND, OR, IN, BETWEEN, LIKE |
| Functions | COUNT, SUM, AVG, MIN, MAX |
| Grouping | GROUP BY, HAVING |
| Conditional Logic | CASE |
| Joins | INNER, LEFT, RIGHT, FULL, CROSS, SELF |
| Subqueries | IN, EXISTS, ANY, ALL |
| CTEs | Non-recursive and recursive CTEs |
| Window Functions | ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD |
| Database Objects | Views, procedures, functions, triggers |
| Transactions | ACID, COMMIT, ROLLBACK |
| Indexes | Clustered, non-clustered, composite |
| Database Design | 1NF, 2NF, 3NF, BCNF |
| Security | GRANT, REVOKE, DENY, SQL Injection |
| Optimization | Execution plans, indexes, SARGable queries |

## Conclusion

Completing these 100 questions gives you a strong foundation for SQL interview preparation.

However, interview readiness also requires practical query-writing skills, understanding execution behavior, and explaining your solutions clearly.