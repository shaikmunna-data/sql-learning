# 07. SQL HAVING Clause

## 1. What is the HAVING Clause?

The `HAVING` clause is used to filter grouped records based on conditions, usually involving aggregate functions.

- `WHERE` filters individual rows before grouping.
- `HAVING` filters groups after grouping.

## 2. Syntax

```sql
SELECT column_name, AGGREGATE_FUNCTION(column_name)
FROM table_name
GROUP BY column_name
HAVING condition;
```

## 3. Basic Example

Find departments where the average salary is greater than 50,000.

```sql
SELECT
    department,
    AVG(salary) AS avg_salary
FROM Employees
GROUP BY department
HAVING AVG(salary) > 50000;
```

## 4. HAVING with COUNT()

Find customers who have placed at least three orders.

```sql
SELECT
    customer_id,
    COUNT(*) AS total_orders
FROM Orders
GROUP BY customer_id
HAVING COUNT(*) >= 3;
```

## 5. HAVING with SUM()

Find customers whose total order amount is greater than 50,000.

```sql
SELECT
    customer_id,
    SUM(total_amount) AS total_spent
FROM Orders
GROUP BY customer_id
HAVING SUM(total_amount) > 50000;
```

## 6. WHERE and HAVING Together

Find departments where employees earning more than 30,000 have an average salary greater than 50,000.

```sql
SELECT
    department,
    AVG(salary) AS avg_salary
FROM Employees
WHERE salary > 30000
GROUP BY department
HAVING AVG(salary) > 50000;
```

**Execution concept:**

1. `WHERE` filters individual employee records.
2. `GROUP BY` groups the remaining records by department.
3. `HAVING` filters departments based on their average salary.

## 7. HAVING Without GROUP BY

`HAVING` can also be used without an explicit `GROUP BY` when filtering an aggregate result.

```sql
SELECT
    COUNT(*) AS total_orders
FROM Orders
HAVING COUNT(*) > 100;
```

The query treats the complete result as one group.

## 8. WHERE vs HAVING

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>WHERE</th>
<th>HAVING</th>
</tr>
<tr>
<td>Filters individual rows.</td>
<td>Filters groups.</td>
</tr>
<tr>
<td>Applied before grouping.</td>
<td>Applied after grouping.</td>
</tr>
<tr>
<td>Generally used without aggregate conditions.</td>
<td>Commonly used with aggregate functions.</td>
</tr>
<tr>
<td>Can be used without GROUP BY.</td>
<td>Can be used with or without GROUP BY.</td>
</tr>
<tr>
<td>Example: <code>WHERE salary > 30000</code></td>
<td>Example: <code>HAVING AVG(salary) > 50000</code></td>
</tr>
</table>

## 9. Important Rules

- `HAVING` is commonly used with `GROUP BY`.
- Aggregate functions such as `COUNT()`, `SUM()`, and `AVG()` are commonly used in `HAVING`.
- `WHERE` filters rows before grouping.
- `HAVING` filters groups after aggregation.
- A condition that does not depend on aggregation should generally be placed in `WHERE` when possible.

## 10. Frequently Asked Interview Questions

**1. What is the HAVING clause?**

`HAVING` filters grouped records based on specified conditions.

**2. What is the difference between WHERE and HAVING?**

`WHERE` filters rows before grouping, whereas `HAVING` filters groups after grouping.

**3. Can we use HAVING without GROUP BY?**

Yes. It can filter the result of an aggregate query treated as one group.

**4. Can we use aggregate functions in WHERE?**

Generally, no. Aggregate conditions belong in `HAVING`.

**5. Can WHERE and HAVING be used together?**

Yes. `WHERE` filters rows first, and `HAVING` filters the resulting groups.

**6. Can HAVING be used with COUNT()?**

Yes. For example:

```sql
HAVING COUNT(*) > 5
```

**7. Does HAVING always require GROUP BY?**

No. It can also be used without an explicit `GROUP BY`.

**8. Which is generally more efficient: WHERE or HAVING?**

Filtering rows with `WHERE` before grouping can reduce the amount of data that needs to be grouped. Use `HAVING` for group-level conditions.

## 11. Common Mistakes

- Using `WHERE` instead of `HAVING` for aggregate conditions.
- Using `HAVING` when a row-level condition belongs in `WHERE`.
- Forgetting to include non-aggregated selected columns in `GROUP BY`.
- Confusing row filtering with group filtering.

## 12. Quick Revision

- `HAVING` filters groups.
- `WHERE` filters rows.
- `GROUP BY` creates groups.
- Aggregate functions are commonly used with `HAVING`.
- `WHERE` and `HAVING` can be used together.
- `HAVING` can work without an explicit `GROUP BY`.