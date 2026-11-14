# 05. SQL TOP, LIMIT, FETCH and OFFSET

## 1. Definition

SQL provides different clauses to restrict the number of rows returned by a query.

They are useful for:
- Retrieving a limited number of records.
- Finding top-performing employees or products.
- Displaying the latest records.
- Implementing pagination.

## 2. TOP

`TOP` is commonly used in SQL Server to limit the number of rows returned.

### Retrieve Top 5 Employees

```sql
SELECT TOP 5 *
FROM Employees;
```

### Retrieve Top 5 Highest-Paid Employees

```sql
SELECT TOP 5 *
FROM Employees
ORDER BY salary DESC;
```

### TOP with PERCENT

Retrieves a percentage of the result rows.

```sql
SELECT TOP 10 PERCENT *
FROM Employees
ORDER BY salary DESC;
```

### TOP WITH TIES

Includes additional rows that have the same ordering value as the last selected row.

```sql
SELECT TOP 3 WITH TIES *
FROM Employees
ORDER BY salary DESC;
```

## 3. LIMIT

`LIMIT` is supported by databases such as MySQL, PostgreSQL and SQLite.

### Retrieve First 5 Employees

```sql
SELECT *
FROM Employees
LIMIT 5;
```

### Retrieve Top 5 Highest-Paid Employees

```sql
SELECT *
FROM Employees
ORDER BY salary DESC
LIMIT 5;
```

## 4. FETCH

`FETCH` is used with `OFFSET` as part of SQL's row-limiting syntax. Support and exact syntax vary by database.

Example:

```sql
SELECT *
FROM Employees
ORDER BY salary DESC
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY;
```

This retrieves the first five highest-paid employees.

## 5. OFFSET

`OFFSET` skips a specified number of rows before returning the remaining rows or the requested limited number.

Example:

```sql
SELECT *
FROM Employees
ORDER BY employee_id
OFFSET 5 ROWS;
```

This skips the first five rows.

### OFFSET with FETCH

```sql
SELECT *
FROM Employees
ORDER BY employee_id
OFFSET 5 ROWS
FETCH NEXT 5 ROWS ONLY;
```

This skips the first five rows and retrieves the next five.

## 6. Pagination

Pagination divides query results into smaller pages.

Example: Displaying 5 employees per page.

**Page 1:**

```sql
SELECT *
FROM Employees
ORDER BY employee_id
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY;
```

**Page 2:**

```sql
SELECT *
FROM Employees
ORDER BY employee_id
OFFSET 5 ROWS
FETCH NEXT 5 ROWS ONLY;
```

**Page 3:**

```sql
SELECT *
FROM Employees
ORDER BY employee_id
OFFSET 10 ROWS
FETCH NEXT 5 ROWS ONLY;
```

Pagination is commonly used in websites, dashboards, and applications.

## 7. Important Differences

### TOP vs LIMIT vs FETCH

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>TOP</th>
<th>LIMIT</th>
<th>FETCH</th>
</tr>
<tr>
<td>Commonly used in SQL Server.</td>
<td>Used in MySQL, PostgreSQL and SQLite.</td>
<td>Supported by several SQL databases.</td>
</tr>
<tr>
<td>Written after SELECT.</td>
<td>Written at the end of the query.</td>
<td>Used with OFFSET in row-limiting syntax.</td>
</tr>
<tr>
<td><code>SELECT TOP 5 *</code></td>
<td><code>LIMIT 5</code></td>
<td><code>FETCH NEXT 5 ROWS ONLY</code></td>
</tr>
</table>

### LIMIT vs OFFSET

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>LIMIT</th>
<th>OFFSET</th>
</tr>
<tr>
<td>Restricts the number of returned rows.</td>
<td>Skips a specified number of rows.</td>
</tr>
<tr>
<td>Controls page size.</td>
<td>Controls the starting position.</td>
</tr>
</table>

## 8. Frequently Asked Interview Questions

**1. What is TOP in SQL?**

TOP restricts the number or percentage of rows returned by a query in SQL Server.

**2. What is LIMIT in SQL?**

LIMIT restricts the number of rows returned by a query in supported databases.

**3. What is FETCH?**

FETCH specifies how many rows to retrieve after an optional OFFSET.

**4. What is OFFSET?**

OFFSET skips a specified number of rows before returning results.

**5. What is pagination?**

Pagination divides a large result set into smaller pages.

**6. What is the difference between TOP and LIMIT?**

Both restrict returned rows, but their syntax and database support differ.

**7. Can we use ORDER BY with TOP or LIMIT?**

Yes. ORDER BY determines which rows are selected when limiting results.

**8. What is TOP WITH TIES?**

It includes additional rows tied with the last selected row based on the ORDER BY values.

**9. Can we use OFFSET without FETCH?**

Yes. Some databases support OFFSET alone to skip rows, but syntax varies.

**10. Why is ORDER BY important when using pagination?**

It provides a defined and consistent row order. A unique tie-breaker is recommended to avoid unstable page results.

## 9. Common Mistakes

- Using TOP syntax in a database that does not support it.
- Using LIMIT syntax in SQL Server.
- Forgetting ORDER BY when retrieving top records.
- Confusing LIMIT with OFFSET.
- Using an incorrect OFFSET value for a page.
- Assuming query results have a guaranteed order without ORDER BY.
- Ignoring duplicate sort values when implementing pagination.
- Assuming all databases use identical FETCH syntax.

## 10. Quick Revision

- TOP = Limits rows in SQL Server.
- LIMIT = Limits rows in supported databases.
- FETCH = Specifies the number of rows to retrieve.
- OFFSET = Skips rows.
- TOP WITH TIES = Includes tied rows.
- ORDER BY = Determines which rows are selected.
- Pagination = Divides results into pages.
- Stable pagination = Use ORDER BY with a unique tie-breaker.