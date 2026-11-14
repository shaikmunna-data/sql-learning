# 06. SQL Common Table Expressions (CTEs)

## 1. Definition

A **Common Table Expression (CTE)** is a temporary named result set defined using the `WITH` keyword.

It makes complex SQL queries easier to read, understand, and maintain.

Example:

```sql
WITH DepartmentAverage AS (
    SELECT department, AVG(salary) AS avg_salary
    FROM Employees
    GROUP BY department
)
SELECT *
FROM DepartmentAverage;
```

The CTE exists only for the duration of the statement that follows it.

## 2. Types of CTEs

### Non-Recursive CTE

A non-recursive CTE does not refer to itself.

```sql
WITH HighSalaryEmployees AS (
    SELECT employee_id, employee_name, salary
    FROM Employees
    WHERE salary > 50000
)
SELECT *
FROM HighSalaryEmployees;
```

### Recursive CTE

A recursive CTE refers to itself to process hierarchical or sequential data.

It is commonly used for:
- Employee-manager hierarchies.
- Organizational structures.
- Category hierarchies.
- Parent-child relationships.
- Generating sequences.

A recursive CTE generally contains two parts:

1. **Anchor member:** Returns the initial rows.
2. **Recursive member:** Refers to the CTE and generates additional rows.

Example:

```sql
WITH EmployeeHierarchy AS (
    -- Anchor member
    SELECT employee_id, employee_name, manager_id, 1 AS level
    FROM Employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive member
    SELECT e.employee_id, e.employee_name,
           e.manager_id, eh.level + 1
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh
        ON e.manager_id = eh.employee_id
)
SELECT *
FROM EmployeeHierarchy;
```

This query retrieves employees across all management levels.

## 3. Important CTE Concepts

### Multiple CTEs

Multiple CTEs can be defined in a single `WITH` clause and separated by commas.

```sql
WITH DepartmentAverage AS (
    SELECT department, AVG(salary) AS avg_salary
    FROM Employees
    GROUP BY department
),
HighSalaryDepartments AS (
    SELECT department, avg_salary
    FROM DepartmentAverage
    WHERE avg_salary > 50000
)
SELECT *
FROM HighSalaryDepartments;
```

### CTE with INSERT, UPDATE and DELETE

Depending on database support, CTEs can also be used with data modification statements.

Example:

```sql
WITH InactiveCustomers AS (
    SELECT customer_id
    FROM Customers
    WHERE customer_status = 'Inactive'
)
DELETE FROM Customers
WHERE customer_id IN (
    SELECT customer_id
    FROM InactiveCustomers
);
```

Syntax and support can vary between database systems.

## 4. Important Differences

### CTE vs Subquery

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>CTE</th>
<th>Subquery</th>
</tr>
<tr>
<td>Defined using the <code>WITH</code> keyword.</td>
<td>Written inside another SQL statement.</td>
</tr>
<tr>
<td>Has a meaningful name.</td>
<td>Usually written directly inside the query.</td>
</tr>
<tr>
<td>Improves readability for complex queries.</td>
<td>Useful for simpler nested queries.</td>
</tr>
<tr>
<td>Can support recursion.</td>
<td>Ordinary subqueries do not provide recursive processing.</td>
</tr>
</table>

### CTE vs Temporary Table

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>CTE</th>
<th>Temporary Table</th>
</tr>
<tr>
<td>Exists for one statement.</td>
<td>Can exist across multiple statements within its scope.</td>
</tr>
<tr>
<td>Defined using <code>WITH</code>.</td>
<td>Created using temporary table syntax.</td>
</tr>
<tr>
<td>Does not normally require explicitly creating a stored table.</td>
<td>Stores intermediate data in a temporary table.</td>
</tr>
<tr>
<td>Useful for organizing query logic.</td>
<td>Useful for storing and reusing intermediate results.</td>
</tr>
</table>

### Anchor Member vs Recursive Member

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Anchor Member</th>
<th>Recursive Member</th>
</tr>
<tr>
<td>Provides the initial result.</td>
<td>Generates additional results.</td>
</tr>
<tr>
<td>Does not reference the recursive CTE.</td>
<td>References the recursive CTE.</td>
</tr>
<tr>
<td>Starts the recursion.</td>
<td>Continues the recursion until no more rows are produced or a limit is reached.</td>
</tr>
</table>

## 5. Frequently Asked Interview Questions

**1. What is a CTE?**

A CTE is a temporary named result set defined using the `WITH` keyword.

**2. What is the purpose of a CTE?**

To improve query readability, organize complex logic, and simplify query maintenance.

**3. What are the types of CTEs?**

- Non-recursive CTE.
- Recursive CTE.

**4. What is a recursive CTE?**

A CTE that references itself to process hierarchical or sequential data.

**5. What are anchor and recursive members?**

- Anchor member provides the initial rows.
- Recursive member generates additional rows using the previous result.

**6. Can we create multiple CTEs in one query?**

Yes. Multiple CTEs can be separated by commas in the same `WITH` clause.

**7. Can we use a CTE multiple times?**

Yes. A CTE can be referenced multiple times within the statement where it is defined.

**8. Can we use a CTE inside another CTE?**

A later CTE can reference an earlier CTE in the same `WITH` clause. Nested CTE syntax and support vary by database.

**9. Is a CTE a physical table?**

No. A CTE is a named query result, not a permanently stored table.

**10. Is a CTE always faster than a subquery?**

No. Performance depends on the query, database optimizer, indexes, and execution plan.

**11. Can a CTE be used with UPDATE and DELETE?**

Yes, depending on database support and syntax.

**12. What happens if a recursive CTE has no proper stopping condition?**

It may continue until the database's recursion limit is reached or an error occurs.

## 6. Common Mistakes

- Forgetting the `WITH` keyword.
- Forgetting commas between multiple CTE definitions.
- Using incorrect column names in the recursive member.
- Forgetting the anchor member.
- Creating recursion without a proper stopping condition.
- Assuming a CTE is a permanent table.
- Assuming CTEs always improve performance.
- Confusing CTEs with temporary tables.

## 7. Quick Revision

- CTE = Common Table Expression.
- `WITH` = Defines a CTE.
- CTE = Temporary named query result.
- Non-recursive CTE = Does not reference itself.
- Recursive CTE = References itself.
- Anchor member = Initial result.
- Recursive member = Generates additional rows.
- Multiple CTEs = Separated by commas.
- CTE scope = One SQL statement.
- Recursive CTE use cases = Hierarchies and sequential data.