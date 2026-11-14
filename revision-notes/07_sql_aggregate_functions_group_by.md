# 06. SQL Aggregate Functions and GROUP BY

## 1. Aggregate Functions

Aggregate functions perform calculations on multiple rows and return a single result.

They are commonly used to summarize data.

### Important Aggregate Functions

| Function | Purpose |
|---|---|
| `COUNT()` | Counts rows or non-NULL values. |
| `SUM()` | Calculates the total. |
| `AVG()` | Calculates the average. |
| `MIN()` | Returns the minimum value. |
| `MAX()` | Returns the maximum value. |

### COUNT()

Counts rows or non-NULL values in a column.

```sql
-- Count all employees
SELECT COUNT(*) AS total_employees
FROM Employees;

-- Count employees with a non-NULL manager_id
SELECT COUNT(manager_id) AS employees_with_manager
FROM Employees;
```

### SUM()

Calculates the total of numeric values.

```sql
SELECT SUM(salary) AS total_salary
FROM Employees;
```

### AVG()

Calculates the average of numeric values.

```sql
SELECT AVG(salary) AS average_salary
FROM Employees;
```

### MIN()

Returns the smallest value.

```sql
SELECT MIN(salary) AS minimum_salary
FROM Employees;
```

### MAX()

Returns the largest value.

```sql
SELECT MAX(salary) AS maximum_salary
FROM Employees;
```

## 2. GROUP BY Clause

The `GROUP BY` clause groups rows that have the same values in specified columns.

It is commonly used with aggregate functions to calculate summaries for each group.

Example:

```sql
SELECT
    department,
    COUNT(*) AS total_employees
FROM Employees
GROUP BY department;
```

This counts employees in each department.

### GROUP BY with Multiple Columns

```sql
SELECT
    department,
    manager_id,
    COUNT(*) AS total_employees
FROM Employees
GROUP BY department, manager_id;
```

This groups employees by department and manager.

### GROUP BY with Multiple Aggregate Functions

```sql
SELECT
    department,
    COUNT(*) AS total_employees,
    SUM(salary) AS total_salary,
    AVG(salary) AS average_salary,
    MIN(salary) AS minimum_salary,
    MAX(salary) AS maximum_salary
FROM Employees
GROUP BY department;
```

## 3. GROUP BY with WHERE

WHERE filters rows before grouping takes place.

```sql
SELECT
    department,
    AVG(salary) AS average_salary
FROM Employees
WHERE salary > 30000
GROUP BY department;
```

This calculates the average salary for employees earning more than 30,000 in each department.

## 4. Important Differences

### COUNT(*) vs COUNT(column) vs COUNT(DISTINCT column)

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Function</th>
<th>Purpose</th>
</tr>
<tr>
<td><code>COUNT(*)</code></td>
<td>Counts all rows, including rows containing NULL values.</td>
</tr>
<tr>
<td><code>COUNT(column)</code></td>
<td>Counts non-NULL values in the specified column.</td>
</tr>
<tr>
<td><code>COUNT(DISTINCT column)</code></td>
<td>Counts unique non-NULL values in the specified column.</td>
</tr>
</table>

### SUM() vs AVG()

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>SUM()</th>
<th>AVG()</th>
</tr>
<tr>
<td>Calculates the total.</td>
<td>Calculates the average.</td>
</tr>
<tr>
<td>Adds numeric values.</td>
<td>Divides the sum by the number of non-NULL values.</td>
</tr>
</table>

### Aggregate Functions vs GROUP BY

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Aggregate Functions</th>
<th>GROUP BY</th>
</tr>
<tr>
<td>Perform calculations on multiple rows.</td>
<td>Divides rows into groups.</td>
</tr>
<tr>
<td>Can return one overall result.</td>
<td>Returns a result for each group when used with aggregates.</td>
</tr>
<tr>
<td>Examples: SUM(), AVG(), COUNT().</td>
<td>Example: GROUP BY department.</td>
</tr>
</table>

## 5. Important Rules

- Aggregate functions generally ignore NULL values, except `COUNT(*)`, which counts rows.
- `COUNT(column)` counts only non-NULL values.
- `COUNT(DISTINCT column)` counts unique non-NULL values.
- GROUP BY can contain one or multiple columns.
- In a grouped query, selected columns generally must be grouped, aggregated, or otherwise valid according to the database's grouping rules.
- WHERE filters rows before grouping.
- GROUP BY does not automatically guarantee the order of results.

## 6. Frequently Asked Interview Questions

**1. What are aggregate functions?**

Functions that perform calculations on multiple rows and return a summarized result.

**2. What are the commonly used aggregate functions?**

COUNT(), SUM(), AVG(), MIN(), and MAX().

**3. What is GROUP BY?**

GROUP BY groups rows with matching values for summary calculations.

**4. What is the difference between COUNT(*) and COUNT(column)?**

COUNT(*) counts all rows, while COUNT(column) counts only non-NULL values.

**5. Does AVG() include NULL values?**

No. AVG() ignores NULL values.

**6. Does SUM() include NULL values?**

No. SUM() ignores NULL values.

**7. Can we use multiple aggregate functions in one query?**

Yes. We can use COUNT(), SUM(), AVG(), MIN(), and MAX() together.

**8. Can GROUP BY use multiple columns?**

Yes. Multiple columns can be specified in GROUP BY.

**9. Can we use WHERE with GROUP BY?**

Yes. WHERE filters rows before GROUP BY performs grouping.

**10. Can we use aggregate functions without GROUP BY?**

Yes. Aggregate functions can calculate an overall result for the selected rows.

**11. Does GROUP BY sort the result?**

No. Use ORDER BY when a specific sorting order is required.

**12. What happens when NULL values are present in a GROUP BY column?**

Rows with NULL in that grouping column are generally grouped together.

## 7. Common Mistakes

- Confusing COUNT(*) with COUNT(column).
- Assuming aggregate functions count or calculate NULL values.
- Forgetting required GROUP BY columns.
- Using aggregate functions directly in WHERE.
- Assuming GROUP BY automatically sorts results.
- Using DISTINCT unnecessarily with aggregate functions.
- Confusing GROUP BY with PARTITION BY.
- Forgetting that AVG() ignores NULL values.

## 8. Quick Revision

- Aggregate Functions = Summarize multiple rows.
- COUNT(*) = Counts all rows.
- COUNT(column) = Counts non-NULL values.
- COUNT(DISTINCT column) = Counts unique non-NULL values.
- SUM() = Total.
- AVG() = Average.
- MIN() = Minimum.
- MAX() = Maximum.
- GROUP BY = Groups matching values.
- WHERE = Filters rows before grouping.
- GROUP BY does not guarantee sorting.