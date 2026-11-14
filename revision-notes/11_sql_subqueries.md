# 05. SQL Subqueries

## 1. Definition

A **subquery** is a SQL query written inside another SQL query.

- The inner query is called the **subquery**.
- The outer query is called the **main query**.
- Subqueries are used to retrieve data that the main query needs.

Example:

```sql
SELECT *
FROM Employees
WHERE salary > (
    SELECT AVG(salary)
    FROM Employees
);
```

This query retrieves employees whose salaries are greater than the average salary.

## 2. Types of Subqueries

### Based on Result

- **Single-row subquery:** Returns one row.
- **Multiple-row subquery:** Returns multiple rows.
- **Scalar subquery:** Returns exactly one value (one row and one column).
- **Multiple-column subquery:** Returns more than one column.

### Based on Dependency

- **Non-correlated subquery:** Executes independently of the outer query.
- **Correlated subquery:** References a column from the outer query.

Example of a correlated subquery:

```sql
SELECT e.employee_name, e.salary
FROM Employees e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM Employees e2
    WHERE e2.department = e.department
);
```

This retrieves employees earning more than their department's average salary.

## 3. Important Operators

### IN

Checks whether a value matches any value returned by a subquery.

```sql
SELECT *
FROM Customers
WHERE customer_id IN (
    SELECT customer_id
    FROM Orders
);
```

### EXISTS

Checks whether a subquery returns at least one row.

```sql
SELECT *
FROM Customers c
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.customer_id = c.customer_id
);
```

### ANY

Returns TRUE if the comparison is true for at least one value returned by the subquery.

```sql
SELECT *
FROM Employees
WHERE salary > ANY (
    SELECT salary
    FROM Employees
    WHERE department = 'Sales'
);
```

### ALL

Returns TRUE if the comparison is true for every value returned by the subquery.

```sql
SELECT *
FROM Employees
WHERE salary > ALL (
    SELECT salary
    FROM Employees
    WHERE department = 'Sales'
);
```

### NOT EXISTS

Returns rows for which the subquery does not return any matching rows.

```sql
SELECT *
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.customer_id = c.customer_id
);
```

## 4. Important Differences

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Feature</th>
<th>Meaning</th>
</tr>
<tr>
<td><code>IN</code></td>
<td>Checks whether a value matches any value in a list or subquery result.</td>
</tr>
<tr>
<td><code>EXISTS</code></td>
<td>Checks whether the subquery returns at least one row.</td>
</tr>
<tr>
<td><code>ANY</code></td>
<td>Comparison must be true for at least one returned value.</td>
</tr>
<tr>
<td><code>ALL</code></td>
<td>Comparison must be true for every returned value.</td>
</tr>
<tr>
<td><code>NOT EXISTS</code></td>
<td>Checks whether no matching row exists.</td>
</tr>
</table>

### ANY vs ALL

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>ANY</th>
<th>ALL</th>
</tr>
<tr>
<td>True if at least one comparison is true.</td>
<td>True if every comparison is true.</td>
</tr>
<tr>
<td>Less restrictive.</td>
<td>More restrictive.</td>
</tr>
<tr>
<td><code>&gt; ANY</code> means greater than at least one value.</td>
<td><code>&gt; ALL</code> means greater than every value.</td>
</tr>
</table>

### Correlated vs Non-Correlated Subquery

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Non-Correlated</th>
<th>Correlated</th>
</tr>
<tr>
<td>Independent of the outer query.</td>
<td>References the outer query.</td>
</tr>
<tr>
<td>Can execute independently.</td>
<td>Depends on values from the outer query.</td>
</tr>
<tr>
<td>Does not refer to outer query columns.</td>
<td>Uses outer query columns.</td>
</tr>
</table>

### Subquery vs JOIN

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Subquery</th>
<th>JOIN</th>
</tr>
<tr>
<td>Uses a query inside another query.</td>
<td>Combines rows from multiple tables.</td>
</tr>
<tr>
<td>Useful for filtering and comparisons.</td>
<td>Useful for retrieving related columns from tables.</td>
</tr>
<tr>
<td>Can sometimes be rewritten as a JOIN.</td>
<td>Can sometimes replace a subquery.</td>
</tr>
</table>

## 5. Frequently Asked Interview Questions

**1. What is a subquery?**

A query written inside another SQL query.

**2. What is a correlated subquery?**

A subquery that references columns from the outer query.

**3. What is the difference between IN and EXISTS?**

- IN compares a value against values returned by a subquery.
- EXISTS checks whether the subquery returns at least one row.

**4. What is the difference between ANY and ALL?**

- ANY requires at least one comparison to be true.
- ALL requires every comparison to be true.

**5. Can a subquery return multiple rows?**

Yes. Multiple-row subqueries can return multiple rows, but a scalar subquery must return at most one row.

**6. What happens if a scalar subquery returns multiple rows?**

The database generally raises an error in a scalar context.

**7. Can we use a subquery inside SELECT?**

Yes. A scalar subquery can be used in the SELECT list.

**8. Can we use a subquery inside FROM?**

Yes. A subquery in the FROM clause is commonly called a derived table.

**9. What is the difference between NOT IN and NOT EXISTS?**

- NOT IN excludes values found in the subquery result.
- NOT EXISTS checks for the absence of matching rows.
- NOT IN can produce unexpected results when the subquery returns NULL.

**10. Are subqueries slower than JOINs?**

Not always. Performance depends on the query, database optimizer, indexes, and data. Compare execution plans instead of assuming one is always faster.

## 6. Common Mistakes

- Using `=` when a subquery can return multiple rows.
- Using `NOT IN` without considering NULL values.
- Forgetting the relationship condition in a correlated subquery.
- Confusing `ANY` with `ALL`.
- Assuming correlated subqueries always execute physically once per outer row.
- Assuming JOINs are always faster than subqueries.
- Returning multiple columns from a scalar subquery.

## 7. Quick Revision

- Subquery = Query inside another query.
- Scalar subquery = One value.
- Multiple-row subquery = Multiple rows.
- Correlated subquery = Depends on the outer query.
- Non-correlated subquery = Independent of the outer query.
- IN = Matches any value.
- EXISTS = Checks whether rows exist.
- ANY = At least one comparison is true.
- ALL = Every comparison is true.
- NOT EXISTS = No matching row exists.
- Derived table = Subquery in the FROM clause.