# Nova Retail Group — SQL Database Analysis

A SQL-based business intelligence project analyzing sales, customer behavior, and product performance for Nova Retail Group, a South African retail company operating across physical stores and an online platform.

## Background

Nova Retail Group is a growing retail company operating across multiple regions in South Africa, selling consumer products through both physical stores and an online platform. Management needed help analyzing their data to make better, evidence-based business decisions.

For this project, I took on the role of Junior Data Analyst — tasked with analyzing sales data, customer behavior, and product performance, writing SQL queries to answer specific business questions, and delivering clear insights back to management.

## Repository structure

```
Nova-Retail-Group/
├── [`/Data`](./Data)     # Source CSVs: Products, Customers, Sales, CustomerFeedback
├── [`/Docs`](./Docs)     # Full answer sheet, project brief
├── [`/SQL`](./SQL)      # All SQL queries, organized by project part
├── NovaRetail-ERD/   # ERD Image
└── README.md
```

## What problem did I solve?

Nova Retail Group's management needed a clearer picture of business performance across products, customers, and regions to guide decision-making. As a Junior Data Analyst, I was tasked with querying the company's sales database to answer specific business questions — which categories drive revenue, whether discounting is helping or hurting profit, which regions are underperforming, and whether customer satisfaction actually predicts repeat purchases — then turning those answers into concrete recommendations for management.

## What tools & skills did I use?

**SQL** (Databricks SQL / Spark SQL syntax) — including:
- `SELECT`, `WHERE`, `ORDER BY`, `GROUP BY`, `HAVING`
- Aggregate functions (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`)
- Joins (`INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`)
- Subqueries and CTEs (Common Table Expressions)
- Window functions (`RANK`, `ROW_NUMBER`, `PARTITION BY`)
- Date functions and time-based analysis

## How did I approach it?

**1. Mapped the database first.** Before writing a single query, I built an entity-relationship diagram (ERD) of the 4 tables (`Products`, `Customers`, `Sales`, `CustomerFeedback`). Sales is the central fact table, linked to Products and Customers via foreign keys, with CustomerFeedback linked to both Sales and Customers. Mapping this out upfront made it much clearer which joins each question would actually need — for example, seeing that `Category` only exists in `Products`, not `Sales`, immediately signals that any question about "revenue by category" requires a join, not just a `GROUP BY`. The ERD is included as an image in this repo.

**2. Then moved from foundational to advanced, layering each skill on the last:**
1. **Basic queries** — filtering and sorting the raw Products, Customers, and Sales data.
2. **Intermediate queries** — joining tables together and aggregating by category, customer, channel, and month.
3. **Advanced queries** — using window functions and CTEs to rank top products/regions and calculate year-over-year growth.
4. **Business intelligence** — applying the above to specific strategic questions (satisfaction vs. repeat purchases, discount effectiveness, underperforming products), each backed by a written insight.
5. **Executive report** — consolidating the strongest findings into a summary report with data-driven recommendations for management.

## Where is the code?

All SQL queries are organized by project part in [`/SQL`](./SQL). The full written answer sheet — queries, results, and business insights together — is in [`/Docs`](./Docs).

## What was the outcome?

- **Electronics drives the business** — it generates more revenue and profit than Home Appliances and Lifestyle Goods combined.
- **Deep discounts erode margin** — profit margin drops from ~40% (no discount) to under 19% at 21–30% discount, with no clear evidence the volume gained justifies the loss.
- **Regional performance is uneven** — the North region outperforms the West by roughly 30%, pointing to a gap worth investigating rather than an even budget split.
- **Satisfaction doesn't predict repeat purchases** — order frequency is nearly identical between highly and poorly satisfied customers, so retention strategy needs to look beyond satisfaction scores alone.

These findings fed directly into the strategic recommendations in the final executive report.

## Database schema

**NovaRetailDB** consists of 4 tables:

| Table | Records | Description |
|---|---|---|
| `Products` | 30 | Product catalog — name, category, pricing |
| `Customers` | 500 | Customer info — region, channel, join date |
| `Sales` | 2,500 | Transaction fact table — orders, revenue, profit |
| `CustomerFeedback` | 1,000 | Satisfaction surveys and ratings |

---
*Tshegofatso Senona — 2026*
