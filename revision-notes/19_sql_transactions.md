# 19. SQL Transactions

## 1. What is a Transaction?

A **transaction** is a group of SQL operations treated as a single logical unit of work.

A transaction ensures that either all operations are completed successfully or none of them are applied.

**Example:**

When transferring ₹1,000 from one bank account to another:

1. Deduct ₹1,000 from Account 1.
2. Add ₹1,000 to Account 2.

Both operations must succeed. If one operation fails, the transaction should be rolled back.

## 2. Why Do We Use Transactions?

- To maintain data consistency.
- To prevent incomplete operations.
- To handle errors safely.
- To protect important database operations.
- To ensure reliable data modifications.

## 3. Transaction Commands

The main transaction commands are:

- `BEGIN TRANSACTION`
- `COMMIT`
- `ROLLBACK`
- `SAVEPOINT` / `SAVE TRANSACTION`

## 4. BEGIN TRANSACTION

`BEGIN TRANSACTION` starts a transaction.

**Syntax (SQL Server):**

```sql
BEGIN TRANSACTION;
```

**Example:**

```sql
BEGIN TRANSACTION;

UPDATE Orders
SET order_status = 'Delivered'
WHERE order_id = 101;

COMMIT TRANSACTION;
```

The transaction starts, updates the order, and commits the change.

## 5. COMMIT

`COMMIT` permanently saves the changes made by a transaction.

**Example:**

```sql
BEGIN TRANSACTION;

UPDATE Products
SET stock_quantity = stock_quantity - 1
WHERE product_id = 201;

COMMIT TRANSACTION;
```

After the commit, the change becomes permanent.

## 6. ROLLBACK

`ROLLBACK` cancels the changes made in the current transaction that have not been committed.

**Example:**

```sql
BEGIN TRANSACTION;

UPDATE Products
SET stock_quantity = stock_quantity - 1
WHERE product_id = 201;

ROLLBACK TRANSACTION;
```

The stock quantity returns to its previous value.

## 7. SAVEPOINT

A **savepoint** allows us to mark a specific point inside a transaction so that we can roll back to that point instead of cancelling the entire transaction.

**SQL Server syntax:**

```sql
BEGIN TRANSACTION;

UPDATE Products
SET stock_quantity = stock_quantity - 1
WHERE product_id = 201;

SAVE TRANSACTION stock_update;

UPDATE Orders
SET order_status = 'Delivered'
WHERE order_id = 101;

ROLLBACK TRANSACTION stock_update;

COMMIT TRANSACTION;
```

Here:
- The stock update is performed.
- A savepoint is created.
- The order update is performed.
- The transaction rolls back to the savepoint.
- The stock update remains and is committed.

**Important:** SQL Server uses `SAVE TRANSACTION` to create a savepoint. Other databases, such as PostgreSQL and MySQL, use `SAVEPOINT`.

## 8. ACID Properties

ACID properties ensure reliable transaction processing.

ACID stands for:

1. Atomicity
2. Consistency
3. Isolation
4. Durability

### 8.1 Atomicity

Atomicity means all operations in a transaction succeed together or fail together.

**Example:** In a bank transfer, money should not be deducted from one account without being credited to the other.

### 8.2 Consistency

Consistency ensures that a transaction moves the database from one valid state to another valid state while maintaining database rules and constraints.

**Example:** A transaction must not violate a primary key or foreign key constraint.

### 8.3 Isolation

Isolation ensures that concurrent transactions do not interfere with each other in ways that produce incorrect results.

**Example:** Two users updating the same account should not cause incorrect balance calculations.

### 8.4 Durability

Durability ensures that committed changes are preserved even if the system fails afterward.

**Example:** Once a payment transaction is committed, the saved payment record should remain available after a system restart.

## 9. ACID Properties Summary

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Property</th>
<th>Meaning</th>
</tr>
<tr>
<td>Atomicity</td>
<td>All operations succeed or none do.</td>
</tr>
<tr>
<td>Consistency</td>
<td>Maintains database rules and validity.</td>
</tr>
<tr>
<td>Isolation</td>
<td>Controls interference between concurrent transactions.</td>
</tr>
<tr>
<td>Durability</td>
<td>Committed changes are permanently preserved.</td>
</tr>
</table>

## 10. Autocommit vs Explicit Transactions

### Autocommit

In autocommit mode, each SQL statement is treated as an individual transaction and is automatically committed when successful.

### Explicit Transaction

An explicit transaction is started and controlled manually using transaction commands.

### Comparison

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Feature</th>
<th>Autocommit</th>
<th>Explicit Transaction</th>
</tr>
<tr>
<td>Control</td>
<td>Automatic</td>
<td>Manual</td>
</tr>
<tr>
<td>Transaction start</td>
<td>Handled automatically</td>
<td>Started explicitly</td>
</tr>
<tr>
<td>Commit</td>
<td>Automatic after successful statement</td>
<td>Using COMMIT</td>
</tr>
<tr>
<td>Rollback</td>
<td>Statement-level failure handling</td>
<td>Can roll back uncommitted transaction changes</td>
</tr>
<tr>
<td>Use case</td>
<td>Individual operations</td>
<td>Multiple related operations</td>
</tr>
</table>

**Note:** Autocommit behavior and configuration vary across database systems.

## 11. Transaction Isolation Levels

Isolation levels control how transactions interact when multiple users access or modify data simultaneously.

Common isolation levels include:

### 11.1 READ UNCOMMITTED

Allows a transaction to read changes made by another transaction before they are committed.

This can cause dirty reads.

### 11.2 READ COMMITTED

A transaction can read only committed data.

It prevents dirty reads, but non-repeatable reads and phantom reads may occur.

### 11.3 REPEATABLE READ

Ensures that rows read by a transaction cannot be changed by another transaction before the first transaction completes.

Phantom reads may still occur.

### 11.4 SERIALIZABLE

Provides the strictest standard isolation level by preventing conflicting transactions from producing results inconsistent with serial execution.

It prevents dirty reads, non-repeatable reads, and phantom reads.

### 11.5 SNAPSHOT

Provides a transaction-level consistent view of data using row versions.

It helps reduce read-write blocking, but availability and behavior depend on the database system and its configuration.

## 12. Isolation Levels Comparison

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Isolation Level</th>
<th>Dirty Read</th>
<th>Non-Repeatable Read</th>
<th>Phantom Read</th>
</tr>
<tr>
<td>READ UNCOMMITTED</td>
<td>Possible</td>
<td>Possible</td>
<td>Possible</td>
</tr>
<tr>
<td>READ COMMITTED</td>
<td>Prevented</td>
<td>Possible</td>
<td>Possible</td>
</tr>
<tr>
<td>REPEATABLE READ</td>
<td>Prevented</td>
<td>Prevented</td>
<td>Possible</td>
</tr>
<tr>
<td>SERIALIZABLE</td>
<td>Prevented</td>
<td>Prevented</td>
<td>Prevented</td>
</tr>
<tr>
<td>SNAPSHOT</td>
<td>Prevented</td>
<td>Prevented for snapshot reads</td>
<td>Prevented for snapshot reads</td>
</tr>
</table>

**Note:** The table describes common behavior. Exact implementation details can vary between database systems.

## 13. Common Transaction Problems

### 13.1 Dirty Read

A dirty read occurs when one transaction reads data modified by another transaction that has not yet been committed.

**Example:**

- Transaction A updates an account balance.
- Transaction B reads the updated balance.
- Transaction A rolls back.

Transaction B has read a value that was never committed.

### 13.2 Non-Repeatable Read

A non-repeatable read occurs when the same row returns different values when read more than once within a transaction.

**Example:**

- Transaction A reads an employee salary.
- Transaction B updates and commits that salary.
- Transaction A reads the salary again and gets a different value.

### 13.3 Phantom Read

A phantom read occurs when a transaction executes the same search condition again and finds additional or missing rows because another transaction inserted or deleted matching records.

**Example:**

- Transaction A searches for orders above ₹10,000.
- Transaction B inserts and commits another matching order.
- Transaction A repeats the search and sees an additional row.

## 14. Setting Isolation Level

**SQL Server example:**

```sql
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

BEGIN TRANSACTION;

SELECT *
FROM Orders
WHERE order_status = 'Pending';

COMMIT TRANSACTION;
```

This sets the isolation level for the session.

Other supported isolation levels include:

```sql
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
```

**Note:** SQL Server requires snapshot isolation to be enabled at the database level before it can be used.

## 15. Handling Errors in Transactions

In SQL Server, `TRY...CATCH` can be used to handle errors and roll back a transaction.

**Example:**

```sql
BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE Products
    SET stock_quantity = stock_quantity - 1
    WHERE product_id = 201;

    UPDATE Orders
    SET order_status = 'Delivered'
    WHERE order_id = 101;

    COMMIT TRANSACTION;
END TRY

BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
```

Here:
- `TRY` contains the transaction operations.
- `CATCH` handles errors.
- `@@TRANCOUNT` checks whether a transaction is active.
- `ROLLBACK` cancels the uncommitted transaction.
- `THROW` returns the error to the caller.

## 16. COMMIT vs ROLLBACK vs SAVEPOINT

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Command</th>
<th>Purpose</th>
</tr>
<tr>
<td>COMMIT</td>
<td>Saves transaction changes.</td>
</tr>
<tr>
<td>ROLLBACK</td>
<td>Cancels uncommitted transaction changes.</td>
</tr>
<tr>
<td>SAVE TRANSACTION</td>
<td>Creates a savepoint in SQL Server.</td>
</tr>
<tr>
<td>ROLLBACK TO SAVEPOINT</td>
<td>Rolls back to a savepoint in databases that support this syntax.</td>
</tr>
</table>

## 17. Frequently Asked Interview Questions

**1. What is a transaction in SQL?**

A transaction is a group of SQL operations treated as a single logical unit of work.

**2. What are ACID properties?**

Atomicity, Consistency, Isolation, and Durability.

**3. What is COMMIT?**

COMMIT permanently saves the changes made by a transaction.

**4. What is ROLLBACK?**

ROLLBACK cancels changes made within an uncommitted transaction.

**5. What is a SAVEPOINT?**

A savepoint marks a position inside a transaction to which we can roll back.

**6. What is the difference between COMMIT and ROLLBACK?**

COMMIT saves changes, while ROLLBACK cancels uncommitted changes.

**7. What is autocommit?**

Autocommit automatically commits each successful statement as an individual transaction.

**8. What are transaction isolation levels?**

They control how transactions interact when accessing data concurrently.

**9. What is a dirty read?**

Reading uncommitted changes made by another transaction.

**10. What is a non-repeatable read?**

Reading the same row twice and getting different values because another transaction modified it.

**11. What is a phantom read?**

Repeating a query and getting additional or missing rows because another transaction changed the matching row set.

**12. Which isolation level provides the strictest standard isolation?**

SERIALIZABLE.

**13. What is the difference between READ COMMITTED and READ UNCOMMITTED?**

READ COMMITTED prevents dirty reads, while READ UNCOMMITTED allows them.

**14. Can a transaction contain multiple SQL statements?**

Yes. A transaction can contain multiple related SQL statements.

**15. What happens if a transaction fails before COMMIT?**

Its uncommitted changes can be rolled back. Exact error behavior depends on the database system and the type of error.

## 18. Common Mistakes

- Forgetting to commit or roll back an explicit transaction.
- Using transactions for unrelated operations unnecessarily.
- Assuming ROLLBACK can undo already committed changes.
- Confusing SAVEPOINT with COMMIT.
- Assuming all database systems use identical transaction syntax.
- Choosing an isolation level without understanding its effects.
- Leaving transactions open for too long.
- Assuming READ COMMITTED prevents every concurrency problem.

## 19. Quick Revision

- **Transaction:** Group of SQL operations treated as one unit.
- **BEGIN TRANSACTION:** Starts a transaction.
- **COMMIT:** Saves changes.
- **ROLLBACK:** Cancels uncommitted changes.
- **SAVEPOINT:** Marks a point inside a transaction.
- **ACID:** Atomicity, Consistency, Isolation, Durability.
- **Autocommit:** Automatically commits individual successful statements.
- **Dirty Read:** Reading uncommitted data.
- **Non-Repeatable Read:** Same row returns different values.
- **Phantom Read:** Repeated query returns a different set of rows.
- **SERIALIZABLE:** Strictest standard isolation level.
- **TRY...CATCH:** Handles errors in SQL Server transactions.