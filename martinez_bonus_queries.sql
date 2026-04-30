-- BONUS QUESTIONS --
-- Territory: South Region - South Carolina 

/* 1. Create a list of all transactions that took place on January 15, 2024, sorted by sale amount from
highest to lowest */ 

SELECT *
FROM store_sales
WHERE Store_ID IN (852,853) 
AND Transaction_Date = '2024-01-15'
ORDER BY Sale_Amount DESC;

/* 2. Which transactions had a sale amount greater than $500? Display the transaction date, store ID,
product number, and sale amount */ 

SELECT Store_ID, Prod_Num, Sale_Amount, Transaction_Date
FROM store_sales
WHERE Store_ID IN (852,853) 
AND Sale_Amount > 500
ORDER BY Sale_Amount DESC; 

/* 3. Find all products whose product number begins with the prefix 105250. What category do they
belong to? 
The products belong to the Technology & Accessories category */

SELECT ProdNum, Category
from products
JOIN inventory_categories 
ON products.Categoryid = inventory_categories.Categoryid;
WHERE products.ProdNum LIKE ' 105250%' ;

/* 4. What is the total sales revenue across all transactions? What is the average transaction amount?
The total sales revenue was 45370048.85 and the average transaction amount was $135.38  */

SELECT SUM(Sale_Amount) AS SalesRevenue, 
AVG(Sale_Amount) AS AvgTransaction
FROM store_sales;

/* 5. How many transactions were recorded for each product category? Which category has the most
transactions? */
/* Stationary and supplies had the highest number of transactions at 69,176 transactions, 68,344 for Technology & Accessories, 
63,346 for Apparel and Merchandise, 53,143 for Art Supplies, 45,924 for Textbooks, 35,196 for book. */ 

SELECT Category, COUNT(*) AS TotalTransactions
FROM store_sales
JOIN products
ON store_sales.Prod_Num = products.ProdNum
JOIN inventory_categories
ON products.Categoryid = inventory_categories.Categoryid
GROUP BY Category 
ORDER BY TotalTransactions DESC;




