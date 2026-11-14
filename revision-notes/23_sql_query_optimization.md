# 23. SQL Query Optimization

## 1. What is Query Optimization?

**Query Optimization** is the process of improving SQL queries so they execute faster and use fewer database resources.

The goal is to retrieve the required results efficiently without unnecessary operations.

**Example:**

A query that retrieves all records from a large table may take longer than a query that retrieves only the required columns and rows.

## 2. Why is Query Optimization Important?

- Improves query execution speed.
- Reduces CPU and memory usage.
- Reduces unnecessary disk operations.
- Improves database performance.
- Handles large datasets efficiently.
- Improves application response time.

## 3. What is a Query Execution Plan?

A **Query Execution Plan** describes how the database engine executes a SQL query.

It shows the operations performed by the database to retrieve or modify data.

A query execution plan can include:

- Table Scan.
- Index Scan.
- Index Seek.
- Sort.
- Filter.
- Nested Loops.
- Hash Match.
- Merge Join.

**SQL Server example:**

```sql
SELECT *
FROM Orders
WHERE customer_id = 101;
```

In SQL Server Management Studio (SSMS), you can view the execution plan using:

- Display Estimated Execution Plan.
- Include Actual Execution Plan.

**Shortcuts in SSMS:**

- Estimated Execution Plan: `Ctrl + L`
- Actual Execution Plan: `Ctrl + M`, then execute the query.

## 4. Estimated vs Actual Execution Plan

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Feature</th>
<th>Estimated Plan</th>
<th>Actual Plan</th>
</tr>
<tr>
<td>Execution</td>
<td>Does not execute the query.</td>
<td>Executes the query.</td>
</tr>
<tr>
<td>Information</td>
<td>Shows the optimizer's estimated operations and costs.</td>
<td>Shows the actual operations and runtime information.</td>
</tr>
<tr>
<td>Use</td>
<td>Understand the planned execution.</td>
<td>Investigate actual query performance.</td>
</tr>
</table>

## 5. Use SELECT Instead of SELECT *

Avoid selecting unnecessary columns.

**Less efficient:**

```sql
SELECT *
FROM Customers;
```

**Better:**

```sql
SELECT customer_id, customer_name, city
FROM Customers;
```

Selecting only required columns can reduce data transfer and resource usage.

## 6. Use WHERE to Filter Rows

Use appropriate filtering conditions to retrieve only the required records.

**Less efficient:**

```sql
SELECT *
FROM Orders;
```

**Better:**

```sql
SELECT order_id, customer_id, total_amount
FROM Orders
WHERE order_status = 'Delivered';
```

Filtering reduces the number of rows returned.

## 7. Use Indexes Properly

Indexes can improve data retrieval when queries frequently filter, join, or sort using suitable columns.

**Example:**

```sql
CREATE INDEX idx_orders_customer_id
ON Orders (customer_id);
```

Query:

```sql
SELECT order_id, total_amount
FROM Orders
WHERE customer_id = 101;
```

The optimizer may use the index to locate matching records efficiently.

**Important:** An index does not guarantee faster execution. The optimizer decides whether using it is beneficial.

## 8. Avoid Functions on Indexed Columns in WHERE

Applying functions to indexed columns can make it harder for the database to use an index efficiently.

**Less efficient:**

```sql
SELECT *
FROM Orders
WHERE YEAR(order_date) = 2025;
```

**Better:**

```sql
SELECT *
FROM Orders
WHERE order_date >= '2025-01-01'
AND order_date < '2026-01-01';
```

The second query uses a date range and can make an index on `order_date` more useful.

This is commonly called writing a SARGable condition.

## 9. What is SARGable?

**SARGable** means Search ARGument ABLE.

A SARGable condition allows the database optimizer to use an index efficiently for searching or filtering.

**Less SARGable:**

```sql
SELECT *
FROM Customers
WHERE LOWER(customer_name) = 'ravi';
```

**Potentially more SARGable:**

```sql
SELECT *
FROM Customers
WHERE customer_name = 'Ravi';
```

The second example can use an index more effectively, depending on the column's collation and query requirements.

## 10. Use EXISTS Instead of IN When Appropriate

`EXISTS` checks whether a subquery returns at least one row.

**Example using IN:**

```sql
SELECT customer_id, customer_name
FROM Customers
WHERE customer_id IN (
    SELECT customer_id
    FROM Orders
);
```

**Example using EXISTS:**

```sql
SELECT c.customer_id, c.customer_name
FROM Customers c
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.customer_id = c.customer_id
);
```

Both queries return customers who have placed orders.

**Important:** EXISTS is not always faster than IN. Modern database optimizers can transform both queries into similar execution plans. Choose based on the required logic and compare execution plans.

## 11. Avoid Unnecessary DISTINCT

`DISTINCT` removes duplicate rows from the result.

However, it may require additional sorting or hashing operations.

**Example:**

```sql
SELECT DISTINCT customer_id
FROM Orders;
```

Use `DISTINCT` only when duplicate elimination is required.

Do not use it unnecessarily to hide incorrect JOIN conditions.

## 12. Use UNION ALL When Duplicates Are Allowed

`UNION` removes duplicate rows, while `UNION ALL` keeps duplicates.

**Example using UNION:**

```sql
SELECT customer_id
FROM CampaignA

UNION

SELECT customer_id
FROM CampaignB;
```

**Example using UNION ALL:**

```sql
SELECT customer_id
FROM CampaignA

UNION ALL

SELECT customer_id
FROM CampaignB;
```

`UNION ALL` can be faster because it does not need to eliminate duplicates.

Use it when duplicate rows are acceptable or required.

## 13. Avoid Unnecessary Subqueries

Some queries can be written more simply using JOINs or EXISTS.

**Example:**

```sql
SELECT customer_id, customer_name
FROM Customers
WHERE customer_id IN (
    SELECT customer_id
    FROM Orders
    WHERE order_status = 'Delivered'
);
```

An alternative using EXISTS:

```sql
SELECT c.customer_id, c.customer_name
FROM Customers c
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.customer_id = c.customer_id
    AND o.order_status = 'Delivered'
);
```

The best approach depends on the query, indexes, data distribution, and execution plan.

## 14. Avoid Unnecessary ORDER BY

Sorting data requires database resources.

Use `ORDER BY` only when the result must be returned in a particular order.

**Example:**

```sql
SELECT order_id, total_amount
FROM Orders
WHERE order_status = 'Delivered'
ORDER BY order_date DESC;
```

If ordering is not required, avoid adding unnecessary sorting.

## 15. Use LIMIT or TOP to Retrieve Required Rows

When only a limited number of rows are required, avoid retrieving the entire result set.

**SQL Server:**

```sql
SELECT TOP 10 *
FROM Orders
ORDER BY order_date DESC;
```

**MySQL / PostgreSQL:**

```sql
SELECT *
FROM Orders
ORDER BY order_date DESC
LIMIT 10;
```

Using TOP or LIMIT can reduce the amount of data returned. The database may still need to examine or sort many rows depending on the execution plan and available indexes.

## 16. Avoid Leading Wildcards in LIKE

A leading wildcard can prevent efficient index seeks on a normal B-tree index.

**Example:**

```sql
SELECT *
FROM Customers
WHERE customer_name LIKE '%Ravi';
```

This searches for names ending in Ravi.

A normal index generally cannot efficiently seek using this leading-wildcard pattern.

**Better for prefix searches:**

```sql
SELECT *
FROM Customers
WHERE customer_name LIKE 'Ravi%';
```

A prefix search may use an index efficiently, depending on the database and query conditions.

## 17. Choose Appropriate Data Types

Use suitable data types for columns.

Examples:

- `INT` for integer identifiers.
- `DATE` for dates without time.
- `DECIMAL` for precise financial values.
- `VARCHAR` for variable-length text.

Avoid unnecessarily large or inappropriate data types.

Using compatible data types in JOIN and WHERE conditions also helps avoid implicit conversions that can affect performance.

## 18. Avoid Unnecessary JOINs

Only join tables that are required to retrieve the requested information.

**Example:**

If you only need customer details, do not join the `Orders` table unnecessarily.

```sql
SELECT customer_id, customer_name
FROM Customers;
```

Unnecessary joins can increase query complexity and processing cost.

## 19. Understand JOIN Algorithms

Database optimizers can choose different algorithms to execute joins.

Common join algorithms include:

### 19.1 Nested Loops Join

Compares rows from one input with matching rows from another input.

It can be efficient when one input is small and the other has a suitable index.

### 19.2 Hash Join

Builds a hash table from one input and uses it to find matches in the other input.

It is commonly useful for larger unsorted inputs.

### 19.3 Merge Join

Uses sorted inputs to match rows efficiently.

It can be useful when both inputs are already sorted on the join columns.

### Comparison

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Join Algorithm</th>
<th>How It Works</th>
<th>Common Use</th>
</tr>
<tr>
<td>Nested Loops</td>
<td>Searches for matching rows for each row in one input.</td>
<td>Small input with suitable indexing.</td>
</tr>
<tr>
<td>Hash Join</td>
<td>Uses a hash table to match rows.</td>
<td>Larger unsorted inputs.</td>
</tr>
<tr>
<td>Merge Join</td>
<td>Matches rows from sorted inputs.</td>
<td>Inputs sorted on join columns.</td>
</tr>
</table>

## 20. What is Query Cost?

Query cost is an estimate used by the query optimizer to compare possible execution plans.

It can consider factors such as:

- CPU usage.
- I/O operations.
- Memory requirements.
- Estimated number of rows.
- Sorting and joining operations.

**Important:** An estimated query cost is not the actual execution time.

## 21. What are Statistics?

Statistics contain information about the distribution of values in table columns and indexes.

The query optimizer uses statistics to estimate how many rows a query will return and choose an execution plan.

In SQL Server:

```sql
UPDATE STATISTICS Orders;
```

This updates statistics for the `Orders` table.

**Important:** SQL Server also updates statistics automatically under supported conditions. Manual updates should be based on performance needs.

## 22. Common Performance Problems

### 22.1 Table Scan

A table scan reads table rows to find matching records.

It may be inefficient for selective queries on large tables, but can be appropriate when a large percentage of rows is required.

### 22.2 Missing Index

A missing suitable index can cause unnecessary data scanning.

### 22.3 Implicit Conversion

Using incompatible data types in comparisons can cause conversions that affect index usage and performance.

### 22.4 Excessive Sorting

Unnecessary `ORDER BY` operations can increase query cost.

### 22.5 Too Many Indexes

Too many indexes consume storage and increase the cost of INSERT, UPDATE, and DELETE operations.

## 23. Frequently Asked Interview Questions

**1. What is query optimization?**

Query optimization is the process of improving SQL query performance and reducing unnecessary resource usage.

**2. What is a query execution plan?**

It describes the operations the database engine uses to execute a query.

**3. What is an index seek?**

An operation that uses an index to locate specific rows.

**4. What is an index scan?**

An operation that reads through index entries to find matching rows.

**5. What is a table scan?**

An operation that reads table rows to find matching records.

**6. What is SARGable?**

A SARGable condition allows the optimizer to use an index efficiently for searching or filtering.

**7. Why should we avoid SELECT *?**

It retrieves unnecessary columns, which can increase data transfer and resource usage.

**8. Why can functions on indexed columns affect performance?**

They can make index-based searching less efficient because the database may need to calculate the function for many rows.

**9. Is EXISTS always faster than IN?**

No. Modern optimizers can produce similar execution plans for both. Performance depends on the query and data.

**10. What is the difference between UNION and UNION ALL?**

UNION removes duplicate rows, while UNION ALL keeps duplicates.

**11. What are database statistics?**

Statistics describe data distribution and help the optimizer estimate query results.

**12. What is a hash join?**

A join algorithm that uses a hash table to match rows between two inputs.

**13. What is a nested loops join?**

A join algorithm that searches for matching rows from one input for each row in another input.

**14. What is a merge join?**

A join algorithm that matches rows from sorted inputs.

**15. What is query cost?**

An optimizer estimate used to compare execution plans.

## 24. Common Mistakes

- Using `SELECT *` unnecessarily.
- Creating indexes without analyzing query patterns.
- Assuming indexes always improve performance.
- Using unnecessary DISTINCT.
- Using UNION when UNION ALL is sufficient.
- Applying functions to indexed columns unnecessarily.
- Ignoring execution plans.
- Ignoring outdated or inaccurate statistics.
- Adding unnecessary JOINs.
- Assuming the query with fewer lines always performs better.
- Optimizing based only on estimated cost instead of actual runtime and resource usage.

## 25. Quick Revision

- **Query Optimization:** Improves query execution performance.
- **Execution Plan:** Shows how a query is executed.
- **Index Seek:** Locates rows using an index.
- **Index Scan:** Reads index entries.
- **Table Scan:** Reads table rows.
- **SARGable:** Allows efficient index-based searching.
- **Statistics:** Help the optimizer estimate data distribution.
- **Query Cost:** Estimated cost of an execution plan.
- **Nested Loops:** Matches rows using repeated searches.
- **Hash Join:** Uses a hash table to match rows.
- **Merge Join:** Matches sorted inputs.
- **UNION:** Removes duplicates.
- **UNION ALL:** Keeps duplicates.
- **Best Practice:** Measure performance and examine execution plans before optimizing.