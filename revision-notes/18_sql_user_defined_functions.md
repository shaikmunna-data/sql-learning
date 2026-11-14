# 18. SQL User-Defined Functions (UDFs)

## 1. What are User-Defined Functions?

User-Defined Functions (UDFs) are custom functions created by users to perform specific operations and return a value or a table.

They allow developers to reuse SQL logic whenever required.

UDFs are commonly used to:

- Perform calculations.
- Transform data.
- Return calculated values.
- Reuse SQL logic.
- Simplify complex queries.

## 2. Types of User-Defined Functions

In SQL Server, there are three main types of UDFs:

1. Scalar Functions
2. Inline Table-Valued Functions
3. Multi-Statement Table-Valued Functions

## 3. Scalar Functions

A scalar function returns a single value.

**Example:** Create a function to calculate annual salary.

```sql
CREATE FUNCTION CalculateAnnualSalary
(
    @MonthlySalary DECIMAL(10, 2)
)
RETURNS DECIMAL(12, 2)
AS
BEGIN
    RETURN @MonthlySalary * 12;
END;
```

**Execute the function:**

```sql
SELECT dbo.CalculateAnnualSalary(50000)
    AS AnnualSalary;
```

**Result:** `600000.00`

## 4. Scalar Function with Table Data

A scalar function can be used to calculate a value for each row.

**Example:** Calculate annual salary for every employee.

```sql
SELECT
    employee_name,
    salary AS monthly_salary,
    dbo.CalculateAnnualSalary(salary) AS annual_salary
FROM Employees;
```

## 5. Inline Table-Valued Functions

An Inline Table-Valued Function (ITVF) returns a table using a single SELECT statement.

**Example:** Create a function to retrieve employees from a department.

```sql
CREATE FUNCTION GetEmployeesByDepartment
(
    @Department VARCHAR(50)
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        employee_id,
        employee_name,
        department,
        salary
    FROM Employees
    WHERE department = @Department
);
```

**Execute the function:**

```sql
SELECT *
FROM dbo.GetEmployeesByDepartment('Sales');
```

## 6. Multi-Statement Table-Valued Functions

A Multi-Statement Table-Valued Function (MSTVF) returns a table variable populated using multiple SQL statements.

**Example:**

```sql
CREATE FUNCTION GetHighSalaryEmployees
(
    @MinimumSalary DECIMAL(10, 2)
)
RETURNS @EmployeeTable TABLE
(
    employee_id INT,
    employee_name VARCHAR(100),
    salary DECIMAL(10, 2)
)
AS
BEGIN
    INSERT INTO @EmployeeTable
    SELECT
        employee_id,
        employee_name,
        salary
    FROM Employees
    WHERE salary >= @MinimumSalary;

    RETURN;
END;
```

**Execute the function:**

```sql
SELECT *
FROM dbo.GetHighSalaryEmployees(50000);
```

## 7. ALTER FUNCTION

Use `ALTER FUNCTION` to modify an existing function in SQL Server.

**Example:**

```sql
ALTER FUNCTION CalculateAnnualSalary
(
    @MonthlySalary DECIMAL(10, 2)
)
RETURNS DECIMAL(12, 2)
AS
BEGIN
    RETURN @MonthlySalary * 13;
END;
```

## 8. CREATE OR ALTER FUNCTION

SQL Server supports `CREATE OR ALTER FUNCTION`.

It creates a function if it does not exist or modifies it if it already exists.

**Example:**

```sql
CREATE OR ALTER FUNCTION CalculateAnnualSalary
(
    @MonthlySalary DECIMAL(10, 2)
)
RETURNS DECIMAL(12, 2)
AS
BEGIN
    RETURN @MonthlySalary * 12;
END;
```

## 9. DROP FUNCTION

Use `DROP FUNCTION` to remove a user-defined function.

**Syntax:**

```sql
DROP FUNCTION function_name;
```

**Example:**

```sql
DROP FUNCTION CalculateAnnualSalary;
```

This removes the function definition from the database.

## 10. Scalar Function vs Table-Valued Function

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Scalar Function</th>
<th>Table-Valued Function</th>
</tr>
<tr>
<td>Returns a single value.</td>
<td>Returns a table.</td>
</tr>
<tr>
<td>Can return INT, VARCHAR, DECIMAL and other scalar data types.</td>
<td>Returns a table containing rows and columns.</td>
</tr>
<tr>
<td>Can be used in SELECT expressions.</td>
<td>Can be used in the FROM clause.</td>
</tr>
<tr>
<td>Example: Calculate annual salary.</td>
<td>Example: Retrieve employees by department.</td>
</tr>
</table>

## 11. Inline TVF vs Multi-Statement TVF

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Inline TVF</th>
<th>Multi-Statement TVF</th>
</tr>
<tr>
<td>Uses a single SELECT statement.</td>
<td>Uses multiple SQL statements.</td>
</tr>
<tr>
<td>Returns the result directly from a query.</td>
<td>Populates and returns a table variable.</td>
</tr>
<tr>
<td>Generally allows the optimizer more flexibility.</td>
<td>May have additional optimization limitations.</td>
</tr>
<tr>
<td>Uses <code>RETURNS TABLE</code>.</td>
<td>Defines a return table variable using <code>RETURNS @TableName TABLE</code>.</td>
</tr>
</table>

## 12. Stored Procedure vs User-Defined Function

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Stored Procedure</th>
<th>User-Defined Function</th>
</tr>
<tr>
<td>Used to perform database operations.</td>
<td>Used to calculate and return values or tables.</td>
</tr>
<tr>
<td>Can return result sets and output parameters.</td>
<td>Returns a scalar value or a table, depending on its type.</td>
</tr>
<tr>
<td>Can perform INSERT, UPDATE and DELETE operations.</td>
<td>SQL Server UDFs cannot modify database state through ordinary DML operations.</td>
</tr>
<tr>
<td>Executed using EXEC or EXECUTE.</td>
<td>Used within SQL expressions or the FROM clause, depending on its type.</td>
</tr>
<tr>
<td>Can manage transactions.</td>
<td>Cannot use transaction-control statements such as COMMIT and ROLLBACK.</td>
</tr>
</table>

## 13. Advantages of User-Defined Functions

- **Reusability:** Reuse the same logic in multiple queries.
- **Modularity:** Divide complex calculations into smaller functions.
- **Maintainability:** Update logic in one place.
- **Readability:** Simplify complex SQL expressions.
- **Consistency:** Apply the same calculation or transformation wherever required.

## 14. Limitations of User-Defined Functions

- SQL Server UDFs have restrictions on modifying database data.
- UDFs cannot use transaction-control statements.
- Some functions may affect query performance when used extensively.
- Scalar functions can introduce performance overhead depending on their implementation and SQL Server version.
- Functions have restrictions on the SQL statements they can execute.

## 15. Important Rules

- `CREATE FUNCTION` creates a user-defined function.
- `ALTER FUNCTION` modifies an existing function.
- `CREATE OR ALTER FUNCTION` creates or modifies a function in SQL Server.
- `DROP FUNCTION` removes a function.
- Scalar functions return a single value.
- Table-valued functions return a table.
- Inline TVFs use a single SELECT statement.
- Multi-statement TVFs populate a return table variable.
- Functions can accept input parameters.
- SQL Server UDFs have more restrictions than stored procedures.

## 16. Frequently Asked Interview Questions

**1. What is a User-Defined Function?**

A UDF is a custom function created to perform specific operations and return a value or table.

**2. What are the types of UDFs in SQL Server?**

Scalar functions, Inline Table-Valued Functions and Multi-Statement Table-Valued Functions.

**3. What is a scalar function?**

A scalar function returns a single value.

**4. What is a table-valued function?**

A table-valued function returns a table containing rows and columns.

**5. What is an inline table-valued function?**

An inline TVF returns a table using a single SELECT statement.

**6. What is a multi-statement table-valued function?**

An MSTVF uses multiple statements to populate and return a table variable.

**7. Can a function accept parameters?**

Yes. UDFs can accept input parameters.

**8. Can we use a function inside SELECT?**

Yes. Scalar functions can be used in SELECT expressions.

**9. Can we use a table-valued function in FROM?**

Yes. A table-valued function can be queried in the FROM clause.

**10. Can a SQL Server UDF perform INSERT, UPDATE and DELETE?**

A SQL Server UDF cannot modify database state through ordinary DML operations.

**11. Can a function return multiple values?**

A scalar function returns one value, while a table-valued function can return multiple rows and columns.

**12. What is the difference between a stored procedure and a function?**

A stored procedure performs database operations and can return result sets or output parameters. A function returns a scalar value or table and has additional restrictions.

**13. Can a function call another function?**

Yes, subject to SQL Server's function restrictions.

**14. Can we drop a function?**

Yes. Use `DROP FUNCTION`.

**15. Do functions always improve performance?**

No. Performance depends on the function type, implementation, query design and execution plan.

## 17. Common Mistakes

- Confusing scalar functions with table-valued functions.
- Confusing stored procedures with UDFs.
- Forgetting the RETURN statement in scalar functions.
- Using EXEC to call a function.
- Trying to modify database tables through a SQL Server UDF.
- Assuming all functions return a single value.
- Assuming inline and multi-statement TVFs have identical performance characteristics.

## 18. Quick Revision

- UDF = User-Defined Function.
- Scalar function = Returns a single value.
- Inline TVF = Returns a table using one SELECT statement.
- Multi-Statement TVF = Returns a table populated through multiple statements.
- `CREATE FUNCTION` = Creates a function.
- `ALTER FUNCTION` = Modifies a function.
- `CREATE OR ALTER FUNCTION` = Creates or modifies a function.
- `DROP FUNCTION` = Removes a function.
- Functions support reusable SQL logic.
- SQL Server UDFs have restrictions on data modification and transaction control.