# SQL

All SQL queries for this project, organized by part and written against the NovaRetailDB schema (Databricks SQL / Spark SQL syntax).

| File | Contents |
|---|---|
| `Part1_Basic.sql` | Fundamental querying: `SELECT`, `WHERE`, `ORDER BY`. Covers the product catalog, customer counts by region, the ten most recent orders, affordable products under a price threshold, and a customer satisfaction summary. |
| `Part2_Intermediate.sql` | Joins and aggregate functions. Covers total sales revenue and profit by category, the top five customers by purchase amount, a monthly sales trend for 2024, online vs. store channel performance, and average product ratings by category. |
| `Part3_Advanced.sql` | Subqueries, CTEs, and window functions. Covers the best-selling product within each category (using `RANK() OVER (PARTITION BY ...)`), customer lifetime value for repeat buyers, profit margin analysis per product, year-over-year sales growth (2023 vs. 2024), and a regional performance ranking. |
| `Part4_BusinessIntelligence.sql` | Applied analysis addressing specific business questions: whether customer satisfaction correlates with repeat purchase frequency, the relationship between discount bands and profit margin, and identification of the five lowest-revenue products for portfolio review. |
| `Part5_ExecutiveReport.sql` | The summary query behind the overall business performance metrics, plus the three supporting queries behind the executive report's top insights (category performance, discount effectiveness, and regional ranking). |

## Conventions used throughout

- SQL keywords are written in `UPPERCASE`; table and column names follow the casing used in the source schema.
- Every non-aggregated column in a `SELECT` statement is included in the corresponding `GROUP BY` clause, in line with this environment's strict evaluation rules.
- `HAVING` is used, rather than `WHERE`, whenever a query filters on the result of an aggregate function or a window function — since both are evaluated after `WHERE` in SQL's logical processing order.
- Table aliases are applied consistently across every query: `p` for `Products`, `c` for `Customers`, `s` for `Sales`, and `f` for `CustomerFeedback`.
- Join type (`INNER` vs. `LEFT`) is chosen deliberately based on whether a row without a match should be preserved in the result — for example, `LEFT JOIN` is used wherever a category or customer with zero matching sales still needs to appear in the output.

For the full context behind each query — including sample results and the written reasoning that follows — see [`/Docs`](../Docs).
