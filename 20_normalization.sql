/*
===============================================================================
23. DATABASE NORMALIZATION
===============================================================================

1. WHAT IS NORMALIZATION?

Normalization is the process of organizing data into related tables to:
    - Reduce duplicate data.
    - Maintain data consistency.
    - Prevent insertion, update, and deletion anomalies.
    - Improve database structure and maintainability.

Normalization is commonly explained using 1NF, 2NF, and 3NF.
Higher normal forms include BCNF, 4NF, and 5NF.


===============================================================================
2. WHY DO WE NEED NORMALIZATION?
===============================================================================

Consider this table before normalization:

OrderID | CustomerID | CustomerName | CustomerCity | ProductID | ProductName
--------|------------|--------------|--------------|-----------|-------------
101     | 1          | Ravi         | Hyderabad    | 201       | Laptop
101     | 1          | Ravi         | Hyderabad    | 202       | Mouse
102     | 2          | Priya        | Chennai      | 203       | Keyboard
103     | 1          | Ravi         | Hyderabad    | 204       | Monitor

Problems:

1. Data duplication:
   Ravi's name and city are repeated for every order.

2. Update anomaly:
   If Ravi changes city, multiple rows must be updated.

3. Insertion anomaly:
   A new customer or product may be difficult to store without an order.

4. Deletion anomaly:
   Deleting a customer's only order could also remove the only copy
   of that customer's details.

Normalization separates customer, order, product, and order-item data.


===============================================================================
3. FIRST NORMAL FORM (1NF)
===============================================================================

RULE:
    - Each cell must contain a single value.
    - Each row must be uniquely identifiable.
    - Each column should contain values of the same kind.

NOT IN 1NF:

OrderID | CustomerName | Products
--------|--------------|----------------
101     | Ravi         | Laptop, Mouse
102     | Priya        | Keyboard

The Products column contains multiple values in one cell.

IN 1NF:

OrderID | CustomerName | Product
--------|--------------|---------
101     | Ravi         | Laptop
101     | Ravi         | Mouse
102     | Priya        | Keyboard

Each cell now contains one product.

The following query demonstrates a table in 1NF.
*/

DROP TABLE IF EXISTS dbo.Norm_1NF;
GO

CREATE TABLE dbo.Norm_1NF
(
    OrderID INT NOT NULL,
    CustomerName VARCHAR(50) NOT NULL,
    ProductName VARCHAR(50) NOT NULL,
    Quantity INT NOT NULL,
    CONSTRAINT PK_Norm_1NF
        PRIMARY KEY (OrderID, ProductName)
);
GO

INSERT INTO dbo.Norm_1NF
    (OrderID, CustomerName, ProductName, Quantity)
VALUES
    (101, 'Ravi', 'Laptop', 1),
    (101, 'Ravi', 'Mouse', 2),
    (102, 'Priya', 'Keyboard', 1);
GO

SELECT *
FROM dbo.Norm_1NF;
GO


/*
===============================================================================
4. SECOND NORMAL FORM (2NF)
===============================================================================

RULE:
    - The table must be in 1NF.
    - Every non-key column must depend on the entire candidate key.
    - There must be no partial dependency on part of a composite key.

EXAMPLE:

OrderItems table:

OrderID | ProductID | ProductName | Quantity
--------|-----------|-------------|---------
101     | 201       | Laptop      | 1
101     | 202       | Mouse       | 2
102     | 201       | Laptop      | 1

Assume the composite primary key is (OrderID, ProductID).

Functional dependencies:

    OrderID + ProductID -> Quantity
    ProductID           -> ProductName

Quantity depends on the complete key.
ProductName depends only on ProductID.

Therefore, ProductName has a partial dependency.

SOLUTION:

OrderItems:

OrderID | ProductID | Quantity
--------|-----------|---------
101     | 201       | 1
101     | 202       | 2
102     | 201       | 1

Products:

ProductID | ProductName
----------|------------
201       | Laptop
202       | Mouse

Now product details are stored separately.

The following queries demonstrate the 2NF structure.
*/

DROP TABLE IF EXISTS dbo.Norm_OrderItems_2NF;
DROP TABLE IF EXISTS dbo.Norm_Products_2NF;
GO

CREATE TABLE dbo.Norm_Products_2NF
(
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL
);
GO

CREATE TABLE dbo.Norm_OrderItems_2NF
(
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,

    CONSTRAINT PK_Norm_OrderItems_2NF
        PRIMARY KEY (OrderID, ProductID),

    CONSTRAINT FK_Norm_OrderItems_Products_2NF
        FOREIGN KEY (ProductID)
        REFERENCES dbo.Norm_Products_2NF(ProductID)
);
GO

INSERT INTO dbo.Norm_Products_2NF
    (ProductID, ProductName)
VALUES
    (201, 'Laptop'),
    (202, 'Mouse');
GO

INSERT INTO dbo.Norm_OrderItems_2NF
    (OrderID, ProductID, Quantity)
VALUES
    (101, 201, 1),
    (101, 202, 2),
    (102, 201, 1);
GO

SELECT *
FROM dbo.Norm_Products_2NF;

SELECT *
FROM dbo.Norm_OrderItems_2NF;
GO


/*
===============================================================================
5. THIRD NORMAL FORM (3NF)
===============================================================================

RULE:
    - The table must be in 2NF.
    - Non-key columns must not depend transitively on a key.
    - In simple terms, non-key columns should depend on the key,
      not on other non-key columns.

EXAMPLE:

Customers:

CustomerID | CustomerName | CityID | CityName
-----------|--------------|--------|----------
1          | Ravi         | 10     | Hyderabad
2          | Priya        | 20     | Chennai
3          | Arun         | 10     | Hyderabad

Assume each CityID identifies one CityName.

Functional dependencies:

    CustomerID -> CustomerName, CityID
    CityID     -> CityName

CityName depends on CityID, which is not the customer key.
This creates a transitive dependency.

SOLUTION:

Customers:

CustomerID | CustomerName | CityID
-----------|--------------|-------
1          | Ravi         | 10
2          | Priya        | 20
3          | Arun         | 10

Cities:

CityID | CityName
-------|----------
10     | Hyderabad
20     | Chennai

CityName is now stored only in the Cities table.

The following queries demonstrate the 3NF structure.
*/

DROP TABLE IF EXISTS dbo.Norm_Customers_3NF;
DROP TABLE IF EXISTS dbo.Norm_Cities_3NF;
GO

CREATE TABLE dbo.Norm_Cities_3NF
(
    CityID INT PRIMARY KEY,
    CityName VARCHAR(50) NOT NULL
);
GO

CREATE TABLE dbo.Norm_Customers_3NF
(
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50) NOT NULL,
    CityID INT NOT NULL,

    CONSTRAINT FK_Norm_Customers_Cities_3NF
        FOREIGN KEY (CityID)
        REFERENCES dbo.Norm_Cities_3NF(CityID)
);
GO

INSERT INTO dbo.Norm_Cities_3NF
    (CityID, CityName)
VALUES
    (10, 'Hyderabad'),
    (20, 'Chennai');
GO

INSERT INTO dbo.Norm_Customers_3NF
    (CustomerID, CustomerName, CityID)
VALUES
    (1, 'Ravi', 10),
    (2, 'Priya', 20),
    (3, 'Arun', 10);
GO

SELECT
    c.CustomerID,
    c.CustomerName,
    ci.CityName
FROM dbo.Norm_Customers_3NF AS c
INNER JOIN dbo.Norm_Cities_3NF AS ci
    ON c.CityID = ci.CityID;
GO


/*
===============================================================================
6. BOYCE-CODD NORMAL FORM (BCNF)
===============================================================================

BCNF is a stricter version of 3NF.

RULE:
    Every determinant must be a superkey.

A determinant is a column or group of columns that determines another value.
A superkey is a column or group of columns that uniquely identifies a row.

EXAMPLE:

Student | Subject | Instructor
--------|---------|-----------
Asha    | SQL     | Ravi
Asha    | Python  | Meena
Arun    | SQL     | Ravi

Assume:
    - A student can take multiple subjects.
    - Each subject has one instructor.
    - The same instructor can teach multiple subjects.

Then:
    Subject -> Instructor

If the table's candidate key is (Student, Subject),
Subject alone is not a superkey.

This dependency violates BCNF.

SOLUTION:

SubjectInstructors:

Subject | Instructor
--------|-----------
SQL     | Ravi
Python  | Meena

StudentSubjects:

Student | Subject
--------|--------
Asha    | SQL
Asha    | Python
Arun    | SQL

The decomposition separates instructor assignments from student enrolments.

Note:
A BCNF violation depends on the actual business rules and candidate keys.
The example is illustrative.


===============================================================================
7. FOURTH NORMAL FORM (4NF)
===============================================================================

RULE:
    - The table must be in BCNF.
    - It should not contain independent, non-trivial multivalued
      dependencies unless the determinant is a superkey.

EXAMPLE:

Employee | Skill    | Language
---------|----------|---------
Ravi     | SQL      | English
Ravi     | SQL      | Telugu
Ravi     | Python   | English
Ravi     | Python   | Telugu

Assume Ravi's skills and languages are independent facts.

Combining them creates every possible skill-language combination.

SOLUTION:

EmployeeSkills:

Employee | Skill
---------|--------
Ravi     | SQL
Ravi     | Python

EmployeeLanguages:

Employee | Language
---------|---------
Ravi     | English
Ravi     | Telugu

Independent multivalued facts are stored separately.


===============================================================================
8. FIFTH NORMAL FORM (5NF)
===============================================================================

RULE:
    - The table must be in 4NF.
    - It should not contain join dependencies that can be decomposed
      into smaller tables without losing information.

5NF deals with complex relationships where a table can be split into
multiple smaller tables and reconstructed correctly using joins.

It is mainly relevant to complex database designs and is less common
in everyday Data Analyst work.

Remember:
The decomposition must preserve the original information and relationships.
Splitting tables arbitrarily does not guarantee 5NF.


===============================================================================
9. NORMALIZATION VS DENORMALIZATION
===============================================================================

NORMALIZATION:
    - Separates data into related tables.
    - Reduces unnecessary duplication.
    - Helps maintain consistency.
    - Often used in transactional databases.

DENORMALIZATION:
    - Intentionally combines or duplicates some data.
    - Can reduce joins and improve particular reporting queries.
    - Requires care to keep duplicated values consistent.
    - Sometimes used in analytics and reporting systems.

Denormalization is not automatically better or faster.
It depends on the workload, indexes, data volume, and query design.


===============================================================================
10. IMPORTANT NORMALIZATION TERMS
===============================================================================

PRIMARY KEY:
    Uniquely identifies each row in a table.

CANDIDATE KEY:
    A minimal set of columns that can uniquely identify a row.

COMPOSITE KEY:
    A key made from two or more columns.

FOREIGN KEY:
    Connects related tables and helps enforce referential integrity.

FUNCTIONAL DEPENDENCY:
    X -> Y means that a value of X determines a value of Y.

PARTIAL DEPENDENCY:
    A non-key attribute depends on only part of a composite candidate key.

TRANSITIVE DEPENDENCY:
    A non-key attribute depends on another non-key attribute through a key.

ANOMALIES:
    - Insertion anomaly
    - Update anomaly
    - Deletion anomaly


===============================================================================
11. QUICK REVISION
===============================================================================

1NF:
    Each cell contains one value.

2NF:
    1NF + no partial dependency of non-key attributes on a candidate key.

3NF:
    2NF + no transitive dependency of non-key attributes on a candidate key.

BCNF:
    Every determinant is a superkey.

4NF:
    No non-trivial multivalued dependency unless its determinant is a superkey.

5NF:
    No remaining non-trivial join dependency that requires further
    lossless decomposition.

For Data Analyst interviews, prioritize:
    1NF, 2NF, 3NF, primary keys, foreign keys, functional dependencies,
    anomalies, and normalization versus denormalization.
===============================================================================
*/ 