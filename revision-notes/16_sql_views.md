# 16. SQL Views

## 1. What is a View in SQL?

A view is a virtual table created using a SQL query.

It displays data from one or more underlying tables without normally storing the result data itself.

Views are commonly used to:

- Simplify complex SQL queries.
- Hide sensitive columns.
- Provide customized data access.
- Reuse frequently written queries.
- Improve data organization.

## 2. Creating a View

Use `CREATE VIEW` to create a view.

**Syntax:**

```sql
CREATE VIEW view_name AS
SELECT column1, column2
FROM table_name
WHERE condition;
```

**Example:**

Create a view containing only active customers.

```sql
CREATE VIEW ActiveCustomers AS
SELECT
    customer_id,
    customer_name,
    email,
    city
FROM Customers
WHERE customer_status = 'Active';
```

## 3. Retrieving Data from a View

A view can be queried like a regular table.

```sql
SELECT *
FROM ActiveCustomers;
```

You can also apply filtering and sorting.

```sql
SELECT
    customer_name,
    city
FROM ActiveCustomers
WHERE city = 'Hyderabad'
ORDER BY customer_name;
```

## 4. Creating a View Using JOIN

A view can combine data from multiple tables.

**Example:** Create a view showing customer order details.

```sql
CREATE VIEW CustomerOrderDetails AS
SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_date,
    o.total_amount
FROM Customers AS c
INNER JOIN Orders AS o
    ON c.customer_id = o.customer_id;
```

Retrieve the view:

```sql
SELECT *
FROM CustomerOrderDetails;
```

## 5. Updating a View

Some views can be updated using `INSERT`, `UPDATE`, or `DELETE`.

**Example:**

```sql
UPDATE ActiveCustomers
SET city = 'Chennai'
WHERE customer_id = 101;
```

This updates the underlying Customers table if the view is updatable and the operation satisfies its restrictions.

**Important:** Not all views are updatable. Views involving joins, aggregate functions, GROUP BY, DISTINCT, or other complex operations may have restrictions depending on the database system.

## 6. ALTER VIEW

`ALTER VIEW` modifies an existing view definition in SQL Server.

**Example:**

```sql
ALTER VIEW ActiveCustomers AS
SELECT
    customer_id,
    customer_name,
    email,
    city,
    registration_date
FROM Customers
WHERE customer_status = 'Active';
```

This modifies the existing view without dropping and recreating it.

## 7. DROP VIEW

`DROP VIEW` removes a view from the database.

**Syntax:**

```sql
DROP VIEW view_name;
```

**Example:**

```sql
DROP VIEW ActiveCustomers;
```

This removes the view definition. It does not delete the underlying Customers table or its records.

## 8. CREATE OR ALTER VIEW

SQL Server supports `CREATE OR ALTER VIEW`.

It creates a view if it does not exist or modifies it if it already exists.

**Example:**

```sql
CREATE OR ALTER VIEW ActiveCustomers AS
SELECT
    customer_id,
    customer_name,
    email
FROM Customers
WHERE customer_status = 'Active';
```

This is useful when maintaining views in scripts that may be executed repeatedly.

## 9. Types of Views

Commonly discussed view categories include:

**1. Simple View**

A view based on a single table without complex operations.

```sql
CREATE VIEW EmployeeDetails AS
SELECT
    employee_id,
    employee_name,
    department
FROM Employees;
```

**2. Complex View**

A view based on multiple tables or queries involving joins, aggregate functions, or other complex operations.

```sql
CREATE VIEW DepartmentSalary AS
SELECT
    department,
    AVG(salary) AS average_salary
FROM Employees
GROUP BY department;
```

**3. Materialized View**

A materialized view stores the result of a query physically and can be refreshed to reflect changes in the underlying data.

Materialized views are supported by databases such as PostgreSQL and Oracle. SQL Server provides indexed views, which are a related but different implementation.

## 10. View vs Table

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>View</th>
<th>Table</th>
</tr>
<tr>
<td>Normally a virtual representation of data.</td>
<td>Stores data physically.</td>
</tr>
<tr>
<td>Defined using a SQL query.</td>
<td>Defined using columns and data types.</td>
</tr>
<tr>
<td>Usually does not store the result data itself.</td>
<td>Stores records in the database.</td>
</tr>
<tr>
<td>Can simplify complex queries.</td>
<td>Stores and manages actual records.</td>
</tr>
<tr>
<td>Depends on underlying objects.</td>
<td>Can exist independently.</td>
</tr>
</table>

## 11. View vs Materialized View

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>View</th>
<th>Materialized View</th>
</tr>
<tr>
<td>Normally does not store query results physically.</td>
<td>Stores query results physically.</td>
</tr>
<tr>
<td>Retrieves data through its underlying query.</td>
<td>Reads stored results.</td>
</tr>
<tr>
<td>Reflects underlying data changes when queried.</td>
<td>May need refreshing to reflect changes.</td>
</tr>
<tr>
<td>Generally requires less storage.</td>
<td>Requires additional storage.</td>
</tr>
</table>

## 12. Advantages of Views

- **Simplicity:** Hides complex SQL queries behind a simple view name.
- **Security:** Can restrict access to selected columns or rows.
- **Reusability:** Allows frequently used queries to be reused.
- **Data abstraction:** Users can work with a simplified representation of data.
- **Consistency:** Provides a common query definition for multiple users.

## 13. Limitations of Views

- Some views cannot be updated directly.
- Complex views can be difficult to maintain.
- Normal views do not automatically improve query performance.
- Views depend on underlying tables and database objects.
- Changes to underlying tables may affect dependent views.

## 14. Important Rules

- A view is created using `CREATE VIEW`.
- A view can be queried using `SELECT`.
- `ALTER VIEW` modifies an existing view definition in SQL Server.
- `DROP VIEW` removes a view definition.
- A normal view generally stores its query definition, not its result data.
- Views can be created using one or more tables.
- Some views are updatable, while others are not.
- A view can be used to restrict access to sensitive data, but appropriate permissions must also be configured.

## 15. Frequently Asked Interview Questions

**1. What is a view in SQL?**

A view is a virtual table created using a SQL query.

**2. Why do we use views?**

Views simplify queries, improve data abstraction, support controlled data access, and allow query reuse.

**3. Does a normal view store data physically?**

Generally, no. It stores the query definition and retrieves data from underlying tables when queried.

**4. Can we insert or update data through a view?**

Yes, if the view is updatable and the operation satisfies the database's rules.

**5. Can a view be created using multiple tables?**

Yes. A view can combine multiple tables using JOIN operations.

**6. What is a materialized view?**

A materialized view physically stores the result of a query and may require refreshing to reflect changes.

**7. What is the difference between a view and a table?**

A table stores actual records, whereas a normal view provides a virtual representation of data.

**8. Can we delete a view?**

Yes. Use `DROP VIEW`.

**9. Does dropping a view delete the underlying table?**

No. Dropping a view removes only its definition.

**10. Can we create a view using another view?**

Yes. A view can reference another view, provided the referenced objects are valid.

**11. Do views improve performance?**

Not necessarily. Normal views mainly simplify queries and provide abstraction. Performance depends on the underlying query and database optimization.

**12. What is an indexed view in SQL Server?**

An indexed view is a SQL Server view with a unique clustered index. Its result is physically stored and maintained by SQL Server.

**13. What happens if an underlying table is modified?**

A normal view generally reflects the changes when queried, provided its definition remains valid.

**14. What is the difference between ALTER VIEW and DROP VIEW?**

ALTER VIEW changes an existing view definition, whereas DROP VIEW removes the view.

## 16. Common Mistakes

- Assuming a normal view stores data physically.
- Assuming every view supports INSERT, UPDATE, and DELETE.
- Confusing views with materialized views.
- Assuming views always improve performance.
- Thinking DROP VIEW deletes the underlying tables.
- Forgetting that views depend on underlying database objects.
- Assuming SQL Server supports materialized views in exactly the same way as PostgreSQL or Oracle.

## 17. Quick Revision

- View = Virtual table.
- `CREATE VIEW` = Creates a view.
- `ALTER VIEW` = Modifies a view definition in SQL Server.
- `CREATE OR ALTER VIEW` = Creates or modifies a view in SQL Server.
- `DROP VIEW` = Removes a view.
- Simple view = Usually based on one table.
- Complex view = May involve joins or aggregations.
- Materialized view = Stores query results physically.
- Views provide abstraction, simplicity, and controlled data access.