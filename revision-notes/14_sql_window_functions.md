# 07. SQL Window Functions

## 1. Definition

**Window functions** perform calculations across a set of related rows without combining them into a single row.

Unlike aggregate functions with `GROUP BY`, window functions preserve individual rows.

Example:

```sql
SELECT
    employee_id,
    employee_name,
    department,
    salary,
    AVG(salary) OVER (
        PARTITION BY department
    ) AS department_avg_salary
FROM Employees;
```

This displays each employee along with their department's average salary.

## 2. Important Concepts

### OVER()

The `OVER()` clause defines the window of rows used by a window function.

```sql
SELECT
    employee_name,
    salary,
    SUM(salary) OVER () AS total_salary
FROM Employees;
```

An empty `OVER()` applies the calculation across the entire result set.

### PARTITION BY

Divides rows into groups for window calculations without reducing the number of rows.

```sql
SELECT
    employee_name,
    department,
    salary,
    AVG(salary) OVER (
        PARTITION BY department
    ) AS department_avg
FROM Employees;
```

### ORDER BY

Defines the order of rows within the window. It is important for ranking, running totals, and value functions.

```sql
SELECT
    employee_name,
    salary,
    RANK() OVER (
        ORDER BY salary DESC
    ) AS salary_rank
FROM Employees;
```

### ROWS / RANGE

Defines the frame of rows used by a window calculation.

```sql
SELECT
    employee_name,
    salary,
    SUM(salary) OVER (
        ORDER BY employee_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM Employees;
```

Common frame boundaries:

- `UNBOUNDED PRECEDING` – From the beginning of the partition.
- `CURRENT ROW` – The current row.
- `UNBOUNDED FOLLOWING` – Through the end of the partition.
- `n PRECEDING` – A specified number of rows before the current row.
- `n FOLLOWING` – A specified number of rows after the current row.

## 3. Types of Window Functions

### Ranking Functions

| Function | Purpose |
|---|---|
| `ROW_NUMBER()` | Assigns a unique sequential number to each row. |
| `RANK()` | Assigns ranks with gaps when values are tied. |
| `DENSE_RANK()` | Assigns ranks without gaps when values are tied. |
| `NTILE(n)` | Divides rows into approximately equal groups. |
| `PERCENT_RANK()` | Calculates the relative rank of a row. |
| `CUME_DIST()` | Calculates the cumulative distribution of a row. |

Example:

```sql
SELECT
    employee_name,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num,
    RANK() OVER (ORDER BY salary DESC) AS salary_rank,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rank
FROM Employees;
```

### Difference Between Ranking Functions

Assume salaries are:

`60000, 50000, 50000, 40000`

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Salary</th>
<th>ROW_NUMBER</th>
<th>RANK</th>
<th>DENSE_RANK</th>
</tr>
<tr><td>60000</td><td>1</td><td>1</td><td>1</td></tr>
<tr><td>50000</td><td>2</td><td>2</td><td>2</td></tr>
<tr><td>50000</td><td>3</td><td>2</td><td>2</td></tr>
<tr><td>40000</td><td>4</td><td>4</td><td>3</td></tr>
</table>

### Aggregate Window Functions

Aggregate functions can also be used as window functions.

| Function | Purpose |
|---|---|
| `SUM()` | Calculates a sum. |
| `AVG()` | Calculates an average. |
| `COUNT()` | Counts rows or non-NULL values. |
| `MIN()` | Returns the minimum value. |
| `MAX()` | Returns the maximum value. |

Example:

```sql
SELECT
    employee_name,
    department,
    salary,
    SUM(salary) OVER (
        PARTITION BY department
    ) AS department_total,
    AVG(salary) OVER (
        PARTITION BY department
    ) AS department_average
FROM Employees;
```

### Value Functions

| Function | Purpose |
|---|---|
| `LAG()` | Accesses a value from a previous row. |
| `LEAD()` | Accesses a value from a following row. |
| `FIRST_VALUE()` | Returns the first value in the window frame. |
| `LAST_VALUE()` | Returns the last value in the window frame. |
| `NTH_VALUE()` | Returns the value at a specified position in the window frame. |

Example:

```sql
SELECT
    employee_name,
    salary,
    LAG(salary) OVER (
        ORDER BY employee_id
    ) AS previous_salary,
    LEAD(salary) OVER (
        ORDER BY employee_id
    ) AS next_salary
FROM Employees;
```

## 4. Important Differences

### GROUP BY vs Window Functions

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>GROUP BY</th>
<th>Window Functions</th>
</tr>
<tr>
<td>Combines rows into groups.</td>
<td>Preserves individual rows.</td>
</tr>
<tr>
<td>Usually returns one row per group.</td>
<td>Returns a calculated value for each row.</td>
</tr>
<tr>
<td>Used for grouped summaries.</td>
<td>Used for ranking, comparisons, and analytical calculations.</td>
</tr>
</table>

### PARTITION BY vs ORDER BY

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>PARTITION BY</th>
<th>ORDER BY</th>
</tr>
<tr>
<td>Divides rows into groups.</td>
<td>Defines the order of rows.</td>
</tr>
<tr>
<td>Calculations are performed separately for each partition.</td>
<td>Calculations follow the specified row order.</td>
</tr>
<tr>
<td>Does not itself define row sequence.</td>
<td>Does not itself divide rows into groups.</td>
</tr>
</table>

### ROW_NUMBER vs RANK vs DENSE_RANK

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Function</th>
<th>Unique Numbers</th>
<th>Gaps After Ties</th>
</tr>
<tr>
<td><code>ROW_NUMBER()</code></td>
<td>Yes</td>
<td>Not applicable; every row gets a different number.</td>
</tr>
<tr>
<td><code>RANK()</code></td>
<td>No, tied rows share a rank.</td>
<td>Yes</td>
</tr>
<tr>
<td><code>DENSE_RANK()</code></td>
<td>No, tied rows share a rank.</td>
<td>No</td>
</tr>
</table>

### LAG vs LEAD

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>LAG()</th>
<th>LEAD()</th>
</tr>
<tr>
<td>Accesses a previous row's value.</td>
<td>Accesses a following row's value.</td>
</tr>
<tr>
<td>Useful for previous-period comparisons.</td>
<td>Useful for next-period comparisons.</td>
</tr>
</table>

## 5. Frequently Asked Interview Questions

**1. What is a window function?**

A function that performs calculations across related rows while preserving individual rows.

**2. What is the purpose of OVER()?**

It defines the window of rows used by a window function.

**3. What is PARTITION BY?**

It divides rows into groups for separate window calculations.

**4. Is PARTITION BY mandatory?**

No. Without it, the window function generally operates across the entire result set.

**5. What is the difference between GROUP BY and PARTITION BY?**

GROUP BY combines rows into groups, whereas PARTITION BY divides rows for calculations without removing individual rows.

**6. What is the difference between ROW_NUMBER(), RANK(), and DENSE_RANK()?**

- ROW_NUMBER assigns unique numbers.
- RANK assigns the same rank to tied values and leaves gaps.
- DENSE_RANK assigns the same rank to tied values without gaps.

**7. What is NTILE()?**

It divides ordered rows into a specified number of approximately equal groups.

**8. What is the difference between LAG() and LEAD()?**

LAG accesses a previous row, while LEAD accesses a following row.

**9. What are running totals?**

Running totals are cumulative sums calculated row by row using a window frame.

**10. What is PERCENT_RANK()?**

It calculates the relative rank of a row using:

`(Rank - 1) / (Total Rows - 1)`

Its result ranges from 0 to 1. A single-row partition returns 0.

**11. What is CUME_DIST()?**

It calculates the proportion of rows with values less than or equal to the current row's value in the specified ordering.

`CUME_DIST = Number of rows up to the current peer group / Total rows`

Its result is greater than 0 and less than or equal to 1.

**12. What is the difference between PERCENT_RANK() and CUME_DIST()?**

PERCENT_RANK is based on rank, while CUME_DIST is based on the cumulative number of rows.

**13. What is a window frame?**

A window frame specifies which rows around the current row are included in a window calculation.

**14. Can we use aggregate functions as window functions?**

Yes. Functions such as SUM(), AVG(), COUNT(), MIN(), and MAX()