# 03. SQL WHERE Clause

## 1. Definition

The `WHERE` clause is used to filter rows based on specified conditions.

Only rows that satisfy the condition are returned.

Example:

```sql
SELECT *
FROM Employees
WHERE department = 'Sales';
```

This retrieves employees who belong to the Sales department.

## 2. Filtering with WHERE

### Filtering Text Values

```sql
SELECT *
FROM Employees
WHERE department = 'IT';
```

### Filtering Numeric Values

```sql
SELECT *
FROM Employees
WHERE salary > 50000;
```

### Filtering Date Values

```sql
SELECT *
FROM Orders
WHERE order_date >= '2026-01-01';
```

### Filtering Multiple Conditions

```sql
SELECT *
FROM Employees
WHERE department = 'Sales'
AND salary > 40000;
```

### Filtering with Multiple Values

```sql
SELECT *
FROM Employees
WHERE department IN ('Sales', 'IT', 'Support');
```

## 3. Important WHERE Conditions

| Condition | Purpose |
|---|---|
| `=` | Equal to |
| `<>` | Not equal to |
| `>` | Greater than |
| `<` | Less than |
| `>=` | Greater than or equal to |
| `<=` | Less than or equal to |
| `AND` | All conditions must be true |
| `OR` | At least one condition must be true |
| `NOT` | Reverses a condition |
| `IN` | Matches values in a list |
| `BETWEEN` | Checks an inclusive range |
| `LIKE` | Matches a text pattern |
| `IS NULL` | Checks for NULL |
| `IS NOT NULL` | Checks for non-NULL values |

## 4. Important Filtering Techniques

### AND

Returns rows when all specified conditions are true.

```sql
SELECT *
FROM Employees
WHERE department = 'Sales'
AND salary > 50000;
```

### OR

Returns rows when at least one condition is true.

```sql
SELECT *
FROM Employees
WHERE department = 'Sales'
OR department = 'IT';
```

### IN

Checks whether a value matches any value in a specified list.

```sql
SELECT *
FROM Employees
WHERE department IN ('Sales', 'IT');
```

### BETWEEN

Filters values within an inclusive range.

```sql
SELECT *
FROM Employees
WHERE salary BETWEEN 30000 AND 60000;
```

Both boundary values are included.

### LIKE

Searches for values matching a specified text pattern.

```sql
SELECT *
FROM Employees
WHERE employee_name LIKE 'A%';
```

Common wildcards:

| Wildcard | Meaning |
|---|---|
| `%` | Zero or more characters |
| `_` | Exactly one character |

Examples:

```sql
-- Names starting with A
WHERE employee_name LIKE 'A%';

-- Names ending with a
WHERE employee_name LIKE '%a';

-- Names containing an
WHERE employee_name LIKE '%an%';

-- Names with A as the second character
WHERE employee_name LIKE '_A%';
```

Pattern matching and case sensitivity depend on the database and collation.

### IS NULL

Checks whether a column contains NULL values.

```sql
SELECT *
FROM Customers
WHERE email IS NULL;
```

### IS NOT NULL

Checks whether a column contains a non-NULL value.

```sql
SELECT *
FROM Customers
WHERE email IS NOT NULL;
```

## 5. Important Differences

### WHERE vs HAVING

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>WHERE</th>
<th>HAVING</th>
</tr>
<tr>
<td>Filters individual rows.</td>
<td>Filters grouped results.</td>
</tr>
<tr>
<td>Applied before GROUP BY.</td>
<td>Applied after GROUP BY.</td>
</tr>
<tr>
<td>Cannot normally filter using aggregate conditions directly.</td>
<td>Can filter using aggregate conditions.</td>
</tr>
</table>

### AND vs OR

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>AND</th>
<th>OR</th>
</tr>
<tr>
<td>All conditions must be true.</td>
<td>At least one condition must be true.</td>
</tr>
<tr>
<td>Usually makes filtering more restrictive.</td>
<td>Usually makes filtering less restrictive.</td>
</tr>
</table>

### IN vs BETWEEN

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>IN</th>
<th>BETWEEN</th>
</tr>
<tr>
<td>Matches specific values.</td>
<td>Checks a range of values.</td>
</tr>
<tr>
<td><code>department IN ('IT', 'Sales')</code></td>
<td><code>salary BETWEEN 30000 AND 60000</code></td>
</tr>
</table>

### = NULL vs IS NULL

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>= NULL</th>
<th>IS NULL</th>
</tr>
<tr>
<td>Does not correctly test for NULL.</td>
<td>Correctly checks for NULL.</td>
</tr>
<tr>
<td>Evaluates to UNKNOWN in standard SQL.</td>
<td>Returns TRUE when the value is NULL.</td>
</tr>
</table>

## 6. Frequently Asked Interview Questions

**1. What is the purpose of WHERE?**

It filters rows based on specified conditions.

**2. Can we use multiple conditions in WHERE?**

Yes. We can combine conditions using AND, OR, and NOT.

**3. What is the difference between WHERE and HAVING?**

WHERE filters rows before grouping, while HAVING filters grouped results.

**4. What is the difference between AND and OR?**

AND requires all conditions to be true, while OR requires at least one condition to be true.

**5. What is BETWEEN?**

BETWEEN filters values within an inclusive range.

**6. What is the difference between IN and OR?**

IN checks a value against multiple specified values. OR combines multiple conditions.

**7. What is LIKE used for?**

LIKE is used for pattern matching in text values.

**8. What is the difference between % and _ in LIKE?**

- `%` matches zero or more characters.
- `_` matches exactly one character.

**9. How do you find NULL values?**

Use `IS NULL` or `IS NOT NULL`.

**10. Can we use aggregate functions directly in WHERE?**

Generally, no. Use HAVING to filter grouped aggregate results.

**11. What happens when a condition evaluates to UNKNOWN?**

In a WHERE clause, only rows for which the condition is TRUE are returned. FALSE and UNKNOWN rows are filtered out.

**12. Can WHERE be used without SELECT?**

WHERE is used as part of statements such as SELECT, UPDATE, and DELETE, but it is not a standalone SQL statement.

## 7. Common Mistakes

- Using `= NULL` instead of `IS NULL`.
- Forgetting quotes around text values.
- Using AND when OR is required, or vice versa.
- Forgetting that BETWEEN includes both boundary values.
- Using aggregate functions directly in WHERE.
- Ignoring wildcard positions in LIKE.
- Forgetting parentheses when combining AND and OR.
- Assuming LIKE is case-sensitive in every database.
- Forgetting that NULL comparisons can produce UNKNOWN.

## 8. Quick Revision

- WHERE = Filters rows.
- AND = All conditions must be true.
- OR = At least one condition must be true.
- NOT = Reverses a condition.
- IN = Matches values in a list.
- BETWEEN = Checks an inclusive range.
- LIKE = Pattern matching.
- `%` = Zero or more characters.
- `_` = Exactly one character.
- IS NULL = Checks NULL values.
- IS NOT NULL = Checks non-NULL values.
- HAVING = Filters grouped results.