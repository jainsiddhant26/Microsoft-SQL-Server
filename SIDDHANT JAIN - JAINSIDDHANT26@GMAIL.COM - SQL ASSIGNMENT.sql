--Create Database EXL_assessment

--Use EXL_assessment

--Q1. Create a report that shows the CategoryName and Description from the categories table sorted by CategoryName.
select categoryname , description  from categories
order by categoryname

--Q2. Create a report that shows the ContactName, CompanyName, ContactTitle and Phone number from the customers table
     --sorted by Phone.
Select contactname,companyname , contacttitle , phone from customers
order by phone

--Q3. Create a report that shows the capitalized FirstName and capitalized LastName renamed as FirstName and Lastname
	--respectively and HireDate from the employees table sorted from the newest to the oldest employee.
Select CONCAT(UPPER(LEFT(FirstName,1)), RIGHT(FirstName,LEN(FirstName) - 1))'FirstName',
CONCAT(UPPER(LEFT(LastName,1)), RIGHT(LastName,LEN(LastName) - 1))'LastName'
	,hiredate from employees
	order by hiredate

--Q4.  Create a report that shows the top 10 OrderID, OrderDate, ShippedDate, CustomerID, Freight from the orders table sorted
	--by Freight in descending order.
   
select top 10  orderid, orderdate , shippeddate , customerid , freight from orders
order by freight desc

--Q5. Create a report that shows all the CustomerID in lowercase letter and renamed as ID from the customers table
select LOWER(customerid) 'ID' from customers

--Q6. Create a report that shows the CompanyName, Fax, Phone, Country, HomePage from the suppliers table sorted by the
	--Country in descending order then by CompanyName in ascending order.
select companyname,fax,phone,country,homepage from suppliers
order by country desc , companyname asc

--Q7. Create a report that shows CompanyName, ContactName of all customers from ‘Buenos Aires' only.
select companyname,contactname from customers
where city like('Buenos Aires')

--Q8. Create a report showing ProductName, UnitPrice, QuantityPerUnit of products that are out of stock.
select productname,unitprice,quantityperunit from products
where unitsinstock = 0

--Q9. Create a report showing all the ContactName, Address, City of all customers not from Germany, Mexico, Spain
select contactname,address,city  from customers
where country not IN('Germany','Mexico','Spain')

--Q10. Create a report showing OrderDate, ShippedDate, CustomerID, Freight of all orders placed on 21 May 1996.
select orderdate,shippeddate,customerid,freight from orders
where orderdate = '1996-05-21'

--Q11. Create a report showing FirstName, LastName, Country from the employees not from United States.
select firstname,lastname,country from employees
where country not in('USA')

--Q12. Create a report thatshowsthe EmployeeID, OrderID, CustomerID, RequiredDate, ShippedDate from all orders shipped later
	--than the required date.
select  employeeid,orderid,customerid,requireddate,shippeddate from orders
where requireddate < shippeddate

--Q13. Create a report that shows the City, CompanyName, ContactName of customers from cities starting with A or B
select * from customers
where city like('[AB]%')

--Q14. Create a report showing all the even numbers of OrderID from the orders table.

select orderid from orders
where orderid %2 = 0
 
--Q15. Create a report that shows all the orders where the freight cost more than $500.

select * from orders
where freight > 500

--Q16. Create a report that shows the ProductName, UnitsInStock, UnitsOnOrder, ReorderLevel of all products that are up for	
	--reorder.
select productname,unitsinstock,unitsonorder,reorderlevel from products
where unitsinstock <= reorderlevel  

--Q17. Create a report that shows the CompanyName, ContactName number of all customer that have no fax number.
select companyname,contactname, phone ,fax from customers
where fax is null  

--Q18. Create a report that shows the FirstName, LastName of all employees that do not report to anybody.
select firstname,lastname from employees 
where reportsto is null

--Q19. Create a report showing all the odd numbers of OrderID from the orders table.
select orderid from orders
where orderid%2!=0

--Q20. Create a report that shows the CompanyName, ContactName, Fax of all customersthat do not have Fax number and sorted
	--by ContactName.

select companyname,contactname,fax from customers
where fax is null
order by contactname

--Q21. Create a report that shows the City, CompanyName, ContactName of customers from cities that has letter L in the name
	--sorted by ContactName.
select city,companyname,contactname from customers
where city like('%L%') 
order by contactname

--Q22. Create a report that shows the FirstName, LastName, BirthDate of employees born in the 1950s.
select * from employees
where year(birthdate) like('195_') 

--Q23. Create a report that shows the FirstName, LastName, the year of Birthdate as birth year from the employees table.
select firstname,lastname,Year(birthdate) 'Birth Year' from employees

--Q24. Create a report showing OrderID, total number of Order ID as NumberofOrders from the orderdetails table grouped by
		--OrderID and sorted by NumberofOrders in descending order. HINT: you will need to use a Groupby statement.
select orderid,COUNT(orderid) 'Number of Orders' from orders_details
group by orderid
order by COUNT(orderid) desc

--Q25. Create a report that shows the SupplierID, ProductName, CompanyName from all product Supplied by Exotic Liquids,
	--Specialty Biscuits, Ltd., Escargots Nouveaux sorted by the supplier ID

select supplierid, contactname,companyname from suppliers
where companyname In('Exotic Liquids' , 'Specialty Biscuits, Ltd.','Escargots Nouveaux')

--Q26. Create a report that shows the ShipPostalCode, OrderID, OrderDate, RequiredDate, ShippedDate, ShipAddress of all orders
	--with ShipPostalCode beginning with "98124".

select shippostalcode,orderid,orderdate,requireddate,shippeddate,shipaddress from orders
where shippostalcode Like('98124%')

--Q27. Create a report that shows the ContactName, ContactTitle, CompanyName of customers that the has no "Sales" in their
	--ContactTitle.
select contactname,contacttitle,companyname from customers
where contacttitle not like('%Sales%')

--Q28. Create a report that shows the LastName, FirstName, City of employees in cities other "Seattle";
select lastname,firstname,city from employees
where city not in('Seattle')

--Q29. Create a report that shows the CompanyName, ContactTitle, City, Country of all customers in any city in Mexico or other
	--cities in Spain other than Madrid.
select companyname,contacttitle,city,country from customers
where country IN('Mexico','Spain') and city not in('Madrid')

--Q30. Create a select statement that outputs the following:
 select CONCAT(firstname,' ',lastname,' can be reached at x',extension) from employees

--Q31. Create a report that shows the ContactName of all customers that do not have letter A as the second alphabet in their
	--Contactname.
select contactname from customers
where contactname not like('_a%')

--Q32. Create a report that shows the average UnitPrice rounded to the next whole number, total price of UnitsInStock and
	--maximum number of orders from the products table. All saved as AveragePrice, TotalStock and MaxOrder respectively
select round(AVG(unitprice),2) 'AveragePrice' ,
       Sum(unitprice*unitsinstock) 'Total Price',
	   max(unitsonorder) 'Max Order'
       from products

--Q33. Create a report that shows the SupplierID, CompanyName, CategoryName, ProductName and UnitPrice from the products,
	--suppliers and categories table.
 
select t1.supplierid,t2.companyname,t3.categoryname,t1.productname,t1.unitprice
			from products t1 left join suppliers t2 
			on t1.supplierid = t2.supplierid left join categories t3
			on t1.categoryid = t3.categoryid

--Q34. Create a report thatshowsthe CustomerID,sum of Freight, from the orderstable with sum of freight greater $200, grouped
	--by CustomerID. HINT: you will need to use a Groupby and a Having statement.
select  customerid,SUM(freight) 'Sum of Freight' from orders
group by customerid
having SUM(freight) >200

--Q35. . Create a report that shows the OrderID ContactName, UnitPrice, Quantity, Discount from the order details, orders and
	--customers table with discount given on every purchase.
select t1.orderid,t3.contactname,t2.unitprice,t2.quantity,t2.discount from orders t1 left join orders_details t2 
			on t1.orderid = t2.orderid left join customers t3
			on t1.customerid = t3.customerid

--Q36. Create a report that showsthe EmployeeID, the LastName and FirstName as employee, and the LastName and FirstName of
	--who they report to as manager from the employees table sorted by Employee ID. HINT: This is a SelfJoin.


select T1.employeeid,CONCAT(T1.Lastname,' ',T1.firstname)'Employee' ,
		CONCAT(T2.Lastname,' ' ,T2.firstname)'Manager'
		from employees T1  inner join employees T2
		on t1.reportsto = t2.employeeid

--Q37. Create a report that shows the average, minimum and maximum UnitPrice of all products as AveragePrice, MinimumPrice
	--and MaximumPrice respectively
select round(AVG(unitprice),2) 'Average Price' ,
       min(unitprice) 'Minimum Price',
	   max(unitprice) 'Maximum Order'
       from products

--Q38.  Create a view named CustomerInfo that shows the CustomerID, CompanyName, ContactName, ContactTitle, Address, City,
	--Country, Phone, OrderDate, RequiredDate, ShippedDate from the customers and orderstable. HINT: Create a View.

create view [CustomerInfo] as
	(select	T1.customerid,T1.companyname,T1.contactname,T1.address,
			T1.city,T1.country,T1.phone,T2.orderdate,T2.requireddate,
			T2.shippeddate
		from customers  T1 left join orders T2 
		on T1.customerID = T2.customerid);

 Select * from CustomerInfo

 --Q39. Change the name of the view you created from customerinfo to customer details.

 EXEC sp_rename 'CustomerInfo' , 'Customer_Details'

 --Q40. Create a view named ProductDetails that shows the ProductID, CompanyName, ProductName, CategoryName, Description,
		--QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued from the supplier, products and
		--categories tables. HINT: Create a View
Create View [ProductDetails] as 
(select  t1.productid,t2.companyname,t1.productname,t3.categoryname,t3.description,
		t1.quantityperunit,t1.unitprice,t1.unitsinstock,t1.unitsonorder,t1.reorderlevel,t1.discontinued
			from products t1 left join suppliers t2 
			on t1.supplierid = t2.supplierid left join categories t3
			on t1.categoryid = t3.categoryid);

select * from ProductDetails

--Q41. Drop the customer details view.
Drop View Customer_Details;

--Q42. Create a report that fetch the first 5 character of categoryName from the category tables and renamed as ShortInfo

select LEFT(categoryname,5) 'ShortInfo' from categories

--Q43. Create a copy of the shipper table asshippers_duplicate. Then insert a copy ofshippers data into the new table 
select * into Shippers_duplicate from shippers

Select * from Shippers_duplicate

--Q44. Create a select statement that outputs the following from the shippers_duplicate Table:

Select shipperid ,companyname,phone , 
	Concat(Replace(companyname,' ' , ''),'@gmail.com')
	from Shippers_duplicate

--Q45. Create a report that shows the CompanyName and ProductName from all product in the Seafood category.

select  t2.companyname, t1.productname
			from products t1 left join suppliers t2 
			on t1.supplierid = t2.supplierid left join categories t3
			on t1.categoryid = t3.categoryid
			where t3.categoryname = 'Seafood'

--Q46. Create a report that shows the CategoryID, CompanyName and ProductName from all product in the categoryID 5.

select  t3.categoryid,t2.companyname, t1.productname
			from products t1 left join suppliers t2 
			on t1.supplierid = t2.supplierid left join categories t3
			on t1.categoryid = t3.categoryid
			where t3.categoryid = 5
 
 --Q47. Delete the shippers_duplicate table.

 Drop Table Shippers_duplicate

 --Q48. Create a select statement that ouputs the following from the employees table.
		--NB: The age might differ depending on the year you are attempting this query.
 Select lastname,firstname,title,
		Concat(DATEDIFF(YY,year(GETDATE() ),birthdate),' Years') 'Age' from employees

--Q49. Create a report that the CompanyName and total number of orders by customer renamed as number of orders since
		--Decemeber 31, 1994. Show number of Orders greater than 10.
Select T1.companyname, COUNT(orderid)'Number of Orders since December 31,1994' from customers T1 left join orders T2 
		on t1.customerid = t2.customerid
		group by companyname 
		order by COUNT(orderid) desc

--Q50. Create a select statement that ouputs the following from the product table
		--NB: It should return 77rows
Select CONCAT(productname,' weights/is ',quantityperunit,' and $',unitprice) from [products]