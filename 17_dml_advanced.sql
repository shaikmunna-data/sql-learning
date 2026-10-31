/*
===============================================================================
17. DATA MODIFICATION - ADVANCED DML
===============================================================================

DML stands for Data Manipulation Language.

DML commands are used to add, modify, and delete table data.

Topics:
    1. INSERT
    2. UPDATE
    3. DELETE
    4. UPDATE Using JOIN
    5. INSERT Using SELECT
    6. DELETE Using JOIN
    7. Dangers of UPDATE and DELETE Without WHERE
    8. MERGE Concept

IMPORTANT:
    Always check the rows affected before modifying important data.
===============================================================================
*/

USE EcommerceSQL;
GO


/*
===============================================================================
1. INSERT
===============================================================================

INSERT adds new rows to a table.

Syntax:

INSERT INTO table_name (column1, column2)
VALUES (value1, value2);

Example:
Add a new product.

Run this example only once unless you delete the inserted product first.
*/

INSERT INTO Products
    (product_id, product_name, category, price, stock_quantity, supplier)
VALUES
    (999, 'Wireless Mouse', 'Electronics', 799.00, 50, 'Tech Supplier');


-- View the inserted record.
SELECT *
FROM Products
WHERE product_id = 999;


/*
Insert multiple rows in one statement.
Use unused product IDs in your own database.
*/

INSERT INTO Products
    (product_id, product_name, category, price, stock_quantity, supplier)
VALUES
    (997, 'Laptop Stand', 'Accessories', 1200.00, 25, 'Office Supplier'),
    (998, 'USB Cable', 'Electronics', 199.00, 100, 'Tech Supplier');


-- View the inserted records.
SELECT *
FROM Products
WHERE product_id IN (997, 998);


/*
===============================================================================
2. UPDATE
===============================================================================

UPDATE changes existing data.

Syntax:

UPDATE table_name
SET column_name = new_value
WHERE condition;

Example:
Change the price of product 999.
*/

UPDATE Products
SET price = 849.00
WHERE product_id = 999;


-- Verify the updated price.
SELECT product_id, product_name, price
FROM Products
WHERE product_id = 999;


/*
Update multiple columns.
*/

UPDATE Products
SET
    price = 899.00,
    stock_quantity = 45
WHERE product_id = 999;


/*
===============================================================================
3. DELETE
===============================================================================

DELETE removes rows from a table.

Syntax:

DELETE FROM table_name
WHERE condition;

Example:
Delete only product 999.
*/

DELETE FROM Products
WHERE product_id = 999;


-- Check whether the record still exists.
SELECT *
FROM Products
WHERE product_id = 999;

--Delete multiple products
DELETE FROM Products
WHERE product_id IN (997, 998);

-- Check whether the records still exists.
SELECT *
FROM Products;
/*
===============================================================================
4. UPDATE USING JOIN
===============================================================================

A JOIN lets you update one table using matching data from another table.

Example scenario:
An order is handled by an employee. We want to update the order status
for orders handled by a particular employee.

This example changes matching orders to 'Processing'.
Use it only if 'Processing' is a valid order_status in your database.
*/

-- Preview the affected orders first.
SELECT
    o.order_id,
    o.order_status,
    e.employee_id,
    e.employee_name
FROM Orders AS o
INNER JOIN Employees AS e
    ON o.employee_id = e.employee_id
WHERE e.employee_id = 101;


-- Update matching orders only after checking the preview.
-- Uncomment the following statement when ready.

-- UPDATE o
-- SET order_status = 'Processing'
-- FROM Orders AS o
-- INNER JOIN Employees AS e
--     ON o.employee_id = e.employee_id
--WHERE e.employee_id = 101;


/*
===============================================================================
5. INSERT USING SELECT
===============================================================================

INSERT INTO ... SELECT copies query results into another table.

Example scenario:
Create a backup table for products costing more than 1000.

This creates a new table, so run it only once.
*/

IF OBJECT_ID('dbo.ExpensiveProductsBackup', 'U') IS NULL
BEGIN
    SELECT
        product_id,
        product_name,
        category,
        price
    INTO dbo.ExpensiveProductsBackup
    FROM Products
    WHERE price > 1000;
END;
GO


-- View the backup data.
SELECT *
FROM dbo.ExpensiveProductsBackup;


/*
To insert additional qualifying products later, use INSERT INTO ... SELECT.
The NOT EXISTS check avoids inserting product IDs already in the backup.
*/

INSERT INTO dbo.ExpensiveProductsBackup
    (product_id, product_name, category, price)
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.price
FROM Products AS p
WHERE p.price > 1000
  AND NOT EXISTS
  (
      SELECT 1
      FROM dbo.ExpensiveProductsBackup AS b
      WHERE b.product_id = p.product_id
  );


/*
===============================================================================
6. DELETE USING JOIN
===============================================================================

A JOIN lets you delete rows from one table based on matching data
in another table.

Example scenario:
Delete order items belonging to cancelled orders.

IMPORTANT:
Preview the matching rows before deleting.
Deleting order items permanently removes those detail records.
*/

-- Preview the order items that match cancelled orders.
SELECT
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    o.order_status
FROM OrderItems AS oi
INNER JOIN Orders AS o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Cancelled';


-- Delete only after confirming the preview and business requirements.
-- Uncomment when you are certain these detail records should be removed.

--DELETE oi
--FROM OrderItems AS oi
--INNER JOIN Orders AS o
--    ON oi.order_id = o.order_id
--WHERE o.order_status = 'Cancelled';


/*
===============================================================================
7. DANGER: UPDATE WITHOUT WHERE
===============================================================================

An UPDATE without WHERE changes EVERY ROW in the table.

DANGEROUS EXAMPLE - DO NOT RUN:

UPDATE Products
SET price = 0;

This sets every product price to zero.

SAFE EXAMPLE:
*/

UPDATE Products
SET price = 999.00
WHERE product_id = 201;


/*
===============================================================================
7.1. DANGER: DELETE WITHOUT WHERE
===============================================================================

A DELETE without WHERE removes EVERY ROW from the table.

DANGEROUS EXAMPLE - DO NOT RUN:

DELETE FROM Products;

This removes all product records.

SAFE EXAMPLE:
*/

DELETE FROM Products
WHERE product_id = 999;


/*
===============================================================================
7.2 SAFER UPDATE AND DELETE WITH TRANSACTIONS
===============================================================================

A transaction lets you check a change before committing it.

Example:
Update one product price, verify the result, and roll back the change.

ROLLBACK cancels the changes made inside this transaction.
*/

BEGIN TRANSACTION;

UPDATE Products
SET price = 1234.00
WHERE product_id = 201;

-- Verify the temporary change.
SELECT product_id, product_name, price
FROM Products
WHERE product_id = 201;

-- Cancel the example change.
ROLLBACK TRANSACTION;


/*
To make a verified change permanent, use COMMIT TRANSACTION instead
of ROLLBACK TRANSACTION.

Always confirm the WHERE condition and affected rows before committing.
*/

/*
===============================================================================
17. MERGE STATEMENT - SQL SERVER
===============================================================================

WHAT IS MERGE?

MERGE compares a SOURCE table with a TARGET table using a matching condition.

Based on the match, MERGE can:
    1. UPDATE existing records.
    2. INSERT new records.
    3. DELETE existing records when they are absent from the source,
       if that action is explicitly specified.

IMPORTANT TERMS:

TARGET:
    The table whose data we want to change.

SOURCE:
    The table or query containing the incoming data.

ON:
    Specifies how source records match target records.

WHEN MATCHED:
    A source record matches a target record.

WHEN NOT MATCHED BY TARGET:
    A source record has no matching target record.

WHEN NOT MATCHED BY SOURCE:
    A target record has no matching source record.

===============================================================================
1. BASIC MERGE SYNTAX
===============================================================================

MERGE INTO TargetTable AS target
USING SourceTable AS source
    ON target.id = source.id

WHEN MATCHED THEN
    UPDATE SET target.column_name = source.column_name

WHEN NOT MATCHED BY TARGET THEN
    INSERT (id, column_name)
    VALUES (source.id, source.column_name)

WHEN NOT MATCHED BY SOURCE THEN
    DELETE
;

The DELETE action is optional. Include it only when deleting target records
that are missing from the source is genuinely required.

Always terminate a SQL Server MERGE statement with a semicolon.


===============================================================================
2. CREATE SOURCE AND TARGET TABLES
===============================================================================

Example scenario:

An online store receives updated product information from a supplier.

The target table stores the current products.
The source table stores the latest supplier data.

We will demonstrate all three actions:
    - UPDATE a matching product.
    - INSERT a new product.
    - DELETE a target product that is absent from the source.

These are demonstration tables, separate from the existing Products table.
*/

IF OBJECT_ID('dbo.MergeTargetProducts', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.MergeTargetProducts
    (
        product_id INT PRIMARY KEY,
        product_name VARCHAR(100) NOT NULL,
        price DECIMAL(10, 2) NOT NULL,
        stock_quantity INT NOT NULL
    );
END;
GO

IF OBJECT_ID('dbo.MergeSourceProducts', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.MergeSourceProducts
    (
        product_id INT PRIMARY KEY,
        product_name VARCHAR(100) NOT NULL,
        price DECIMAL(10, 2) NOT NULL,
        stock_quantity INT NOT NULL
    );
END;
GO


/*
===============================================================================
3. INSERT SAMPLE DATA
===============================================================================

For repeatable practice, reset only these demonstration tables.
Do not use this reset pattern on real business tables.
*/

DELETE FROM dbo.MergeSourceProducts;
DELETE FROM dbo.MergeTargetProducts;

INSERT INTO dbo.MergeTargetProducts
    (product_id, product_name, price, stock_quantity)
VALUES
    (1, 'Wireless Mouse', 700.00, 20),
    (2, 'Keyboard',       1200.00, 15),
    (3, 'USB Hub',         500.00, 30);

INSERT INTO dbo.MergeSourceProducts
    (product_id, product_name, price, stock_quantity)
VALUES
    (1, 'Wireless Mouse', 800.00, 25),
    (2, 'Keyboard',       1200.00, 15),
    (4, 'Laptop Stand',   1500.00, 10);


/*
Before MERGE, view both tables.
*/

SELECT * FROM dbo.MergeTargetProducts ORDER BY product_id;
SELECT * FROM dbo.MergeSourceProducts ORDER BY product_id;


/*
TARGET TABLE:

product_id | product_name    | price  | stock_quantity
-----------|-----------------|--------|---------------
1          | Wireless Mouse  | 700.00 | 20
2          | Keyboard        | 1200.00| 15
3          | USB Hub         | 500.00 | 30

SOURCE TABLE:

product_id | product_name    | price  | stock_quantity
-----------|-----------------|--------|---------------
1          | Wireless Mouse  | 800.00 | 25
2          | Keyboard        | 1200.00| 15
4          | Laptop Stand    | 1500.00| 10


===============================================================================
4. MERGE WITH UPDATE ONLY
===============================================================================

WHEN MATCHED:

Product IDs 1 and 2 exist in both tables.
Their target rows are updated using the source values.

Product ID 3 is not changed because it has no source match.
Product ID 4 is not inserted because there is no INSERT action.
*/

MERGE INTO dbo.MergeTargetProducts AS target
USING dbo.MergeSourceProducts AS source
    ON target.product_id = source.product_id
WHEN MATCHED THEN
    UPDATE SET
        target.product_name = source.product_name,
        target.price = source.price,
        target.stock_quantity = source.stock_quantity
;

SELECT * FROM dbo.MergeTargetProducts ORDER BY product_id;


/*
RESULT:
    Product 1 price changes from 700 to 800.
    Product 1 stock changes from 20 to 25.
    Product 2 remains unchanged because its values are the same.
    Product 3 remains in the target.
    Product 4 is not inserted.

NOTE:
We will reset the target before the next independent example.
*/


/*
===============================================================================
5. MERGE WITH INSERT AND UPDATE
===============================================================================

WHEN MATCHED:
    Update the existing target record.

WHEN NOT MATCHED BY TARGET:
    Insert a source record that does not exist in the target.

This is a common data synchronization pattern.
*/

-- Reset the target to its original demonstration data.
DELETE FROM dbo.MergeTargetProducts;

INSERT INTO dbo.MergeTargetProducts
    (product_id, product_name, price, stock_quantity)
VALUES
    (1, 'Wireless Mouse', 700.00, 20),
    (2, 'Keyboard',       1200.00, 15),
    (3, 'USB Hub',         500.00, 30);


MERGE INTO dbo.MergeTargetProducts AS target
USING dbo.MergeSourceProducts AS source
    ON target.product_id = source.product_id

WHEN MATCHED THEN
    UPDATE SET
        target.product_name = source.product_name,
        target.price = source.price,
        target.stock_quantity = source.stock_quantity

WHEN NOT MATCHED BY TARGET THEN
    INSERT
        (product_id, product_name, price, stock_quantity)
    VALUES
        (source.product_id, source.product_name,
         source.price, source.stock_quantity)
;

SELECT * FROM dbo.MergeTargetProducts ORDER BY product_id;


/*
RESULT:
    Product 1 is updated.
    Product 2 is matched and updated with the same values.
    Product 3 remains unchanged.
    Product 4 is inserted.

Product 3 is not deleted because no DELETE action was specified.


===============================================================================
6. MERGE WITH UPDATE, INSERT, AND DELETE
===============================================================================

WHEN NOT MATCHED BY SOURCE:
    Identifies a target record that has no matching source record.

If we specify DELETE for this condition, the target row is deleted.

WARNING:
This can delete many target rows if the source is incomplete or filtered.
Use it only when the source represents the complete authoritative dataset
for the target records being synchronized.

This example is destructive to the demonstration target only.
*/

-- Reset the target to its original demonstration data.
DELETE FROM dbo.MergeTargetProducts;

INSERT INTO dbo.MergeTargetProducts
    (product_id, product_name, price, stock_quantity)
VALUES
    (1, 'Wireless Mouse', 700.00, 20),
    (2, 'Keyboard',       1200.00, 15),
    (3, 'USB Hub',         500.00, 30);


MERGE INTO dbo.MergeTargetProducts AS target
USING dbo.MergeSourceProducts AS source
    ON target.product_id = source.product_id

WHEN MATCHED THEN
    UPDATE SET
        target.product_name = source.product_name,
        target.price = source.price,
        target.stock_quantity = source.stock_quantity

WHEN NOT MATCHED BY TARGET THEN
    INSERT
        (product_id, product_name, price, stock_quantity)
    VALUES
        (source.product_id, source.product_name,
         source.price, source.stock_quantity)

WHEN NOT MATCHED BY SOURCE THEN
    DELETE
;

SELECT * FROM dbo.MergeTargetProducts ORDER BY product_id;


/*
RESULT:
    Product 1 is updated.
    Product 2 is matched and updated.
    Product 4 is inserted.
    Product 3 is deleted because it is absent from the source.

The target now reflects the source dataset.


===============================================================================
7. WHEN MATCHED AND WHEN NOT MATCHED
===============================================================================

WHEN MATCHED:
    The ON condition finds a source row for the target row.

WHEN NOT MATCHED BY TARGET:
    A source row has no corresponding target row.
    Useful for INSERT.

WHEN NOT MATCHED BY SOURCE:
    A target row has no corresponding source row.
    Can be used for DELETE or for a conditional UPDATE.

Example: mark missing target records as inactive instead of deleting them.

The following is a syntax example; it requires an IsActive column in the
target table and is not executable against the demonstration schema above.

MERGE INTO TargetTable AS target
USING SourceTable AS source
    ON target.id = source.id
WHEN MATCHED THEN
    UPDATE SET target.value = source.value
WHEN NOT MATCHED BY SOURCE THEN
    UPDATE SET target.IsActive = 0
;


===============================================================================
8. CONDITIONAL MERGE ACTIONS
===============================================================================

You can add an AND condition to WHEN MATCHED.

Example:
Update the target only when the price is different.

WHEN MATCHED AND target.price <> source.price THEN
    UPDATE SET target.price = source.price

This avoids unnecessary updates when values are already equal.

For nullable columns, use a NULL-safe comparison. In SQL Server 2022 and
later, IS DISTINCT FROM can help compare values including NULLs.

Example:

WHEN MATCHED
 AND target.price IS DISTINCT FROM source.price THEN
    UPDATE SET target.price = source.price

The IS DISTINCT FROM syntax requires SQL Server 2022 or a compatible version.
For older SQL Server versions, use an explicit NULL-safe comparison.


===============================================================================
9. MERGE RULES
===============================================================================

1. The ON condition identifies matching records.
2. Source and target must have compatible matching columns.
3. The source should contain at most one row for each target key.
4. Multiple source rows matching the same target row can cause an error
   when MERGE attempts to update that target row more than once.
5. The INSERT column list must match the VALUES list.
6. The DELETE action must be explicitly specified.
7. End the MERGE statement with a semicolon in SQL Server.
8. Test the statement before using it on production data.
9. A transaction can help control and review changes.
10. Do not use WHEN NOT MATCHED BY SOURCE THEN DELETE unless the source is
    complete and deletion is intended.


===============================================================================
10. MERGE VS SEPARATE DML STATEMENTS
===============================================================================

MERGE:
    Can combine matching UPDATE, INSERT, and DELETE actions in one statement.

Separate INSERT / UPDATE / DELETE:
    Can be easier to understand, test, and troubleshoot independently.

Important:
    MERGE is not automatically safer or faster. SQL Server MERGE behavior
    and concurrency need careful testing. For critical workloads, separate
    DML statements inside a well-designed transaction may be preferable.

===============================================================================
END OF DATA MODIFICATION
===============================================================================
*/
