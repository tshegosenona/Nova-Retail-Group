# Data

Source CSV files for the NovaRetailDB database used throughout this project. These four files represent the complete dataset behind every query, result, and insight in this repository.

| File | Records | Columns | Description |
|---|---|---|---|
| `Products.csv` | 30 | ProductID (PK), ProductName, Category, UnitPrice, CostPrice | Product catalog covering three categories: Electronics, Home Appliances, and Lifestyle Goods. |
| `Customers.csv` | 500 | CustomerID (PK), FirstName, LastName, Region, Channel, JoinDate | Customer records spanning four regions (North, South, East, West) and two purchase channels (Online, Store). |
| `Sales.csv` | 2,500 | OrderID (PK), OrderDate, CustomerID (FK), ProductID (FK), Quantity, UnitPrice, DiscountPercent, DiscountAmount, TotalSales, TotalCost, Profit, Channel | The transactional fact table. Covers orders placed across 2023 and 2024. |
| `CustomerFeedback.csv` | 1,000 | FeedbackID (PK), OrderID (FK), CustomerID (FK), Rating, Satisfaction, RecommendLikelihood | Post-purchase satisfaction surveys, including a 1–5 star rating, a satisfaction category, and a 1–10 Net Promoter Score. |

## Table relationships

- `Sales.CustomerID` → `Customers.CustomerID` (many sales per customer)
- `Sales.ProductID` → `Products.ProductID` (many sales per product)
- `CustomerFeedback.OrderID` → `Sales.OrderID` (feedback tied to a specific order)
- `CustomerFeedback.CustomerID` → `Customers.CustomerID` (a customer may leave multiple pieces of feedback, one per order reviewed)

The full visual schema, including primary and foreign key annotations, is available in the entity-relationship diagram at the root of this repository.

## Notes on the data

- `Sales` functions as the central fact table. The majority of queries in this project — particularly joins and aggregations — route through it, since it is the only table containing transaction-level financial data (`TotalSales`, `Profit`, `DiscountPercent`).
- Every product in this dataset has at least one associated sale. This was verified directly via a diagnostic query (checking for products with zero matching `Sales` rows) before running category-level aggregations in Part 2, rather than assumed.
- `Sales.DiscountPercent` and `Sales.TotalCost` are present in the raw data but not listed in the original project schema document — worth noting if cross-referencing against the assignment brief in `/Docs`.
