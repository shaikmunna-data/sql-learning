# 02. SQL Operators

## 1. What are SQL Operators?

SQL Operators are symbols or keywords used to perform operations on data, compare values, combine conditions and filter records.

## 2. Types of SQL Operators

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Operator Type</th>
<th>Purpose</th>
<th>Examples</th>
</tr>
<tr>
<td>Arithmetic</td>
<td>Performs mathematical operations</td>
<td><code>+</code>, <code>-</code>, <code>*</code>, <code>/</code>, <code>%</code></td>
</tr>
<tr>
<td>Comparison</td>
<td>Compares two values</td>
<td><code>=</code>, <code><></code>, <code>!=</code>, <code>></code>, <code><</code>, <code>>=</code>, <code><=</code></td>
</tr>
<tr>
<td>Logical</td>
<td>Combines multiple conditions</td>
<td><code>AND</code>, <code>OR</code>, <code>NOT</code></td>
</tr>
<tr>
<td>Special</td>
<td>Performs specific filtering operations</td>
<td><code>IN</code>, <code>BETWEEN</code>, <code>LIKE</code>, <code>IS NULL</code></td>
</tr>
<tr>
<td>Set</td>
<td>Combines results of multiple queries</td>
<td><code>UNION</code>, <code>UNION ALL</code>, <code>INTERSECT</code>, <code>EXCEPT</code></td>
</tr>
</table>

## 3. Important Differences

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Operators</th>
<th>Difference</th>
</tr>
<tr>
<td><code>=</code> vs <code><></code></td>
<td>Checks equality vs checks inequality.</td>
</tr>
<tr>
<td><code>AND</code> vs <code>OR</code></td>
<td>All conditions must be true vs at least one condition must be true.</td>
</tr>
<tr>
<td><code>IN</code> vs <code>BETWEEN</code></td>
<td>Checks against a list of values vs checks within a range.</td>
</tr>
<tr>
<td><code>LIKE</code> vs <code>=</code></td>
<td>Pattern matching vs exact comparison.</td>
</tr>
<tr>
<td><code>UNION</code> vs <code>UNION ALL</code></td>
<td>Removes duplicate rows vs retains duplicate rows.</td>
</tr>
<tr>
<td><code>IS NULL</code> vs <code>= NULL</code></td>
<td>Correctly checks NULL values vs does not correctly check NULL values.</td>
</tr>
</table>

## 4. Important LIKE Wildcards

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Wildcard</th>
<th>Meaning</th>
<th>Example</th>
</tr>
<tr>
<td><code>%</code></td>
<td>Matches zero or more characters.</td>
<td><code>'A%'</code></td>
</tr>
<tr>
<td><code>_</code></td>
<td>Matches exactly one character.</td>
<td><code>'A_'</code></td>
</tr>
</table>

## 5. Frequently Asked Interview Questions

**Q1. What are SQL Operators?**

SQL Operators are used to perform calculations, comparisons and logical operations on data.

**Q2. What is the difference between AND and OR?**

AND returns TRUE only when all conditions are TRUE. OR returns TRUE when at least one condition is TRUE.

**Q3. What is the difference between IN and BETWEEN?**

IN checks whether a value matches any value in a specified list. BETWEEN checks whether a value falls within a specified range, including both boundaries.

**Q4. What is the difference between LIKE and =?**

LIKE is used for pattern matching, whereas = is used for equality comparison.

**Q5. What is the difference between UNION and UNION ALL?**

UNION combines query results and removes duplicate rows. UNION ALL combines query results without removing duplicates.

**Q6. How do you check NULL values in SQL?**

Use `IS NULL` to check for NULL values and `IS NOT NULL` to check for non-NULL values.

**Q7. What is the difference between NOT IN and NOT EXISTS?**

NOT IN checks whether a value is absent from a list or subquery result. NOT EXISTS checks whether a subquery returns no rows. NULL values can affect NOT IN results, so NOT EXISTS is often safer for anti-join queries.

**Q8. What is operator precedence in SQL?**

Operator precedence determines the order in which SQL evaluates operators in an expression. Parentheses can be used to control evaluation order.

## 6. Common Mistakes

- Using `= NULL` instead of `IS NULL`.
- Confusing AND with OR.
- Forgetting that BETWEEN includes both boundary values.
- Using `%` and `_` incorrectly in LIKE patterns.
- Assuming UNION ALL removes duplicates.
- Ignoring NULL behavior when using NOT IN.
- Forgetting parentheses when combining multiple AND and OR conditions.

## 7. Quick Revision

- Arithmetic → Mathematical calculations.
- Comparison → Compares values.
- Logical → Combines conditions.
- IN → Matches values from a list.
- BETWEEN → Checks a range (inclusive).
- LIKE → Pattern matching.
- IS NULL → Checks missing values.
- UNION → Combines results without duplicates.
- UNION ALL → Combines results with duplicates.
- INTERSECT → Returns common rows.
- EXCEPT → Returns rows from the first query that are absent from the second query.