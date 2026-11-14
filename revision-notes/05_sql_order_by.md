# 04. SQL ORDER BY Clause

## 1. Definition

The `ORDER BY` clause is used to sort query results in ascending or descending order.

- `ASC` – Ascending order.
- `DESC` – Descending order.

Example:

```sql
SELECT *
FROM Employees
ORDER BY salary ASC;
```

This displays employees from the lowest salary to the highest salary.

## 2. Sorting Data

### Ascending Order (ASC)

Sorts values from lowest to highest or alphabetically from A to Z.

```sql
SELECT *
FROM Employees
ORDER BY salary ASC;
```

### Descending Order (DESC)

Sorts values from highest to lowest or alphabetically from Z to A.

```sql
SELECT *
FROM Employees
ORDER BY salary DESC;
```

**Important:** ASC is the default sorting order when neither ASC nor DESC is specified.

### Sorting Text Values

```sql
SELECT *
FROM Employees
ORDER BY employee_name ASC;
```

### Sorting Date Values

```sql
SELECT *
FROM Orders
ORDER BY order_date DESC;
```

Displays the latest order dates first.

## 3. Sorting Multiple Columns

We can sort data using more than one column.

```sql
SELECT *
FROM Employees
ORDER BY department ASC, salary DESC;
```

The sorting happens in this order:

1. Sort departments alphabetically.
2. Within each department, sort employees by salary from highest to lowest.

## 4. Sorting Using Column Position

We can also sort using the position of a column in the SELECT list.

```sql
SELECT employee_name, salary
FROM Employees
ORDER BY 2 DESC;
```

Here, `2` refers to the second selected column, which is salary.

Using column names is generally more readable and maintainable.

## 5. Sorting Using Column Aliases

```sql
SELECT
    employee_name,
    salary * 12 AS annual_salary
FROM Employees
ORDER BY annual_salary DESC;
```

The result is sorted using the calculated column alias.

## 6. NULL Values in ORDER BY

NULL values may appear first or last depending on the database and sort direction.

Some databases support explicit NULL placement using:

```sql
ORDER BY salary ASC NULLS LAST;
```

```sql
ORDER BY salary DESC NULLS FIRST;
```

Syntax and default behavior vary between database systems.

## 7. Important Differences

### ASC vs DESC

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>ASC</th>
<th>DESC</th>
</tr>
<tr>
<td>Ascending order.</td>
<td>Descending order.</td>
</tr>
<tr>
<td>Lowest to highest.</td>
<td>Highest to lowest.</td>
</tr>
<tr>
<td>A to Z for text values.</td>
<td>Z to A for text values.</td>
</tr>
<tr>
<td>Default sorting order.</td>
<td>Must be specified when required.</td>
</tr>
</table>

### ORDER BY vs GROUP BY

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>ORDER BY</th>
<th>GROUP BY</th>
</tr>
<tr>
<td>Sorts query results.</td>
<td>Groups rows with matching values.</td>
</tr>
<tr>
<td>Does not combine rows.</td>
<td>Produces grouped results.</td>
</tr>
<tr>
<td>Supports ASC and DESC.</td>
<td>Used commonly with aggregate functions.</td>
</tr>
</table>

## 8. Frequently Asked Interview Questions

**1. What is ORDER BY?**

ORDER BY sorts query results in ascending or descending order.

**2. What is the default sorting order?**

Ascending order (ASC).

**3. What is the difference between ASC and DESC?**

ASC sorts from lowest to highest, while DESC sorts from highest to lowest.

**4. Can we sort by multiple columns?**

Yes. Multiple columns can be specified in ORDER BY.

**5. Can we use ORDER BY with column aliases?**

Yes. In most SQL databases, SELECT-list aliases can be used in ORDER BY.

**6. Can we use ORDER BY with aggregate functions?**

Yes. We can sort grouped results using aggregate expressions or their aliases.

**7. Can we use ORDER BY without SELECT?**

ORDER BY is used as part of a query or statement, not as a standalone SQL statement.

**8. What happens when we sort using multiple columns?**

The first column determines the primary sorting order. Subsequent columns determine the order when earlier column values are equal.

**9. Can we use column positions in ORDER BY?**

Yes. We can refer to selected columns by their positions, although column names are generally preferred.

**10. How are NULL values sorted?**

Their position depends on the database system and sorting rules. Some databases support NULLS FIRST and NULLS LAST.

## 9. Common Mistakes

- Confusing ASC with DESC.
- Assuming DESC is the default.
- Forgetting that multiple columns are sorted in the specified sequence.
- Using incorrect column positions.
- Assuming NULL values always appear last.
- Confusing ORDER BY with GROUP BY.
- Forgetting that ORDER BY sorts the final query result.

## 10. Quick Revision

- ORDER BY = Sorts query results.
- ASC = Ascending order.
- DESC = Descending order.
- ASC = Default sorting order.
- Multiple columns = Sorts by priority.
- Column position = Sorts using SELECT column number.
- Column alias = Can be used for sorting.
- NULL sorting = Database-dependent.
- GROUP BY = Groups rows.
- ORDER BY = Sorts rows.