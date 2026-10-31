/*
===============================================================================
28. SQL SECURITY
===============================================================================

What is SQL Security?

SQL Security controls who can access a database and what operations
they are allowed to perform.

Why is it important?

- Protect sensitive data.
- Prevent unauthorized access.
- Control database operations.
- Maintain data security.


===============================================================================
1. USERS
===============================================================================

A database user represents an identity that can access a database.

Users can be given permissions to perform specific operations.

Examples:
- Read data.
- Insert records.
- Update records.
- Delete records.

In SQL Server, a database user is generally mapped to a server login.

Example syntax:

    CREATE USER analyst_user FOR LOGIN analyst_login;

Note:
The server login must already exist.


===============================================================================
2. ROLES
===============================================================================

A role is a collection of permissions.

Instead of assigning permissions to each user individually,
we can assign users to roles.

Common SQL Server fixed database roles:

1. db_owner
   Full control over the database.

2. db_datareader
   Can read data from all user tables and views.

3. db_datawriter
   Can insert, update and delete data in user tables and views.

4. db_ddladmin
   Can execute DDL commands.

Example syntax:

    ALTER ROLE db_datareader
    ADD MEMBER analyst_user;

This gives analyst_user read access to user tables and views.

Important:
Give users only the permissions they need.


===============================================================================
3. PERMISSIONS
===============================================================================

Permissions determine which operations a user can perform.

Common permissions:

- SELECT  : Read data.
- INSERT  : Insert records.
- UPDATE  : Modify records.
- DELETE  : Delete records.
- EXECUTE : Execute stored procedures and functions.

Permissions can be assigned to individual users or roles.


===============================================================================
4. GRANT
===============================================================================

GRANT gives permission to a user or role.

Syntax:

    GRANT permission_name
    ON object_name
    TO user_or_role;

Example:

    GRANT SELECT
    ON dbo.Customers
    TO analyst_user;

Now analyst_user can read data from the Customers table.


===============================================================================
5. REVOKE
===============================================================================

REVOKE removes a previously granted or denied permission.

It does not explicitly deny access.

Syntax:

    REVOKE permission_name
    ON object_name
    FROM user_or_role;

Example:

    REVOKE SELECT
    ON dbo.Customers
    FROM analyst_user;

The explicitly assigned SELECT permission is removed.

Note:
If another role grants the same permission, the user may still have access.


===============================================================================
6. DENY
===============================================================================

DENY explicitly prevents a user or role from performing an operation.

Syntax:

    DENY permission_name
    ON object_name
    TO user_or_role;

Example:

    DENY DELETE
    ON dbo.Customers
    TO analyst_user;

The user is explicitly denied permission to delete records.

Important:
In SQL Server, DENY generally overrides GRANT permissions inherited
through roles or membership.


===============================================================================
7. AUTHENTICATION VS AUTHORIZATION
===============================================================================

AUTHENTICATION:

Authentication verifies WHO you are.

Examples:
- Username and password.
- Windows authentication.
- Microsoft Entra authentication.

AUTHORIZATION:

Authorization determines WHAT you are allowed to do.

Examples:
- Read customer records.
- Insert orders.
- Update product prices.
- Delete records.

Simple example:

Authentication:
A user successfully logs into SQL Server.

Authorization:
The user can SELECT from Customers but cannot DELETE records.


===============================================================================
QUICK REVISION
===============================================================================

1. User:
   An identity that accesses a database.

2. Role:
   A group of permissions assigned to users.

3. Permission:
   Controls which database operations are allowed.

4. GRANT:
   Gives permission.

5. REVOKE:
   Removes an explicit permission assignment.

6. DENY:
   Explicitly blocks permission.

7. Authentication:
   Verifies who you are.

8. Authorization:
   Determines what you can access or do.


===============================================================================
INTERVIEW QUESTIONS
===============================================================================

1. What is SQL Security?
2. What is the difference between a user and a role?
3. What are database permissions?
4. What is the difference between GRANT and REVOKE?
5. What is the difference between GRANT and DENY?
6. What is authentication?
7. What is authorization?
8. What is the difference between authentication and authorization?
9. What is the purpose of db_datareader?
10. What is the principle of least privilege?

===============================================================================
*/