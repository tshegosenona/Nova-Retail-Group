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

SELECT satisfaction, 
COUNT(feedbackID) AS Number_Of_Feedbacks
FROM workspace.nova.customer_feedback
GROUP BY satisfaction
ORDER BY Number_Of_Feedbacks DESC;

-- COMMAND ----------

SELECT * 
FROM workspace.nova.sales; 

SELECT *
FROM workspace.nova.products;

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

SELECT p.category, 
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



-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Question 2.3: Monthly Sales Trend (10 points) 
-- MAGIC Show total sales by month for 2024. Display Year, Month (as number), and Total Sales. 
-- MAGIC Order chronologically.**

-- COMMAND ----------



-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Question 2.4: Channel Performance (10 points) 
-- MAGIC Compare Online vs Store performance. Show Channel, Number of Orders, Average 
-- MAGIC Order Value, and Total Revenue.**

-- COMMAND ----------



-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Question 2.5: Product Performance with Ratings (10 points) 
-- MAGIC For each product category, show the average customer rating. Include Category, 
-- MAGIC Average Rating, and Number of Reviews. Only show categories with at least 50 
-- MAGIC reviews.**

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### **PART 3**

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Question 3.1: Best Selling Product per Category (15 points) 
-- MAGIC Find the product with the highest total sales in each category. Show Category, 
-- MAGIC ProductName, and Total Revenue for that product. Use a window function or subquery.**

-- COMMAND ----------



-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Question 3.2: Customer Lifetime Value (15 points) 
-- MAGIC Create a query showing each customer's total purchases, number of orders, and 
-- MAGIC average order value. Also include their region and primary channel. Only show 
-- MAGIC customers with more than 3 orders. Order by total purchases descending.**

-- COMMAND ----------



-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Question 3.3: Profit Margin Analysis (15 points) 
-- MAGIC Calculate the profit margin percentage for each product. Show ProductName, Category, 
-- MAGIC Total Sales, Total Profit, and Profit Margin %. Order by profit margin descending. 
-- MAGIC Formula: (Profit / Sales) * 100**

-- COMMAND ----------



-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Question 3.4: Year-over-Year Growth (15 points) 
-- MAGIC Compare sales between 2023 and 2024. Show the total sales for each year and 
-- MAGIC calculate the growth percentage. Use a CTE or subquery.**

-- COMMAND ----------



-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Question 3.5: Regional Performance Ranking (15 points) 
-- MAGIC Rank regions by total sales. Use the RANK() or ROW_NUMBER() window function. 
-- MAGIC Show Region, Total Sales, Total Orders, and Rank.**

-- COMMAND ----------

-- MAGIC %md
-- MAGIC

-- COMMAND ----------



-- COMMAND ----------

