/*
===============================================================================
19. DATABASE DESIGN AND NORMALIZATION
===============================================================================

WHAT IS DATABASE DESIGN?

Database design is the process of organizing data into tables and defining
relationships between them.

Good database design helps:
    - Reduce duplicate data.
    - Maintain data accuracy.
    - Connect related tables.
    - Make data easier to retrieve and maintain.


===============================================================================
1. ENTITY AND ATTRIBUTE
===============================================================================

ENTITY:
    A real-world object about which we store information.
    Examples: Customer, Product, Order, Employee.

ATTRIBUTE:
    A property that describes an entity.
    Examples: customer_name, email, price, order_date.

Example:
    Entity: Customer

    Attributes:
        customer_id
        customer_name
        email
        city


===============================================================================
2. DATABASE RELATIONSHIPS
===============================================================================

ONE-TO-ONE (1:1):
    One record in Table A relates to one record in Table B.

    Example:
        One person has one passport.

ONE-TO-MANY (1:M):
    One record in Table A relates to many records in Table B.

    Example:
        One customer can place many orders.

MANY-TO-MANY (M:N):
    Many records in Table A relate to many records in Table B.

    Example:
        An order can contain many products, and a product can appear
        in many orders.

    A junction table, such as OrderItems, represents this relationship.


===============================================================================
3. PRIMARY KEY AND FOREIGN KEY
===============================================================================

PRIMARY KEY:
    Uniquely identifies each row in a table.
    It cannot contain NULL or duplicate values.

FOREIGN KEY:
    Connects related tables and helps maintain referential integrity.

Example from an e-commerce database:

    Customers
        customer_id (Primary Key)

    Orders
        order_id (Primary Key)
        customer_id (Foreign Key)

One customer can have many orders.


===============================================================================
4. NORMALIZATION
===============================================================================

Normalization organizes data into related tables to reduce unnecessary
duplication and prevent data anomalies.

Common problems normalization helps prevent:

INSERTION ANOMALY:
    Difficulty inserting data without unrelated information.

UPDATE ANOMALY:
    The same information must be changed in multiple places.

DELETION ANOMALY:
    Deleting one record unintentionally removes other useful information.


===============================================================================
5. FIRST NORMAL FORM (1NF)
===============================================================================

RULE:
    Each column should contain a single value per row.
    Do not store multiple values in one column or repeating groups.

NOT IN 1NF:

OrderID | Products
--------|-------------------
101     | Mouse, Keyboard

The Products column contains multiple values.

IN 1NF:

OrderID | Product
--------|---------
101     | Mouse
101     | Keyboard

Each row contains one product value.

In a real database, an OrderItems table would normally store these
individual order-product records.


===============================================================================
6. SECOND NORMAL FORM (2NF)
===============================================================================

RULE:
    The table must be in 1NF.
    Every non-key attribute must depend on the whole candidate key,
    not just part of a composite candidate key.

Example:

OrderID | ProductID | ProductName | Quantity
--------|-----------|-------------|---------
101     | 201       | Mouse       | 2
101     | 202       | Keyboard    | 1

Assume the primary key is (OrderID, ProductID).

ProductName depends only on ProductID, not on the entire composite key.
This is a partial dependency.

A better design separates the data:

Products:
    ProductID (Primary Key)
    ProductName

OrderItems:
    OrderID
    ProductID
    Quantity

Now ProductName is stored with the product, while Quantity belongs
to the order-product relationship.


===============================================================================
7. THIRD NORMAL FORM (3NF)
===============================================================================

RULE:
    The table must be in 2NF.
    Non-key attributes should not depend on other non-key attributes.

Example of a problem:

EmployeeID | DepartmentID | DepartmentName
-----------|--------------|---------------
101        | 10           | Sales
102        | 10           | Sales

Assume:
    EmployeeID determines DepartmentID.
    DepartmentID determines DepartmentName.

DepartmentName depends on DepartmentID, not directly on the employee key.
This is a transitive dependency.

Better design:

Employees:
    EmployeeID
    DepartmentID

Departments:
    DepartmentID
    DepartmentName

The department name is stored once in the Departments table.


===============================================================================
8. DENORMALIZATION
===============================================================================

Denormalization deliberately combines or duplicates data to improve
read performance in selected situations.

Example:
    A reporting table may store monthly sales totals instead of recalculating
    them from millions of order rows every time.

Advantages:
    - Can improve reporting performance.
    - Can simplify analytical queries.

Disadvantages:
    - Duplicated data can become inconsistent.
    - Additional storage may be required.
    - Data refresh and maintenance become more complex.

Normalization is common in transactional design.
Denormalization is often used in reporting and analytical systems.


===============================================================================
9. OLTP VS OLAP
===============================================================================

OLTP = Online Transaction Processing

Purpose:
    Handle everyday business transactions.

Examples:
    - Creating an order.
    - Updating product stock.
    - Registering a customer.

Typical characteristics:
    - Frequent INSERT, UPDATE, and DELETE operations.
    - Current, detailed data.
    - Often uses normalized tables.

OLAP = Online Analytical Processing

Purpose:
    Analyze business data to support decisions.

Examples:
    - Monthly sales trends.
    - Customer purchase behavior.
    - Product performance by category.

Typical characteristics:
    - Complex analytical queries.
    - Aggregations over large datasets.
    - Often uses dimensional models such as star schemas.


===============================================================================
10. STAR SCHEMA
===============================================================================

A star schema is a dimensional data model used for analytics.

It contains:
    - A central FACT table.
    - Multiple surrounding DIMENSION tables.

FACT TABLE:
    Stores measurable business events.

Example: FactSales
    DateKey
    ProductKey
    CustomerKey
    Quantity
    SalesAmount

DIMENSION TABLES:
    DimDate
    DimProduct
    DimCustomer

Example structure:

    DimDate --------\
    DimProduct ------ FactSales ------ DimCustomer

FactSales stores sales transactions or sales measures.
Dimensions describe when, what, and to whom a sale occurred.

Advantages:
    - Simple analytical queries.
    - Clear relationships for Power BI.
    - Useful for aggregations and reporting.


===============================================================================
11. SNOWFLAKE SCHEMA
===============================================================================

A snowflake schema is a dimensional model where one or more dimensions
are divided into additional related tables.

Example:

    FactSales
        |
    DimProduct
        |
    DimCategory

Instead of storing category details directly in DimProduct, category
information is stored in a separate table.

Advantages:
    - Can reduce duplicated dimension data.
    - Organizes complex dimensions into related tables.

Disadvantages:
    - Requires more joins.
    - Can make reporting queries more complex.

In practice, star schemas are often preferred for straightforward BI
reporting because they are simpler to query.


===============================================================================
12. STAR SCHEMA VS SNOWFLAKE SCHEMA
===============================================================================

STAR SCHEMA:
    Dimensions are generally denormalized.
    Fewer joins.
    Easier for reporting users.

SNOWFLAKE SCHEMA:
    Dimensions are split into more normalized tables.
    More joins.
    Can reduce duplicated dimension attributes.

Neither design is always best; choose based on reporting needs,
data complexity, and maintenance requirements.


===============================================================================
13. QUICK REVISION
===============================================================================

ENTITY:
    A real-world object represented in a database.

ATTRIBUTE:
    A property of an entity.

PRIMARY KEY:
    Uniquely identifies a row.

FOREIGN KEY:
    Connects related tables.

1NF:
    One value per column per row.

2NF:
    1NF + no partial dependency on a composite candidate key.

3NF:
    2NF + no transitive dependency of non-key attributes on a key.

DENORMALIZATION:
    Deliberately duplicates or combines data for selected performance needs.

OLTP:
    Handles day-to-day transactions.

OLAP:
    Supports analytical queries and reporting.

STAR SCHEMA:
    A fact table connected to dimension tables.

SNOWFLAKE SCHEMA:
    A fact table connected to more normalized dimensions.

===============================================================================
END OF DATABASE DESIGN AND NORMALIZATION
===============================================================================
*/