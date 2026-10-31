/*
===============================================================================
21. STORED PROCEDURES
===============================================================================

1. WHAT IS A STORED PROCEDURE?

A stored procedure is a collection of SQL statements saved in a database
and executed whenever required.

Advantages:
- Reuse SQL code.
- Accept parameters.
- Perform calculations and conditional operations.
- Retrieve or modify data.

NOTE:
Stored procedure syntax differs between database systems.
The examples below use SQL Server syntax because our database is EcommerceSQL.


===============================================================================
2. CREATE PROCEDURE
===============================================================================

CREATE PROCEDURE creates a stored procedure.

SQL Server syntax:

CREATE OR ALTER PROCEDURE procedure_name
AS
BEGIN
    SQL statements;
END;

GO separates batches in SQL Server tools.
It is not part of standard SQL.
*/

USE EcommerceSQL;
GO

CREATE OR ALTER PROCEDURE dbo.GetAllCustomers
AS
BEGIN
    SELECT
        customer_id,
        customer_name,
        city
    FROM dbo.Customers;
END;
GO

/*
CALLING A PROCEDURE

In SQL Server, use EXEC or EXECUTE.
Other databases may use CALL.
*/

EXEC dbo.GetAllCustomers;
GO


/*
===============================================================================
3. INPUT PARAMETERS
===============================================================================

Input parameters pass values into a procedure.

Example:
Retrieve customers from a particular city.
*/

CREATE OR ALTER PROCEDURE dbo.GetCustomersByCity
    @City VARCHAR(100)
AS
BEGIN
    SELECT
        customer_id,
        customer_name,
        city
    FROM dbo.Customers
    WHERE city = @City;
END;
GO

-- Pass a value to the input parameter.
EXEC dbo.GetCustomersByCity @City = 'Hyderabad';
GO

EXEC dbo.GetCustomersByCity @City = 'Chennai';
GO


/*
===============================================================================
4. MULTIPLE INPUT PARAMETERS
===============================================================================

A procedure can accept more than one input parameter.
*/

CREATE OR ALTER PROCEDURE dbo.GetOrdersByStatus
    @OrderStatus VARCHAR(30),
    @MinimumAmount DECIMAL(10, 2)
AS
BEGIN
    SELECT
        order_id,
        customer_id,
        order_status,
        total_amount
    FROM dbo.Orders
    WHERE order_status = @OrderStatus
      AND total_amount >= @MinimumAmount;
END;
GO

EXEC dbo.GetOrdersByStatus
    @OrderStatus = 'Delivered',
    @MinimumAmount = 1000;
GO


/*
===============================================================================
5. VARIABLES
===============================================================================

Variables temporarily store values.

DECLARE creates a variable.
SET assigns a value.
*/

DECLARE @MinimumPrice DECIMAL(10, 2);

SET @MinimumPrice = 500;

SELECT
    product_id,
    product_name,
    price
FROM dbo.Products
WHERE price >= @MinimumPrice;
GO

/*
Variables can also be used inside stored procedures.
*/

CREATE OR ALTER PROCEDURE dbo.GetOrderCount
    @OrderStatus VARCHAR(30)
AS
BEGIN
    DECLARE @TotalOrders INT;

    SELECT @TotalOrders = COUNT(*)
    FROM dbo.Orders
    WHERE order_status = @OrderStatus;

    SELECT @TotalOrders AS TotalOrders;
END;
GO

EXEC dbo.GetOrderCount @OrderStatus = 'Delivered';
GO


/*
===============================================================================
6. OUTPUT PARAMETERS
===============================================================================

An OUTPUT parameter returns a value through a parameter.

SQL Server-specific syntax:
- Declare the parameter with OUTPUT.
- Use OUTPUT when executing the procedure.
*/

CREATE OR ALTER PROCEDURE dbo.GetCustomerCount
    @TotalCustomers INT OUTPUT
AS
BEGIN
    SELECT @TotalCustomers = COUNT(*)
    FROM dbo.Customers;
END;
GO

DECLARE @CustomerCount INT;

EXEC dbo.GetCustomerCount
    @TotalCustomers = @CustomerCount OUTPUT;

SELECT @CustomerCount AS TotalCustomers;
GO


/*
===============================================================================
7. CONDITIONAL LOGIC: IF...ELSE
===============================================================================

IF...ELSE executes different statements depending on a condition.

Example:
Check whether an order exists.
*/

CREATE OR ALTER PROCEDURE dbo.CheckOrder
    @OrderID INT
AS
BEGIN
    IF EXISTS
    (
        SELECT 1
        FROM dbo.Orders
        WHERE order_id = @OrderID
    )
    BEGIN
        SELECT
            order_id,
            customer_id,
            order_status,
            total_amount
        FROM dbo.Orders
        WHERE order_id = @OrderID;
    END
    ELSE
    BEGIN
        SELECT 'Order not found' AS Message;
    END;
END;
GO

-- Replace 1 with an order ID that exists in your database.
EXEC dbo.CheckOrder @OrderID = 1;
GO


/*
===============================================================================
8. DEFAULT PARAMETER VALUES
===============================================================================

A parameter can have a default value.
If no value is provided, the default is used.
*/

CREATE OR ALTER PROCEDURE dbo.GetRecentOrders
    @NumberOfOrders INT = 5
AS
BEGIN
    SELECT TOP (@NumberOfOrders)
        order_id,
        customer_id,
        order_date,
        total_amount
    FROM dbo.Orders
    ORDER BY order_date DESC, order_id DESC;
END;
GO

-- Uses the default value of 5.
EXEC dbo.GetRecentOrders;
GO

-- Requests the latest 10 orders.
EXEC dbo.GetRecentOrders @NumberOfOrders = 10;
GO


/*
===============================================================================
9. QUICK REVISION
===============================================================================

Stored procedure:
    Saved SQL statements that can be executed repeatedly.

CREATE PROCEDURE:
    Defines a procedure.

EXEC:
    Executes a procedure in SQL Server.

Input parameter:
    Passes a value into a procedure.

OUTPUT parameter:
    Returns a value through a parameter.

DECLARE:
    Creates a variable.

SET:
    Assigns a value to a variable.

IF...ELSE:
    Executes statements based on a condition.

GO:
    Separates batches in SQL Server tools; not standard SQL.

PORTABILITY NOTE:
CREATE OR ALTER PROCEDURE, @parameter syntax, OUTPUT, EXEC, IF...ELSE,
and TOP are SQL Server-specific or differ across database systems.
MySQL, PostgreSQL, and Oracle use different procedure syntax and
parameter conventions.
===============================================================================
*/
/*
===============================================================================
DROP PROCEDURE
===============================================================================

DROP PROCEDURE permanently removes a stored procedure.

Syntax:
    DROP PROCEDURE procedure_name;

Use IF EXISTS to avoid an error if the procedure does not exist.
*/

-- Drop a procedure only if it exists.
DROP PROCEDURE IF EXISTS dbo.GetAllCustomers;
GO

-- Drop multiple procedures.
DROP PROCEDURE IF EXISTS
    dbo.GetCustomersByCity,
    dbo.GetOrdersByStatus;
GO


/*
/*
===============================================================================
21. STORED PROCEDURES - COMPARISON OF DIFFERENT DBMS
===============================================================================

Databases covered:
1. SQL Server
2. MySQL
3. PostgreSQL
4. Oracle

Topics:
- CREATE PROCEDURE
- Input parameters
- Output parameters
- INOUT parameters
- Variables
- Assigning values
- Conditional logic
- Calling procedures

IMPORTANT:
- SQL Server examples are executable.
- Other DBMS examples are comments for comparison.
- Procedure syntax differs between database systems.


===============================================================================
1. SQL SERVER (T-SQL)
===============================================================================

SQL Server syntax:
- Input parameter: @ParameterName DataType
- Output parameter: OUTPUT
- Variable: DECLARE @VariableName DataType
- Assignment: SET @VariableName = value
- Conditional logic: IF...ELSE
- Procedure call: EXEC
- Batch separator: GO

*/

USE EcommerceSQL;
GO

CREATE OR ALTER PROCEDURE dbo.CountOrdersByStatus
    @Status VARCHAR(30),           -- Input parameter
    @OrderCount INT OUTPUT         -- Output parameter
AS
BEGIN
    DECLARE @Message VARCHAR(100); -- Local variable

    SELECT @OrderCount = COUNT(*)
    FROM dbo.Orders
    WHERE order_status = @Status;

    IF @OrderCount > 0
    BEGIN
        SET @Message = 'Orders found';
    END
    ELSE
    BEGIN
        SET @Message = 'No orders found';
    END;

    SELECT @Message AS Message;
END;
GO

-- Call the procedure and receive the output value.

DECLARE @Total INT;

EXEC dbo.CountOrdersByStatus
    @Status = 'Delivered',
    @OrderCount = @Total OUTPUT;

SELECT @Total AS OrderCount;
GO


/*
===============================================================================
2. MYSQL
===============================================================================

Syntax differences:
- Input parameter: IN
- Output parameter: OUT
- Input and output: INOUT
- Variable: DECLARE variable_name DataType
- Assignment: SET variable_name = value
- Store query result: SELECT ... INTO variable_name
- Conditional logic: IF...THEN...ELSE...END IF
- Procedure call: CALL
- DELIMITER is a client command, not an SQL statement.

The following is a MySQL example, not executable in SQL Server.

DELIMITER //

CREATE PROCEDURE CountOrdersByStatus(
    IN p_status VARCHAR(30),
    OUT p_order_count INT
)
BEGIN
    DECLARE v_message VARCHAR(100);

    SELECT COUNT(*) INTO p_order_count
    FROM Orders
    WHERE order_status = p_status;

    IF p_order_count > 0 THEN
        SET v_message = 'Orders found';
    ELSE
        SET v_message = 'No orders found';
    END IF;

    SELECT v_message AS Message;
END //

DELIMITER ;

-- Call the procedure:
CALL CountOrdersByStatus('Delivered', @total);

SELECT @total AS OrderCount;


===============================================================================
3. POSTGRESQL (PL/pgSQL)
===============================================================================

Syntax differences:
- Input parameter: IN
- Output parameter: OUT
- Input and output: INOUT
- Variable declaration: DECLARE variable_name DataType
- Assignment: variable_name := value
- Store query result: SELECT ... INTO variable_name
- Conditional logic: IF...THEN...ELSE...END IF
- Procedure call: CALL
- Procedure body: $$ ... $$

The following is a PostgreSQL example, not executable in SQL Server.

CREATE OR REPLACE PROCEDURE CountOrdersByStatus(
    IN p_status VARCHAR(30),
    OUT p_order_count BIGINT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_message VARCHAR(100);
BEGIN
    SELECT COUNT(*) INTO p_order_count
    FROM Orders
    WHERE order_status = p_status;

    IF p_order_count > 0 THEN
        v_message := 'Orders found';
    ELSE
        v_message := 'No orders found';
    END IF;

    RAISE NOTICE '%', v_message;
END;
$$;

-- Call the procedure:
CALL CountOrdersByStatus('Delivered', NULL);


===============================================================================
4. ORACLE (PL/SQL)
===============================================================================

Syntax differences:
- Input parameter: IN
- Output parameter: OUT
- Input and output: IN OUT
- Variable declaration: variable_name DataType;
- Assignment: variable_name := value;
- Store query result: SELECT ... INTO variable_name
- Conditional logic: IF...THEN...ELSE...END IF
- Procedure call: PL/SQL block or EXEC in supported clients
- Common data types: VARCHAR2 and NUMBER
- Slash (/) submits a PL/SQL block in clients such as SQL*Plus.

The following is an Oracle example, not executable in SQL Server.

CREATE OR REPLACE PROCEDURE CountOrdersByStatus(
    p_status IN VARCHAR2,
    p_order_count OUT NUMBER
)
AS
    v_message VARCHAR2(100);
BEGIN
    SELECT COUNT(*) INTO p_order_count
    FROM Orders
    WHERE order_status = p_status;

    IF p_order_count > 0 THEN
        v_message := 'Orders found';
    ELSE
        v_message := 'No orders found';
    END IF;

    DBMS_OUTPUT.PUT_LINE(v_message);
END;
/

-- Call the procedure:
DECLARE
    v_total NUMBER;
BEGIN
    CountOrdersByStatus('Delivered', v_total);
    DBMS_OUTPUT.PUT_LINE('Order count: ' || v_total);
END;
/


===============================================================================
5. IN, OUT, AND INOUT PARAMETERS
===============================================================================

IN:
- Passes a value into a procedure.
- Common in MySQL, PostgreSQL, and Oracle.
- SQL Server input parameters are the default.

OUT:
- Returns a value through a parameter.
- SQL Server uses the OUTPUT keyword.

INOUT:
- Receives a value, modifies it, and returns the result.
- Available as INOUT in MySQL and PostgreSQL.
- Written as IN OUT in Oracle.
- SQL Server can use an OUTPUT parameter for a similar pattern.


===============================================================================
6. VARIABLES AND ASSIGNMENT
===============================================================================

SQL Server:
    DECLARE @x INT;
    SET @x = 10;

MySQL:
    DECLARE x INT;
    SET x = 10;

PostgreSQL:
    DECLARE x INT;
    x := 10;

Oracle:
    x NUMBER;
    x := 10;

Note:
Variable declaration and assignment syntax depends on the DBMS and
whether the code is inside a procedure or a standalone script.


===============================================================================
7. QUICK COMPARISON
===============================================================================

Feature                 SQL Server       MySQL       PostgreSQL      Oracle
-------------------------------------------------------------------------------
Create or replace       CREATE OR ALTER  CREATE      CREATE OR       CREATE OR
procedure               PROCEDURE        PROCEDURE   REPLACE         REPLACE
                                                    PROCEDURE       PROCEDURE

Input parameter         Default          IN          IN              IN
Output parameter        OUTPUT           OUT         OUT             OUT
Input/output            OUTPUT           INOUT       INOUT           IN OUT
Variable prefix         @                None        None            None
Assignment              SET              SET         :=              :=
Procedure call          EXEC             CALL        CALL            PL/SQL block
Conditional logic       IF...ELSE        IF...THEN   IF...THEN       IF...THEN

===============================================================================
8. INTERVIEW REVISION
===============================================================================

1. A stored procedure is saved SQL code that can be executed repeatedly.
2. Input parameters pass values into a procedure.
3. Output parameters return values to the caller.
4. INOUT parameters receive and return values.
5. Variables temporarily store values during execution.
6. IF...ELSE performs conditional operations.
7. Procedure creation and calling syntax varies between DBMSs.
8. GO, DELIMITER, and / are client-specific batch or script delimiters;
   they are not interchangeable standard SQL statements.

===============================================================================
*/