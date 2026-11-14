# 22. SQL Security

## 1. What is SQL Security?

SQL Security refers to protecting a database from unauthorized access, modification, deletion, and other security threats.

It ensures that only authorized users can access database objects and perform permitted operations.

## 2. Why is SQL Security Important?

- Protects sensitive information.
- Prevents unauthorized access.
- Controls user permissions.
- Protects data from accidental deletion or modification.
- Helps maintain data confidentiality and integrity.
- Supports database auditing and compliance.

## 3. Authentication vs Authorization

### Authentication

Authentication verifies the identity of a user.

**Example:** Checking a username and password before allowing a user to connect to a database.

### Authorization

Authorization determines what an authenticated user is allowed to do.

**Example:** Allowing a user to read customer records but not delete them.

### Comparison

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Feature</th>
<th>Authentication</th>
<th>Authorization</th>
</tr>
<tr>
<td>Purpose</td>
<td>Verifies user identity</td>
<td>Controls user permissions</td>
</tr>
<tr>
<td>Question</td>
<td>Who are you?</td>
<td>What can you do?</td>
</tr>
<tr>
<td>Example</td>
<td>Login credentials</td>
<td>SELECT, INSERT, UPDATE permissions</td>
</tr>
</table>

## 4. What is a Login?

A login is an account used to authenticate a user when connecting to a database server.

In SQL Server, logins are created at the server level.

**Example (SQL Server):**

```sql
CREATE LOGIN analyst_login
WITH PASSWORD = 'StrongPassword@123';
```

**Note:** This is an illustrative password. Use a strong, unique secret and never store real passwords in scripts or GitHub repositories.

## 5. What is a Database User?

A database user is an account inside a particular database that is associated with a login or another supported authentication mechanism.

In SQL Server, a login typically needs a corresponding database user to access a database.

**Example:**

```sql
USE EcommerceSQL;

CREATE USER analyst_user
FOR LOGIN analyst_login;
```

## 6. Login vs User

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Feature</th>
<th>Login</th>
<th>Database User</th>
</tr>
<tr>
<td>Scope</td>
<td>Server level</td>
<td>Database level</td>
</tr>
<tr>
<td>Purpose</td>
<td>Authenticates access to SQL Server</td>
<td>Provides access within a database</td>
</tr>
<tr>
<td>Association</td>
<td>Can be mapped to database users</td>
<td>Can be mapped to a login</td>
</tr>
</table>

## 7. What is a Role?

A role is a collection of permissions that can be assigned to users.

Instead of granting permissions individually, administrators can assign users to roles.

SQL Server provides fixed database roles such as:

- `db_owner`
- `db_datareader`
- `db_datawriter`
- `db_ddladmin`

### Common Database Roles

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Role</th>
<th>Purpose</th>
</tr>
<tr>
<td><code>db_owner</code></td>
<td>Has full control over the database.</td>
</tr>
<tr>
<td><code>db_datareader</code></td>
<td>Can read data from user tables and views.</td>
</tr>
<tr>
<td><code>db_datawriter</code></td>
<td>Can insert, update, and delete data in user tables and views.</td>
</tr>
<tr>
<td><code>db_ddladmin</code></td>
<td>Can execute many data definition language commands.</td>
</tr>
</table>

## 8. GRANT Command

`GRANT` gives permissions to a user or role.

**Syntax:**

```sql
GRANT permission_name
ON object_name
TO user_or_role;
```

**Example:**

```sql
GRANT SELECT
ON Customers
TO analyst_user;
```

This allows `analyst_user` to read data from the `Customers` table.

**Grant multiple permissions:**

```sql
GRANT SELECT, INSERT
ON Orders
TO analyst_user;
```

## 9. REVOKE Command

`REVOKE` removes a previously granted or denied permission.

**Syntax:**

```sql
REVOKE permission_name
ON object_name
FROM user_or_role;
```

**Example:**

```sql
REVOKE SELECT
ON Customers
FROM analyst_user;
```

This removes the applicable SELECT permission grant.

## 10. DENY Command

`DENY` explicitly prevents a user or role from performing a particular operation.

**Example:**

```sql
DENY DELETE
ON Orders
TO analyst_user;
```

This explicitly denies the user or role permission to delete records from `Orders`.

### GRANT vs REVOKE vs DENY

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Command</th>
<th>Purpose</th>
</tr>
<tr>
<td><code>GRANT</code></td>
<td>Gives a permission.</td>
</tr>
<tr>
<td><code>REVOKE</code></td>
<td>Removes a permission grant or denial.</td>
</tr>
<tr>
<td><code>DENY</code></td>
<td>Explicitly blocks a permission.</td>
</tr>
</table>

**Important:** In SQL Server, an applicable DENY generally overrides a GRANT. Ownership and special permissions can affect the final result.

## 11. Creating a Custom Database Role

You can create your own database role and assign permissions to it.

**Example:**

```sql
CREATE ROLE sales_analyst;
```

Grant permissions to the role:

```sql
GRANT SELECT
ON Orders
TO sales_analyst;

GRANT SELECT
ON Customers
TO sales_analyst;
```

Add a user to the role:

```sql
ALTER ROLE sales_analyst
ADD MEMBER analyst_user;
```

Now, the user receives the permissions assigned to the role, subject to other applicable permissions and denials.

## 12. Removing a User from a Role

Use `ALTER ROLE ... DROP MEMBER` in SQL Server.

**Example:**

```sql
ALTER ROLE sales_analyst
DROP MEMBER analyst_user;
```

This removes the user from the role.

## 13. Principle of Least Privilege

The **Principle of Least Privilege** means giving users only the permissions necessary to perform their work.

**Example:**

A data analyst who only needs to read reports should generally receive SELECT permission rather than full database control.

Benefits:

- Reduces security risks.
- Prevents unauthorized modifications.
- Limits accidental data deletion.
- Protects sensitive information.

## 14. What is SQL Injection?

SQL Injection is a security attack in which malicious SQL input is used to manipulate a database query.

**Unsafe example:**

```sql
DECLARE @username VARCHAR(100) = 'admin';

DECLARE @sql VARCHAR(MAX);

SET @sql =
    'SELECT * FROM Users
     WHERE username = ''' + @username + '''';

EXEC(@sql);
```

Building SQL statements by directly concatenating user input can allow an attacker to change the query's meaning.

### How to Prevent SQL Injection

- Use parameterized queries.
- Avoid directly concatenating user input into SQL.
- Validate input appropriately.
- Use least-privilege permissions.
- Avoid exposing detailed database error messages to users.

**Safer SQL Server example:**

```sql
DECLARE @username VARCHAR(100) = 'admin';

EXEC sp_executesql
    N'SELECT * FROM Users
      WHERE username = @username',
    N'@username VARCHAR(100)',
    @username = @username;
```

The parameter is treated as data rather than executable SQL code.

## 15. Data Encryption

Encryption converts readable data into an unreadable form to protect it from unauthorized access.

Common encryption approaches include:

### 15.1 Encryption at Rest

Protects stored data, such as database files and backups.

### 15.2 Encryption in Transit

Protects data while it travels between applications and database servers.

### 15.3 Column-Level Encryption

Protects selected sensitive columns, such as financial or personal information.

### Encryption Types

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Type</th>
<th>Purpose</th>
</tr>
<tr>
<td>Encryption at Rest</td>
<td>Protects stored database data.</td>
</tr>
<tr>
<td>Encryption in Transit</td>
<td>Protects data during transmission.</td>
</tr>
<tr>
<td>Column-Level Encryption</td>
<td>Protects selected sensitive columns.</td>
</tr>
</table>

## 16. What is Auditing?

Auditing is the process of tracking and recording database activities.

It helps administrators identify who accessed or modified data and when the activity occurred.

Examples of activities that may be audited:

- Login attempts.
- Data modifications.
- Permission changes.
- Access to sensitive information.

SQL Server provides SQL Server Audit for auditing supported server-level and database-level events.

## 17. Frequently Asked Interview Questions

**1. What is SQL Security?**

SQL Security protects databases from unauthorized access and modifications.

**2. What is authentication?**

Authentication verifies the identity of a user.

**3. What is authorization?**

Authorization determines what an authenticated user is allowed to access or perform.

**4. What is the difference between a login and a database user?**

A login operates at the SQL Server level, while a database user operates within a particular database.

**5. What is a role in SQL?**

A role is a collection of permissions that can be assigned to users.

**6. What is GRANT?**

GRANT provides permissions to users or roles.

**7. What is REVOKE?**

REVOKE removes a previously granted or denied permission.

**8. What is DENY?**

DENY explicitly prevents a user or role from performing an operation.

**9. What is SQL Injection?**

SQL Injection is an attack that manipulates SQL queries through malicious input.

**10. How can SQL Injection be prevented?**

By using parameterized queries, validating input, and avoiding unsafe SQL concatenation.

**11. What is the Principle of Least Privilege?**

Giving users only the permissions required to perform their tasks.

**12. What is database encryption?**

Encryption protects sensitive data by converting readable information into an unreadable form.

**13. What is database auditing?**

Auditing records database activities to support monitoring and security investigations.

**14. What is the purpose of db_datareader?**

It allows reading data from user tables and views in a SQL Server database.

**15. What is the purpose of db_datawriter?**

It allows inserting, updating, and deleting data in user tables and views in a SQL Server database.

## 18. Common Mistakes

- Confusing authentication with authorization.
- Confusing SQL Server logins with database users.
- Giving every user `db_owner` permissions.
- Using GRANT without considering existing DENY permissions.
- Building dynamic SQL through unsafe string concatenation.
- Storing passwords in plain text.
- Ignoring database auditing.
- Assuming encryption replaces access control.

## 19. Quick Revision

- **SQL Security:** Protects database resources.
- **Authentication:** Verifies user identity.
- **Authorization:** Controls user permissions.
- **Login:** Server-level account in SQL Server.
- **Database User:** Account within a database.
- **Role:** Collection of permissions.
- **GRANT:** Gives permissions.
- **REVOKE:** Removes a permission grant or denial.
- **DENY:** Explicitly blocks permissions.
- **Least Privilege:** Gives only necessary permissions.
- **SQL Injection:** Attack through malicious SQL input.
- **Parameterized Queries:** Help prevent SQL injection.
- **Encryption:** Protects sensitive data.
- **Auditing:** Tracks database activities.