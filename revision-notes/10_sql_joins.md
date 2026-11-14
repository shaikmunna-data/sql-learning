# 04. SQL JOINs

## 1. What is a JOIN?

A JOIN is used to combine rows from two or more tables based on a related column between them.

## 2. Types of JOINs

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>JOIN Type</th>
<th>Description</th>
</tr>
<tr>
<td>INNER JOIN</td>
<td>Returns only matching rows from both tables.</td>
</tr>
<tr>
<td>LEFT JOIN</td>
<td>Returns all rows from the left table and matching rows from the right table.</td>
</tr>
<tr>
<td>RIGHT JOIN</td>
<td>Returns all rows from the right table and matching rows from the left table.</td>
</tr>
<tr>
<td>FULL OUTER JOIN</td>
<td>Returns matching and non-matching rows from both tables.</td>
</tr>
<tr>
<td>CROSS JOIN</td>
<td>Returns the Cartesian product of both tables.</td>
</tr>
<tr>
<td>SELF JOIN</td>
<td>Joins a table with itself.</td>
</tr>
</table>

## 3. Important Differences

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>JOIN Types</th>
<th>Difference</th>
</tr>
<tr>
<td>INNER vs LEFT JOIN</td>
<td>INNER returns only matching rows; LEFT also returns unmatched rows from the left table.</td>
</tr>
<tr>
<td>LEFT vs RIGHT JOIN</td>
<td>LEFT preserves all rows from the left table; RIGHT preserves all rows from the right table.</td>
</tr>
<tr>
<td>LEFT vs FULL OUTER JOIN</td>
<td>LEFT preserves all left-table rows; FULL OUTER preserves all rows from both tables.</td>
</tr>
<tr>
<td>INNER vs CROSS JOIN</td>
<td>INNER returns matching rows; CROSS returns all possible combinations.</td>
</tr>
<tr>
<td>JOIN vs UNION</td>
<td>JOIN combines columns from tables; UNION combines rows from query results.</td>
</tr>
<tr>
<td>SELF JOIN vs Other JOINs</td>
<td>SELF JOIN joins a table with itself; other JOINs generally combine different tables.</td>
</tr>
</table>

## 4. Frequently Asked Interview Questions

**Q1. What is a JOIN in SQL?**

A JOIN combines data from two or more tables using related columns.

**Q2. What is the difference between INNER JOIN and LEFT JOIN?**

INNER JOIN returns only matching records from both tables. LEFT JOIN returns all records from the left table and matching records from the right table.

**Q3. What happens when there is no matching record in a LEFT JOIN?**

The columns from the right table contain NULL values for unmatched rows.

**Q4. What is a SELF JOIN?**

A SELF JOIN joins a table with itself. It is commonly used to identify hierarchical relationships, such as employees and their managers.

**Q5. What is a CROSS JOIN?**

A CROSS JOIN returns the Cartesian product of two tables. Each row from the first table is combined with every row from the second table.

**Q6. Can we join more than two tables?**

Yes. We can join multiple tables in a single SQL query using multiple JOIN clauses.

**Q7. What is the difference between ON and WHERE in JOINs?**

ON specifies the condition used to match rows between tables. WHERE filters the resulting rows after the join.

**Q8. Can we use multiple conditions in a JOIN?**

Yes. Multiple conditions can be combined using AND or OR in the ON clause.

**Q9. What is an anti join?**

An anti join returns rows from one table that have no matching rows in another table. It can be implemented using NOT EXISTS or LEFT JOIN with an IS NULL filter.

**Q10. What happens when a JOIN column contains duplicate values?**

Multiple matching rows can be returned, potentially producing more rows than either original table.

**Q11. What is an equi join?**

An equi join is a join that uses the equality operator (=) to match rows between tables.

**Q12. What is a non-equi join?**

A non-equi join uses comparison operators such as <, >, <= or >= instead of equality to match rows.

## 5. Common Mistakes

- Forgetting the ON condition when using JOINs.
- Joining tables using incorrect columns.
- Confusing INNER JOIN with LEFT JOIN.
- Ignoring duplicate records in join results.
- Forgetting that unmatched columns contain NULL values in outer joins.
- Accidentally converting a LEFT JOIN into an INNER JOIN through WHERE conditions.
- Not understanding the effect of multiple matching records.
- Confusing JOIN with UNION.

## 6. Quick Revision

- JOIN → Combines related tables.
- INNER JOIN → Matching rows only.
- LEFT JOIN → All left-table rows.
- RIGHT JOIN → All right-table rows.
- FULL OUTER JOIN → All rows from both tables.
- CROSS JOIN → Cartesian product.
- SELF JOIN → Table joined with itself.
- Anti Join → Non-matching rows.
- Equi Join → Uses equality (=).
- Non-Equi Join → Uses comparison operators.
- ON → Defines join conditions.
- WHERE → Filters resulting rows.