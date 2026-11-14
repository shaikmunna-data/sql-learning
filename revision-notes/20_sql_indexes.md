# 20. SQL Indexes

## 1. What is an Index?

An **index** is a database object that helps retrieve data from a table faster.

It works like an index in a book. Instead of searching every page, you can use the index to find the required information quickly.

Without an index, the database may need to scan the entire table.

With an appropriate index, the database can locate rows more efficiently.

**Example:**

Suppose the `Customers` table contains thousands of records. If you frequently search customers using `customer_id`, an index on that column can improve search performance.

## 2. Why Do We Use Indexes?

- To retrieve data faster.
- To improve query performance.
- To speed up filtering and searching.
- To improve join performance.
- To support sorting and grouping operations.

## 3. How Does an Index Work?

An index stores selected column values along with references to the corresponding table rows.

Instead of checking every row, the database can use the index to locate matching records.

## 4. Creating an Index

**Syntax:**

```sql
CREATE INDEX index_name
ON table_name (column_name);
```

**Example:**

```sql
CREATE INDEX idx_customers_city
ON Customers (city);
```

This creates an index on the `city` column.

Queries filtering customers by city may benefit from this index.

```sql
SELECT *
FROM Customers
WHERE city = 'Hyderabad';
```

## 5. Types of Indexes

### 5.1 Clustered Index

A clustered index determines how table rows are organized in the underlying storage structure.

A table can have only one clustered index because the rows can have only one clustered organization.

**Example (SQL Server):**

```sql
CREATE CLUSTERED INDEX idx_orders_order_id
ON Orders (order_id);
```

### 5.2 Non-Clustered Index

A non-clustered index is a separate structure that stores indexed column values and references to the corresponding table rows.

A table can have multiple non-clustered indexes.

**Example:**

```sql
CREATE NONCLUSTERED INDEX idx_orders_customer_id
ON Orders (customer_id);
```

### 5.3 Unique Index

A unique index ensures that the indexed column or combination of columns does not contain duplicate values.

**Example:**

```sql
CREATE UNIQUE INDEX idx_customers_email
ON Customers (email);
```

A unique index cannot be created if duplicate non-NULL values already exist in the indexed column.

NULL handling in unique indexes varies by database system.

### 5.4 Composite Index

A composite index is an index created on two or more columns.

**Example:**

```sql
CREATE INDEX idx_orders_customer_status
ON Orders (customer_id, order_status);
```

This index can help queries that filter using `customer_id`, or using both `customer_id` and `order_status`.

Column order matters when designing a composite index.

## 6. Clustered vs Non-Clustered Index

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Feature</th>
<th>Clustered Index</th>
<th>Non-Clustered Index</th>
</tr>
<tr>
<td>Storage</td>
<td>Determines the physical organization of table rows</td>
<td>Stored separately from the table rows</td>
</tr>
<tr>
<td>Number per table</td>
<td>One</td>
<td>Multiple</td>
</tr>
<tr>
<td>Purpose</td>
<td>Organizes table data</td>
<td>Provides additional access paths</td>
</tr>
<tr>
<td>References</td>
<td>Contains the table data at the leaf level</td>
<td>Contains row references or clustered key values</td>
</tr>
</table>

## 7. Creating an Index on Multiple Columns

You can create an index using multiple columns.

```sql
CREATE INDEX idx_orders_customer_date
ON Orders (customer_id, order_date);
```

This index may help queries such as:

```sql
SELECT *
FROM Orders
WHERE customer_id = 101
AND order_date >= '2025-01-01';
```

**Important:** The order of columns in a composite index affects how efficiently the index can be used.

## 8. Dropping an Index

Use `DROP INDEX` to remove an existing index.

**SQL Server syntax:**

```sql
DROP INDEX idx_customers_city
ON Customers;
```

Dropping an index removes the index structure but does not delete the table data.

## 9. Index Seek vs Index Scan vs Table Scan

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Operation</th>
<th>Meaning</th>
</tr>
<tr>
<td>Index Seek</td>
<td>Uses an index to locate specific rows efficiently.</td>
</tr>
<tr>
<td>Index Scan</td>
<td>Reads through index entries to find matching rows.</td>
</tr>
<tr>
<td>Table Scan</td>
<td>Reads the table rows to find matching records.</td>
</tr>
</table>

**Note:** A scan is not always bad. For queries returning a large percentage of a table, scanning may be more efficient than using an index.

## 10. Advantages of Indexes

- Faster data retrieval.
- Improved search performance.
- Better performance for suitable join queries.
- Can improve sorting and filtering operations.
- Unique indexes help enforce uniqueness.

## 11. Disadvantages of Indexes

- Require additional storage space.
- Can slow down INSERT operations.
- Can slow down UPDATE operations.
- Can slow down DELETE operations.
- Require maintenance when underlying data changes.
- Too many indexes can reduce overall database performance.

## 12. When Should We Create Indexes?

Consider creating indexes on columns frequently used in:

- `WHERE` conditions.
- `JOIN` conditions.
- `ORDER BY` clauses.
- `GROUP BY` clauses.

However, index creation should depend on actual query patterns and execution plans.

## 13. When Should We Avoid Creating Indexes?

Avoid unnecessary indexes on:

- Columns that are rarely used in queries.
- Tables with very frequent data modifications and few read operations.
- Columns with very few distinct values, when an index is unlikely to help.
- Small tables where scanning is already efficient.

These are guidelines, not absolute rules. Actual performance depends on the data and query.

## 14. Index vs Primary Key

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Feature</th>
<th>Index</th>
<th>Primary Key</th>
</tr>
<tr>
<td>Purpose</td>
<td>Improves data retrieval performance</td>
<td>Uniquely identifies each row</td>
</tr>
<tr>
<td>Duplicates</td>
<td>Depends on the index type</td>
<td>Not allowed</td>
</tr>
<tr>
<td>NULL values</td>
<td>Depends on database rules and index type</td>
<td>Not allowed</td>
</tr>
<tr>
<td>Count per table</td>
<td>Multiple indexes are allowed</td>
<td>Only one primary key constraint</td>
</tr>
<tr>
<td>Automatic index</td>
<td>Created explicitly or by database features</td>
<td>Usually creates a supporting unique index</td>
</tr>
</table>

**Important:** A primary key does not always create a clustered index. In SQL Server, a primary key is clustered by default when possible, but it can be created as non-clustered.

## 15. What is a Covering Index?

A covering index contains all the columns required by a particular query.

The database may be able to return the requested data directly from the index without accessing the underlying table rows.

**Example (SQL Server):**

```sql
CREATE NONCLUSTERED INDEX idx_orders_customer
ON Orders (customer_id)
INCLUDE (order_date, total_amount);
```

Query:

```sql
SELECT customer_id, order_date, total_amount
FROM Orders
WHERE customer_id = 101;
```

The index contains the filtering column and the selected columns.

## 16. Frequently Asked Interview Questions

**1. What is an index in SQL?**

An index is a database object that helps retrieve records faster.

**2. Why are indexes used?**

Indexes improve data retrieval performance by reducing the amount of data the database may need to examine.

**3. What are the main types of indexes?**

Common types include clustered, non-clustered, unique, and composite indexes.

**4. How many clustered indexes can a table have?**

A table can have only one clustered index.

**5. Can a table have multiple non-clustered indexes?**

Yes. A table can have multiple non-clustered indexes.

**6. Does an index improve INSERT performance?**

Usually not. Indexes generally add work to INSERT operations because the database must maintain the indexes.

**7. Can indexes slow down UPDATE and DELETE operations?**

Yes. The database may need to update or remove affected index entries.

**8. What is a composite index?**

An index created on two or more columns.

**9. What is a unique index?**

An index that prevents duplicate indexed key values.

**10. What is a covering index?**

An index that contains all the columns required by a query.

**11. What is an index seek?**

An operation that uses an index to locate specific rows.

**12. What is an index scan?**

An operation that reads through index entries to find matching rows.

**13. What happens when we drop an index?**

The index is removed, but the table data remains unchanged.

**14. Can indexes improve JOIN performance?**

Yes. Indexes on suitable join columns can improve join performance.

**15. Should we create indexes on every column?**

No. Too many indexes consume storage and can slow down data modification operations.

## 17. Common Mistakes

- Creating indexes on every column.
- Creating duplicate or unnecessary indexes.
- Ignoring the column order in composite indexes.
- Assuming indexes always improve query performance.
- Forgetting that indexes require additional storage.
- Ignoring index maintenance.
- Assuming every primary key must be clustered.

## 18. Quick Revision

- **Index:** Helps retrieve data faster.
- **Clustered Index:** Determines the organization of table rows.
- **Non-Clustered Index:** Separate index structure.
- **Unique Index:** Prevents duplicate indexed key values.
- **Composite Index:** Index on multiple columns.
- **Covering Index:** Contains all columns required by a query.
- **Index Seek:** Locates rows using an index.
- **Index Scan:** Reads through index entries.
- **Table Scan:** Reads table rows.
- **Main disadvantage:** Additional storage and slower data modifications.