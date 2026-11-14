# 21. SQL Normalization and Database Design

## 1. What is Database Design?

Database design is the process of organizing data into tables, columns, and relationships to store information efficiently.

A good database design helps:

- Reduce duplicate data.
- Maintain data accuracy.
- Establish relationships between tables.
- Improve data management.
- Make queries easier to maintain.

## 2. What is Normalization?

**Normalization** is the process of organizing data in a database to reduce data redundancy and prevent data anomalies.

It involves dividing large tables into smaller related tables and connecting them using keys.

### Example: Before Normalization

Suppose an order table stores customer and product details together.

| order_id | customer_name | product_1 | product_2 |
|---|---|---|---|
| 101 | Ravi | Laptop | Mouse |
| 102 | Priya | Keyboard | Monitor |

Problems:
- Multiple product columns.
- Difficult to add more products.
- Repeated customer information.
- Difficult to maintain data consistently.

After normalization, we can separate the data into related tables:

**Customers**

| customer_id | customer_name |
|---|---|
| 1 | Ravi |
| 2 | Priya |

**Orders**

| order_id | customer_id |
|---|---|
| 101 | 1 |
| 102 | 2 |

**OrderItems**

| order_id | product_id |
|---|---|
| 101 | 201 |
| 101 | 202 |
| 102 | 203 |
| 102 | 204 |

This structure avoids storing multiple products in separate columns.

## 3. Why Do We Need Normalization?

- Reduces duplicate data.
- Improves data consistency.
- Prevents insertion anomalies.
- Prevents update anomalies.
- Prevents deletion anomalies.
- Makes database maintenance easier.

## 4. Types of Normalization

The most commonly discussed normal forms are:

1. First Normal Form (1NF)
2. Second Normal Form (2NF)
3. Third Normal Form (3NF)
4. Boyce-Codd Normal Form (BCNF)

## 5. First Normal Form (1NF)

A table is in **First Normal Form (1NF)** when:

- Each column contains atomic (single) values.
- There are no repeating groups or multiple values in one cell.
- Each row can be uniquely identified.

**Example: Not in 1NF**

| customer_id | customer_name | phone_numbers |
|---|---|---|
| 1 | Ravi | 9876543210, 9123456780 |
| 2 | Priya | 9988776655 |

The `phone_numbers` column contains multiple values in one cell.

**After converting to 1NF:**

| customer_id | customer_name | phone_number |
|---|---|---|
| 1 | Ravi | 9876543210 |
| 1 | Ravi | 9123456780 |
| 2 | Priya | 9988776655 |

Each cell now contains a single value.

## 6. Second Normal Form (2NF)

A table is in **Second Normal Form (2NF)** when:

- It is already in 1NF.
- Every non-key column depends on the whole candidate key.
- There is no partial dependency on a part of a composite candidate key.

**Example: Not in 2NF**

Consider this table:

| order_id | product_id | product_name | quantity |
|---|---|---|---|
| 101 | 201 | Laptop | 2 |
| 101 | 202 | Mouse | 1 |
| 102 | 201 | Laptop | 1 |

Assume the composite primary key is `(order_id, product_id)`.

Here:
- `quantity` depends on both `order_id` and `product_id`.
- `product_name` depends only on `product_id`.

This is a partial dependency.

**After converting to 2NF:**

**OrderItems**

| order_id | product_id | quantity |
|---|---|---|
| 101 | 201 | 2 |
| 101 | 202 | 1 |
| 102 | 201 | 1 |

**Products**

| product_id | product_name |
|---|---|
| 201 | Laptop |
| 202 | Mouse |

Now, product details are stored separately.

## 7. Third Normal Form (3NF)

A table is in **Third Normal Form (3NF)** when:

- It is already in 2NF.
- It has no transitive dependency of non-key attributes on a candidate key.

**Example: Not in 3NF**

| employee_id | employee_name | department_id | department_name |
|---|---|---|---|
| 101 | Ravi | 10 | Sales |
| 102 | Priya | 20 | IT |
| 103 | Arun | 10 | Sales |

Dependencies:

- `employee_id` determines `department_id`.
- `department_id` determines `department_name`.

Therefore, `department_name` depends indirectly on `employee_id` through `department_id`.

**After converting to 3NF:**

**Employees**

| employee_id | employee_name | department_id |
|---|---|---|
| 101 | Ravi | 10 |
| 102 | Priya | 20 |
| 103 | Arun | 10 |

**Departments**

| department_id | department_name |
|---|---|
| 10 | Sales |
| 20 | IT |

Department information is now stored separately.

## 8. Boyce-Codd Normal Form (BCNF)

**BCNF** is a stronger version of 3NF.

A table is in BCNF when every determinant is a superkey.

A determinant is an attribute or combination of attributes that determines another attribute.

**Example:**

Consider a table with these columns:

| student_id | course_id | instructor |
|---|---|---|
| 1 | SQL | Ravi |
| 2 | SQL | Ravi |
| 1 | Python | Priya |

Assume:
- A student can enroll in multiple courses.
- Each instructor teaches only one course.
- Each course can have multiple students.
- The candidate key is `(student_id, course_id)`.
- `instructor` determines `course_id`.

Here, `instructor` is not a superkey, even though it determines `course_id`. This violates BCNF.

The table can be decomposed into:

**InstructorCourses**

| instructor | course_id |
|---|---|
| Ravi | SQL |
| Priya | Python |

**StudentInstructors**

| student_id | instructor |
|---|---|
| 1 | Ravi |
| 2 | Ravi |
| 1 | Priya |

## 9. Comparison of Normal Forms

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Normal Form</th>
<th>Main Requirement</th>
</tr>
<tr>
<td>1NF</td>
<td>Atomic values and no repeating groups.</td>
</tr>
<tr>
<td>2NF</td>
<td>1NF + no partial dependency on a candidate key.</td>
</tr>
<tr>
<td>3NF</td>
<td>2NF + no transitive dependency of non-key attributes on a candidate key.</td>
</tr>
<tr>
<td>BCNF</td>
<td>Every determinant must be a superkey.</td>
</tr>
</table>

## 10. What are Database Anomalies?

Database anomalies are problems that occur due to poorly organized or redundant data.

There are three main types.

### 10.1 Insertion Anomaly

Occurs when we cannot insert certain information without inserting unrelated information.

**Example:** We cannot add a new department unless at least one employee belongs to it.

### 10.2 Update Anomaly

Occurs when the same information is stored in multiple rows and must be updated in several places.

**Example:** If a department name changes, we must update every employee record containing that department name.

### 10.3 Deletion Anomaly

Occurs when deleting one record accidentally removes other important information.

**Example:** Deleting the only employee in a department may also remove the only stored record of that department.

## 11. What is Denormalization?

**Denormalization** is the process of intentionally combining tables or storing redundant data to improve read performance.

It is often used in reporting, analytics, and data warehouses.

**Example:**

Instead of joining Customers and Orders every time, a reporting table may store customer names alongside order details.

### Normalization vs Denormalization

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Feature</th>
<th>Normalization</th>
<th>Denormalization</th>
</tr>
<tr>
<td>Purpose</td>
<td>Reduces redundancy</td>
<td>Can improve read performance</td>
</tr>
<tr>
<td>Data storage</td>
<td>Divides data into related tables</td>
<td>May combine data or duplicate values</td>
</tr>
<tr>
<td>Data consistency</td>
<td>Easier to maintain consistency</td>
<td>Requires careful synchronization</td>
</tr>
<tr>
<td>Joins</td>
<td>May require more joins</td>
<td>Can reduce joins</td>
</tr>
<tr>
<td>Common use</td>
<td>Transactional databases</td>
<td>Reporting and analytics systems</td>
</tr>
</table>

## 12. What is a Database Schema?

A **database schema** describes the logical structure of a database, including its tables, columns, relationships, constraints, and other objects.

Common schema designs include:

### 12.1 Star Schema

A star schema contains one central fact table connected directly to multiple dimension tables.

<pre>
       DimCustomer
            |
DimProduct - FactSales - DimDate
            |
        DimStore
</pre>

**Example:**

- FactSales: sales amount, quantity, customer key, product key, date key.
- DimCustomer: customer details.
- DimProduct: product details.
- DimDate: date information.
- DimStore: store details.

### 12.2 Snowflake Schema

A snowflake schema is similar to a star schema, but dimension tables are further divided into related tables.

<pre>
             DimCategory
                  |
DimProduct - FactSales - DimDate
                  |
              DimCustomer
</pre>

For example, a product dimension may be separated into Product and Category tables.

### Star Schema vs Snowflake Schema

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Feature</th>
<th>Star Schema</th>
<th>Snowflake Schema</th>
</tr>
<tr>
<td>Structure</td>
<td>Simple</td>
<td>More normalized</td>
</tr>
<tr>
<td>Dimension tables</td>
<td>Usually denormalized</td>
<td>Further divided into related tables</td>
</tr>
<tr>
<td>Joins</td>
<td>Usually fewer</td>
<td>Usually more</td>
</tr>
<tr>
<td>Storage</td>
<td>May require more storage</td>
<td>Can reduce dimension data redundancy</td>
</tr>
<tr>
<td>Query complexity</td>
<td>Generally simpler</td>
<td>Can be more complex</td>
</tr>
</table>

## 13. Fact Table and Dimension Table

### Fact Table

A fact table stores measurable business events and numeric values.

Examples:
- Sales amount.
- Quantity sold.
- Profit.
- Discount amount.

### Dimension Table

A dimension table stores descriptive information used to analyze facts.

Examples:
- Customer details.
- Product details.
- Date information.
- Store details.

### Fact Table vs Dimension Table

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Feature</th>
<th>Fact Table</th>
<th>Dimension Table</th>
</tr>
<tr>
<td>Stores</td>
<td>Business measurements and events</td>
<td>Descriptive attributes</td>
</tr>
<tr>
<td>Data</td>
<td>Usually numeric measures and foreign keys</td>
<td>Names, categories, dates, locations</td>
</tr>
<tr>
<td>Rows</td>
<td>Often many rows</td>
<td>Usually fewer rows</td>
</tr>
<tr>
<td>Example</td>
<td>FactSales</td>
<td>DimCustomer</td>
</tr>
</table>

## 14. Frequently Asked Interview Questions

**1. What is normalization?**

Normalization is the process of organizing database tables to reduce data redundancy and prevent anomalies.

**2. Why is normalization important?**

It improves data consistency, reduces duplication, and makes database maintenance easier.

**3. What is 1NF?**

A table is in 1NF when each cell contains a single atomic value and there are no repeating groups.

**4. What is 2NF?**

A table is in 2NF when it is in 1NF and has no partial dependency of non-key attributes on a candidate key.

**5. What is 3NF?**

A table is in 3NF when it is in 2NF and has no transitive dependency of non-key attributes on a candidate key.

**6. What is BCNF?**

BCNF is a stronger form of 3NF in which every determinant must be a superkey.

**7. What is partial dependency?**

Partial dependency occurs when a non-key attribute depends on only part of a composite candidate key.

**8. What is transitive dependency?**

Transitive dependency occurs when a non-key attribute depends on another non-key attribute rather than directly on a candidate key.

**9. What are database anomalies?**

The three main anomalies are insertion, update, and deletion anomalies.

**10. What is denormalization?**

Denormalization intentionally introduces redundancy or combines data to improve read performance.

**11. What is a star schema?**

A star schema is a data warehouse design with a central fact table connected to dimension tables.

**12. What is a snowflake schema?**

A snowflake schema is a design where dimension tables are further normalized into related tables.

**13. What is a fact table?**

A fact table stores measurable business events and numeric values.

**14. What is a dimension table?**

A dimension table stores descriptive information used to analyze facts.

**15. What is the difference between normalization and denormalization?**

Normalization reduces redundancy, while denormalization can introduce redundancy to improve read performance.

## 15. Common Mistakes

- Thinking 1NF only means having a primary key.
- Confusing partial dependency with transitive dependency.
- Assuming 3NF and BCNF are the same.
- Thinking normalization always improves query performance.
- Confusing fact tables with dimension tables.
- Assuming star schema and snowflake schema are identical.
- Denormalizing data without considering consistency.

## 16. Quick Revision

- **Database Design:** Organizing tables and relationships.
- **Normalization:** Reduces redundancy and prevents anomalies.
- **1NF:** Atomic values and no repeating groups.
- **2NF:** No partial dependency on a candidate key.
- **3NF:** No transitive dependency of non-key attributes on a candidate key.
- **BCNF:** Every determinant is a superkey.
- **Anomalies:** Insertion, update, and deletion.
- **Denormalization:** Introduces redundancy to improve read performance.
- **Star Schema:** Central fact table with dimension tables.
- **Snowflake Schema:** Normalized dimension tables.
- **Fact Table:** Stores measurable business data.
- **Dimension Table:** Stores descriptive data.