/*
===============================================================================
11 - SQL JOINS
===============================================================================

DATABASE:
    EcommerceSQL

TOPICS:
    1. Why Joins Are Needed
    2. Primary Key and Foreign Key Relationships
    3. Types of Relationships
    4. INNER JOIN
    5. LEFT JOIN
    6. RIGHT JOIN
    7. FULL OUTER JOIN
    8. CROSS JOIN
    9. SELF JOIN
    10. LEFT ANTI JOIN
    11. RIGHT ANTI JOIN
    12. FULL ANTI JOIN
    13. Joining Multiple Tables
    14. Join Conditions
    15. Multiple Join Conditions
    16. Duplicate Rows Caused by Joins
    17. ON vs WHERE
    18. Practice Questions
    19. Quick Revision

===============================================================================
*/


USE EcommerceSQL;
GO


/*
===============================================================================
1. WHY ARE JOINS NEEDED?
===============================================================================

Real-world databases store information in separate related tables.

For example:

    Customers
        Stores customer details.

    Orders
        Stores order details.

    Products
        Stores product details.

    OrderItems
        Connects orders with products.

    Employees
        Stores employee details.

If we want to display an order together with the customer name,
we need to combine Customers and Orders.

JOIN allows us to retrieve related information from multiple tables.

Example business question:

    Display order ID, customer name, order date, and total amount.


===============================================================================
2. PRIMARY KEY AND FOREIGN KEY RELATIONSHIPS
===============================================================================

PRIMARY KEY:
    Uniquely identifies a row in a table.

FOREIGN KEY:
    References a primary key or another eligible unique key
    in a related table.

Existing relationships in EcommerceSQL:

    Customers.customer_id
        -> Orders.customer_id

    Employees.employee_id
        -> Orders.employee_id

    Orders.order_id
        -> OrderItems.order_id

    Products.product_id
        -> OrderItems.product_id

The join condition commonly compares the foreign key with
the corresponding primary key.


===============================================================================
3. TYPES OF TABLE RELATIONSHIPS
===============================================================================

ONE-TO-ONE:
    One row in table A corresponds to at most one row in table B.

    Example:
        One user and one user profile.

ONE-TO-MANY:
    One row in table A can correspond to multiple rows in table B.

    Example:
        One customer can place multiple orders.

MANY-TO-MANY:
    Multiple rows in table A can relate to multiple rows in table B.

    Example:
        Orders and Products.

    OrderItems acts as the junction table between them.

SELF-REFERENCING RELATIONSHIP:
    A table references itself.

    Example:
        Employees.manager_id references Employees.employee_id.


===============================================================================
4. INNER JOIN
===============================================================================

INNER JOIN returns only rows with matching values in both tables.

Syntax:

    SELECT columns
    FROM TableA AS A
    INNER JOIN TableB AS B
        ON A.key_column = B.key_column;

Unmatched rows from either table are excluded.


-------------------------------------------------------------------------------
4.1 Customers and Orders
-------------------------------------------------------------------------------
*/

SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_date,
    o.total_amount
FROM Customers AS c
INNER JOIN Orders AS o
    ON c.customer_id = o.customer_id;


/*
Explanation:

    Customers is assigned alias c.
    Orders is assigned alias o.

    ON c.customer_id = o.customer_id

    Matches each order to its customer.

Customers without orders will not appear.


-------------------------------------------------------------------------------
4.2 Orders and Employees
-------------------------------------------------------------------------------
*/

SELECT
    o.order_id,
    o.order_date,
    e.employee_id,
    e.employee_name,
    e.department
FROM Orders AS o
INNER JOIN Employees AS e
    ON o.employee_id = e.employee_id;


/*
Orders with employee_id = NULL are excluded because NULL does not
match an employee ID using the equality condition.


-------------------------------------------------------------------------------
4.3 Products and OrderItems
-------------------------------------------------------------------------------
*/

SELECT
    p.product_id,
    p.product_name,
    oi.order_id,
    oi.quantity,
    oi.unit_price
FROM Products AS p
INNER JOIN OrderItems AS oi
    ON p.product_id = oi.product_id;


/*
Only products appearing in OrderItems are returned.


===============================================================================
5. LEFT JOIN
===============================================================================

LEFT JOIN returns:

    All rows from the LEFT table.
    Matching rows from the RIGHT table.

If no matching right-side row exists, right-side columns return NULL.

LEFT JOIN is also called LEFT OUTER JOIN.


-------------------------------------------------------------------------------
5.1 Display all customers and their orders
-------------------------------------------------------------------------------
*/

SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_date,
    o.total_amount
FROM Customers AS c
LEFT JOIN Orders AS o
    ON c.customer_id = o.customer_id;


/*
All customers appear, including customers who have never placed an order.

For customers without orders, order columns contain NULL.


-------------------------------------------------------------------------------
5.2 Display all products and their order details
-------------------------------------------------------------------------------
*/

SELECT
    p.product_id,
    p.product_name,
    oi.order_id,
    oi.quantity
FROM Products AS p
LEFT JOIN OrderItems AS oi
    ON p.product_id = oi.product_id;


/*
Products without any order items are still included.


===============================================================================
6. RIGHT JOIN
===============================================================================

RIGHT JOIN returns:

    All rows from the RIGHT table.
    Matching rows from the LEFT table.

Unmatched left-side columns return NULL.

RIGHT JOIN is also called RIGHT OUTER JOIN.


-------------------------------------------------------------------------------
6.1 Display all orders and their assigned employees
-------------------------------------------------------------------------------
*/

SELECT
    e.employee_id,
    e.employee_name,
    o.order_id,
    o.employee_id AS assigned_employee_id
FROM Employees AS e
RIGHT JOIN Orders AS o
    ON e.employee_id = o.employee_id;


/*
All orders appear, even if no employee is assigned.

Orders without an assigned employee have NULL employee details.

Equivalent LEFT JOIN:

    SELECT ...
    FROM Orders AS o
    LEFT JOIN Employees AS e
        ON o.employee_id = e.employee_id;

In practice, LEFT JOIN is often preferred because its preserved
table is written first.


===============================================================================
7. FULL OUTER JOIN
===============================================================================

FULL OUTER JOIN returns:

    Matching rows from both tables.
    Unmatched rows from the left table.
    Unmatched rows from the right table.

Missing-side columns are returned as NULL.


-------------------------------------------------------------------------------
7.1 Compare all customers and orders
-------------------------------------------------------------------------------
*/

SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.customer_id AS order_customer_id
FROM Customers AS c
FULL OUTER JOIN Orders AS o
    ON c.customer_id = o.customer_id;;
/*
Because Orders.customer_id has a foreign key referencing Customers,
valid non-NULL order customer IDs must match existing customers.

However, FULL OUTER JOIN is still useful for understanding both-sided
matching and for comparing tables without enforced relationships.
    
-------------------------------------------------------------------------------
7.1 Compare all customers and orders
-------------------------------------------------------------------------------
*/

SELECT
    e.employee_id,
    e.employee_name,
    e.department,
    e.salary,
    o.order_id,
    o.order_date,
    o.total_amount
FROM Employees e
FULL OUTER JOIN Orders o
    ON e.employee_id = o.employee_id;
/*
===============================================================================
8. CROSS JOIN
===============================================================================

CROSS JOIN returns the Cartesian product.

Every row from the first table is combined with every row
from the second table.

If table A has M rows and table B has N rows:

    Result rows = M * N

CROSS JOIN does not require an ON condition.


-------------------------------------------------------------------------------
8.1 Combine each customer with each product
-------------------------------------------------------------------------------
*/

SELECT
    c.customer_name,
    p.product_name,
    p.price
FROM Customers AS c
CROSS JOIN Products AS p;


/*
In the existing dataset:

    10 customers * 10 products = 100 combinations.

This can be useful for generating combinations,
but large tables can produce very large results.


===============================================================================
9. SELF JOIN
===============================================================================

A SELF JOIN joins a table to itself.

It is useful for hierarchical relationships such as:

    Employee -> Manager
    Category -> Parent Category

The Employees table contains:

    employee_id
    employee_name
    manager_id

manager_id references another employee_id in the same table.

Aliases are essential to distinguish the two table instances.


-------------------------------------------------------------------------------
9.1 Display employees and their managers
-------------------------------------------------------------------------------
*/

SELECT
    e.employee_id,
    e.employee_name AS employee_name,
    e.department,
    m.employee_name AS manager_name
FROM Employees AS e
LEFT JOIN Employees AS m
    ON e.manager_id = m.employee_id;

SELECT * FROM Employees;
/*
e represents the employee.
m represents the manager.

LEFT JOIN keeps employees who do not have a manager.

Their manager_name will be NULL.


===============================================================================
10. LEFT ANTI JOIN
===============================================================================

A LEFT ANTI JOIN returns rows from the left table that have
NO matching row in the right table.

SQL Server does not have a dedicated LEFT ANTI JOIN keyword.

Use NOT EXISTS or LEFT JOIN with an IS NULL filter.


-------------------------------------------------------------------------------
10.1 Find customers who have never placed an order
-------------------------------------------------------------------------------
*/

SELECT
    c.customer_id,
    c.customer_name,
    c.city
FROM Customers AS c
WHERE NOT EXISTS
(
    SELECT 1
    FROM Orders AS o
    WHERE o.customer_id = c.customer_id
);


/*
Equivalent LEFT JOIN approach:
*/

SELECT
    c.customer_id,
    c.customer_name,
    c.city
FROM Customers AS c
LEFT JOIN Orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


/*
Use a right-table column that cannot be NULL for a matched row,
such as its primary key.

In this dataset, customer_id 3 has an order, so the cancelled order
still counts as an order for this particular question.

We are checking whether an order exists, not whether it was delivered.


-------------------------------------------------------------------------------
10.2 Find products that have never appeared in OrderItems
-------------------------------------------------------------------------------
*/

SELECT
    p.product_id,
    p.product_name,
    p.category
FROM Products AS p
WHERE NOT EXISTS
(
    SELECT 1
    FROM OrderItems AS oi
    WHERE oi.product_id = p.product_id
);

SELECT
    p.product_id,
    p.product_name,
    p.category
FROM Products AS p
LEFT JOIN OrderItems AS oi
    ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;

/*
===============================================================================
11. RIGHT ANTI JOIN
===============================================================================

A RIGHT ANTI JOIN returns rows from the right table that have
NO matching row in the left table.

SQL Server does not have a dedicated RIGHT ANTI JOIN keyword.

Use NOT EXISTS or RIGHT JOIN with an IS NULL filter.

For this example, compare all orders with the subset of orders
assigned to employees.


-------------------------------------------------------------------------------
11.1 Find orders without an assigned employee
-------------------------------------------------------------------------------
*/

SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.employee_id
FROM Employees AS e
RIGHT JOIN Orders AS o
    ON e.employee_id = o.employee_id
WHERE e.employee_id IS NULL;


/*
Equivalent NOT EXISTS approach:
*/

SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.employee_id
FROM Orders AS o
WHERE NOT EXISTS
(
    SELECT 1
    FROM Employees AS e
    WHERE e.employee_id = o.employee_id
);


/*
An order with employee_id = NULL has no matching employee.

This query also finds an order with a non-NULL employee_id
if that employee does not exist in Employees and no foreign key
prevents that situation.


===============================================================================
12. FULL ANTI JOIN
===============================================================================

A FULL ANTI JOIN returns unmatched rows from BOTH tables.

SQL Server has no dedicated FULL ANTI JOIN keyword.

One approach is FULL OUTER JOIN with a filter for unmatched rows.

IMPORTANT:
    The join columns should be checked carefully.

    In this example, Orders.customer_id is a foreign key, so
    unmatched non-NULL order customer IDs cannot normally exist.

This pattern is more useful when comparing independent datasets.


-------------------------------------------------------------------------------
12.1 Demonstrate the full anti-join pattern
-------------------------------------------------------------------------------
*/

SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.customer_id AS order_customer_id
FROM Customers AS c
FULL OUTER JOIN Orders AS o
    ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL
   OR o.order_id IS NULL;


SELECT
    e.employee_id,
    e.employee_name,
    e.department,
    e.salary,
    o.order_id,
    o.order_date,
    o.total_amount
FROM Employees e
FULL OUTER JOIN Orders o
    ON e.employee_id = o.employee_id
    WHERE o.order_date IS NULL OR e.employee_id is NULL;
/*
Interpretation:

    c.customer_id IS NULL
        -> A row exists on the Orders side but has no matching customer.

    o.order_id IS NULL
        -> A customer has no matching order.

With the current foreign key and sample data, this query returns
customers without orders, but no unmatched valid order customer IDs.


===============================================================================
13. JOINING MULTIPLE TABLES
===============================================================================

Multiple joins can be used to combine information from three
or more related tables.

Example business requirement:

    Display order ID, customer name, employee name, and order amount.

Tables:

    Customers
        |
        | customer_id
        |
    Orders
        |
        | employee_id
        |
    Employees


-------------------------------------------------------------------------------
13.1 Orders, Customers, and Employees
-------------------------------------------------------------------------------
*/

SELECT
    o.order_id,
    c.customer_name,
    e.employee_name,
    o.order_date,
    o.order_status,
    o.total_amount
FROM Orders AS o
INNER JOIN Customers AS c
    ON o.customer_id = c.customer_id
LEFT JOIN Employees AS e
    ON o.employee_id = e.employee_id;


/*
INNER JOIN ensures every displayed order has a customer.

LEFT JOIN retains orders even when no employee is assigned.


-------------------------------------------------------------------------------
13.2 Orders, Customers, OrderItems, and Products
-------------------------------------------------------------------------------
*/

SELECT
    o.order_id,
    c.customer_name,
    o.order_date,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price AS line_total
FROM Orders AS o
INNER JOIN Customers AS c
    ON o.customer_id = c.customer_id
INNER JOIN OrderItems AS oi
    ON o.order_id = oi.order_id
INNER JOIN Products AS p
    ON oi.product_id = p.product_id
ORDER BY
    o.order_id,
    p.product_name;


/*
This query displays one row per order item.

An order containing three products appears in three rows.

line_total is calculated from quantity multiplied by unit_price.


-------------------------------------------------------------------------------
13.3 Combine all five tables
-------------------------------------------------------------------------------
*/

SELECT
    o.order_id,
    c.customer_name,
    e.employee_name,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price AS line_total,
    o.order_status,
    o.payment_method
FROM Orders AS o
INNER JOIN Customers AS c
    ON o.customer_id = c.customer_id
LEFT JOIN Employees AS e
    ON o.employee_id = e.employee_id
INNER JOIN OrderItems AS oi
    ON o.order_id = oi.order_id
INNER JOIN Products AS p
    ON oi.product_id = p.product_id
ORDER BY
    o.order_id,
    oi.order_item_id;


/*
===============================================================================
14. JOIN CONDITIONS
===============================================================================

The ON clause specifies the condition used to match rows.

A correct join condition should reflect the intended relationship
between the tables.

Correct example:

    FROM Customers AS c
    INNER JOIN Orders AS o
        ON c.customer_id = o.customer_id

Incorrect or incomplete join conditions can create unintended
combinations or incorrect results.


-------------------------------------------------------------------------------
14.1 Join using primary key and foreign key
-------------------------------------------------------------------------------
*/

SELECT
    c.customer_id,
    c.customer_name,
    o.order_id
FROM Customers AS c
INNER JOIN Orders AS o
    ON c.customer_id = o.customer_id;


/*
-------------------------------------------------------------------------------
14.2 Join using multiple conditions
-------------------------------------------------------------------------------

Multiple conditions can be combined using AND or OR.

For example, suppose a business requirement matches products
using both product_id and supplier.

Because product_id is unique, matching by product_id alone is
sufficient to identify the product. The additional supplier condition
would restrict which product rows match.
*/

SELECT
    oi.order_id,
    p.product_name,
    p.supplier,
    oi.quantity
FROM OrderItems AS oi
INNER JOIN Products AS p
    ON oi.product_id = p.product_id
   AND p.category = 'Electronics';


/*
Here, the second condition limits the joined products to Electronics.

For a normal foreign-key relationship, do not add unnecessary
conditions that change which matches are allowed.


===============================================================================
15. MULTIPLE JOIN CONDITIONS
===============================================================================

AND:
    Both conditions must be true.

OR:
    Either condition can be true.

Choose the intended logic carefully.


-------------------------------------------------------------------------------
15.1 Join with AND
-------------------------------------------------------------------------------
*/

SELECT
    o.order_id,
    c.customer_name,
    o.customer_id,
    c.customer_id AS matched_customer_id
FROM Orders AS o
INNER JOIN Customers AS c
    ON o.customer_id = c.customer_id
   AND c.customer_status = 'Active';


/*
Only orders belonging to Active customers are returned.


-------------------------------------------------------------------------------
15.2 Join with OR
-------------------------------------------------------------------------------
*/
SELECT
    oi.order_id,
    p.product_name,
    p.category,
    oi.quantity
FROM OrderItems AS oi
INNER JOIN Products AS p
    ON oi.product_id = p.product_id
   AND (
        p.category = 'Electronics'
        OR p.category = 'Accessories'
   )
ORDER BY
    oi.order_id,
    p.product_name;
/*
EXPLANATION:
    1. oi.product_id = p.product_id matches each order item
       with its correct product.

    2. p.category = 'Electronics'
       OR p.category = 'Accessories'
       includes either of these two categories.

    3. Furniture products are excluded.

IMPORTANT:
    Do not add unnecessary OR conditions to a join.
    They can create unintended matches between unrelated rows.
*/
/*
===============================================================================
16. DUPLICATE ROWS CAUSED BY JOINS
===============================================================================

A JOIN does not necessarily return one row per left-side record.

If one customer has five orders, joining Customers to Orders
returns five rows for that customer.

This is expected one-to-many behavior, not automatically a mistake.

A many-to-many relationship can produce even more rows.

Common causes of unexpected duplicates:

    1. Joining tables using an incomplete condition.
    2. Joining tables with one-to-many relationships.
    3. Joining many-to-many relationships.
    4. Joining on a non-unique column.
    5. Joining without the intended key relationship.


-------------------------------------------------------------------------------
16.1 Count orders for each customer
-------------------------------------------------------------------------------
*/

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS order_count
FROM Customers AS c
LEFT JOIN Orders AS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY
    order_count DESC;


/*
COUNT(o.order_id) counts matched orders.

For customers without orders, COUNT(o.order_id) returns 0.

Using COUNT(*) here would count the preserved customer row even
when no order matches, producing at least 1 for those customers.


-------------------------------------------------------------------------------
16.2 Understand one row per order item
-------------------------------------------------------------------------------
*/

SELECT
    o.order_id,
    c.customer_name,
    oi.order_item_id,
    p.product_name
FROM Orders AS o
INNER JOIN Customers AS c
    ON o.customer_id = c.customer_id
INNER JOIN OrderItems AS oi
    ON o.order_id = oi.order_id
INNER JOIN Products AS p
    ON oi.product_id = p.product_id;


/*
Each order item creates a separate result row.

Do not use DISTINCT automatically to hide repeated order IDs.

First identify whether the repetitions are expected from the
one-to-many relationship.


===============================================================================
17. ON VS WHERE IN JOINS
===============================================================================

ON:
    Specifies how rows match during the join.

WHERE:
    Filters rows from the joined result.

For INNER JOIN, placing a right-table filter in ON or WHERE
often produces the same result.

For LEFT JOIN, moving a right-table filter from ON to WHERE
can change the result because WHERE removes rows where that
right-side column is NULL.

-------------------------------------------------------------------------------
17.1 Filter in ON with LEFT JOIN
-------------------------------------------------------------------------------

Return all customers, but attach only Delivered orders.
*/

SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_status,
    o.order_status
FROM Customers AS c
LEFT JOIN Orders AS o
    ON c.customer_id = o.customer_id
   AND o.order_status = 'Delivered';


/*
All customers remain in the output.

Only Delivered orders are attached.

Customers with no Delivered orders have NULL order columns.


-------------------------------------------------------------------------------
17.2 Filter in WHERE with LEFT JOIN
-------------------------------------------------------------------------------

Return only customers who have Delivered orders.
*/

SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_status
FROM Customers AS c
LEFT JOIN Orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered';


/*
The WHERE condition removes rows where order_status is NULL
or is not Delivered.

Therefore, customers without Delivered orders are excluded.

This query behaves like an INNER JOIN for this filter.


-------------------------------------------------------------------------------
17.3 Filter with INNER JOIN
-------------------------------------------------------------------------------
*/

SELECT
    c.customer_name,
    o.order_id,
    o.order_status
FROM Customers AS c
INNER JOIN Orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered';


/*
With this INNER JOIN, placing the Delivered condition in ON
would give the same matching rows:

    ON c.customer_id = o.customer_id
   AND o.order_status = 'Delivered'

The key difference to remember is the behavior of outer joins.
====================================================================
LEFT JOIN: ON vs. WHERE
====================================================================
1. LEFT TABLE NEVER GETS FILTERED IN 'ON':
   - A LEFT JOIN always keeps ALL rows from the Left table.
   - Any condition in the ON clause only decides whether 
     the RIGHT table matches or returns NULL.

2. GOLDEN RULE:
   - Filter LEFT table?  -> Put it in WHERE (removes unwanted rows).
   - Filter RIGHT table? -> Put it in ON    (keeps all left rows, pairs NULLs).

===============================================================================
18. PRACTICE QUESTIONS
===============================================================================

INNER JOIN
----------

1. Display order IDs with customer names.

2. Display order IDs with employee names.

3. Display product names and their order IDs.

4. Display order ID, customer name, order date, and total amount.


LEFT JOIN
---------

5. Display every customer and their orders.

6. Display every product and its order items.

7. Find the number of orders for each customer, including customers
   who have no orders.


RIGHT JOIN
----------

8. Display every order and its assigned employee.

9. Rewrite question 8 using LEFT JOIN.


FULL OUTER JOIN
---------------

10. Compare customers and orders using FULL OUTER JOIN.

11. Explain what happens to unmatched rows on either side.


CROSS JOIN
----------

12. Generate every customer-product combination.

13. Calculate the expected number of rows in the result.


SELF JOIN
---------

14. Display each employee and their manager.

15. Include employees who have no manager.


ANTI JOINS
----------

16. Find customers who have never placed an order.

17. Find products that have never appeared in OrderItems.

18. Find orders without an assigned employee.

19. Explain the difference between LEFT ANTI and RIGHT ANTI joins.

20. Write a FULL ANTI JOIN pattern that returns unmatched rows
    from both sides.


MULTIPLE TABLES
---------------

21. Display order ID, customer name, employee name, and status.

22. Display order ID, customer name, product name, quantity,
    unit price, and line total.

23. Calculate line totals for all order items.

24. Explain why an order can appear in multiple rows when joined
    with OrderItems.


JOIN CONDITIONS
---------------

25. Join Orders and Customers using their related keys.

26. Add a condition to include only Active customers.

27. Explain when AND and OR are appropriate in an ON clause.


DUPLICATES
----------

28. Explain why one customer can appear multiple times in a join.

29. Explain why SUM(o.total_amount) can be inflated after joining
    Orders to OrderItems.

30. Explain why DISTINCT is not always the correct solution
    for duplicate rows.


ON VS WHERE
-----------

31. Return every customer with only their Delivered orders attached.

32. Return only customers who have Delivered orders.

33. Explain the difference between the two queries above.


===============================================================================
19. QUICK REVISION
===============================================================================

INNER JOIN:
    Returns matching rows only.

LEFT JOIN:
    Returns all left rows and matching right rows.

RIGHT JOIN:
    Returns all right rows and matching left rows.

FULL OUTER JOIN:
    Returns matching and unmatched rows from both sides.

CROSS JOIN:
    Returns every possible combination.

SELF JOIN:
    Joins a table to itself.

LEFT ANTI JOIN:
    Returns unmatched rows from the left side.

RIGHT ANTI JOIN:
    Returns unmatched rows from the right side.

FULL ANTI JOIN:
    Returns unmatched rows from both sides.


IMPORTANT:

    SQL Server has no dedicated ANTI JOIN keyword.
    Use NOT EXISTS or an outer join with an IS NULL filter.

    ON defines the matching condition.

    WHERE filters the joined result.

    One-to-many joins can return multiple rows per parent.

    Understand the grain of the data before using aggregate functions.

    Use primary keys and foreign keys to identify intended relationships.


===============================================================================
*/
