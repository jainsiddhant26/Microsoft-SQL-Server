-- CREATE DATABASE SQL_Assessment

USE SQL_Assessment

-- List of Questions:

-- 1. List all customers

SELECT * FROM Customer;

-- 2. List the first name, last name, and city of all customers

SELECT FirstName, LastName, City FROM Customer;

-- 3. List the customers in Sweden. Remember it is "Sweden" and NOT "sweden" because filtering value is case sensitive in Redshift.

SELECT * FROM Customer WHERE Country = 'Sweden';

-- 4. Create a copy of Supplier table. Update the city to Sydney for supplierstarting with letter P.

SELECT Id,CompanyName,ContactName,Country,Phone,Fax,
	CASE
		WHEN City LIKE 'P%' THEN 'Sydney' 
		ELSE City  
	END [City] INTO copy_of_supplier
FROM Supplier

-- 5. Create a copy of Products table and Delete all products with unit price higher than $50.

SELECT * INTO copy_of_Products FROM Product WHERE UnitPrice <= 50;

-- 6. List the number of customers in each country

SELECT Country, COUNT(Id) 'No. of Customers' FROM Customer 
GROUP BY Country;

-- 7. List the number of customers in each country sorted high to low

SELECT Country, COUNT(Id) 'No. of Customers' FROM Customer 
GROUP BY Country
ORDER BY 'No. of Customers' DESC


-- 8. List the total amount for items ordered by each customer

SELECT CustomerId, SUM(TotalAmount) 'Total Amount' FROM Orders
GROUP BY CustomerId;

-- 9. List the number of customers in each country. Only include countries with more than 10 customers.

SELECT Country, COUNT(Id)  'No. of Customers' FROM Customer
GROUP BY Country
	HAVING COUNT(Id) > 10;

-- 10. List the number of customers in each country, except the USA, sorted high to low. Only include countries with 9 or more customers.

SELECT Country, COUNT(Id) 'No Of Customers' FROM customer
WHERE Country != 'USA'
GROUP BY Country
	HAVING COUNT(Id) >= 9
ORDER BY [No Of Customers] DESC

-- 11. List all customers whose first name or last name contains "ill".

SELECT * FROM Customer
WHERE FirstName LIKE '%ill%' OR LastName LIKE '%ill%'

-- 12. List all customers whose average of their total order amount is between $1000 and $1200. Limit your output to 5 results.

SELECT TOP 5 CustomerId, AVG(TotalAmount) 'Average Spend' FROM Orders 
GROUP by CustomerId
	HAVING AVG(TotalAmount) BETWEEN 1000 and 1200

-- 13. List all suppliers in the 'USA', 'Japan', and 'Germany', ordered by country from A-Z, and then by company name in reverse order.

SELECT * FROM Supplier
WHERE Country IN ('USA','Japan','Germany')
ORDER BY Country ASC, CompanyName DESC;

-- 14. Show all orders, sorted by total amount (the largest amount first), within each year.

SELECT *, YEAR(OrderDate) 'Year' 
FROM Orders
ORDER BY 'Year', TotalAmount DESC;

-- 15. Products with Unit Price greater than 50 are not selling despite promotions. You are asked to discontinue products over $25. Write a query to reflect this. Do this in the copy of the Product table. DO NOT perform the update operation in the Product table.

DELETE FROM copy_of_Products
WHERE UnitPrice > 25

-- 16. List top 10 most expensive products

SELECT TOP 10 * 
FROM Product
ORDER BY UnitPrice DESC

-- 17. Get all but the 10 most expensive products sorted by price

SELECT * FROM Product
ORDER BY UnitPrice DESC
OFFSET 10 ROWS;

-- 18. Get the 10th to 15th most expensive products sorted by price

SELECT * FROM Product
ORDER BY UnitPrice DESC
OFFSET 9 ROWS
FETCH NEXT 6 ROWS only

-- 19. Write a query to get the number of supplier countries. Do not count duplicate values.

SELECT COUNT(DISTINCT Country) 'number of supplier countries ' FROM Supplier;

-- 20. Find the total sales cost in each month of the year 2013.

SELECT MONTH(OrderDate) 'Month' , SUM(TotalAmount) 'Total Sales' FROM Orders
WHERE YEAR(OrderDate) = 2013
GROUP BY MONTH(OrderDate)

-- 21. List all products that start with 'Cha' or 'Chan' and have one more character.

SELECT * FROM product
WHERE ProductName LIKE 'Cha_' OR ProductName LIKE 'Chan_'

-- 22. Your manager notices there are some suppliers without fax numbers. He seeks your help to get a list of suppliers with remark as "No fax number" for suppliers who do not have fax numbers (fax numbers might be null or blank).Also, Fax number should be displayed for customer with fax number).

SELECT Id,CompanyName,ContactName,City,Country,Phone,
	CASE
		WHEN LEN(Fax) ='' OR Fax IS NULL THEN 'No Fax Number'
		ELSE Fax
	END [Fax]
FROM Supplier;

-- 23. List all orders, their orderDates with product names, quantities, and prices.

SELECT * 
FROM Orders a 
LEFT JOIN OrderItem b 
ON a.id = b.orderid 
LEFT JOIN Product c 
ON b.ProductId = c.Id;

-- 24. List all customers who have not placed any Orders.

SELECT * FROM Customer
WHERE Customer.Id NOT IN ( SELECT CustomerId FROM Orders );

-- 25. List suppliersthat have no customers in their country, and customers that have no suppliers in their country, and customers and suppliers that are from the same country

SELECT c.FirstName , c.LastName , c.Country 'CustomerCountry' , s.Country 'SupplierCountry' , s.ContactName 
    FROM Customer c 
	FULL OUTER JOIN Supplier s 
         ON c.Country = s.Country;

-- 26. List suppliers that have no customers in their country, and customers that have no suppliers in their country, and customers and suppliers that are from the same country.

select c.FirstName , c.LastName , c.Country 'CustomerCountry' , s.Country'SupplierCountry' , s.ContactName 
    from Customer c full outer join Supplier s 
         on c.Country = s.Country

--27. Match customers that are from the same city and country. That is you are asked to give a list 
--of customers that are from same country and city. Display firstname, lastname, city and 
--coutntry of such customers. 
--Hint See sample output for your reference.AnalytixLabs, Website: www.analytixlabs.co.in Email: info@analytixlabs.co.in phone: +91-88021-73069
select  T1.FirstName 'FirstName1',T1.LastName'LastName1',T2.FirstName'FirstName2',T2.LastName'LastName2', T1.City,T1.Country from Customer T1 inner join Customer T2
	on T1.City = T2.City and T1.Country = T2.Country
 	Order by Country,City

--28. List all Suppliers and Customers. Give a Label in a separate column as 'Suppliers' if he is a 
--supplier and 'Customer' if he is a customer accordingly. Also, do not display firstname and 
--lastname as twoi fields; Display Full name of customer or supplier. 
--Hint: See sample output for your reference.
 
Select 'Customer'[Type],CONCAT(FirstName,' ' ,LastName) 'ContactName' ,City ,Country,Phone
from  Customer 
Union  
Select 'Supplier'[Type],ContactName,City,Country,Phone from Supplier

--29. Create a copy of orders table. In this copy table, now add a column city of type varchar (40). 
--Update this city column using the city info in customers table.
SELECT o.*,c.City into copy_of_orders
from Orders o LEFT JOIN Customer c on o.CustomerId = c.Id

ALTER TABLE copy_of_orders
ALTER COLUMN City VARCHAR(40)

--30. Suppose you would like to see the last OrderID and the OrderDate for this last order that 
--was shipped to 'Paris'. Along with that information, say you would also like to see the 
--OrderDate for the last order shipped regardless of the Shipping City. In addition to this, you 
--would also like to calculate the difference in days between these two OrderDates that you get. Write a single query which performs this.
--(Hint: make use of max (columnname) function to get the last order date and the output is a single row output.)

SELECT * , DATEDIFF(DAY,t1.[Overall Paris Order],t1.[Overall Last Order]) [Difference]
FROM (SELECT (SELECT MAX(OrderDate) from copy_of_orders) [Overall Last Order],(SELECT MAX(OrderDate) from copy_of_orders WHERE City = 'Paris') [Overall Paris Order] ) t1


-- 31. Find those customer countries who do not have suppliers. This might help you provide 
-- better delivery time to customers by adding suppliers to these countires. Use SubQueries.

SELECT distinct Country FROM Customer
where Country not in (SELECT distinct Country FROM Supplier)


-- 32. Suppose a company would like to do some targeted marketing where it would contact 
-- customers in the country with the fewest number of orders. It is hoped that this targeted 
-- marketing will increase the overall sales in the targeted country. You are asked to write a query 
-- to get all details of such customers from top 5 countries with fewest numbers of orders. Use 
-- Subqueries.
SELECT * from Customer
where Country in (select top 5 Country from orders o LEFT JOIN Customer c on o.CustomerId= c.Id GROUP by Country Order by count(o.Id)) 

-- 33. Let's say you want report of all distinct "OrderIDs" where the customer did not purchase 
-- more than 10% of the average quantity sold for a given product. This way you could review 
-- these orders, and possibly contact the customers, to help determine if there was a reason for 
-- the low quantity order. Write a query to report such orderIDs.

SELECT Distinct o.OrderId
from OrderItem o LEFT JOIN (select ProductId, AVG( CAST(Quantity as float) )[Average Qty for Prod] from OrderItem GROUP BY ProductId) q1 on o.ProductId = q1.ProductId
WHERE o.Quantity  < q1.[Average Qty for Prod] * 1.1

-- 34. Find Customers whose total orderitem amount is greater than 7500$ for the year 2013. The 
-- total order item amount for 1 order for a customer is calculated using the formula UnitPrice * 
-- Quantity * (1 - Discount). DO NOT consider the total amount column from 'Order' table to 
-- calculate the total orderItem for a customer.

SELECT CustomerId, SUM(UnitPrice * Quantity * (1- Discount))[Calc Total Order Amount ]
from Orders a inner JOIN OrderItem b on a.Id = b.OrderId
where YEAR(OrderDate) = 2013 
GROUP BY CustomerId
HAVING SUM(UnitPrice * Quantity * (1- Discount)) > 7500

-- 35. Display the top two customers, based on the total dollar amount associated with their 
-- orders, per country. The dollar amount is calculated as OI.unitprice * OI.Quantity * (1 -
-- OI.Discount). You might want to perform a query like this so you can reward these customers, 
-- since they buy the most per country. 
-- Please note: if you receive the error message for this question "This type of correlated subquery 
-- pattern is not supported yet", that is totally fine.
-- Sample output is as below for your response
select *
from	(select Country,CustomerId,SUM(TotalAmount) [Dollar Amount], RANK() OVER(PARTITION by Country ORDER by Country, SUM(TotalAmount) DESC ) [Country rank]
		from Orders o inner join Customer c on  o.customerid = c.id
		group by Country,CustomerId) t1
WHERE [Country Rank] <=2
ORDER by Country

-- 36. Create a View of Products whose unit price is above average Price.

CREATE VIEW [test1]
as  (select * from Product where UnitPrice > (select AVG(UnitPrice) from Product))

-- 37. Write a store procedure that performs the following action:
-- Check if Product_copy table (this is a copy of Product table) is present. If table exists, the 
-- procedure should drop this table first and recreated.
-- Add a column Supplier_name in this copy table. Update this column with that of 
-- 'CompanyName' column from Supplier ta
CREATE PROCEDURE q37 as 
	if 'copy_of_products' IN (select TABLE_NAME from  INFORMATION_SCHEMA.TABLES)
	begin 
		drop TABLE copy_of_products
		select p.*,s.Country into copy_of_Products 
		from Product p LEFT JOIN Supplier s on p.SupplierId = s.Id 
	END

EXEC q37
