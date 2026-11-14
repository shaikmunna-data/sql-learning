# 01. SQL Fundamentals

## 1. What is SQL?

SQL (Structured Query Language) is a standard language used to communicate with relational databases. It is used to store, retrieve, manipulate and manage data.

## 2. What is a Database?

A database is an organized collection of data that allows users to store, access, manage and retrieve information efficiently.

## 3. What is an RDBMS?

RDBMS (Relational Database Management System) is a database management system that stores data in tables consisting of rows and columns and establishes relationships between tables.

Examples:
- MySQL
- SQL Server
- PostgreSQL
- Oracle
- SQLite

## 4. Important SQL Terms

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Term</th>
<th>Meaning</th>
</tr>
<tr>
<td>Database</td>
<td>Organized collection of data</td>
</tr>
<tr>
<td>Table</td>
<td>Collection of related data</td>
</tr>
<tr>
<td>Row</td>
<td>A single record</td>
</tr>
<tr>
<td>Column</td>
<td>An attribute of a table</td>
</tr>
<tr>
<td>Primary Key</td>
<td>Uniquely identifies each row</td>
</tr>
<tr>
<td>Foreign Key</td>
<td>Establishes a relationship between tables</td>
</tr>
<tr>
<td><code>NULL</code></td>
<td>Represents missing or unknown data</td>
</tr>
<tr>
<td>Schema</td>
<td>Logical structure or namespace containing database objects</td>
</tr>
</table>

## 5. Types of SQL Commands

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Category</th>
<th>Purpose</th>
<th>Commands</th>
</tr>
<tr>
<td>DDL</td>
<td>Defines database structure</td>
<td><code>CREATE</code>, <code>ALTER</code>, <code>DROP</code>, <code>TRUNCATE</code></td>
</tr>
<tr>
<td>DML</td>
<td>Manipulates data</td>
<td><code>INSERT</code>, <code>UPDATE</code>, <code>DELETE</code></td>
</tr>
<tr>
<td>DQL</td>
<td>Retrieves data</td>
<td><code>SELECT</code></td>
</tr>
<tr>
<td>DCL</td>
<td>Controls permissions</td>
<td><code>GRANT</code>, <code>REVOKE</code></td>
</tr>
<tr>
<td>TCL</td>
<td>Manages transactions</td>
<td><code>COMMIT</code>, <code>ROLLBACK</code>, <code>SAVEPOINT</code></td>
</tr>
</table>

## 6. Frequently Asked Interview Questions

**Q1. What is SQL?**

SQL is a standard language used to communicate with relational databases and perform operations on data.

**Q2. What is the difference between SQL and MySQL?**

SQL is a query language, whereas MySQL is a relational database management system that uses SQL.

**Q3. What is the difference between DBMS and RDBMS?**

DBMS manages databases, whereas RDBMS organizes data in related tables and supports relationships between them.

**Q4. What is the difference between a row and a column?**

A row represents a single record, whereas a column represents an attribute of the data.

**Q5. What is a Primary Key?**

A Primary Key uniquely identifies each record in a table. It cannot contain NULL values or duplicate values.

**Q6. What is a Foreign Key?**

A Foreign Key is a column or group of columns that references a key in another or the same table to establish a relationship.

**Q7. What is NULL in SQL?**

NULL represents missing or unknown information. It is different from zero, an empty string or a blank space.

**Q8. Is SQL case-sensitive?**

SQL keywords are generally case-insensitive, but case sensitivity of identifiers and string comparisons depends on the database system and its configuration.

## 7. Common Mistakes

- Confusing SQL with MySQL or SQL Server.
- Treating NULL as zero.
- Assuming every database uses exactly the same SQL syntax.
- Confusing Primary Keys with Foreign Keys.
- Thinking a table row and column represent the same thing.

## 8. Quick Revision

- SQL → Structured Query Language.
- Database → Organized collection of data.
- RDBMS → Relational database management system.
- Table → Rows and columns.
- Primary Key → Unique identification.
- Foreign Key → Establishes relationships.
- NULL → Missing or unknown value.
- DDL → Structure.
- DML → Data manipulation.
- DQL → Data retrieval.
- DCL → Permissions.
- TCL → Transactions.