# Docs

Supporting documentation for the Nova Retail Group SQL project.

| File | Description |
|---|---|
| `Project Description.pdf` | The original project brief, provided by the course. Includes the company background, database schema documentation, and all assignment questions across five parts: Basic SQL, Intermediate SQL, Advanced SQL, Business Intelligence, and the Executive Management Report. |
| `Nove Project-AnswerScript.pdf` | The complete, formatted answer sheet. Contains every SQL query written for the project, organized by part and question number, alongside the written business insights and strategic recommendations that accompany Parts 4 and 5. |

The entity-relationship diagram is located at the beginning of the answer script since it was produced before the queries. 

## Why the ERD came first

Before writing any queries, the four tables (`Products`, `Customers`, `Sales`, `CustomerFeedback`) were mapped to understand how they relate to one another. `Sales` serves as the central fact table, linked to `Products` and `Customers` via foreign keys, with `CustomerFeedback` connected to both `Sales` (via `OrderID`) and `Customers` (via `CustomerID`).

Establishing this structure upfront resolved a number of practical questions before they became problems mid-query. For example, recognizing that `Category` exists only in the `Products` table — not in `Sales` — made it clear from the outset that any question involving "revenue by category" would require a join, rather than a `GROUP BY` on `Sales` alone. This same reasoning informed the join-type decisions documented throughout the answer sheet (for instance, choosing `LEFT JOIN` over `INNER JOIN` in cases where a category or product might have zero recorded sales).
