# 13. SQL Set Operators

## 1. What are Set Operators?

Set operators are used to combine the results of two or more SELECT queries into a single result.

SQL provides four commonly used set operators:

- `UNION`
- `UNION ALL`
- `INTERSECT`
- `EXCEPT`

## 2. Rules for Using Set Operators

The SELECT queries must follow these rules:

1. Each SELECT query must return the same number of columns.
2. Corresponding columns must have compatible data types.
3. Columns must appear in the same order.
4. The final result uses column names from the first SELECT query.

## 3. UNION

`UNION` combines the results of multiple SELECT queries and removes duplicate rows.

**Example:**

```sql
SELECT customer_id, customer_name
FROM Customers_2025

UNION

SELECT customer_id, customer_name
FROM Customers_2026;
```

**Result:** Returns customers from both tables without duplicate rows.

## 4. UNION ALL

`UNION ALL` combines the results of multiple SELECT queries and keeps duplicate rows.

**Example:**

```sql
SELECT customer_id, customer_name
FROM Customers_2025

UNION ALL

SELECT customer_id, customer_name
FROM Customers_2026;
```

**Result:** Returns all rows from both tables, including duplicates.

## 5. INTERSECT

`INTERSECT` returns only the rows that exist in both SELECT query results.

**Example:**

```sql
SELECT customer_id, customer_name
FROM Customers_2025

INTERSECT

SELECT customer_id, customer_name
FROM Customers_2026;
```

**Result:** Returns customers who appear in both tables.

Duplicate rows are removed.

## 6. EXCEPT

`EXCEPT` returns rows from the first SELECT query that do not exist in the second SELECT query.

**Example:**

```sql
SELECT customer_id, customer_name
FROM Customers_2025

EXCEPT

SELECT customer_id, customer_name
FROM Customers_2026;
```

**Result:** Returns customers who appear in Customers_2025 but not in Customers_2026.

Duplicate rows are removed.

**Important:** The order of SELECT queries matters when using EXCEPT.

## 7. UNION vs UNION ALL

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>UNION</th>
<th>UNION ALL</th>
</tr>
<tr>
<td>Combines query results.</td>
<td>Combines query results.</td>
</tr>
<tr>
<td>Removes duplicate rows.</td>
<td>Keeps duplicate rows.</td>
</tr>
<tr>
<td>Usually requires additional work to eliminate duplicates.</td>
<td>Usually faster because it does not eliminate duplicates.</td>
</tr>
<tr>
<td>Use when unique results are required.</td>
<td>Use when all rows are required.</td>
</tr>
</table>

## 8. UNION vs INTERSECT vs EXCEPT

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Operator</th>
<th>Purpose</th>
</tr>
<tr>
<td><code>UNION</code></td>
<td>Combines results and removes duplicates.</td>
</tr>
<tr>
<td><code>UNION ALL</code></td>
<td>Combines results and keeps duplicates.</td>
</tr>
<tr>
<td><code>INTERSECT</code></td>
<td>Returns common rows from both results.</td>
</tr>
<tr>
<td><code>EXCEPT</code></td>
<td>Returns rows from the first result that are absent from the second.</td>
</tr>
</table>

## 9. Using ORDER BY with Set Operators

`ORDER BY` is generally placed at the end of the complete set operation.

```sql
SELECT customer_id, customer_name
FROM Customers_2025

UNION

SELECT customer_id, customer_name
FROM Customers_2026

ORDER BY customer_name;
```

This sorts the final combined result by customer name.

## 10. UNION vs JOIN

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>UNION</th>
<th>JOIN</th>
</tr>
<tr>
<td>Combines rows from multiple query results.</td>
<td>Combines columns from related tables.</td>
</tr>
<tr>
<td>Requires the same number of columns with compatible data types.</td>
<td>Uses join conditions to match rows.</td>
</tr>
<tr>
<td>Results are stacked vertically.</td>
<td>Results are combined horizontally.</td>
</tr>
<tr>
<td>Example: Combining customer lists.</td>
<td>Example: Combining Customers and Orders.</td>
</tr>
</table>

## 11. Important Rules

- Set operators combine SELECT query results.
- The number of columns must be equal.
- Corresponding columns must have compatible data types.
- Column order must match.
- `UNION` removes duplicates.
- `UNION ALL` keeps duplicates.
- `INTERSECT` returns common rows.
- `EXCEPT` returns rows from the first result that are not in the second.
- `ORDER BY` is generally placed at the end of the complete set operation.
- `MINUS` is used instead of `EXCEPT` in Oracle Database.

## 12. Frequently Asked Interview Questions

**1. What are SQL set operators?**

Set operators combine the results of two or more SELECT queries.

**2. What are the four common SQL set operators?**

UNION, UNION ALL, INTERSECT and EXCEPT.

**3. What is the difference between UNION and UNION ALL?**

UNION removes duplicate rows, whereas UNION ALL keeps duplicate rows.

**4. Which set operator returns common records?**

INTERSECT.

**5. Which set operator returns records present only in the first query?**

EXCEPT.

**6. Can we use different column names in UNION queries?**

Yes. Column names do not need to be identical, but the number, order and data type compatibility of columns must match.

**7. Can we use ORDER BY with UNION?**

Yes. ORDER BY can sort the final combined result.

**8. Does UNION remove duplicates?**

Yes. UNION removes duplicate rows from the combined result.

**9. Does UNION ALL remove duplicates?**

No. UNION ALL keeps duplicate rows.

**10. What is the difference between UNION and JOIN?**

UNION combines rows vertically, whereas JOIN combines columns horizontally based on a relationship or condition.

**11. Does INTERSECT remove duplicates?**

Yes. INTERSECT returns distinct common rows.

**12. Is EXCEPT order-sensitive?**

Yes. EXCEPT returns rows from the first query that are absent from the second query.

**13. What is the Oracle equivalent of EXCEPT?**

Oracle uses MINUS.

## 13. Common Mistakes

- Using different numbers of columns in the SELECT queries.
- Using incompatible data types in corresponding columns.
- Assuming UNION ALL removes duplicates.
- Confusing UNION with JOIN.
- Forgetting that EXCEPT depends on query order.
- Placing ORDER BY incorrectly between individual queries.
- Assuming column names must be identical.

## 14. Quick Revision

- `UNION` combines results and removes duplicates.
- `UNION ALL` combines results and keeps duplicates.
- `INTERSECT` returns common rows.
- `EXCEPT` returns rows from the first query that are absent from the second.
- Set operators require equal column counts and compatible data types.
- `ORDER BY` sorts the final result.
- Oracle uses `MINUS` instead of `EXCEPT`.