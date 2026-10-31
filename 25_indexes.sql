/*
===============================================================================
24. INDEXES
===============================================================================

1. WHAT IS AN INDEX?
===============================================================================

An index is a database object that helps SQL Server find records faster.

Think of an index in a book.

Without an index:
    You may need to read every page to find a topic.

With an index:
    You can quickly find the page number using the index.

Similarly, a database index helps locate rows without scanning
the entire table in many queries.

Example:

    SELECT *
    FROM dbo.Customers
    WHERE customer_id = 5;

An index on customer_id can help SQL Server find the customer faster.


===============================================================================
2. WHY ARE INDEXES USED?
===============================================================================

Indexes are used to:

    - Retrieve records faster.
    - Improve WHERE clause performance.
    - Improve JOIN operations.
    - Help with ORDER BY operations.
    - Improve GROUP BY operations in suitable queries.
    - Enforce uniqueness when using a UNIQUE index.

Without a suitable index, SQL Server may perform a table scan
or another less efficient access method.

IMPORTANT:

An index does not guarantee that SQL Server will use it.
The query optimizer chooses an execution plan based on available
indexes, statistics, estimated costs, and other factors.


===============================================================================
3. CLUSTERED INDEX
===============================================================================

A clustered index determines the logical order of rows in a table
according to its index key.

The table's data rows are stored at the leaf level of the clustered
index.

IMPORTANT:
    - A table can have only ONE clustered index.
    - A clustered index can contain one or more columns.
    - A primary key is not automatically the clustered index in every case.
    - If no clustered index exists, the table is called a heap.

EXAMPLE:

We use a separate practice table to avoid conflicts with existing tables.
*/

DROP TABLE IF EXISTS dbo.Index_ClusteredDemo;
GO

CREATE TABLE dbo.Index_ClusteredDemo
(
    OrderID INT NOT NULL,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL
);
GO

-- Create a clustered index.
CREATE CLUSTERED INDEX IX_Index_ClusteredDemo_OrderID
ON dbo.Index_ClusteredDemo(OrderID);
GO

-- Insert sample data.
INSERT INTO dbo.Index_ClusteredDemo
    (OrderID, CustomerID, OrderDate, TotalAmount)
VALUES
    (103, 1, '2026-01-03', 2500.00),
    (101, 2, '2026-01-01', 1500.00),
    (102, 3, '2026-01-02', 3000.00);
GO

-- Search using the clustered index key.
SELECT *
FROM dbo.Index_ClusteredDemo
WHERE OrderID = 101;
GO


/*
===============================================================================
4. NON-CLUSTERED INDEX
===============================================================================

A non-clustered index is a separate index structure that stores:

    - Index key values.
    - Row locators that help find the actual table rows.

It works like an index in a book.

IMPORTANT:
    - A table can have multiple non-clustered indexes.
    - They are separate from the table's data rows.
    - They can improve searches on frequently filtered columns.

EXAMPLE:

Create an index on customer_id in the Orders table.

*/

CREATE NONCLUSTERED INDEX IX_Orders_CustomerID
ON dbo.Orders(customer_id);
GO

-- Find all orders for a customer.
SELECT *
FROM dbo.Orders
WHERE customer_id = 1;
GO


/*
===============================================================================
5. COMPOSITE INDEX
===============================================================================

A composite index is an index created on two or more columns.

It is useful when queries frequently filter or sort using
a combination of columns.

EXAMPLE:

Find orders for a particular customer with a particular status.

*/

CREATE NONCLUSTERED INDEX IX_Orders_CustomerID_OrderStatus
ON dbo.Orders(customer_id, order_status);
GO

SELECT *
FROM dbo.Orders
WHERE customer_id = 1
  AND order_status = 'Delivered';
GO

/*
IMPORTANT:

Column order matters in a composite index.

For this index:

    (customer_id, order_status)

It is generally useful for:

    WHERE customer_id = 1

    WHERE customer_id = 1
      AND order_status = 'Delivered'

It may not be as useful for:

    WHERE order_status = 'Delivered'

This is because customer_id is the first key column.

This is commonly called the leftmost-prefix principle.


===============================================================================
6. UNIQUE INDEX
===============================================================================

A unique index ensures that duplicate index key values are not allowed.

It helps maintain data integrity.

EXAMPLE:

Email addresses should be unique in the Customers table.

*/

CREATE UNIQUE NONCLUSTERED INDEX UX_Customers_Email
ON dbo.Customers(email)
WHERE email IS NOT NULL;
GO

-- Search customers using email.
SELECT *
FROM dbo.Customers
WHERE email = 'ravi@example.com';
GO

/*
IMPORTANT:

The example uses a filtered unique index because the sample Customers
table contains NULL email values.

In SQL Server, a normal single-column UNIQUE index generally allows
only one NULL key value. The filtered index excludes NULL values.

A UNIQUE constraint also creates a unique index to enforce uniqueness.


===============================================================================
7. COVERING INDEX
===============================================================================

A covering index contains all the columns required by a query.

SQL Server can sometimes return the required data directly from the index
without looking up additional columns in the base table.

EXAMPLE:

Query:

    SELECT order_date, order_status, total_amount
    FROM dbo.Orders
    WHERE customer_id = 1;

Create a covering index:

*/

CREATE NONCLUSTERED INDEX IX_Orders_Customer_Covering
ON dbo.Orders(customer_id)
INCLUDE (order_date, order_status, total_amount);
GO

SELECT
    order_date,
    order_status,
    total_amount
FROM dbo.Orders
WHERE customer_id = 1;
GO

/*
INCLUDE columns are stored at the leaf level of the non-clustered index.
They are not part of the index key.


===============================================================================
8. UNIQUE INDEX VS UNIQUE CONSTRAINT
===============================================================================

UNIQUE INDEX:
    Creates an index that prevents duplicate key values.

UNIQUE CONSTRAINT:
    Defines a data-integrity rule that prevents duplicate values.

Both enforce uniqueness.

Example of a UNIQUE constraint:

    ALTER TABLE dbo.Customers
    ADD CONSTRAINT UQ_Customers_Email
    UNIQUE (email);

SQL Server creates a unique index to enforce the constraint.

Use a UNIQUE constraint when you want to express a business rule.
Use a unique index when you need index-specific options,
such as a filtered unique index.


===============================================================================
9. INDEX ADVANTAGES
===============================================================================

1. Faster data retrieval.
2. Faster searches using suitable WHERE conditions.
3. Can improve JOIN performance.
4. Can help with sorting and grouping.
5. Unique indexes help prevent duplicate values.
6. Covering indexes can reduce additional data lookups.


===============================================================================
10. INDEX DISADVANTAGES
===============================================================================

1. Requires additional storage space.

2. INSERT operations can become slower because indexes must be maintained.

3. UPDATE operations can become slower when indexed columns change.

4. DELETE operations must also maintain affected indexes.

5. Too many indexes increase maintenance overhead.

6. Indexes need maintenance and monitoring as data changes.


===============================================================================
11. WHEN CAN INDEXES HURT PERFORMANCE?
===============================================================================

Indexes can hurt performance when:

1. Too many indexes are created on a table.

2. A table has frequent INSERT, UPDATE, and DELETE operations.

3. An index is created on a column that is rarely searched.

4. An index has very low selectivity for a particular query.

5. An index is much larger than necessary.

6. The index does not match the query's filtering or sorting requirements.

IMPORTANT:

Do not create an index on every column.

Create indexes based on actual query patterns and execution plans.


===============================================================================
12. WHEN SHOULD WE CREATE INDEXES?
===============================================================================

Consider indexes on columns frequently used in:

    - WHERE conditions.
    - JOIN conditions.
    - ORDER BY clauses.
    - GROUP BY clauses.

Examples:

    Orders.customer_id
    Orders.order_date
    OrderItems.order_id
    OrderItems.product_id
    Customers.email

However, the best index depends on the actual queries,
data distribution, table size, and workload.


===============================================================================
13. VIEW EXISTING INDEXES
===============================================================================

SQL Server provides system catalog views to inspect indexes.

Example:
*/

SELECT
    t.name AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    i.is_unique AS IsUnique
FROM sys.indexes AS i
INNER JOIN sys.tables AS t
    ON i.object_id = t.object_id
ORDER BY
    t.name,
    i.name;
GO


/*
===============================================================================
14. DROP AN INDEX
===============================================================================

DROP INDEX removes an index from a table.

Syntax:

    DROP INDEX IndexName ON TableName;

Example:

*/

DROP INDEX IF EXISTS IX_Orders_CustomerID
ON dbo.Orders;
GO

/*
Use DROP INDEX only when you intentionally want to remove an index.

Do not drop indexes blindly because queries may depend on their performance.

To remove a UNIQUE constraint, use ALTER TABLE ... DROP CONSTRAINT.
*/


/*
===============================================================================
15. CLUSTERED VS NON-CLUSTERED INDEX
===============================================================================

CLUSTERED INDEX:

    - Determines the logical order of table rows.
    - Data rows are stored at the leaf level.
    - Only one per table.
    - Useful for suitable range and lookup queries.

NON-CLUSTERED INDEX:

    - Separate index structure.
    - Contains key values and row locators.
    - Multiple per table.
    - Useful for searches on additional columns.

QUICK COMPARISON:

    Clustered index:
        Organizes the table's data rows by the clustered key.

    Non-clustered index:
        Stores a separate structure to locate table rows.


===============================================================================
16. QUICK REVISION
===============================================================================

What is an index?
    A database object that helps retrieve records efficiently.

Why do we use indexes?
    To improve data retrieval performance.

What is a clustered index?
    An index that determines the logical order of table rows.

What is a non-clustered index?
    A separate index structure containing key values and row locators.

What is a composite index?
    An index created on multiple columns.

What is a unique index?
    An index that prevents duplicate key values.

What is a covering index?
    An index that contains all columns needed by a query.

What is the main disadvantage of indexes?
    Additional storage and slower data modifications due to index maintenance.

Can a table have multiple clustered indexes?
    No. A table can have only one clustered index.

Can a table have multiple non-clustered indexes?
    Yes.


===============================================================================
17. INTERVIEW QUESTIONS
===============================================================================

1. What is an index in SQL?
2. Why are indexes important?
3. Clustered index vs non-clustered index?
4. Can a table have multiple clustered indexes?
5. What is a composite index?
6. Why does column order matter in a composite index?
7. What is a unique index?
8. What is a covering index?
9. What are the disadvantages of indexes?
10. Can indexes slow down INSERT and UPDATE operations?
11. What is the difference between a UNIQUE constraint and a UNIQUE index?
12. When should you avoid creating an index?

===============================================================================
18. INDEXES IN OTHER DATABASE MANAGEMENT SYSTEMS
===============================================================================

Indexes are supported by:

    1. SQL Server
    2. MySQL
    3. PostgreSQL
    4. Oracle

The basic purpose is the same:
    Improve data retrieval performance.

However, syntax and index features can differ.


===============================================================================
A. SQL SERVER
===============================================================================

1. CLUSTERED INDEX

    CREATE CLUSTERED INDEX IX_Orders_OrderID
    ON Orders(order_id);

2. NON-CLUSTERED INDEX

    CREATE NONCLUSTERED INDEX IX_Orders_CustomerID
    ON Orders(customer_id);

3. COMPOSITE INDEX

    CREATE INDEX IX_Orders_Customer_Status
    ON Orders(customer_id, order_status);

4. UNIQUE INDEX

    CREATE UNIQUE INDEX UX_Customers_Email
    ON Customers(email);

5. COVERING INDEX

    CREATE INDEX IX_Orders_Customer
    ON Orders(customer_id)
    INCLUDE (order_date, total_amount);

IMPORTANT:
    - SQL Server supports clustered and non-clustered indexes.
    - A table can have only one clustered index.
    - INCLUDE columns can be used in non-clustered indexes.


===============================================================================
B. MYSQL
===============================================================================

1. INDEX

    CREATE INDEX idx_orders_customer
    ON Orders(customer_id);

2. COMPOSITE INDEX

    CREATE INDEX idx_orders_customer_status
    ON Orders(customer_id, order_status);

3. UNIQUE INDEX

    CREATE UNIQUE INDEX ux_customers_email
    ON Customers(email);

4. DROP INDEX

    DROP INDEX idx_orders_customer
    ON Orders;

IMPORTANT:
    - InnoDB tables use clustered storage, normally organized by the
      primary key.
    - Secondary indexes store the primary key as the row locator.
    - MySQL does not use SQL Server's CLUSTERED INDEX syntax.
    - MySQL supports different index types, including B-tree and FULLTEXT.


===============================================================================
C. POSTGRESQL
===============================================================================

1. INDEX

    CREATE INDEX idx_orders_customer
    ON Orders(customer_id);

2. COMPOSITE INDEX

    CREATE INDEX idx_orders_customer_status
    ON Orders(customer_id, order_status);

3. UNIQUE INDEX

    CREATE UNIQUE INDEX ux_customers_email
    ON Customers(email);

4. PARTIAL INDEX

    CREATE INDEX idx_pending_orders
    ON Orders(order_date)
    WHERE order_status = 'Pending';

5. DROP INDEX

    DROP INDEX IF EXISTS idx_orders_customer;

IMPORTANT:
    - PostgreSQL does not have SQL Server-style clustered indexes.
    - PostgreSQL supports B-tree, Hash, GiST, SP-GiST, GIN, and BRIN indexes.
    - Partial indexes are useful when queries frequently access a subset
      of table records.
    - INCLUDE columns are also supported by PostgreSQL B-tree indexes.


===============================================================================
D. ORACLE
===============================================================================

1. INDEX

    CREATE INDEX idx_orders_customer
    ON Orders(customer_id);

2. COMPOSITE INDEX

    CREATE INDEX idx_orders_customer_status
    ON Orders(customer_id, order_status);

3. UNIQUE INDEX

    CREATE UNIQUE INDEX ux_customers_email
    ON Customers(email);

4. BITMAP INDEX

    CREATE BITMAP INDEX idx_orders_status
    ON Orders(order_status);

5. DROP INDEX

    DROP INDEX idx_orders_customer;

IMPORTANT:
    - Oracle supports B-tree and bitmap indexes.
    - Bitmap indexes can be useful for analytical workloads with
      low-cardinality columns.
    - Oracle does not use SQL Server's clustered/non-clustered
      index terminology.
    - Oracle also supports function-based indexes.


===============================================================================
19. INDEX TYPES ACROSS DATABASES
===============================================================================

INDEX TYPE             SQL SERVER   MYSQL   POSTGRESQL   ORACLE
----------------------------------------------------------------
B-tree                  Yes         Yes      Yes          Yes
Clustered               Yes         InnoDB   No           No
Non-clustered           Yes         Yes      Yes          Yes
Composite               Yes         Yes      Yes          Yes
Unique                  Yes         Yes      Yes          Yes
Partial / Filtered      Yes         No*      Yes          Yes**
Covering / INCLUDE      Yes         No***    Yes          Yes***

NOTES:

*   MySQL does not provide the same general partial-index syntax as
    PostgreSQL and SQL Server. Some specialized alternatives exist.

**  Oracle supports function-based and other specialized index strategies;
    do not assume its indexing features are identical to PostgreSQL
    partial indexes.

*** Covering-index behavior and syntax differ by database.
    SQL Server and PostgreSQL support INCLUDE columns in relevant indexes.
    MySQL secondary indexes can include the primary key automatically
    in InnoDB.


===============================================================================
20. IMPORTANT DIFFERENCES TO REMEMBER
===============================================================================

1. SQL SERVER:
    Uses clustered and non-clustered index terminology.

2. MYSQL:
    InnoDB organizes table data using a clustered primary key.

3. POSTGRESQL:
    Supports multiple index types and partial indexes.
    CLUSTER can physically reorder a table using an index, but this is
    not the same as a permanently maintained clustered index.

4. ORACLE:
    Supports B-tree, bitmap, and function-based indexes.

5. ALL FOUR DATABASES:
    Support ordinary indexes, composite indexes, and unique indexes.


===============================================================================
21. QUICK REVISION
===============================================================================

SQL Server:
    Clustered + Non-clustered indexes.

MySQL:
    Clustered storage through InnoDB primary key + Secondary indexes.

PostgreSQL:
    B-tree, Hash, GIN, GiST, BRIN, and other index types.

Oracle:
    B-tree, Bitmap, Function-based, and other index types.

Remember:
    The purpose of an index is similar across databases,
    but implementation and syntax vary.
===============================================================================
===============================================================================
END OF INDEXES
===============================================================================
*/