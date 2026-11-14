# 15. SQL Constraints

## 1. What are SQL Constraints?

SQL constraints are rules applied to table columns to maintain data accuracy, consistency, and integrity.

They prevent invalid data from being inserted or updated in a table.

## 2. Types of SQL Constraints

SQL provides six commonly used constraints:

1. `NOT NULL`
2. `UNIQUE`
3. `PRIMARY KEY`
4. `FOREIGN KEY`
5. `CHECK`
6. `DEFAULT`

## 3. NOT NULL Constraint

The `NOT NULL` constraint ensures that a column cannot contain NULL values.

**Example:**

```sql
CREATE TABLE Customers (
    customer_id INT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100)
);
```

Here, `customer_name` cannot contain NULL values.

## 4. UNIQUE Constraint

The `UNIQUE` constraint ensures that values in a column or combination of columns are unique.

**Example:**

```sql
CREATE TABLE Customers (
    customer_id INT,
    email VARCHAR(100) UNIQUE
);
```

No two rows can have the same non-NULL email value.

**Note:** NULL handling in UNIQUE constraints can differ between database systems.

## 5. PRIMARY KEY Constraint

The `PRIMARY KEY` constraint uniquely identifies each record in a table.

Important characteristics:

- Must contain unique values.
- Cannot contain NULL values.
- A table can have only one primary key constraint.
- A primary key can consist of one or multiple columns.

**Example:**

```sql
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100)
);
```

Here, `customer_id` uniquely identifies each customer.

## 6. FOREIGN KEY Constraint

The `FOREIGN KEY` constraint establishes a relationship between two tables.

It ensures referential integrity by requiring foreign key values to match referenced key values, subject to NULL and other database rules.

**Example:**

```sql
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
);
```

Here, `Orders.customer_id` references `Customers.customer_id`.

A customer must exist in the Customers table before their ID can be used as a non-NULL foreign key in Orders.

## 7. CHECK Constraint

The `CHECK` constraint ensures that values satisfy a specified condition.

**Example:**

```sql
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    salary DECIMAL(10, 2)
        CHECK (salary > 0)
);
```

Here, salary must be greater than zero.

Another example:

```sql
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    total_amount DECIMAL(10, 2)
        CHECK (total_amount >= 0)
);
```

## 8. DEFAULT Constraint

The `DEFAULT` constraint automatically assigns a predefined value when an INSERT statement does not provide a value for that column.

**Example:**

```sql
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    customer_status VARCHAR(20) DEFAULT 'Active'
);
```

If no value is provided for `customer_status`, the default value is `'Active'`.

**Important:** An explicitly inserted NULL does not automatically get replaced by the DEFAULT value.

## 9. Column-Level vs Table-Level Constraints

Constraints can be defined at the column level or table level.

**Column-Level Constraint:**

```sql
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    email VARCHAR(100) UNIQUE
);
```

**Table-Level Constraint:**

```sql
CREATE TABLE OrderItems (
    order_id INT,
    product_id INT,
    quantity INT,

    CONSTRAINT PK_OrderItems
        PRIMARY KEY (order_id, product_id),

    CONSTRAINT CHK_Quantity
        CHECK (quantity > 0)
);
```

Table-level constraints are especially useful for composite constraints involving multiple columns.

## 10. Composite Primary Key

A composite primary key consists of two or more columns that together uniquely identify each record.

**Example:**

```sql
CREATE TABLE OrderItems (
    order_id INT,
    product_id INT,
    quantity INT,

    PRIMARY KEY (order_id, product_id)
);
```

Here, the combination of `order_id` and `product_id` must be unique.

The same `product_id` can appear in different orders, but the same product cannot appear twice under the same order with this key design.

## 11. Adding Constraints to an Existing Table

Constraints can be added after creating a table using `ALTER TABLE`.

**Add UNIQUE:**

```sql
ALTER TABLE Customers
ADD CONSTRAINT UQ_Customers_Email
UNIQUE (email);
```

**Add CHECK:**

```sql
ALTER TABLE Employees
ADD CONSTRAINT CHK_Employees_Salary
CHECK (salary > 0);
```

**Add FOREIGN KEY:**

```sql
ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Customers
FOREIGN KEY (customer_id)
REFERENCES Customers(customer_id);
```

**Important:** Existing data must satisfy the new constraint before it can be added successfully.

## 12. Dropping Constraints

In SQL Server, use `ALTER TABLE` with `DROP CONSTRAINT`.

**Example:**

```sql
ALTER TABLE Customers
DROP CONSTRAINT UQ_Customers_Email;
```

This removes the UNIQUE constraint from the email column.

The constraint name must be known.

## 13. ON DELETE and ON UPDATE Actions

Foreign keys can define what happens when a referenced parent record is deleted or updated.

Common actions include:

- `CASCADE` – Automatically applies the change to related child records.
- `SET NULL` – Sets the foreign key value to NULL.
- `SET DEFAULT` – Sets the foreign key to its default value.
- `RESTRICT` / `NO ACTION` – Prevents the operation when dependent records exist, subject to database behavior.

**Example:**

```sql
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,

    FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
        ON DELETE CASCADE
);
```

If a customer is deleted, their related orders are also deleted.

**Important:** Supported actions and their exact behavior can vary between database systems.

## 14. Primary Key vs UNIQUE

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>PRIMARY KEY</th>
<th>UNIQUE</th>
</tr>
<tr>
<td>Uniquely identifies each row.</td>
<td>Ensures unique values.</td>
</tr>
<tr>
<td>Does not allow NULL values.</td>
<td>NULL handling depends on the database system.</td>
</tr>
<tr>
<td>Only one primary key constraint per table.</td>
<td>A table can have multiple UNIQUE constraints.</td>
</tr>
<tr>
<td>Can contain multiple columns.</td>
<td>Can contain multiple columns.</td>
</tr>
</table>

## 15. Primary Key vs Foreign Key

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>PRIMARY KEY</th>
<th>FOREIGN KEY</th>
</tr>
<tr>
<td>Uniquely identifies records in a table.</td>
<td>References a key in another or the same table.</td>
</tr>
<tr>
<td>Cannot contain NULL values.</td>
<td>Can contain NULL values unless restricted by NOT NULL.</td>
</tr>
<tr>
<td>Only one primary key constraint per table.</td>
<td>A table can have multiple foreign key constraints.</td>
</tr>
<tr>
<td>Enforces entity integrity.</td>
<td>Enforces referential integrity.</td>
</tr>
</table>

## 16. Frequently Asked Interview Questions

**1. What are SQL constraints?**

Constraints are rules applied to table columns to maintain data accuracy and integrity.

**2. What are the six common SQL constraints?**

NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, CHECK and DEFAULT.

**3. What is a PRIMARY KEY?**

A primary key uniquely identifies each record in a table and does not allow NULL values.

**4. What is a FOREIGN KEY?**

A foreign key establishes a relationship between tables by referencing a key in another or the same table.

**5. What is the difference between PRIMARY KEY and UNIQUE?**

A primary key uniquely identifies records and cannot contain NULL values. UNIQUE also enforces uniqueness, but its NULL handling depends on the database.

**6. Can a table have multiple primary keys?**

No. A table can have only one primary key constraint, but that key can contain multiple columns.

**7. Can a table have multiple UNIQUE constraints?**

Yes. A table can have multiple UNIQUE constraints.

**8. What is a composite primary key?**

A primary key consisting of two or more columns is called a composite primary key.

**9. What is a CHECK constraint?**

CHECK ensures that values satisfy a specified condition.

**10. What is a DEFAULT constraint?**

DEFAULT assigns a predefined value when an INSERT statement does not provide a value for that column.

**11. Can a FOREIGN KEY contain NULL values?**

Yes, unless the foreign key column also has a NOT NULL constraint.

**12. What is referential integrity?**

Referential integrity ensures that relationships between tables remain valid.

**13. What is ON DELETE CASCADE?**

It automatically deletes related child records when the referenced parent record is deleted.

**14. Can constraints be added after creating a table?**

Yes. Constraints can be added using ALTER TABLE.

**15. Can constraints be removed?**

Yes. Constraints can be removed using ALTER TABLE and DROP CONSTRAINT. Syntax may vary by database.

## 17. Common Mistakes

- Assuming UNIQUE and PRIMARY KEY are identical.
- Creating a foreign key that references a non-unique, non-key column.
- Forgetting that primary keys cannot contain NULL.
- Assuming DEFAULT replaces explicitly inserted NULL values.
- Adding constraints without checking existing data.
- Using CASCADE without understanding its impact on related records.
- Assuming every database handles UNIQUE and NULL values identically.

## 18. Quick Revision

- `NOT NULL` – Prevents NULL values.
- `UNIQUE` – Prevents duplicate values.
- `PRIMARY KEY` – Uniquely identifies each record.
- `FOREIGN KEY` – Establishes relationships between tables.
- `CHECK` – Validates values using conditions.
- `DEFAULT` – Assigns a default value.
- Composite key – Uses multiple columns as a key.
- `ALTER TABLE` – Adds or removes constraints.
- `ON DELETE CASCADE` – Deletes related child records automatically.