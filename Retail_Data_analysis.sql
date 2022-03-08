--CREATE DATABASE CASE_STUDY1

--- DATA PREPARATION AND UNDERSTANDING ---

-- 1. What is the total number of rows in each of the 3 tables in the database?

SELECT COUNT(*)FROM Transactions
SELECT COUNT(*)FROM Customer
SELECT COUNT(*)FROM prod_cat_info

-- 2. What is the total number of transactions that have a return?

SELECT COUNT(total_amt)'Total number of returns'  FROM Transactions WHERE (total_amt<0)

-- 3. As you would have noticed the dates provided across the datasets are not in a correct format. As first steps, \pls convert the date variables into valid date formats before proceeding ahead

-- When I was inserting data in the data base, at that time i used Edit Mapping & changed the data type of Date.


-- 4. What is the time range of the transaction data available for analysis? Show the output in number of days, months and years simultaneously in different columns.

SELECT DATEDIFF(D,MIN(TRAN_DATE) , maX(TRAN_DATE)) ' Number of Days ' ,
          DATEDIFF(m, MIN(TRAN_DATE) , maX(TRAN_DATE))  ' Number of Months' , 
				DATEDIFF(YEAR, MIN(TRAN_DATE) , maX(TRAN_DATE)) ' Number of Years' FROM Transactions

-- 5. Which product category does the sub-category "DIY" belong to?

SELECT Prod_cat FROM prod_cat_info where prod_subcat = 'DIY'

--- DATA ANALYSIS ---

-- 1. Which channel is most frequently used for transactions?

SELECT TOP 1 Store_type FROM Transactions
	GROUP BY Store_type
		ORDER BY COUNT(transaction_id) DESC

-- 2. What is the count of Male and Female customers in the database?

SELECT GENDER, COUNT(customer_id) FROM Customer
	GROUP BY Gender
	HAVING Gender <> ' '

-- 3. From which city do we have the maximum number of customers and how many?

SELECT top 1 city_code, COUNT(customer_id) AS 'Number of Customer ' FROM Customer
GROUP BY city_code 
ORDER BY  'Number of Customer' DESC

-- 4. How many sub-categories are there under the Books category?

SELECT COUNT(prod_subcat) 'No of Sub Category' FROM prod_cat_info
WHERE prod_cat = 'Books'

--5. What is the maximum quantity of products ever ordered?

SELECT MAX(Qty) FROM Transactions

--6. What is the net total revenue generated in categories Electronics and Books?

SELECT SUM(Transactions.total_amt) AS 'TOTAL REVENUE', prod_cat_info.prod_cat
FROM Transactions 
JOIN prod_cat_info 
	ON Transactions.prod_cat_code = prod_cat_info.prod_cat_code
WHERE prod_cat IN ('ELECTRONICS','BOOKS')
	GROUP BY prod_cat
 
--7. How many customers have >10 transactions with us, excluding returns?

SELECT cust_id FROM Transactions
WHERE total_amt>0
GROUP BY cust_id
	HAVING COUNT(cust_id)>10
	ORDER BY COUNT(cust_id) DESC

--8. What is the combined revenue earned from the "Electronics" & "Clothing" categories, from "Flagship stores"?

USE CASE_STUDY1
SELECT SUM(total_amt) AS 'COMBINED REVENUE'
FROM Transactions	
JOIN prod_cat_info
	ON Transactions.prod_cat_code = prod_cat_info.prod_cat_code
	WHERE prod_cat IN('Clothing','Electronics') AND Store_type = 'Flagship store'

--9. What is the total revenue generated from "Male" customers in "Electronics" category? Output should display total revenue by prod sub-cat.


SELECT P.prod_subcat, SUM(T.total_amt) AS 'TOTAL REVENEU'
FROM prod_cat_info P
JOIN Transactions T
	ON T.prod_cat_code = P.prod_cat_code
JOIN Customer C
	ON C.customer_Id = T.cust_id
WHERE Gender = 'M' AND prod_cat = 'Electronics'
	GROUP BY prod_subcat

--10. What is percentage of sales and returns by product sub category, display only top 5 sub categories in terms of sales?

SELECT  TOP 5 P.prod_subcat, SUM(total_amt) / (SELECT SUM(total_amt) FROM Transactions) * 100 AS 'PERCENTAGE'
FROM Transactions T
INNER JOIN prod_cat_info P
	ON T.prod_subcat_code = P.prod_sub_cat_code
GROUP BY P.prod_subcat
	ORDER BY (SUM(total_amt) / (SELECT SUM(total_amt) FROM Transactions)) DESC
	

--11. For all customers aged between 25 to 35 years find what is the net total revenue generated by these consumers in last 30 days of transactions from max transaction date available in the data?

SELECT SUM(T.total_amt) AS 'TOTAL REVENUE' 
FROM ( 
	  SELECT T.*,MAX(T.tran_date) OVER() AS MAX_TRANS_DATE FROM Transactions T
	  )
 T
JOIN Customer C
	ON T.cust_id = C.customer_Id
WHERE 30 <= DATEDIFF(DAY,T.tran_date,T.MAX_TRANS_DATE) AND 
			DATEDIFF(YEAR,DOB,GETDATE()) >25 AND 
			DATEDIFF(YEAR,DOB,GETDATE()) <35

--12. Which product category has seen the max value of returns in the last 3 months of transactions?

	Select top 1 p.prod_cat  
           from ( SELECT t.*, MAX(t.tran_date) OVER () as max_tran_date FROM Transactions t) t 
		      join prod_cat_info p on t.prod_cat_code = p.prod_cat_code and t.prod_subcat_code = p.prod_sub_cat_code
	            where t.tran_date < t.max_tran_date 
	             and t.tran_date > Dateadd(M,-3,t.max_tran_date) 
	             and t.total_amt < 0 
	              group by p.prod_cat
				   Order by count(t.total_amt) desc

--13. Which store-type sells the maximum products, by value of sales amount and by quantity sold?

SELECT TOP 1 Store_type,COUNT(Qty)AS 'PRODUCT SOLD',SUM(total_amt) AS 'TOTAL SALES AMOUNT',
	(SUM(total_amt) / COUNT(Qty)) 'SALES PER PRODUCT' 
FROM Transactions 
GROUP BY Store_type
	ORDER BY 'SALES PER PRODUCT' DESC


--Q14  What are the categories for which average revenue is above the overall average 


SELECT P.prod_cat, AVG(T.total_amt) AS 'AVERAGE REVENUE'
FROM Transactions T 
JOIN prod_cat_info P
	ON T.prod_cat_code = P.prod_cat_code AND T.prod_subcat_code = P.prod_sub_cat_code 
GROUP BY prod_cat
	HAVING AVG(T.total_amt)> (SELECT AVG(total_amt) FROM Transactions)


--Q15 Find the average and total revenue by each subcategory for the categories which are among top 5 categories in terms of quantity sold

SELECT P.prod_subcat,AVG(T.total_amt)AS 'AVERAGE OF SALES BY SUB-CATEGORY', SUM(total_amt) AS 'TOTAL REVENUE'
FROM Transactions T
JOIN prod_cat_info P
	ON T.prod_cat_code = P.prod_cat_code AND T.prod_subcat_code = P.prod_sub_cat_code
WHERE P.prod_cat_code = ANY( SELECT TOP 5 P.prod_cat_code
							 FROM Transactions T
							 JOIN prod_cat_info P
							 ON T.prod_cat_code = T.prod_cat_code
							 GROUP BY P.prod_cat_code
							 ORDER BY COUNT(T.Qty) DESC
							 ) 
GROUP BY P.prod_subcat