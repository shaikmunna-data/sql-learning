# 08. SQL CASE Expressions

## 1. What is the CASE Expression?

The `CASE` expression is used to apply conditional logic in SQL.

It checks conditions and returns a value based on the first condition that evaluates to TRUE.

It works like `IF-ELSE` logic in programming languages.

## 2. Syntax

```sql
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ELSE default_result
END
```

- `WHEN` specifies a condition.
- `THEN` specifies the result when the condition is TRUE.
- `ELSE` specifies the default result.
- `END` closes the CASE expression.

## 3. Simple CASE Expression

A simple CASE compares one expression against multiple values.

**Example:** Display a readable order status.

```sql
SELECT
    order_id,
    order_status,
    CASE order_status
        WHEN 'Delivered' THEN 'Completed'
        WHEN 'Pending' THEN 'In Progress'
        WHEN 'Cancelled' THEN 'Not Completed'
        ELSE 'Unknown Status'
    END AS status_description
FROM Orders;
```

## 4. Searched CASE Expression

A searched CASE evaluates multiple independent conditions.

**Example:** Categorize employees based on salary.

```sql
SELECT
    employee_name,
    salary,
    CASE
        WHEN salary >= 80000 THEN 'High Salary'
        WHEN salary >= 50000 THEN 'Medium Salary'
        ELSE 'Low Salary'
    END AS salary_category
FROM Employees;
```

Conditions are evaluated from top to bottom. The first matching condition determines the result.

## 5. CASE with Aggregate Functions

**Example:** Count delivered, pending, and cancelled orders.

```sql
SELECT
    COUNT(CASE
        WHEN order_status = 'Delivered' THEN 1
    END) AS delivered_orders,

    COUNT(CASE
        WHEN order_status = 'Pending' THEN 1
    END) AS pending_orders,

    COUNT(CASE
        WHEN order_status = 'Cancelled' THEN 1
    END) AS cancelled_orders
FROM Orders;
```

This technique is called conditional aggregation.

## 6. CASE with GROUP BY

**Example:** Calculate total sales for each order status.

```sql
SELECT
    order_status,
    SUM(
        CASE
            WHEN total_amount > 0 THEN total_amount
            ELSE 0
        END
    ) AS total_sales
FROM Orders
GROUP BY order_status;
```

## 7. CASE with ORDER BY

CASE can also be used to customize sorting.

**Example:** Display Pending orders first, followed by Delivered and Cancelled orders.

```sql
SELECT
    order_id,
    order_status,
    total_amount
FROM Orders
ORDER BY
    CASE order_status
        WHEN 'Pending' THEN 1
        WHEN 'Delivered' THEN 2
        WHEN 'Cancelled' THEN 3
        ELSE 4
    END;
```

## 8. CASE with UPDATE

CASE can assign different values based on conditions.

```sql
UPDATE Employees
SET salary =
    CASE
        WHEN salary < 30000 THEN salary * 1.10
        WHEN salary < 50000 THEN salary * 1.05
        ELSE salary
    END;
```

This example increases salaries by different percentages depending on their current values.

## 9. Simple CASE vs Searched CASE

<table style="margin-left: 0; margin-right: auto;">
<tr>
<th>Simple CASE</th>
<th>Searched CASE</th>
</tr>
<tr>
<td>Compares one expression against specific values.</td>
<td>Evaluates independent conditions.</td>
</tr>
<tr>
<td>Uses equality comparisons.</td>
<td>Supports operators such as <code>&gt;</code>, <code>&lt;</code>, <code>=</code> and <code>BETWEEN</code>.</td>
</tr>
<tr>
<td>Useful for matching categories or statuses.</td>
<td>Useful for ranges and complex conditions.</td>
</tr>
<tr>
<td><code>CASE status WHEN 'Pending' THEN ...</code></td>
<td><code>CASE WHEN salary &gt; 50000 THEN ...</code></td>
</tr>
</table>

## 10. Important Rules

- CASE is an expression, not a separate SQL statement.
- CASE returns a value.
- Conditions are checked from top to bottom.
- The first matching condition is returned.
- ELSE is optional. If omitted and no condition matches, CASE returns NULL.
- Result expressions should have compatible data types.
- CASE can be used in SELECT, ORDER BY, GROUP BY, aggregate expressions, and other valid SQL expressions.

## 11. Frequently Asked Interview Questions

**1. What is a CASE expression in SQL?**

CASE is used to implement conditional logic and return values based on specified conditions.

**2. What is the difference between simple CASE and searched CASE?**

Simple CASE compares one expression against values, whereas searched CASE evaluates independent conditions.

**3. Is ELSE mandatory in CASE?**

No. If ELSE is omitted and no condition matches, CASE returns NULL.

**4. Can we use multiple WHEN conditions?**

Yes. A CASE expression can contain multiple WHEN conditions.

**5. Can CASE be used with aggregate functions?**

Yes. It is commonly used for conditional aggregation.

**6. Can CASE be used in ORDER BY?**

Yes. It can create custom sorting rules.

**7. Can CASE be nested?**

Yes. One CASE expression can be placed inside another CASE expression.

**8. Is CASE a statement or an expression?**

CASE is an expression because it returns a value.

**9. What happens when multiple WHEN conditions are TRUE?**

Only the result of the first matching WHEN condition is returned.

**10. Can CASE replace IF-ELSE logic?**

Yes. CASE provides conditional logic within SQL expressions.

## 12. Common Mistakes

- Forgetting the END keyword.
- Writing THEN without a corresponding WHEN.
- Placing conditions in the wrong order.
- Forgetting that only the first matching condition is returned.
- Using incompatible result data types.
- Assuming ELSE is mandatory.

## 13. Quick Revision

- CASE implements conditional logic in SQL.
- Simple CASE compares an expression with values.
- Searched CASE evaluates independent conditions.
- WHEN defines a condition.
- THEN defines the result.
- ELSE defines the default result.
- END closes the CASE expression.
- Conditional aggregation combines CASE with aggregate functions.