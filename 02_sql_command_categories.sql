/*
===============================================================================
                         SQL COMMAND CATEGORIES
===============================================================================

SQL commands are commonly divided into five major categories:

+------+-----------------------------+----------------------------------+
|      | Full Form                   | Purpose                          |
+------+-----------------------------+----------------------------------+
| DDL  | Data Definition Language    | Define database objects         |
| DML  | Data Manipulation Language  | Modify data                     |
| DQL  | Data Query Language         | Retrieve data                   |
| DCL  | Data Control Language       | Control permissions             |
| TCL  | Transaction Control Language| Manage transactions             |
+------+-----------------------------+----------------------------------+


===============================================================================
1. DDL - DATA DEFINITION LANGUAGE
===============================================================================

Purpose:
Define and modify the structure of database objects.

Common DDL commands:

CREATE
ALTER
DROP
TRUNCATE

Examples:

CREATE TABLE
ALTER TABLE
DROP TABLE
TRUNCATE TABLE


CREATE
------
Creates a new database object.

Example:

CREATE TABLE Categories
(
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50)
);


ALTER
-----
Modifies the structure of an existing object.

Example:

ALTER TABLE Products
ADD brand VARCHAR(50);


DROP
----
Deletes a database object and its structure.

Example:

DROP TABLE Categories;


TRUNCATE
--------
Removes all rows from a table while keeping the table structure.

Example:

TRUNCATE TABLE Categories;

===============================================================================
2. DML - DATA MANIPULATION LANGUAGE
===============================================================================

Purpose:
Insert, modify, and delete data stored in tables.

Common DML commands:

INSERT
UPDATE
DELETE


INSERT
------
Adds new rows to a table.

Example:

INSERT INTO Products
(product_id, product_name, category, price, stock_quantity, supplier)
VALUES
(211, 'Webcam', 'Electronics', 3500, 20, 'Logitech');


UPDATE
------
Modifies existing rows.

Example:

UPDATE Products
SET price = 3700
WHERE product_id = 211;


DELETE
------
Removes rows from a table.

Example:

DELETE FROM Products
WHERE product_id = 211;


===============================================================================
3. DQL - DATA QUERY LANGUAGE
===============================================================================

Purpose:
Retrieve data from database tables.

Main command:

SELECT


Example:

SELECT *
FROM Products;


Example:

SELECT
    product_name,
    price
FROM Products
WHERE price > 10000;


NOTE:
Some SQL references classify SELECT separately as DQL,
while others group it under DML. For learning purposes,
we will treat SELECT as DQL.


===============================================================================
4. DCL - DATA CONTROL LANGUAGE
===============================================================================

Purpose:
Control access and permissions on database objects.

Common commands:

GRANT
REVOKE


GRANT
-----
Gives permissions to a user or role.

Example:

GRANT SELECT
ON Products
TO SomeUser;


REVOKE
------
Removes previously granted permissions.

Example:

REVOKE SELECT
ON Products
FROM SomeUser;


NOTE:
These commands require appropriate SQL Server permissions.
Do not execute them unless you have created the required user/role.


===============================================================================
5. TCL - TRANSACTION CONTROL LANGUAGE
===============================================================================

Purpose:
Manage transactions.

Common commands:

BEGIN TRANSACTION
COMMIT
ROLLBACK
SAVE TRANSACTION


BEGIN TRANSACTION
-----------------
Starts a transaction.

COMMIT
------
Permanently saves the changes.

ROLLBACK
--------
Undoes changes made during the transaction.


Example:

BEGIN TRANSACTION;

UPDATE Products
SET price = price + 500
WHERE category = 'Electronics';

ROLLBACK;


After ROLLBACK, the price changes are undone.


Example using COMMIT:

BEGIN TRANSACTION;

UPDATE Products
SET price = price + 500
WHERE category = 'Electronics';

COMMIT;


After COMMIT, the changes are permanently saved.


===============================================================================
QUICK REVISION
===============================================================================

DDL
-> Defines database structure.

CREATE
ALTER
DROP
TRUNCATE


DML
-> Modifies data.

INSERT
UPDATE
DELETE


DQL
-> Retrieves data.

SELECT


DCL
-> Controls permissions.

GRANT
REVOKE


TCL
-> Manages transactions.

BEGIN TRANSACTION
COMMIT
ROLLBACK
SAVE TRANSACTION


===============================================================================
IMPORTANT
===============================================================================

DDL -> Structure
DML -> Data modification
DQL -> Data retrieval
DCL -> Permissions
TCL -> Transactions

===============================================================================
*/