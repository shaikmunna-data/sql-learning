/*
===============================================================================
18. SQL CONSTRAINTS
===============================================================================

WHAT ARE CONSTRAINTS?

Constraints are rules applied to table columns to maintain valid data.

WHY ARE CONSTRAINTS REQUIRED?
    1. Prevent invalid data.
    2. Prevent duplicate values where uniqueness is required.
    3. Ensure required values are provided.
    4. Maintain relationships between tables.
    5. Maintain data accuracy and integrity.

TYPES:
    PRIMARY KEY
    FOREIGN KEY
    UNIQUE
    NOT NULL
    CHECK
    DEFAULT

===============================================================================
1. PRIMARY KEY
===============================================================================

A PRIMARY KEY uniquely identifies each row.

Rules:
    - Cannot contain duplicate values.
    - Cannot contain NULL.
    - A table can have only one PRIMARY KEY constraint,
      which can consist of multiple columns.

Example:
*/

CREATE TABLE Departments
(
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL
);

INSERT INTO Departments
VALUES
    (1, 'Sales'),
    (2, 'IT');

-- Valid: view the records.
SELECT * FROM Departments;

-- Invalid: duplicate primary key.
-- INSERT INTO Departments VALUES (1, 'Support');


/*
===============================================================================
2. FOREIGN KEY
===============================================================================

A FOREIGN KEY connects related tables.

It ensures that a referenced value exists in the parent table,
unless the foreign key column allows NULL.

Example:
*/

CREATE TABLE DepartmentEmployees
(
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    department_id INT,

    CONSTRAINT FK_DepartmentEmployees_Departments
        FOREIGN KEY (department_id)
        REFERENCES Departments(department_id)
);

INSERT INTO DepartmentEmployees
VALUES
    (101, 'Ravi', 1),
    (102, 'Priya', 2);

-- Invalid: department_id 99 does not exist in Departments.
-- INSERT INTO DepartmentEmployees VALUES (103, 'Amit', 99);


/*
===============================================================================
3. UNIQUE
===============================================================================

UNIQUE prevents duplicate values in a column or combination of columns.

Example:
*/

CREATE TABLE EmployeeContacts
(
    employee_id INT PRIMARY KEY,
    email VARCHAR(100) UNIQUE
);

INSERT INTO EmployeeContacts
VALUES
    (1, 'ravi@example.com'),
    (2, 'priya@example.com');

-- Invalid: duplicate email.
-- INSERT INTO EmployeeContacts
-- VALUES (3, 'ravi@example.com');


/*
===============================================================================
4. NOT NULL
===============================================================================

NOT NULL requires a value for a column.

Example:
*/

CREATE TABLE Customers_ConstraintDemo
(
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL
);

INSERT INTO Customers_ConstraintDemo
VALUES (1, 'Ravi');

-- Invalid: customer_name cannot be NULL.
-- INSERT INTO Customers_ConstraintDemo
-- VALUES (2, NULL);


/*
===============================================================================
5. CHECK
===============================================================================

CHECK restricts values to those satisfying a condition.

Example:
*/

CREATE TABLE Products_ConstraintDemo
(
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) CHECK (price >= 0),
    stock_quantity INT CHECK (stock_quantity >= 0)
);

INSERT INTO Products_ConstraintDemo
VALUES (1, 'Mouse', 500, 20);

-- Invalid: price cannot be negative.
-- INSERT INTO Products_ConstraintDemo
-- VALUES (2, 'Keyboard', -100, 10);


/*
===============================================================================
6. DEFAULT
===============================================================================

DEFAULT supplies a value when an INSERT statement omits that column.

Example:
*/

CREATE TABLE Orders_ConstraintDemo
(
    order_id INT PRIMARY KEY,
    order_status VARCHAR(20) DEFAULT 'Pending'
);

-- order_status receives the default value 'Pending'.
INSERT INTO Orders_ConstraintDemo (order_id)
VALUES (1);

-- Explicitly supplied values override the default.
INSERT INTO Orders_ConstraintDemo (order_id, order_status)
VALUES (2, 'Delivered');

SELECT * FROM Orders_ConstraintDemo;


/*
===============================================================================
7. REFERENTIAL INTEGRITY
===============================================================================

Referential integrity ensures that relationships between tables remain valid.

Example:
    Departments is the parent table.
    DepartmentEmployees is the child table.

A child row cannot reference a department that does not exist.

SQL Server normally prevents deleting a parent row while child rows
reference it, unless the foreign key defines an appropriate delete action.

===============================================================================
8. CONSTRAINT VIOLATIONS
===============================================================================

A constraint violation occurs when an INSERT or UPDATE breaks a rule.

Examples:
    Duplicate PRIMARY KEY  -> rejected
    Duplicate UNIQUE value -> rejected
    NULL in NOT NULL column -> rejected
    Negative price when CHECK requires price >= 0 -> rejected
    Invalid FOREIGN KEY value -> rejected

A failed statement does not automatically mean all earlier statements
in a script are rolled back. Transaction behavior depends on how the
statements are executed and whether a transaction is used.


===============================================================================
9. VIEW EXISTING TABLE CONSTRAINTS
===============================================================================

Use system catalog views to inspect constraints on your tables.
*/

SELECT
    t.name AS table_name,
    c.name AS constraint_name,
    c.type_desc AS constraint_type
FROM sys.tables AS t
INNER JOIN sys.objects AS c
    ON c.parent_object_id = t.object_id
WHERE c.type IN ('PK', 'F', 'UQ', 'C', 'D')
ORDER BY t.name, c.type_desc;


/*
===============================================================================
QUICK REVISION
===============================================================================

PRIMARY KEY -> Uniquely identifies each row.
FOREIGN KEY -> Maintains valid relationships between tables.
UNIQUE      -> Prevents duplicate values.
NOT NULL    -> Requires a value.
CHECK       -> Validates a condition.
DEFAULT     -> Supplies a value when the column is omitted.

===============================================================================
END OF SQL CONSTRAINTS
===============================================================================
*/