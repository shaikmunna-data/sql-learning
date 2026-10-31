/*
===============================================================================
                         SQL FUNDAMENTALS
===============================================================================

THEORY
------

1. What is SQL?
2. What is a Database?
3. DBMS vs RDBMS
4. Tables, Rows, and Columns
5. Primary Key
6. Foreign Key
7. Relationships
8. SQL Server Basics
9. SQL Syntax and Statements
10. SQL Keywords and Identifiers
11. Comments
12. NULL Values


PRACTICE
--------

1. Create a Database
2. Create Tables
3. Insert Data
4. View Table Data

Database:
EcommerceSQL

Tables:
Customers
Employees
Products
Orders
OrderItems
===============================================================================
*/


/*
===============================================================================
1. WHAT IS SQL?
===============================================================================

SQL = Structured Query Language.

SQL is used to communicate with relational databases.

SQL can be used to:
- Create database objects
- Insert data
- Retrieve data
- Update data
- Delete data
- Filter data
- Sort data
- Aggregate data
- Join multiple tables
- Modify database structures

Example:

SELECT *
FROM Customers;
*/


/*
===============================================================================
2. WHAT IS A DATABASE?
===============================================================================

A database is an organized collection of data.

An e-commerce company may store:

Customers
Employees
Products
Orders
Order Items

These tables can be connected using keys.
*/


/*
===============================================================================
3. DBMS VS RDBMS
===============================================================================

DBMS
----
Database Management System.

Software used to store, manage, and retrieve data.

RDBMS
-----
Relational Database Management System.

Stores data in tables and allows relationships between tables.

Examples:
- SQL Server
- MySQL
- PostgreSQL
- Oracle

SQL Server is an RDBMS.
*/


/*
===============================================================================
4. TABLES, ROWS, AND COLUMNS
===============================================================================

TABLE
-----
A table stores related data using rows and columns.

ROW
---
A row represents one record.

COLUMN
------
A column represents one attribute.

Example:

Customers

customer_id | customer_name | city
------------|---------------|---------
1           | Rahul Sharma  | Hyderabad
2           | Priya Reddy   | Bengaluru

customer_id, customer_name, city = Columns

Each customer = Row
*/


/*
===============================================================================
5. PRIMARY KEY
===============================================================================

A Primary Key uniquely identifies each row in a table.

Rules:
- Values must be unique.
- Cannot contain NULL.
- A table has one primary key constraint.

Examples from this database:

Customers.customer_id
Employees.employee_id
Products.product_id
Orders.order_id
OrderItems.order_item_id
*/


/*
===============================================================================
6. FOREIGN KEY
===============================================================================

A Foreign Key connects one table to another table.

Examples:

Orders.customer_id
    references
Customers.customer_id


Orders.employee_id
    references
Employees.employee_id


OrderItems.order_id
    references
Orders.order_id


OrderItems.product_id
    references
Products.product_id
*/


/*
===============================================================================
7. RELATIONSHIPS
===============================================================================

Relationships connect related tables.

Our e-commerce database contains One-to-Many relationships.

Customers
    |
    | 1
    |
    | M
   Orders


Employees
    |
    | 1
    |
    | M
   Orders


Orders
    |
    | 1
    |
    | M
 OrderItems


Products
    |
    | 1
    |
    | M
 OrderItems


Example:

One customer can place many orders.

One order can contain many order items.

One product can appear in many order items.
*/


/*
===============================================================================
8. SQL SERVER BASICS
===============================================================================

SQL Server is Microsoft's relational database management system.

SQL Server commonly uses T-SQL
(Transact-SQL).

Tools used to work with SQL Server include:

- SQL Server Management Studio (SSMS)
- Azure Data Studio

GO
--
GO is a batch separator recognized by SQL Server tools.

It separates batches of SQL statements.
*/


/*
===============================================================================
9. SQL SYNTAX AND STATEMENTS
===============================================================================

SQL syntax defines how SQL statements are written.

Example:

SELECT column_name
FROM table_name;


Common SQL statements:

CREATE
INSERT
SELECT
UPDATE
DELETE
ALTER
DROP


SQL statements are commonly terminated with:

;


Example:

SELECT *
FROM Customers;
*/


/*
===============================================================================
10. SQL KEYWORDS AND IDENTIFIERS
===============================================================================

KEYWORDS
--------

Reserved/special words that have meaning in SQL.

Examples:

CREATE
DATABASE
TABLE
SELECT
FROM
WHERE
INSERT
INTO
VALUES
UPDATE
DELETE

DATA TYPES
----------

Data types define what kind of data a column can store.

Examples:

INT
VARCHAR
DATE
DECIMAL

IDENTIFIERS
-----------

Names given to database objects.

Examples from this database:

EcommerceSQL
Customers
customer_id
customer_name
Orders
order_id


Example:

CREATE TABLE Customers
(
    customer_id INT,
    customer_name VARCHAR(100)
);

CREATE, TABLE = keywords

INT, VARCHAR = data types

Customers, customer_id, customer_name = Identifiers
*/


/*
===============================================================================
11. COMMENTS
===============================================================================

Comments are used to explain SQL code.

Single-line comment:

-- This is a single-line comment


Multi-line comment:

/*
This is a
multi-line comment.
*/

Comments are ignored when SQL code is executed.
*/


/*
===============================================================================
12. NULL VALUES
===============================================================================

NULL represents a missing, unknown, or unavailable value.

NULL is NOT the same as:

0
''
' '
FALSE


Examples from our data:

Customers.email

Some customers do not have an email address.


Employees.manager_id

Some employees do not have a manager.


Orders.employee_id

Some orders were not assigned to an employee.


Orders.shipping_date

Some orders do not have a shipping date because they have not
been shipped or because shipping information is not available.

NULL represents the missing shipping date.


Products.supplier

Some products may not have supplier information.


To find NULL values:

WHERE column_name IS NULL


To find non-NULL values:

WHERE column_name IS NOT NULL


Example:

SELECT *
FROM Customers
WHERE email IS NULL;
*/


/*
===============================================================================
                         PRACTICE
===============================================================================
*/


/*
===============================================================================
1. CREATE DATABASE
===============================================================================
*/

CREATE DATABASE EcommerceSQL;
GO

USE EcommerceSQL;
GO


/*
===============================================================================
2. CREATE TABLES
===============================================================================
*/


/*
------------------------------------------------------------------------------
CUSTOMERS
------------------------------------------------------------------------------
Stores customer information.
*/

CREATE TABLE Customers
(
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    registration_date DATE,
    customer_status VARCHAR(20)
);


/*
------------------------------------------------------------------------------
EMPLOYEES
------------------------------------------------------------------------------
Stores employee information.

manager_id represents the employee's manager.
*/

CREATE TABLE Employees
(
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    hire_date DATE,
    manager_id INT NULL,
    salary DECIMAL(10,2)
);


/*
------------------------------------------------------------------------------
PRODUCTS
------------------------------------------------------------------------------
Stores products sold by the e-commerce company.
*/

CREATE TABLE Products
(
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INT,
    supplier VARCHAR(100)
);


/*
------------------------------------------------------------------------------
ORDERS
------------------------------------------------------------------------------
Stores customer orders.

customer_id -> Customers
employee_id -> Employees
*/

CREATE TABLE Orders
(
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    employee_id INT NULL,
    order_date DATE,
    shipping_date DATE NULL,
    order_status VARCHAR(30),
    payment_method VARCHAR(30),
    total_amount DECIMAL(10,2),

    FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),

    FOREIGN KEY (employee_id)
        REFERENCES Employees(employee_id)
);


/*
------------------------------------------------------------------------------
ORDER ITEMS
------------------------------------------------------------------------------
Stores individual products belonging to each order.

order_id  -> Orders
product_id -> Products
*/

CREATE TABLE OrderItems
(
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT,
    unit_price DECIMAL(10,2),

    FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES Products(product_id)
);


/*
===============================================================================
3. INSERT DATA
===============================================================================
*/


/*
------------------------------------------------------------------------------
CUSTOMERS
------------------------------------------------------------------------------
*/

INSERT INTO Customers
(
    customer_id,
    customer_name,
    email,
    city,
    state,
    registration_date,
    customer_status
)
VALUES
(1, 'Rahul Sharma', 'rahul@gmail.com', 'Hyderabad', 'Telangana', '2023-01-15', 'Active'),
(2, 'Priya Reddy', 'priya@gmail.com', 'Bengaluru', 'Karnataka', '2023-03-22', 'Active'),
(3, 'Arjun Kumar', NULL, 'Chennai', 'Tamil Nadu', '2023-05-10', 'Inactive'),
(4, 'Sneha Patel', 'sneha@gmail.com', 'Mumbai', 'Maharashtra', '2023-06-18', 'Active'),
(5, 'Vikram Singh', 'vikram@gmail.com', 'Delhi', 'Delhi', '2023-08-05', 'Active'),
(6, 'Anjali Rao', NULL, 'Pune', 'Maharashtra', '2024-01-12', 'Active'),
(7, 'Kiran Das', 'kiran@gmail.com', 'Kolkata', 'West Bengal', '2024-02-20', 'Inactive'),
(8, 'Meena Iyer', 'meena@gmail.com', 'Chennai', 'Tamil Nadu', '2024-04-11', 'Active'),
(9, 'Amit Verma', 'amit@gmail.com', 'Hyderabad', 'Telangana', '2024-05-25', 'Active'),
(10, 'Divya Nair', 'divya@gmail.com', 'Kochi', 'Kerala', '2024-07-01', 'Active'),
(11, 'Rohit Mehta', 'rohit@gmail.com', 'Ahmedabad', 'Gujarat', '2024-08-15', 'Active'),
(12, 'Lakshmi Devi', 'lakshmi@gmail.com', 'Vijayawada', 'Andhra Pradesh', '2024-09-10', 'Active'),
(13, 'Naveen Reddy', NULL, 'Hyderabad', 'Telangana', '2024-09-25', 'Inactive');


/*
------------------------------------------------------------------------------
EMPLOYEES
------------------------------------------------------------------------------
*/

INSERT INTO Employees
(
    employee_id,
    employee_name,
    department,
    hire_date,
    manager_id,
    salary
)
VALUES
(101, 'Suresh Kumar', 'Sales', '2021-01-10', NULL, 65000),
(102, 'Neha Singh', 'Sales', '2022-03-15', 101, 52000),
(103, 'Ravi Patel', 'Sales', '2023-06-20', 101, 48000),
(104, 'Pooja Sharma', 'Support', '2021-09-12', NULL, 60000),
(105, 'Manoj Rao', 'Support', '2023-02-18', 104, 45000),
(106, 'Kavya Reddy', 'IT', '2020-11-05', NULL, 80000),
(107, 'Arun Das', 'IT', '2024-01-22', 106, 55000),
(108, 'Deepak Sharma', 'Sales', '2024-05-15', 101, 47000),
(109, 'Swathi Rao', 'Support', '2024-06-10', 104, 43000),
(110, 'Nikhil Kumar', 'IT', '2024-07-01', 106, 50000),
(111, 'Amit Verma', 'Sales', '2024-01-15', 102, 42000),
(112, 'Priya Reddy', 'Sales', '2024-02-10', 102, 40000),
(113, 'Kiran Das', 'Sales', '2024-03-05', 103, 40000),
(114, 'Divya Nair', 'Sales', '2024-04-20', 108, 38000),
(115, 'Rahul Mehta', 'Support', '2024-01-22', 105, 41000),
(116, 'Sneha Patel', 'Support', '2024-05-12', 109, 39000),
(117, 'Arjun Kumar', 'IT', '2024-02-18', 107, 46000),
(118, 'Meena Iyer', 'IT', '2024-06-01', 110, 43000),
(119, 'Varun Rao', 'Sales', '2025-01-10', 111, 32000),
(120, 'Anjali Das', 'Sales', '2025-02-15', 111, 31000),
(121, 'Rohit Kumar', 'IT', '2025-03-12', 117, 46000),
(122, 'Pooja Reddy', 'Support', '2025-04-05', 115, 39000);

/*
------------------------------------------------------------------------------
PRODUCTS
------------------------------------------------------------------------------
*/

INSERT INTO Products
(
    product_id,
    product_name,
    category,
    price,
    stock_quantity,
    supplier
)
VALUES
(201, 'Laptop', 'Electronics', 65000.00, 15, 'Dell'),
(202, 'Smartphone', 'Electronics', 30000.00, 25, 'Samsung'),
(203, 'Headphones', 'Electronics', 2500.00, 40, 'Sony'),
(204, 'Keyboard', 'Accessories', 1500.00, 50, 'Logitech'),
(205, 'Mouse', 'Accessories', 800.00, 75, 'Logitech'),
(206, 'Office Chair', 'Furniture', 12000.00, 10, 'GreenSoul'),
(207, 'Desk', 'Furniture', 9000.00, 8, 'Ikea'),
(208, 'Monitor', 'Electronics', 18000.00, 20, 'LG'),
(209, 'Backpack', 'Accessories', 2200.00, 30, NULL),
(210, 'Tablet', 'Electronics', 25000.00, 12, 'Lenovo'),
(211, 'Webcam', 'Electronics', 4500.00, 25, 'Logitech'),
(212, 'Bookshelf', 'Furniture', 7500.00, 12, 'Ikea'),
(213, 'USB Hub', 'Accessories', 1200.00, 35, NULL);

/*
------------------------------------------------------------------------------
ORDERS
------------------------------------------------------------------------------
*/

INSERT INTO Orders
(
    order_id,
    customer_id,
    employee_id,
    order_date,
    shipping_date,
    order_status,
    payment_method,
    total_amount
)
VALUES
(1001, 1, 101, '2024-01-05', '2024-01-07', 'Delivered', 'Credit Card', 67500),
(1002, 2, 102, '2024-01-12', '2024-01-15', 'Delivered', 'UPI', 30000),
(1003, 3, NULL, '2024-02-03', NULL, 'Cancelled', 'Cash', 2500),
(1004, 4, 101, '2024-02-18', '2024-02-20', 'Delivered', 'Credit Card', 13800),
(1005, 5, 103, '2024-03-10', '2024-03-13', 'Delivered', 'UPI', 9200),
(1006, 1, 102, '2024-03-22', '2024-03-25', 'Delivered', 'Debit Card', 18000),
(1007, 6, NULL, '2024-04-05', NULL, 'Pending', 'UPI', 25000),
(1008, 7, 103, '2024-04-18', '2024-04-21', 'Delivered', 'Credit Card', 4000),
(1009, 8, 101, '2024-05-02', '2024-05-05', 'Delivered', 'UPI', 74000),
(1010, 9, 102, '2024-05-15', NULL, 'Pending', 'Credit Card', 12000),
(1011, 10, 103, '2024-06-01', '2024-06-04', 'Delivered', 'UPI', 27000),
(1012, 4, 101, '2024-06-20', '2024-06-23', 'Delivered', 'Debit Card', 10500),
(1013, 2, 102, '2024-07-05', NULL, 'Cancelled', 'UPI', 30000),
(1014, 5, 103, '2024-07-18', '2024-07-21', 'Delivered', 'Credit Card', 12000),
(1015, 6, NULL, '2024-08-02', '2024-08-05', 'Delivered', 'UPI', 20500),
(1016, 1, 108, '2024-08-10', '2024-08-13', 'Delivered', 'UPI', 4500),
(1017, 8, 109, '2024-08-15', '2024-08-18', 'Delivered', 'Credit Card', 7500),
(1018, 9, NULL, '2024-08-20', NULL, 'Pending', 'UPI', 1200),
(1019, 2, 102, '2024-09-05', '2024-09-08', 'Delivered', 'Debit Card', 4500);
/*
------------------------------------------------------------------------------
ORDER ITEMS
------------------------------------------------------------------------------
*/

INSERT INTO OrderItems
(
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price
)
VALUES
(1, 1001, 201, 1, 65000),
(2, 1001, 205, 1, 800),
(3, 1001, 204, 1, 1500),
(4, 1002, 202, 1, 30000),
(5, 1003, 203, 1, 2500),
(6, 1004, 206, 1, 12000),
(7, 1004, 205, 2, 800),
(8, 1005, 207, 1, 9000),
(9, 1005, 205, 1, 800),
(10, 1006, 208, 1, 18000),
(11, 1007, 210, 1, 25000),
(12, 1008, 203, 1, 2500),
(13, 1008, 209, 1, 2200),
(14, 1009, 201, 1, 65000),
(15, 1009, 203, 2, 2500),
(16, 1010, 206, 1, 12000),
(17, 1011, 210, 1, 25000),
(18, 1011, 205, 2, 800),
(19, 1012, 207, 1, 9000),
(20, 1012, 204, 1, 1500),
(21, 1013, 202, 1, 30000),
(22, 1014, 206, 1, 12000),
(23, 1015, 208, 1, 18000),
(24, 1015, 204, 1, 1500),
(25, 1016, 203, 1, 2500),
(26, 1016, 209, 1, 2200),
(27, 1017, 207, 1, 7500),
(28, 1018, 213, 1, 1200),
(29, 1019, 203, 1, 2500),
(30, 1019, 209, 1, 2000);

/*
===============================================================================
4. VIEW TABLE DATA
===============================================================================
*/


/*
View Customers
*/

SELECT *
FROM Customers;


/*
View Employees
*/

SELECT *
FROM Employees;


/*
View Products
*/

SELECT *
FROM Products;


/*
View Orders
*/

SELECT *
FROM Orders;


/*
View OrderItems
*/

SELECT *
FROM OrderItems;


/*
===============================================================================
VIEW SPECIFIC COLUMNS
===============================================================================
*/

SELECT
    customer_id,
    customer_name,
    city,
    customer_status
FROM Customers;


/*
===============================================================================
CHECK NULL VALUES
===============================================================================
*/

SELECT *
FROM Customers
WHERE email IS NULL;


/*
===============================================================================
QUICK REVISION
===============================================================================

SQL
-> Language used to communicate with relational databases.

Database
-> Organized collection of data.

DBMS
-> Software used to manage databases.

RDBMS
-> Database system that stores related data in tables.

Table
-> Stores data in rows and columns.

Row
-> Represents one record.

Column
-> Represents one attribute.

Primary Key
-> Uniquely identifies a row.

Foreign Key
-> Creates a relationship between tables.

Relationship
-> Connects related tables.

NULL
-> Represents missing or unknown data.

SQL Server
-> Microsoft's RDBMS.

T-SQL
-> Microsoft's extension of SQL.

GO
-> Batch separator used by SQL Server tools.

===============================================================================
*/

/*
===============================================================================
PRACTICE DATA: SET OPERATORS
===============================================================================

Scenario
An e-commerce company runs two marketing campaigns.

CampaignA contains customers selected for a festival sale.
CampaignB contains customers selected for a year-end sale.

Some customers appear in both campaigns, while others appear in only one.

This dataset helps us practice:
    UNION
    UNION ALL
    INTERSECT
    EXCEPT
*/


USE EcommerceSQL;
GO


-- -----------------------------------------------------------------------------
-- 1. CREATE TABLES
-- -----------------------------------------------------------------------------

-- Make the script safe to execute again.

IF OBJECT_ID('CampaignA', 'U') IS NOT NULL
    DROP TABLE CampaignA;
GO

IF OBJECT_ID('CampaignB', 'U') IS NOT NULL
    DROP TABLE CampaignB;
GO


CREATE TABLE CampaignA (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL
);
GO

CREATE TABLE CampaignB (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL
);
GO


-- -----------------------------------------------------------------------------
-- 2. INSERT SAMPLE DATA
-- -----------------------------------------------------------------------------

INSERT INTO CampaignA (customer_id, customer_name)
VALUES
(1, 'Rahul Sharma'),
(2, 'Priya Reddy'),
(3, 'Arjun Kumar'),
(4, 'Sneha Patel'),
(5, 'Vikram Singh');

INSERT INTO CampaignB (customer_id, customer_name)
VALUES
(3, 'Arjun Kumar'),
(4, 'Sneha Patel'),
(5, 'Vikram Singh'),
(6, 'Anjali Rao'),
(7, 'Kiran Das');


-- -----------------------------------------------------------------------------
-- 3. VIEW TABLE DATA
-- -----------------------------------------------------------------------------

SELECT *
FROM CampaignA
ORDER BY customer_id;

SELECT *
FROM CampaignB
ORDER BY customer_id;
