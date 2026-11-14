# 17. SQL Stored Procedures

## 1. What is a Stored Procedure?

A stored procedure is a collection of SQL statements saved in a database that can be executed whenever required.

It is used to perform operations such as retrieving, inserting, updating, and deleting data.

Stored procedures are commonly used to:

- Reuse SQL code.
- Perform complex database operations.
- Accept input parameters.
- Return results.
- Improve maintainability.
- Control database operations through permissions.

## 2. Creating a Stored Procedure

Use `CREATE PROCEDURE` to create a stored procedure.

**Syntax (SQL Server):**

```sql
CREATE PROCEDURE procedure_name
AS
BEGIN
    SQL statements;
END;
```

**Example:**

```sql
CREATE PROCEDURE GetAllCustomers
AS
BEGIN
    SELECT *
    FROM Customers;
END;
```

This creates a stored procedure named `GetAllCustomers`.

## 3. Executing a Stored Procedure

Use `EXEC` or `EXECUTE` in SQL Server to execute a stored procedure.

```sql
EXEC GetAllCustomers;
```

This executes the procedure and returns all customer records.

## 4. Stored Procedure with Input Parameters

Input parameters allow values to be passed into a stored procedure.

**Example:** Retrieve customer details using customer ID.

```sql
CREATE PROCEDURE GetCustomerByID
    @CustomerID INT
AS
BEGIN
    SELECT *
    FROM Customers
    WHERE customer_id = @CustomerID;
END;
```

**Execute:**

```sql
EXEC GetCustomerByID @CustomerID = 101;
```

Here, `@CustomerID` is an input parameter.

## 5. Stored Procedure with Multiple Parameters

A stored procedure can accept multiple input parameters.

**Example:**

```sql
CREATE PROCEDURE GetOrdersByCustomer
    @CustomerID INT,
    @OrderStatus VARCHAR(20)
AS
BEGIN
    SELECT
        order_id,
        customer_id,
        order_date,
        order_status,
        total_amount
    FROM Orders
    WHERE customer_id = @CustomerID
      AND order_status = @OrderStatus;
END;
```

**Execute:**

```sql
EXEC GetOrdersByCustomer
    @CustomerID = 101,
    @OrderStatus = 'Delivered';
```

## 6. Stored Procedure with Default Parameters

Parameters can have default values.

**Example:**

```sql
CREATE PROCEDURE GetOrdersByStatus
    @OrderStatus VARCHAR(20) = 'Pending'
AS
BEGIN
    SELECT *
    FROM Orders
    WHERE order_status = @OrderStatus;
END;
```

**Execute using the default value:**

```sql
EXEC GetOrdersByStatus;
```

**Execute with a different value:**

```sql
EXEC GetOrdersByStatus
    @OrderStatus = 'Delivered';
```

## 7. Stored Procedure with OUTPUT Parameters

An OUTPUT parameter allows a stored procedure to return a value through a parameter.

**Example:**

```sql
CREATE PROCEDURE GetCustomerCount
    @TotalCustomers INT OUTPUT
AS
BEGIN
    SELECT @TotalCustomers = COUNT(*)
    FROM Customers;
END;
```

**Execute:**

```sql
DECLARE @Count INT;

EXEC GetCustomerCount
    @TotalCustomers = @Count OUTPUT;

SELECT @Count AS TotalCustomers;
```

Here, the procedure calculates the number of customers and assigns it to the OUTPUT parameter.

## 8. Stored Procedure with INSERT

Stored procedures can perform INSERT operations.

**Example:**

```sql
CREATE PROCEDURE AddCustomer
    @CustomerID INT,
    @CustomerName VARCHAR(100),
    @Email VARCHAR(100)
AS
BEGIN
    INSERT INTO Customers (
        customer_id,
        customer_name,
        email
    )
    VALUES (
        @CustomerID,
        @CustomerName,
        @Email
    );
END;
```

**Execute:**

```sql
EXEC AddCustomer
    @CustomerID = 501,
    @CustomerName = 'Rahul Kumar',
    @Email = 'rahul@example.com';
```

## 9. ALTER PROCEDURE

Use `ALTER PROCEDURE` to modify an existing stored procedure in SQL Server.

**Example:**

```sql
ALTER PROCEDURE GetAllCustomers
AS
BEGIN
    SELECT
        customer_id,
        customer_name,
        email,
        city
    FROM Customers;
END;
```

This modifies the existing procedure.

## 10. CREATE OR ALTER PROCEDURE

SQL Server supports `CREATE OR ALTER PROCEDURE`.

It creates a procedure if it does not exist or modifies it if it already exists.

**Example:**

```sql
CREATE OR ALTER PROCEDURE GetAllCustomers
AS
BEGIN
    SELECT *
    FROM Customers;
END;
```

This is useful when maintaining stored procedure scripts.

## 11. DROP PROCEDURE

Use `DROP PROCEDURE` to remove a stored procedure from the database.

**Syntax:**

```sql
DROP PROCEDURE procedure_name;
```

**Example:**

```sql
DROP PROCEDURE GetAllCustomers;
```

This removes the stored procedure definition. It does not delete the underlying tables or their data.

## 12. Stored Procedure vs SQL Query

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>SQL Query</th>
<th>Stored Procedure</th>
</tr>
<tr>
<td>A SQL statement written to perform an operation.</td>
<td>A saved collection of SQL statements.</td>
</tr>
<tr>
<td>Executed directly.</td>
<td>Executed using its procedure name.</td>
</tr>
<tr>
<td>Can be written and executed whenever required.</td>
<td>Can be reused without rewriting its complete definition.</td>
</tr>
<tr>
<td>Can contain a single statement or multiple statements.</td>
<td>Can contain multiple SQL statements and procedural logic.</td>
</tr>
</table>

## 13. Stored Procedure vs Function

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Stored Procedure</th>
<th>Function</th>
</tr>
<tr>
<td>Used to perform database operations.</td>
<td>Used to calculate and return values.</td>
</tr>
<tr>
<td>Can return result sets and output parameters.</td>
<td>Must return a value or table, depending on function type.</td>
</tr>
<tr>
<td>Can perform INSERT, UPDATE and DELETE operations.</td>
<td>SQL Server UDFs have restrictions on modifying database state.</td>
</tr>
<tr>
<td>Executed using EXEC or EXECUTE in SQL Server.</td>
<td>Used within SQL expressions or queries, depending on function type.</td>
</tr>
</table>

## 14. Advantages of Stored Procedures

- **Reusability:** Execute the same database logic whenever required.
- **Maintainability:** Keep frequently used SQL logic in one place.
- **Security:** Permissions can be granted on procedures without granting direct access to underlying tables in suitable configurations.
- **Reduced network traffic:** Multiple SQL operations can be executed through a single procedure call.
- **Centralized logic:** Business rules can be maintained in the database.
- **Performance:** Execution plans may be cached and reused, depending on the database and query.

## 15. Limitations of Stored Procedures

- Database-specific syntax can reduce portability.
- Complex procedures can be difficult to maintain.
- Debugging can be more challenging than debugging application code.
- Excessive database-side logic can make applications harder to manage.
- Poorly written procedures can cause performance problems.

## 16. Important Rules

- `CREATE PROCEDURE` creates a stored procedure.
- `EXEC` executes a stored procedure in SQL Server.
- Parameters allow values to be passed into procedures.
- OUTPUT parameters return values through parameters.
- Parameters can have default values.
- `ALTER PROCEDURE` modifies an existing procedure.
- `CREATE OR ALTER PROCEDURE` creates or modifies a procedure in SQL Server.
- `DROP PROCEDURE` removes a procedure.
- Stored procedures can contain multiple SQL statements and control-flow logic.
- Stored procedures are database-specific in syntax and capabilities.

## 17. Frequently Asked Interview Questions

**1. What is a stored procedure in SQL?**

A stored procedure is a collection of SQL statements saved in a database and executed whenever required.

**2. Why do we use stored procedures?**

They provide code reusability, maintainability, security, and centralized database logic.

**3. How do you create a stored procedure?**

Use `CREATE PROCEDURE`.

**4. How do you execute a stored procedure in SQL Server?**

Use `EXEC` or `EXECUTE`.

**5. What are parameters in stored procedures?**

Parameters allow values to be passed into a stored procedure.

**6. What are input parameters?**

Input parameters receive values from the caller and use them inside the procedure.

**7. What are OUTPUT parameters?**

OUTPUT parameters allow a procedure to return values through parameters.

**8. Can a stored procedure have multiple parameters?**

Yes. A stored procedure can accept multiple parameters.

**9. Can a stored procedure have default parameter values?**

Yes. Default values can be assigned to parameters.

**10. Can a stored procedure return multiple result sets?**

Yes. A procedure can execute multiple SELECT statements and return multiple result sets.

**11. Can a stored procedure perform INSERT, UPDATE and DELETE operations?**

Yes. Stored procedures can perform data modification operations.

**12. What is the difference between CREATE PROCEDURE and ALTER PROCEDURE?**

CREATE PROCEDURE creates a new procedure, whereas ALTER PROCEDURE modifies an existing one.

**13. What is CREATE OR ALTER PROCEDURE?**

In SQL Server, it creates a procedure if it does not exist or modifies it if it already exists.

**14. Can a stored procedure call another stored procedure?**

Yes. A stored procedure can execute another stored procedure.

**15. Do stored procedures always improve performance?**

No. Performance depends on query design, execution plans, indexing, and database workload.

## 18. Common Mistakes

- Forgetting to execute a procedure after creating it.
- Confusing procedure parameters with local variables.
- Forgetting the OUTPUT keyword when passing or retrieving an output parameter.
- Using incorrect parameter names or data types.
- Assuming stored procedures are completely portable across databases.
- Assuming every stored procedure automatically improves performance.
- Confusing stored procedures with user-defined functions.

## 19. Quick Revision

- Stored procedure = Saved SQL statements.
- `CREATE PROCEDURE` = Creates a procedure.
- `EXEC` = Executes a procedure in SQL Server.
- Input parameter = Receives a value.
- OUTPUT parameter = Returns a value through a parameter.
- Default parameter = Uses a predefined value when omitted.
- `ALTER PROCEDURE` = Modifies a procedure.
- `CREATE OR ALTER PROCEDURE` = Creates or modifies a procedure.
- `DROP PROCEDURE` = Removes a procedure.
- Stored procedures support reusable database logic.