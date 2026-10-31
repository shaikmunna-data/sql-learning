/*
===============================================================================
12. SET OPERATORS
===============================================================================

TOPICS COVERED
--------------
1. What Are Set Operators?
2. Rules for Set Operators
3. UNION
4. UNION ALL
5. UNION vs UNION ALL
6. INTERSECT
7. EXCEPT
8. ORDER BY with Set Operators
9. Combining Set Operators
10. Common Mistakes
11. Practice Section
12. Quick Revision
*/

USE EcommerceSQL;
GO

/*
===============================================================================
1. WHAT ARE SET OPERATORS?
===============================================================================

Set operators combine the results of two or more SELECT statements.

UNION       - Combines results and removes duplicate rows.
UNION ALL   - Combines results and preserves duplicate rows.
INTERSECT   - Returns rows present in both result sets.
EXCEPT      - Returns rows from the first result set that are absent
              from the second result set.

Scenario:
CampaignA contains customers selected for a festival sale.
CampaignB contains customers selected for a year-end sale.

Common customers: 3, 4, 5
CampaignA only:   1, 2
CampaignB only:   6, 7
*/

-- View CampaignA.
SELECT *
FROM CampaignA
ORDER BY customer_id;

-- View CampaignB.
SELECT *
FROM CampaignB
ORDER BY customer_id;


/*
===============================================================================
2. RULES FOR SET OPERATORS
===============================================================================

1. Each SELECT must return the same number of columns.
2. Corresponding columns must have compatible data types.
3. Columns are matched by position, not by column name.
4. Result column names come from the first SELECT.
5. ORDER BY is placed at the end of the combined query.
6. UNION, INTERSECT, and EXCEPT remove duplicate rows.
7. UNION ALL preserves duplicate rows.
*/


/*
===============================================================================
3. UNION
===============================================================================

UNION combines result sets and removes duplicate rows.
*/

-- Example 1: Display all unique customers across both campaigns.

SELECT customer_id, customer_name
FROM CampaignA

UNION

SELECT customer_id, customer_name
FROM CampaignB
ORDER BY customer_id;

/*
Expected: 7 rows.
Customers 3, 4, and 5 appear in both tables but are returned once.
*/

-- Example 2: Count unique customers across both campaigns.

SELECT COUNT(*) AS unique_customer_count
FROM
(
    SELECT customer_id, customer_name
    FROM CampaignA

    UNION

    SELECT customer_id, customer_name
    FROM CampaignB
) AS CombinedCampaigns;

/*
Expected result:
unique_customer_count
---------------------
7
*/


/*
===============================================================================
4. UNION ALL
===============================================================================

UNION ALL combines result sets and preserves duplicate rows.
*/

-- Example 1: Display all campaign entries, including duplicates.

SELECT customer_id, customer_name
FROM CampaignA

UNION ALL

SELECT customer_id, customer_name
FROM CampaignB
ORDER BY customer_id;

/*
Expected: 10 rows.
Customers 3, 4, and 5 appear twice.
*/

-- Example 2: Count all campaign entries.

SELECT COUNT(*) AS total_campaign_entries
FROM
(
    SELECT customer_id, customer_name
    FROM CampaignA

    UNION ALL

    SELECT customer_id, customer_name
    FROM CampaignB
) AS AllCampaignEntries;

/*
Expected result:
total_campaign_entries
----------------------
10
*/


/*
===============================================================================
5. UNION VS UNION ALL
===============================================================================

UNION:
- Removes duplicate rows.
- Performs duplicate elimination.
- May require additional processing.

UNION ALL:
- Preserves duplicate rows.
- Does not eliminate duplicates.
- Is generally faster when duplicates should be retained.
*/

-- Compare the results of UNION and UNION ALL.

SELECT customer_id, customer_name
FROM CampaignA

UNION

SELECT customer_id, customer_name
FROM CampaignB;
GO

SELECT customer_id, customer_name
FROM CampaignA

UNION ALL

SELECT customer_id, customer_name
FROM CampaignB;
GO

/*
UNION returns 7 rows.
UNION ALL returns 10 rows.

Use UNION when unique rows are required.
Use UNION ALL when every row must be preserved.
*/


/*
===============================================================================
6. INTERSECT
===============================================================================

INTERSECT returns distinct rows present in both result sets.
*/

-- Example 1: Find customers who belong to both campaigns.

SELECT customer_id, customer_name
FROM CampaignA

INTERSECT

SELECT customer_id, customer_name
FROM CampaignB
ORDER BY customer_id;

/*
Expected:
3  Arjun Kumar
4  Sneha Patel
5  Vikram Singh

Total rows: 3
*/

-- Example 2: Count customers who belong to both campaigns.

SELECT COUNT(*) AS shared_customer_count
FROM
(
    SELECT customer_id, customer_name
    FROM CampaignA

    INTERSECT

    SELECT customer_id, customer_name
    FROM CampaignB
) AS SharedCustomers;


/*
===============================================================================
7. EXCEPT
===============================================================================

EXCEPT returns distinct rows from the first SELECT result that do not
exist in the second SELECT result.
*/

-- Example 1: Find customers in CampaignA but not in CampaignB.

SELECT customer_id, customer_name
FROM CampaignA

EXCEPT

SELECT customer_id, customer_name
FROM CampaignB
ORDER BY customer_id;

/*
Expected:
1  Rahul Sharma
2  Priya Reddy

Total rows: 2
*/

-- Example 2: Find customers in CampaignB but not in CampaignA.

SELECT customer_id, customer_name
FROM CampaignB

EXCEPT

SELECT customer_id, customer_name
FROM CampaignA
ORDER BY customer_id;

/*
Expected:
6  Anjali Rao
7  Kiran Das

Total rows: 2
*/

-- Example 3: Count customers exclusive to CampaignA.

SELECT COUNT(*) AS campaign_a_only_count
FROM
(
    SELECT customer_id, customer_name
    FROM CampaignA

    EXCEPT

    SELECT customer_id, customer_name
    FROM CampaignB
) AS CampaignAOnly;

/*
EXCEPT is directional.

CampaignA EXCEPT CampaignB returns customers only in CampaignA.
CampaignB EXCEPT CampaignA returns customers only in CampaignB.
*/


/*
===============================================================================
8. ORDER BY WITH SET OPERATORS
===============================================================================

ORDER BY sorts the final combined result.
Place it after the last SELECT statement.
*/

-- Display all unique customers in alphabetical order.

SELECT customer_id, customer_name
FROM CampaignA

UNION

SELECT customer_id, customer_name
FROM CampaignB
ORDER BY customer_name ASC;


/*
===============================================================================
9. COMBINING SET OPERATORS
===============================================================================

Multiple set operators can be used in a single query.

INTERSECT has higher precedence than UNION and EXCEPT in SQL Server.
Use parentheses when necessary to make the intended grouping clear.
*/

-- Example: Find customers belonging to exactly one campaign.

(SELECT customer_id, customer_name
FROM CampaignA

EXCEPT

SELECT customer_id, customer_name
FROM CampaignB)

UNION

(SELECT customer_id, customer_name
FROM CampaignB

EXCEPT

SELECT customer_id, customer_name
FROM CampaignA);

/*
Expected:
1  Rahul Sharma
2  Priya Reddy
6  Anjali Rao
7  Kiran Das

These customers belong to exactly one campaign.
*/

/*
===============================================================================
11.7 SET OPERATORS VS JOINS
===============================================================================
-----------------------------------------------------------------------------
Explain the difference between UNION and INNER JOIN.
-----------------------------------------------------------------------------
UNION combines rows from two SELECT results.

INNER JOIN combines columns from matching rows in two tables.

UNION example: Combine customers from both campaigns.
*/
SELECT customer_id, customer_name
FROM CampaignA

UNION

SELECT customer_id, customer_name
FROM CampaignB;


-- INNER JOIN example: Find customers who belong to both campaigns.

SELECT
    A.customer_id,
    A.customer_name AS campaign_a_customer,
    B.customer_name AS campaign_b_customer
FROM CampaignA AS A
INNER JOIN CampaignB AS B
    ON A.customer_id = B.customer_id;
/*
-----------------------------------------------------------------------------
When would UNION ALL be preferable to UNION?
-----------------------------------------------------------------------------

UNION removes duplicate rows.
UNION ALL preserves duplicate rows and is generally more efficient
when duplicate elimination is unnecessary.

Display all campaign entries, including repeated customers.
*/
SELECT customer_id, customer_name
FROM CampaignA

UNION ALL

SELECT customer_id, customer_name
FROM CampaignB;
/*
-----------------------------------------------------------------------------
Compare INTERSECT with INNER JOIN for finding shared customers.
-----------------------------------------------------------------------------
INTERSECT returns distinct rows common to both result sets.
*/
SELECT customer_id, customer_name
FROM CampaignA

INTERSECT

SELECT customer_id, customer_name
FROM CampaignB;

/*
INNER JOIN matches rows using the specified join condition.
It can return columns from both tables.
*/

SELECT
    A.customer_id,
    A.customer_name AS campaign_a_customer,
    B.customer_name AS campaign_b_customer
FROM CampaignA AS A
INNER JOIN CampaignB AS B
    ON A.customer_id = B.customer_id;

/*
-----------------------------------------------------------------------------
Compare EXCEPT with NOT EXISTS for finding customers absent from a campaign.
-----------------------------------------------------------------------------
EXCEPT returns customers in CampaignA who are absent from CampaignB.
*/
SELECT customer_id, customer_name
FROM CampaignA

EXCEPT

SELECT customer_id, customer_name
FROM CampaignB;

/*
NOT EXISTS checks whether a matching row exists in CampaignB.
This query returns customers in CampaignA who are absent from CampaignB.
*/

SELECT
    A.customer_id,
    A.customer_name
FROM CampaignA AS A
WHERE NOT EXISTS
(
    SELECT 1
    FROM CampaignB AS B
    WHERE B.customer_id = A.customer_id
);
/*
===============================================================================
10. COMMON MISTAKES
===============================================================================

Mistake 1: Returning different numbers of columns.

The following query is invalid because the SELECT statements return
different numbers of columns:

SELECT customer_id, customer_name
FROM CampaignA

UNION

SELECT customer_id
FROM CampaignB;


Mistake 2: Using incompatible data types.

Corresponding columns must have compatible data types.
Use CAST or CONVERT when appropriate.


Mistake 3: Assuming UNION ALL removes duplicates.

UNION ALL preserves duplicate rows.


Mistake 4: Assuming columns match by name.

Set operators match columns by position.


Mistake 5: Assuming EXCEPT works in both directions.

CampaignA EXCEPT CampaignB is different from CampaignB EXCEPT CampaignA.
*/

/*
===============================================================================
11. PRACTICE SECTION
===============================================================================

-----------------------------------------------------------------------------
11.1 UNION
-----------------------------------------------------------------------------

Q1. Display all unique customers across both campaigns.
Q2. Count the unique customers across both campaigns.


-----------------------------------------------------------------------------
11.2 UNION ALL
-----------------------------------------------------------------------------

Q3. Display every campaign entry, including duplicates.
Q4. Count all campaign entries.
Q5. Compare the row counts returned by UNION and UNION ALL.


-----------------------------------------------------------------------------
11.3 INTERSECT
-----------------------------------------------------------------------------

Q6. Find customers who belong to both campaigns.
Q7. Count the customers shared by both campaigns.


-----------------------------------------------------------------------------
11.4 EXCEPT
-----------------------------------------------------------------------------

Q8. Find customers in CampaignA but not CampaignB.
Q9. Find customers in CampaignB but not CampaignA.
Q10. Count the customers exclusive to each campaign.


-----------------------------------------------------------------------------
11.5 ORDER BY WITH SET OPERATORS
-----------------------------------------------------------------------------

Q11. Combine both campaigns and sort customers alphabetically.
Q12. Combine both campaigns and sort by customer_id in descending order.


-----------------------------------------------------------------------------
11.6 COMBINING SET OPERATORS
-----------------------------------------------------------------------------

Q13. Return customers who belong to exactly one campaign.
Q14. Return customers who belong to both campaigns or only CampaignA.
Q15. Explain how reversing the SELECT statements changes EXCEPT.
*/

/*
===============================================================================
12. QUICK REVISION
===============================================================================

UNION:
Combines results and removes duplicate rows.

UNION ALL:
Combines results and preserves duplicate rows.

INTERSECT:
Returns distinct rows found in both result sets.

EXCEPT:
Returns distinct rows from the first result set that are absent
from the second result set.

IMPORTANT RULES:
- Same number of columns.
- Compatible data types in corresponding positions.
- Columns match by position.
- Output column names come from the first SELECT.
- ORDER BY goes at the end of the combined query.
- UNION vs UNION ALL is an important interview topic.
- EXCEPT is directional.
- Set operators combine rows; JOINs combine related columns.

===============================================================================
END OF TOPIC 12: SET OPERATORS
===============================================================================
*/
/*
====================================================================
SET OPERATORS CHEAT SHEET & RULES
====================================================================
1. COMMUTATIVITY (Does order of tables matter?):
   - A UNION B     == B UNION A       (Order does NOT matter)
   - A INTERSECT B == B INTERSECT A   (Order does NOT matter)
   - A EXCEPT B    != B EXCEPT A      (Order DOES matter! It acts like subtraction)

2. UNION vs UNION ALL:
   - UNION: Removes duplicates (runs an internal sort/distinct step - slower).
   - UNION ALL: Keeps all rows, including duplicates (fastest - no deduplication).

3. ORDER BY RULE:
   - You can only place ONE ORDER BY clause, and it MUST go at the very 
     end of the entire compound query to sort the final combined result set.
====================================================================
*/