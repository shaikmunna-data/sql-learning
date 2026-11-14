# 02. SELECT, DISTINCT and Aliases

## 1. SELECT Statement

The `SELECT` statement is used to retrieve data from one or more database tables.

### Selecting All Columns

```sql
SELECT *
FROM Employees;
```

The `*` symbol retrieves all columns from the table.

### Selecting Specific Columns

```sql
SELECT employee_name, department, salary
FROM Employees;
```

Retrieves only the specified columns.

### Selecting Calculated Expressions

```sql
SELECT
    employee_name,
    salary,
    salary * 12 AS annual_salary
FROM Employees;
```

Retrieves employee details and calculates annual salary.

### Selecting Unique Expressions

```sql
SELECT 100 AS employee_bonus;
```

A SELECT statement can also return calculated values without reading from a table.

## 2. DISTINCT Keyword

The `DISTINCT` keyword removes duplicate rows from the query result.

### DISTINCT on One Column

```sql
SELECT DISTINCT department
FROM Employees;
```

Returns each department only once.

### DISTINCT on Multiple Columns

```sql
SELECT DISTINCT department, employee_name
FROM Employees;
```

Returns unique combinations of department and employee name.

### DISTINCT with COUNT

```sql
SELECT COUNT(DISTINCT department) AS total_departments
FROM Employees;
```

Counts the number of unique departments.

## 3. Aliases

An **alias** is a temporary name assigned to a column or table within a SQL query.

### Column Alias

Used to give a column or calculated expression a readable name.

```sql
SELECT
    employee_name AS name,
    salary AS monthly_salary
FROM Employees;
```

### Table Alias

Used to give a table a shorter name within a query.

```sql
SELECT
    e.employee_name,
    e.salary
FROM Employees AS e;
```

### Alias Without AS

The `AS` keyword is optional in many SQL databases.

```sql
SELECT employee_name name
FROM Employees;
```

Using `AS` is generally clearer and easier to read.

## 4. Important Differences

### SELECT * vs SELECT Specific Columns

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>SELECT *</th>
<th>SELECT Specific Columns</th>
</tr>
<tr>
<td>Retrieves all columns.</td>
<td>Retrieves only selected columns.</td>
</tr>
<tr>
<td>Can return unnecessary data.</td>
<td>Returns only required data.</td>
</tr>
<tr>
<td>Useful for quick inspection.</td>
<td>Preferred for production queries.</td>
</tr>
</table>

### DISTINCT vs ALL

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>DISTINCT</th>
<th>ALL</th>
</tr>
<tr>
<td>Removes duplicate result rows.</td>
<td>Includes duplicate result rows.</td>
</tr>
<tr>
<td>Used to retrieve unique results.</td>
<td>Default behavior of SELECT in standard SQL.</td>
</tr>
</table>

### Column Alias vs Table Alias

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Column Alias</th>
<th>Table Alias</th>
</tr>
<tr>
<td>Renames a column in the query result.</td>
<td>Gives a shorter name to a table in the query.</td>
</tr>
<tr>
<td>Example: <code>salary AS monthly_salary</code></td>
<td>Example: <code>Employees AS e</code></td>
</tr>
<tr>
<td>Improves output readability.</td>
<td>Simplifies table references.</td>
</tr>
</table>

## 5. Frequently Asked Interview Questions

**1. What is the purpose of SELECT?**

To retrieve data from database tables or return calculated expressions.

**2. What does SELECT * mean?**

It retrieves all columns from the specified table or query source.

**3. What is DISTINCT?**

DISTINCT removes duplicate rows from the query result.

**4. Can DISTINCT be used with multiple columns?**

Yes. It returns unique combinations of the selected columns.

**5. Does DISTINCT remove duplicates from only one column?**

No. When multiple columns are selected, DISTINCT considers the complete combination of those columns.

**6. What is the difference between COUNT(*) and COUNT(DISTINCT column)?**

- COUNT(*) counts rows.
- COUNT(DISTINCT column) counts unique non-NULL values.

**7. What is an alias in SQL?**

An alias is a temporary name assigned to a column or table within a query.

**8. Is AS mandatory when creating an alias?**

No. In many SQL databases, AS is optional.

**9. Can we use an alias in WHERE?**

Generally, a SELECT-list alias cannot be referenced in the WHERE clause because WHERE is logically processed before SELECT.

**10. Can we use an alias in ORDER BY?**

Yes. In most SQL databases, SELECT-list aliases can be used in ORDER BY.

## 6. Common Mistakes

- Using SELECT * when only a few columns are required.
- Confusing DISTINCT on one column with DISTINCT on multiple columns.
- Assuming DISTINCT removes duplicate records from the original table.
- Forgetting that DISTINCT considers the complete selected row.
- Assuming COUNT(DISTINCT column) counts NULL values.
- Using a SELECT-list alias directly in WHERE.
- Confusing column aliases with table aliases.
- Forgetting to use table aliases when column names are ambiguous.

## 7. Quick Revision

- SELECT = Retrieves data.
- SELECT * = Retrieves all columns.
- SELECT column = Retrieves specific columns.
- DISTINCT = Removes duplicate result rows.
- DISTINCT with multiple columns = Returns unique combinations.
- COUNT(*) = Counts rows.
- COUNT(DISTINCT column) = Counts unique non-NULL values.
- Column Alias = Temporary name for a result column.
- Table Alias = Short name for a table.
- AS = Defines an alias.
- Aliases = Improve readability and simplify queries.