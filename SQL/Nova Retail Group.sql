-- Databricks notebook source
-- MAGIC %md
-- MAGIC ### **Part 1**

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Question 1.1: List all products in the Electronics category. Show ProductID, ProductName, and 
-- MAGIC UnitPrice. Order by price from highest to lowest.**

-- COMMAND ----------

SELECT  productID, 
        productName, 
        unitPrice 
FROM workspace.nova.products
WHERE category = 'Electronics'
ORDER BY unitPrice DESC;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Question 1.2: How many customers are in each region? Show Region and the count of customers.**

-- COMMAND ----------

SELECT region, COUNT(DISTINCT customerID) AS Total_Customers
FROM workspace.nova.customers
GROUP BY region;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Question 1.3: Recent Orders (5 points) 
-- MAGIC Show the 10 most recent orders. Display OrderID, OrderDate, and TotalSales.** 

-- COMMAND ----------

-- DBTITLE 1,It is worth noting here that some orders were made on the same day, as such, adding a nested order by to also see which orderid was the last one  is a nice to have for tie breakers
SELECT  orderID, 
        orderDate, 
        TotalSales
FROM workspace.nova.sales
ORDER BY orderDate DESC, orderID DESC
LIMIT 10;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Question 1.4: Affordable Products (5 points) 
-- MAGIC Find all products with a UnitPrice less than R1000. Show ProductName, Category, and 
-- MAGIC UnitPrice.**

-- COMMAND ----------

SELECT  ProductName, 
        category, 
        unitPrice
FROM workspace.nova.products
WHERE unitPrice < 1000;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Question 1.5: Customer Satisfaction Summary (5 points) 
-- MAGIC Count how many feedback responses exist for each Satisfaction level. Order by count 
-- MAGIC descending.** 

-- COMMAND ----------

SELECT  satisfaction, 
        COUNT(feedbackID) AS Number_Of_Feedbacks
FROM workspace.nova.customer_feedback
GROUP BY satisfaction
ORDER BY Number_Of_Feedbacks DESC;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### **PART 2**

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Question 2.1: Sales by Category (10 points) 
-- MAGIC Calculate total sales revenue for each product category. Show Category, Total 
-- MAGIC Revenue, and Total Profit. Order by revenue descending.**

-- COMMAND ----------

-- MAGIC %md
-- MAGIC I chose an INNER JOIN for this query after first verifying (via a separate diagnostic query) that every category in the dataset has at least one associated sale. Since there are no zero-sale categories to protect, an INNER JOIN and a LEFT JOIN would return identical results here, so I used the simpler INNER JOIN. However, this decision was data-dependent, not a general rule — if a category with zero sales existed (or could exist in future data), a LEFT JOIN with Products as the anchor table would be necessary to avoid silently dropping that category from the results.
-- MAGIC
-- MAGIC
-- MAGIC COUNT(*) counts rows. COUNT(column) counts non-NULL values in that column. For checking "did a match actually happen," always use COUNT(specific_column), never COUNT(*), 5

-- COMMAND ----------

/* EDA
```
SELECT p.category, 
COUNT(s.orderid) as numberofOrders
FROM workspace.nova.products AS p -- LEFT TABLE
LEFT JOIN workspace.nova.sales AS s -- 
ON p.productID=s.productID
GROUP BY p.category
HAVING COUNT(orderid) <=0 OR COUNT(orderid) IS NULL
```
*/

-- COMMAND ----------

SELECT  p.category, 
        ROUND(SUM(s.TotalSales), 2) AS Total_Revenue, 
        ROUND(SUM(s.Profit), 2) AS Total_Profit
FROM workspace.nova.products AS p
INNER JOIN workspace.nova.sales AS s
ON p.productID=s.productID
GROUP BY p.category
ORDER BY Total_Revenue DESC;



-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Question 2.2: Find the top 5 customers by total purchase amount. Show CustomerID, Customer 
-- MAGIC Name (FirstName + LastName), and Total Spent. Hint: Use CONCAT or + to combine 
-- MAGIC names.** 

-- COMMAND ----------

SELECT  c.CustomerID, 
        CONCAT( c.FirstName, ' ', c.LastName) AS Customer_Name,
        ROUND(SUM(TotalSales), 2) AS Total_Purchase_Amount
FROM workspace.nova.customers AS c
LEFT JOIN workspace.nova.sales AS s
ON c.customerid = s.customerid
GROUP BY CONCAT( c.FirstName, ' ', c.LastName),  c.CustomerID
ORDER BY Total_Purchase_Amount DESC
LIMIT 5;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Question 2.3: Monthly Sales Trend (10 points) 
-- MAGIC Show total sales by month for 2024. Display Year, Month (as number), and Total Sales. 
-- MAGIC Order chronologically.**

-- COMMAND ----------

SELECT YEAR(OrderDate) AS Year_, 
MONTH(OrderDate) AS Month_Number, 
ROUND(SUM(TotalSales), 2) AS Total_Saless
FROM workspace.nova.sales
WHERE YEAR(OrderDate) = 2024
GROUP BY YEAR(OrderDate), MONTH(OrderDate) 
ORDER BY Year_ ASC, Month_Number ASC;



-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Question 2.4: Channel Performance (10 points) 
-- MAGIC Compare Online vs Store performance. Show Channel, Number of Orders, Average 
-- MAGIC Order Value, and Total Revenue.**

-- COMMAND ----------

SELECT  Channel, 
        COUNT(OrderID) AS Number_Of_Orders, 
        ROUND(AVG(TotalSales)) AS Average_Order_Value, 
        ROUND(SUM(TotalSales)) AS Total_Revenue
FROM workspace.nova.sales
GROUP BY Channel;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Question 2.5: Product Performance with Ratings (10 points) 
-- MAGIC For each product category, show the average customer rating. Include Category, 
-- MAGIC Average Rating, and Number of Reviews. Only show categories with at least 50 
-- MAGIC reviews.**

-- COMMAND ----------

SELECT p.Category, 
ROUND(AVG(f.Rating)) AS Average_Rating, 
COUNT(f.feedbackID) AS Number_of_Reviews
FROM workspace.nova.customer_feedback AS f
LEFT JOIN workspace.nova.sales AS s
ON s.OrderID = f.OrderID 
INNER JOIN workspace.nova.products AS p
ON s.ProductID = p.ProductID
GROUP BY p.Category
HAVING COUNT(f.feedbackID) >= 50;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### **PART 3**

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Question 3.1: Best Selling Product per Category (15 points) 
-- MAGIC Find the product with the highest total sales in each category. Show Category, 
-- MAGIC ProductName, and Total Revenue for that product. Use a window function or subquery.**

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Sales has one row per transaction, so first sum + group to get one total per product
-- MAGIC Once every product has its one total, box them by category
-- MAGIC Rank within each box
-- MAGIC

-- COMMAND ----------


/*
SELECT  p.Category, 
        p.ProductName, 
        ROUND(SUM(s.TotalSales), 2) AS Total_Sales,
RANK() OVER (PARTITION BY p.Category ORDER BY SUM(s.TotalSales) DESC) AS Product_Rank
FROM workspace.nova.products AS p
INNER JOIN workspace.nova.sales AS s
ON p.ProductID = s.ProductID
GROUP BY p.Category, 
         p.ProductName;
*/

/*
-- Step 1: collapse Sales (many rows per product) into ONE row per
    -- product, with its total revenue.
    - Step 2: rank products within their own category (PARTITION BY),
            -- highest revenue first. Note we re-use SUM(s.TotalSales) here
            -- instead of the alias Total_Sales -- aliases aren't available
            -- yet inside the same SELECT's window function.
            -- Step 3: now that Product_Rank is a real column in this outer layer,
-- we can finally filter to just the #1 in each category.
*/

SELECT Category, ProductName, Total_Sales
FROM (
    SELECT  p.Category, 
            p.ProductName, 
            ROUND(SUM(s.TotalSales), 2) AS Total_Sales,
            RANK() OVER (PARTITION BY p.Category ORDER BY SUM(s.TotalSales) DESC) AS Product_Rank
    FROM workspace.nova.products AS p
    INNER JOIN workspace.nova.sales AS s
    ON p.ProductID = s.ProductID
    GROUP BY p.Category, 
             p.ProductName
) AS ranked_products
WHERE Product_Rank = 1;
       



-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Question 3.2: Customer Lifetime Value (15 points) 
-- MAGIC Create a query showing each customer's total purchases, number of orders, and 
-- MAGIC average order value. Also include their region and primary channel. Only show 
-- MAGIC customers with more than 3 orders. Order by total purchases descending.**

-- COMMAND ----------

SELECT c.CustomerID,
       CONCAT(c.FirstName, ' ', c.LastName) AS Customer_Name,   
       c.Region,
       c.Channel AS Primary_Channel,
       COUNT(s.OrderID) AS Number_Of_Orders,
       ROUND(SUM(s.TotalSales), 2) AS Total_Purchases,
       ROUND(AVG(s.TotalSales), 2) AS Average_Order_Value
FROM workspace.nova.customers AS c
INNER JOIN workspace.nova.sales AS s 
ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.Region, c.Channel
HAVING COUNT(s.OrderID) > 3
ORDER BY Total_Purchases DESC;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Question 3.3: Profit Margin Analysis (15 points) 
-- MAGIC Calculate the profit margin percentage for each product. Show ProductName, Category, 
-- MAGIC Total Sales, Total Profit, and Profit Margin %. Order by profit margin descending. 
-- MAGIC Formula: (Profit / Sales) * 100**

-- COMMAND ----------

SELECT p.ProductName, p.Category,
       ROUND(SUM(s.TotalSales), 2) AS Total_Sales,
       ROUND(SUM(s.Profit), 2) AS Total_Profit,
       ROUND((SUM(s.Profit) / SUM(s.TotalSales)) * 100, 2) AS Profit_Margin_Pct
FROM workspace.nova.products AS p
INNER JOIN workspace.nova.sales AS s ON p.ProductID = s.ProductID
GROUP BY p.ProductName, p.Category
ORDER BY Profit_Margin_Pct DESC;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Question 3.4: Year-over-Year Growth (15 points) 
-- MAGIC Compare sales between 2023 and 2024. Show the total sales for each year and 
-- MAGIC calculate the growth percentage. Use a CTE or subquery.**

-- COMMAND ----------

-- MAGIC %md
-- MAGIC -- Goal: compare 2023 vs 2024 totals and calculate % growth.
-- MAGIC -- Approach: CTE builds one small "year -> total" lookup table, then
-- MAGIC -- the outer query pulls the 2023 and 2024 rows out of it separately
-- MAGIC -- to do the growth math -- this is the "calculate once, reuse the
-- MAGIC -- named result multiple times" pattern CTEs exist for.

-- COMMAND ----------

WITH yearly_sales AS (
    SELECT YEAR(OrderDate) AS Sale_Year, SUM(TotalSales) AS Total_Sales
    FROM workspace.nova.sales
    GROUP BY YEAR(OrderDate)
)
SELECT
    (SELECT Total_Sales FROM yearly_sales WHERE Sale_Year = 2023) AS Sales_2023,
    (SELECT Total_Sales FROM yearly_sales WHERE Sale_Year = 2024) AS Sales_2024,
    ROUND(
      ((SELECT Total_Sales FROM yearly_sales WHERE Sale_Year = 2024) -
       (SELECT Total_Sales FROM yearly_sales WHERE Sale_Year = 2023)) * 100.0 /
       (SELECT Total_Sales FROM yearly_sales WHERE Sale_Year = 2023), 2
    ) AS Growth_Pct;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Question 3.5: Regional Performance Ranking (15 points) 
-- MAGIC Rank regions by total sales. Use the RANK() or ROW_NUMBER() window function. 
-- MAGIC Show Region, Total Sales, Total Orders, and Rank.**

-- COMMAND ----------

-- MAGIC %md
-- MAGIC -- No PARTITION BY here on purpose: we want ONE ranking across
-- MAGIC        -- all regions together, not a separate ranking "within" each
-- MAGIC        -- region (which would be meaningless -- there's only one row
-- MAGIC        -- per region anyway once grouped).

-- COMMAND ----------

SELECT c.Region,
       ROUND(SUM(s.TotalSales), 2) AS Total_Sales,
       COUNT(s.OrderID) AS Total_Orders,
       RANK() OVER (ORDER BY SUM(s.TotalSales) DESC) AS Region_Rank
FROM workspace.nova.customers AS c
INNER JOIN workspace.nova.sales AS s ON c.CustomerID = s.CustomerID
GROUP BY c.Region
ORDER BY Region_Rank;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### **PART 4**

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ###**Question 4.1: Customer Satisfaction vs. Repeat Purchases (20 points)** 
-- MAGIC Analyze whether highly satisfied customers (rating 4-5) make more repeat purchases 
-- MAGIC than less satisfied customers (rating 1-3). Show satisfaction level groups, average 
-- MAGIC number of orders per customer, and total customers in each group. 
-- MAGIC Your SQL Query:

-- COMMAND ----------

WITH customer_orders AS (
    SELECT CustomerID, COUNT(*) AS Num_Orders
    FROM workspace.nova.sales
    GROUP BY CustomerID
)
SELECT
    CASE WHEN f.Rating >= 4 THEN 'High Satisfaction (4-5)'
         ELSE 'Low Satisfaction (1-3)' END AS Satisfaction_Group,
    ROUND(AVG(co.Num_Orders), 2) AS Avg_Orders_Per_Customer,
    COUNT(DISTINCT f.CustomerID) AS Total_Customers
FROM workspace.nova.customer_feedback f
JOIN customer_orders co ON f.CustomerID = co.CustomerID
GROUP BY Satisfaction_Group;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## **INSIGHTS**
-- MAGIC Happy customers (4-5 star ratings) ordered about the same number of times as unhappy customers (1-3 stars), roughly 6 orders each, so satisfaction barely made a difference. This means how happy someone is doesn't really predict whether they'll keep buying from Nove; people may just be shopping with from Nova out of habit or lack of other options. So management shouldn't assume that making customers happier will automatically lead to more repeat purchases

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##**Question 4.2: Discount Effectiveness (20 points)** 
-- MAGIC Examine the relationship between discount percentage and profit. Create discount 
-- MAGIC bands (0%, 1-10%, 11-20%, 21-30%) and show total sales, total profit, and profit margin 
-- MAGIC for each band.

-- COMMAND ----------

SELECT
    CASE
        WHEN DiscountPercent = 0 THEN '0%'
        WHEN DiscountPercent BETWEEN 1 AND 10 THEN '1-10%'
        WHEN DiscountPercent BETWEEN 11 AND 20 THEN '11-20%'
        WHEN DiscountPercent BETWEEN 21 AND 30 THEN '21-30%'
    END AS Discount_Band,
    ROUND(SUM(TotalSales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND((SUM(Profit) / SUM(TotalSales)) * 100, 2) AS Profit_Margin_Pct
FROM workspace.nova.sales
GROUP BY Discount_Band
ORDER BY Discount_Band;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##**INSIGHTS**
-- MAGIC The bigger the discount, the less profit we make, margin drops from about 40% with no discount to under 19% at 21-30% off. This means big discounts are mostly just cutting into profit, without clear proof they're bringing in enough extra sales to make up for it. Management should think twice about offering such large discounts unless there's evidence they're actually worth it.

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### **Question 4.3: Product Portfolio Optimization (20 points)**
-- MAGIC Identify underperforming products (bottom 5 by total revenue) and analyze whether they 
-- MAGIC should be discontinued. Consider sales volume, profit margin, and customer ratings. 

-- COMMAND ----------

WITH product_totals AS (
    SELECT p.ProductID, p.ProductName, p.Category,
           SUM(s.TotalSales) AS Total_Revenue,
           SUM(s.Profit) AS Total_Profit,
           ROUND((SUM(s.Profit) * 1.0 / SUM(s.TotalSales)) * 100, 2) AS Profit_Margin_Pct
    FROM workspace.nova.products AS p
    JOIN workspace.nova.sales s ON p.ProductID = s.ProductID
    GROUP BY p.ProductID, p.ProductName, p.Category
),
product_ratings AS (
    SELECT s.ProductID,
           ROUND(AVG(f.Rating), 2) AS Avg_Rating,
           COUNT(f.FeedbackID) AS Num_Reviews
    FROM workspace.nova.customer_feedback f
    JOIN workspace.nova.sales s ON f.OrderID = s.OrderID
    GROUP BY s.ProductID
)
SELECT pt.ProductName, pt.Category, pt.Total_Revenue, pt.Profit_Margin_Pct,
       pr.Avg_Rating, pr.Num_Reviews
FROM product_totals pt
LEFT JOIN product_ratings pr ON pt.ProductID = pr.ProductID
ORDER BY pt.Total_Revenue ASC
LIMIT 5;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## **PART 5**

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Section 1: Overall Business Performance (15 points)**
-- MAGIC Provide a summary of key business metrics: 
-- MAGIC • Total revenue and profit for 2023-2024 
-- MAGIC • Overall profit margin 
-- MAGIC • Total number of orders and customers 
-- MAGIC • Average order value

-- COMMAND ----------

SELECT
    ROUND(SUM(TotalSales), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND((SUM(Profit) / SUM(TotalSales)) * 100, 2) AS Overall_Profit_Margin_Pct,
    COUNT(OrderID) AS Total_Orders,
    COUNT(DISTINCT CustomerID) AS Total_Customers,
    ROUND(AVG(TotalSales), 2) AS Average_Order_Value
FROM workspace.nova.sales;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## **INSIGHT 1**

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Section 2: Top 3 Insights (20 points)** 
-- MAGIC Identify and explain the three most important insights from your analysis. Each insight 
-- MAGIC must be supported by SQL query results.

-- COMMAND ----------

SELECT p.Category, ROUND(SUM(s.TotalSales),2) AS Total_Revenue, ROUND(SUM(s.Profit),2) AS Total_Profit
FROM workspace.nova.products p INNER JOIN workspace.nova.sales s ON p.ProductID = s.ProductID
GROUP BY p.Category ORDER BY Total_Revenue DESC;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## **INSIGHT 2**

-- COMMAND ----------

SELECT CASE WHEN DiscountPercent=0 THEN '0%' WHEN DiscountPercent BETWEEN 1 AND 10 THEN '1-10%'
     WHEN DiscountPercent BETWEEN 11 AND 20 THEN '11-20%' WHEN DiscountPercent BETWEEN 21 AND 30
     THEN '21-30%' END AS Discount_Band, ROUND((SUM(Profit)/SUM(TotalSales))*100,2) AS Margin_Pct
FROM workspace.nova.sales
GROUP BY Discount_Band;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## **INSIGHT 3**

-- COMMAND ----------

SELECT c.Region, ROUND(SUM(s.TotalSales),2) AS Total_Sales,
       RANK() OVER (ORDER BY SUM(s.TotalSales) DESC) AS Region_Rank
FROM workspace.nova.customers c 
INNER JOIN workspace.nova.sales s
 ON c.CustomerID = s.CustomerID
GROUP BY c.Region;

-- COMMAND ----------

