/* South Region - South Carolina Analysis */

USE sample_sales; 

/* What is total revenue overall for sales in the assigned territory, plus the start date and end date
that tell you what period the data covers? */ 
-- My first thought was to write a query to find the store ID pertinent to my region. Once I have that 
-- ID I will find the start date and end date which will be needed in the query to find the revenue.

SELECT StoreID
FROM store_locations
WHERE State = 'South Carolina';
-- StoreID 852, 853 

SELECT MIN(Transaction_Date),
MAX(Transaction_Date)
FROM store_sales;
-- Start date: 2022-01-01 End date: 2025-12-31

SELECT SUM(Sale_Amount) AS TotalRevenue, 
MIN(Transaction_Date) AS StartDate, MAX(Transaction_Date) AS EndDate
FROM store_sales 
WHERE Store_ID IN (852,853);
-- The total revenue for South Carolina was $648,812.56

/* What is the month by month revenue breakdown for the sales territory? */
-- The "order by" difference would come down to: Do I want to focus on comparing the months to each other? 
-- Or do I want to focus on the performance overall for the year?
-- * October appears to be the strongest perfomring month by revenu across all three years. 

SELECT YEAR(Transaction_Date) AS Year, MONTH(Transaction_Date) AS Month, 
SUM(Sale_Amount) AS TotalRevenue
FROM store_sales
WHERE Store_ID IN (852,853) 
GROUP BY YEAR(Transaction_Date), MONTH(Transaction_Date) 
ORDER BY YEAR(Transaction_Date), MONTH(Transaction_Date);

/* Provide a comparison of total revenue for the specific sales territory and the region it belongs to. */ 
-- South carolina region vs South region 

SELECT SUM(Sale_Amount) AS TotalRevenue
FROM store_sales 
JOIN store_locations ON store_sales.Store_ID = store_locations.StoreID
JOIN management ON store_locations.state = management.state
WHERE Region= 'South';
-- Total Revenue: $7,996,850.12

SELECT SUM(Sale_amount) AS TotalRevenue
FROM store_sales
WHERE Store_ID IN (852,853);
-- Total Revenue: $648,812.56

/* What is the number of transactions per month and average transaction size by product category
for the sales territory? */ 

SELECT MONTH(Transaction_Date) AS Month, COUNT(id) AS Transactions, 
AVG(Sale_Amount) AS AvgTransaction
FROM store_sales
WHERE Store_ID IN (852,853)
GROUP BY MONTH(Transaction_Date)
ORDER BY Month ASC;

/* Can you provide a ranking of in-store sales performance by each store in the sales territory, or a
ranking of online sales performance by state within an online sales territory? */

SELECT ShiptoState AS State, COUNT(id) AS Transactions, SUM(SalesTotal) AS TotalSales
FROM online_sales
GROUP BY ShiptoState
ORDER BY TotalSales DESC;

-- What is your recommendation for where to focus sales attention in the next quarter?
 
SELECT products.Product AS BestSeller, COUNT(*) AS Transactions
FROM store_sales
JOIN products ON products.ProdNum = store_sales.Prod_Num
WHERE store_sales.Store_ID IN (852,853)
GROUP BY products.Product
ORDER BY Transactions DESC
LIMIT 5;
 -- Pendaflex hanging file folders and The omnivore's Dilemma is a top seller 
-- I realize the best selling product may not equate to the most revenue so I have to adjust my query. 

SELECT products.Product, SUM(store_sales.Sale_Amount) AS TotalRevenue
FROM store_sales
JOIN products ON store_sales.Prod_Num = products.ProdNum
WHERE store_sales.Store_ID IN (852,853) 
GROUP BY products.Product
ORDER BY TotalRevenue DESC;
 
 -- It would be useful to analyzye each quarter by year. The results would help us identify any trends and point us to where our focus should be for the following quarter. 
 
 SELECT YEAR(Transaction_Date) AS SalesYear,
 store_sales.Store_ID, products.Product, COUNT(*) AS QuantitySold, 
 SUM(store_sales.Sale_Amount) AS TotalRevenue
 FROM products
 JOIN store_sales ON store_sales.Prod_Num = products.ProdNum
 WHERE store_sales.Store_ID IN (852,853) 
 AND ( Transaction_Date BETWEEN '2023-05-01' AND '2023-08-31' 
 OR Transaction_Date BETWEEN '2024-05-01' AND '2024-08-31'
 OR Transaction_Date BETWEEN '2025-05-01' AND '2025-08-31' )
 GROUP BY YEAR(Transaction_Date), store_sales.Store_ID, products.Product
 ORDER BY QuantitySold DESC;
 
 -- I realized this approach is difficult to read as it does not display the top products for each year.  
 
 /* Updated Analysis:  Given that the HP Spectre generated the most revenue in 2023 and 2024, and the Macbook was a top-performing 
 item in 2025 during Q2(May-August), we should place greater focus on tech products. */
 
 SELECT YEAR(Transaction_Date) AS SalesYear, products.Product, COUNT(*) AS QuantitySold,
 SUM(store_sales.Sale_Amount) AS TotalRevenue
 FROM products
 JOIN store_sales ON store_sales.Prod_Num = products.ProdNum
 WHERE store_sales.Store_ID IN (852,853) 
 AND Transaction_Date BETWEEN '2023-05-01' AND '2023-08-31'
 GROUP BY YEAR(Transaction_Date), products.Product
 ORDER BY TotalRevenue DESC
 LIMIT 5;

 
 SELECT YEAR(Transaction_Date) AS SalesYear, products.Product, COUNT(*) AS QuantitySold,
 SUM(store_sales.Sale_Amount) AS TotalRevenue
 FROM products
 JOIN store_sales ON store_sales.Prod_Num = products.ProdNum
 WHERE store_sales.Store_ID IN (852,853) 
 AND Transaction_Date BETWEEN '2024-05-01' AND '2024-8-31'
 GROUP BY YEAR(Transaction_Date), products.Product
 ORDER BY TotalRevenue DESC
 LIMIT 5;
 

SELECT YEAR(Transaction_Date) AS SalesYear, products.Product, COUNT(*) AS QuantitySold,
 SUM(store_sales.Sale_Amount) AS TotalRevenue
 FROM products
 JOIN store_sales ON store_sales.Prod_Num = products.ProdNum
 WHERE store_sales.Store_ID IN (852,853) 
 AND Transaction_Date BETWEEN '2025-05-01' AND '2025-08-31'
 GROUP BY YEAR(Transaction_Date), products.Product
 ORDER BY TotalRevenue DESC
 LIMIT 5;

 