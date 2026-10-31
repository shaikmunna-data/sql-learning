/*
===============================================================================
23. TRANSACTIONS
===============================================================================

1. WHAT IS A TRANSACTION?
===============================================================================

A transaction is a group of SQL operations treated as one logical unit.

Either all operations are completed successfully, or changes are undone
when the transaction is rolled back.

Example:

When a customer places an order:
    1. Insert a new order.
    2. Insert order items.
    3. Reduce product stock.

All these operations should succeed together.

If one operation fails, we should undo the changes made by the transaction.


===============================================================================
2. WHY DO WE NEED TRANSACTIONS?
===============================================================================

Transactions help to:

    - Maintain data accuracy.
    - Prevent incomplete operations.
    - Protect data consistency.
    - Undo changes when something goes wrong.
    - Handle multiple related SQL operations safely.

Example:

A customer orders a laptop.

Before the transaction:
    Product stock = 10

After a successful order:
    Product stock = 9
    Order record = Created

If order creation fails:
    Product stock should remain 10.


===============================================================================
3. ACID PROPERTIES
===============================================================================

ACID represents four important properties of database transactions.

A. ATOMICITY
------------

A transaction is treated as one complete unit.

Either all operations succeed or none of them are applied.

Example:
    Create an order + Reduce product stock.

If stock reduction fails, the order creation should also be undone.


B. CONSISTENCY
--------------

A transaction must move the database from one valid state to another.

All database rules and constraints must remain satisfied.

Example:
    Product stock should never become negative if a constraint
    prevents negative stock.


C. ISOLATION
------------

Concurrent transactions should not interfere with each other.

The database controls how transactions access shared data.

Example:
    Two customers try to purchase the last available laptop.

The database must handle concurrent updates safely.


D. DURABILITY
-------------

Once a transaction is committed, its changes are permanently saved.

Example:
    After an order is successfully committed, its data remains saved
    even if the application closes.

QUICK REVISION:

    Atomicity   = All or nothing.
    Consistency = Valid data before and after.
    Isolation   = Transactions do not interfere incorrectly.
    Durability  = Committed changes are saved.


===============================================================================
4. BEGIN TRANSACTION
===============================================================================

BEGIN TRANSACTION starts a new transaction.

Changes made after BEGIN TRANSACTION can be committed or rolled back.

SYNTAX:

    BEGIN TRANSACTION;

Example:
*/
SELECT *
FROM Products
WHERE product_id = 201;

BEGIN TRANSACTION;

UPDATE dbo.Products
SET stock_quantity = stock_quantity - 1
WHERE product_id = 201
  AND stock_quantity > 0;

SELECT *
FROM dbo.Products
WHERE product_id = 201;

-- Undo the change for this practice example.
ROLLBACK TRANSACTION;
GO
SELECT *
FROM Products
WHERE product_id = 201;

/*
===============================================================================
5. COMMIT
===============================================================================

COMMIT permanently saves the changes made in a transaction.

SYNTAX:

    BEGIN TRANSACTION;

    SQL statements;

    COMMIT TRANSACTION;

Example:
*/
SELECT *
FROM Products
WHERE product_id = 201;

BEGIN TRANSACTION;

UPDATE dbo.Products
SET stock_quantity = stock_quantity - 1
WHERE product_id = 201
  AND stock_quantity > 0;

-- Check the updated product stock.
SELECT *
FROM dbo.Products
WHERE product_id = 201;

-- Save the changes.
COMMIT TRANSACTION;
GO


/*
===============================================================================
6. ROLLBACK
===============================================================================

ROLLBACK undoes the changes made in the current transaction.

SYNTAX:

    BEGIN TRANSACTION;

    SQL statements;

    ROLLBACK TRANSACTION;

Example:
*/
SELECT *
FROM Products
WHERE product_id = 201;

BEGIN TRANSACTION;

UPDATE dbo.Products
SET stock_quantity = stock_quantity - 5
WHERE product_id = 201;

-- Check the temporary change.
SELECT *
FROM dbo.Products
WHERE product_id = 201;

-- Undo the update.
ROLLBACK TRANSACTION;

-- Check the original stock.
SELECT *
FROM dbo.Products
WHERE product_id = 201;
GO


/*
===============================================================================
7. SAVE TRANSACTION
===============================================================================

SAVE TRANSACTION creates a savepoint inside an active transaction.

It allows us to roll back part of a transaction without undoing
everything.

SYNTAX:

    BEGIN TRANSACTION;

    SAVE TRANSACTION SavepointName;

    ROLLBACK TRANSACTION SavepointName;

Example:

    1. Update product stock.
    2. Create a savepoint.
    3. Update another product.
    4. Roll back to the savepoint.

The first update remains pending.
The second update is undone.

SQL SERVER EXAMPLE:
*/

SELECT *
FROM Products
WHERE product_id IN(201, 202);

BEGIN TRANSACTION;

-- First update.
UPDATE dbo.Products
SET stock_quantity = stock_quantity - 1
WHERE product_id = 201;

-- Create a savepoint.
SAVE TRANSACTION AfterFirstUpdate;

-- Second update.
UPDATE dbo.Products
SET stock_quantity = stock_quantity - 2
WHERE product_id = 202;

-- Undo changes made after the savepoint.
ROLLBACK TRANSACTION AfterFirstUpdate;

-- First update remains pending.
SELECT *
FROM dbo.Products
WHERE product_id IN (201, 202);

-- Undo the entire transaction for practice.
ROLLBACK TRANSACTION;
GO

/*
IMPORTANT:

SQL Server uses:

    SAVE TRANSACTION SavepointName;
    ROLLBACK TRANSACTION SavepointName;

Other databases may use different syntax.

A savepoint does not commit any changes.
The outer transaction must still be committed or rolled back.


===============================================================================
8. TRANSACTION CONSISTENCY
===============================================================================

Consistency means that a transaction must preserve database rules.

Examples of database rules:

    - Primary key values must be unique.
    - Foreign keys must reference existing records.
    - NOT NULL columns cannot contain NULL.
    - CHECK constraints must be satisfied.
    - Product stock must not become negative if a suitable constraint
      is defined.

Example: Prevent negative product stock.

Assuming the Products table does not already have a stock CHECK constraint,
the following example creates a separate practice table.
*/

DROP TABLE IF EXISTS dbo.TransactionStockDemo;
GO

CREATE TABLE dbo.TransactionStockDemo
(
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL,
    StockQuantity INT NOT NULL,

    CONSTRAINT CK_TransactionStockDemo_Stock
        CHECK (StockQuantity >= 0)
);
GO

INSERT INTO dbo.TransactionStockDemo
    (ProductID, ProductName, StockQuantity)
VALUES
    (201, 'Laptop', 10);
GO

-- This update is valid.
UPDATE dbo.TransactionStockDemo
SET StockQuantity = StockQuantity - 2
WHERE ProductID = 201;

SELECT *
FROM dbo.TransactionStockDemo;
GO

-- This update violates the CHECK constraint.
-- SQL Server rejects the update.
-- The transaction example below demonstrates how to handle such errors.

/*
===============================================================================
9. ERROR HANDLING IN TRANSACTIONS
===============================================================================

Errors can occur during a transaction.

Examples:
    - Constraint violation.
    - Invalid data.
    - Duplicate primary key.
    - Foreign key violation.
    - Other SQL execution errors.

SQL Server provides:

    TRY
    CATCH
    ERROR_MESSAGE()
    XACT_STATE()
    ROLLBACK TRANSACTION

TRY:
    Contains SQL statements that may cause errors.

CATCH:
    Handles errors raised inside the TRY block.

XACT_STATE():
    Returns the transaction state:

        1  = Active transaction that can be committed.
       -1  = Active transaction that cannot be committed.
        0  = No active transaction.

Example:
*/

BEGIN TRY

    BEGIN TRANSACTION;

    -- Valid update.
    UPDATE dbo.TransactionStockDemo
    SET StockQuantity = StockQuantity - 2
    WHERE ProductID = 201;

    -- Invalid update: violates the CHECK constraint.
    UPDATE dbo.TransactionStockDemo
    SET StockQuantity = -5
    WHERE ProductID = 201;

    -- Reached only if no error occurs.
    COMMIT TRANSACTION;

END TRY

BEGIN CATCH

    -- Undo the transaction if one is active.
    IF XACT_STATE() <> 0
    BEGIN
        ROLLBACK TRANSACTION;
    END;

    -- Display the error.
    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;

END CATCH;
GO

-- Verify that the first update was also undone.
SELECT *
FROM dbo.TransactionStockDemo;
GO


/*
===============================================================================
10. IMPORTANT TRANSACTION COMMANDS
===============================================================================

BEGIN TRANSACTION:
    Starts a transaction.

COMMIT TRANSACTION:
    Saves all changes in the transaction.

ROLLBACK TRANSACTION:
    Undoes all changes in the transaction.

SAVE TRANSACTION:
    Creates a savepoint.

ROLLBACK TRANSACTION SavepointName:
    Undoes changes made after a savepoint.

TRY...CATCH:
    Handles SQL execution errors.

XACT_STATE():
    Checks the current transaction state.


===============================================================================
11. IMPORTANT THINGS TO REMEMBER
===============================================================================

1. Always decide whether changes should be committed or rolled back.

2. Do not leave transactions open unnecessarily.

3. Use TRY...CATCH for transaction error handling in SQL Server.

4. A failed statement does not always automatically roll back
   the entire transaction.

5. A transaction can contain multiple INSERT, UPDATE, and DELETE statements.

6. COMMIT saves the transaction changes.

7. ROLLBACK undoes uncommitted transaction changes.

8. SAVE TRANSACTION creates a savepoint, not a separate transaction.

9. SQL Server supports nested BEGIN TRANSACTION statements, but they do not
   create independent transactions. A full rollback rolls back the outer
   transaction.

10. Keep transactions as short as practical to reduce locking and blocking.


===============================================================================
13. QUICK REVISION
===============================================================================

What is a transaction?
    A group of SQL operations treated as one logical unit.

What are ACID properties?
    Atomicity, Consistency, Isolation, Durability.

What does BEGIN TRANSACTION do?
    Starts a transaction.

What does COMMIT do?
    Saves transaction changes.

What does ROLLBACK do?
    Undoes uncommitted changes.

What does SAVE TRANSACTION do?
    Creates a savepoint inside a transaction.

What is TRY...CATCH?
    SQL Server error-handling structure.

What does XACT_STATE() do?
    Checks whether a transaction is active and whether it can be committed.

===============================================================================
14. INTERVIEW FOCUS
===============================================================================

Important interview questions:

1. What is a transaction in SQL?
2. Explain ACID properties with examples.
3. Difference between COMMIT and ROLLBACK.
4. What is a savepoint?
5. What happens when an error occurs inside a transaction?
6. What is the difference between a transaction and a savepoint?
7. Can we roll back a committed transaction?
8. What is transaction consistency?
9. What is the purpose of TRY...CATCH?
10. What is the difference between XACT_STATE() and @@TRANCOUNT?

===============================================================================
END OF TRANSACTIONS
===============================================================================
*/