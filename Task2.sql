-- 1
SELECT firstname, lastname
FROM Employee
INNER JOIN Orders
	ON Employee.EmployeeID = Orders.EmployeeID
WHERE OrderDate BETWEEN '1996-08-15' AND '1997-08-15';

--2
SELECT DISTINCT emp.EmployeeID
FROM Employee emp
INNER JOIN Orders ord
	ON emp.EmployeeID = ord.EmployeeID
WHERE OrderDate < '1996-10-16';

--3
SELECT count(od.productid)
FROM OrderDetails od
INNER JOIN (
	Orders o INNER JOIN Employee emp
		ON emp.EmployeeID = o.EmployeeID
	)
	ON o.OrderID = od.OrderID
WHERE o.OrderDate BETWEEN '1997-01-13' AND '1997-04-16';

--4
SELECT sum(od.quantity)
FROM OrderDetails od
INNER JOIN (
	Orders o INNER JOIN Employee emp
		ON emp.EmployeeID = o.EmployeeID
	)
	ON o.OrderID = od.OrderID
WHERE emp.FirstName = 'Anne' AND emp.LastName = 'Dodsworth' AND o.OrderDate BETWEEN '1997-01-13' AND '1997-04-16';

--5 (176)
SELECT count(od.ProductID)
FROM OrderDetails od
INNER JOIN (
	Orders o INNER JOIN Employee emp
		ON emp.EmployeeID = o.EmployeeID
	)
	ON o.OrderID = od.OrderID
WHERE emp.FirstName = 'Robert' AND emp.LastName = 'King';

--6(91)
SELECT count(od.ProductID)
FROM OrderDetails od
INNER JOIN (
	Orders o INNER JOIN Employee emp
		ON emp.EmployeeID = o.EmployeeID
	)
	ON o.OrderID = od.OrderID
WHERE (emp.FirstName = 'Robert' AND emp.LastName = 'King') AND o.OrderDate BETWEEN '1996-08-15' AND '1997-08-15';

--7(97)
SELECT DISTINCT emp.EmployeeID, emp.FirstName + ' ' + emp.LastName AS FullName, emp.HomePhone
FROM (
	Orders o INNER JOIN Employee emp
		ON emp.EmployeeID = o.EmployeeID
	)
WHERE o.OrderDate BETWEEN '1997-01-13' AND '1997-04-16';

--8 (p-id=59)
SELECT TOP 1 p.ProductID, p.ProductName, count(od.OrderID)
FROM OrderDetails od
INNER JOIN Products p
	ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY count(od.OrderID) DESC;

--9
SELECT (OrderDetails.ProductID), count(ProductID)
FROM OrderDetails
WHERE OrderID IN (
		SELECT OrderID
		FROM Orders
		WHERE ShippedDate IS NOT NULL
		)
GROUP BY ProductID
ORDER BY count(ProductID);

--10
SELECT sum(od.unitprice * od.quantity)
FROM OrderDetails od
INNER JOIN (
	Orders o INNER JOIN Employee emp
		ON emp.EmployeeID = o.EmployeeID
	)
	ON od.OrderID = o.OrderID
WHERE emp.FirstName = 'laura' AND emp.LastName = 'Callahan' AND OrderDate = '1997-01-13';

--11
SELECT count(DISTINCT EmployeeID)
FROM Orders
INNER JOIN (
	OrderDetails INNER JOIN Products
		ON products.ProductID = OrderDetails.ProductID
	)
	ON Orders.OrderID = OrderDetails.OrderID
WHERE Products.ProductName IN ('Gorgonzola Telino', 'Gnocchi di nonna Alice', 'Raclette Courdavault', 'Camembert Pierrot') AND Orders.OrderDate BETWEEN '1997-01-01' AND '1997-01-31';

--12
SELECT emp.FirstName + ' ' + emp.LastName
FROM Employee emp
INNER JOIN (
	Orders o INNER JOIN (
		OrderDetails od INNER JOIN Products p
			ON od.ProductID = p.ProductID
		)
		ON o.OrderID = od.OrderID
	)
	ON emp.EmployeeID = o.EmployeeID
WHERE p.ProductName = 'Tofu' AND o.OrderDate BETWEEN '1997-01-13' AND '1997-01-30';

--13
SELECT DISTINCT e.EmployeeID, e.FirstName + ' ' + e.LastName AS FullName, DATEDIFF(DAY, e.BirthDate, GETDATE()) AS Age_in_days, DATEDIFF(MONTH, e.BirthDate, GETDATE()) AS Age_in_months, DATEDIFF(YEAR, e.BirthDate, GETDATE()) AS Age_in_years
FROM Employee e
LEFT JOIN Orders o
	ON e.EmployeeID = o.EmployeeID
WHERE Month(o.OrderDate) = 8;

--14
SELECT s.CompanyName, count(o.OrderID)
FROM Shippers s
INNER JOIN Orders o
	ON s.ShipperID = o.ShipperID
GROUP BY o.ShipperID, s.CompanyName;

--15
SELECT s.CompanyName, count(od.ProductID)
FROM Shippers s
INNER JOIN (
	Orders o INNER JOIN OrderDetails od
		ON o.OrderID = od.OrderID
	)
	ON s.ShipperID = o.ShipperID
WHERE o.ShippedDate IS NOT NULL
GROUP BY s.CompanyName;

--16
SELECT TOP 1 s.ShipperID, s.CompanyName, count(o.OrderID) number_of_orders
FROM Shippers s
INNER JOIN Orders o
	ON s.ShipperID = o.ShipperID
GROUP BY s.ShipperID, s.CompanyName
ORDER BY number_of_orders DESC;

--17
SELECT TOP 1 s.ShipperID, s.CompanyName, count(od.ProductID) number_of_orders
FROM Shippers s
INNER JOIN Orders o
INNER JOIN OrderDetails od
	ON o.OrderID = od.OrderID
		ON s.ShipperID = o.ShipperID WHERE o.ShippedDate BETWEEN '1996-08-10' AND '1998-09-20'
GROUP BY s.ShipperID, s.CompanyName
ORDER BY number_of_orders DESC;

--18
SELECT DISTINCT e.EmployeeID, e.FirstName + ' ' + e.LastName AS FullName
FROM Employee e
LEFT JOIN Orders o
	ON e.EmployeeID = o.EmployeeID AND o.OrderDate = '1997-04-04'
WHERE o.OrderID IS NULL;

--19
SELECT count(od.ProductID)
FROM OrderDetails od
INNER JOIN (
	Orders o INNER JOIN Employee e
		ON e.EmployeeID = o.EmployeeID
	)
	ON od.OrderID = o.OrderID
WHERE e.FirstName = 'Steven' AND LastName = 'Buchanan';

--20
SELECT count(OrderID)
FROM Orders o
INNER JOIN Employee e
	ON o.EmployeeID = e.EmployeeID
INNER JOIN Shippers s
	ON o.ShipperID = s.ShipperID
WHERE s.CompanyName = 'Federal Shipping' AND e.FirstName = 'michael' AND e.LastName = 'Suyama' AND o.ShippedDate IS NOT NULL;

--21
SELECT od.ProductID, count(OrderID) AS No_Of_Orders
FROM OrderDetails od
INNER JOIN Products p
INNER JOIN Suppliers sp
	ON p.SupplierID = sp.SupplierID
		ON od.ProductID = p.ProductID WHERE sp.Country IN ('UK', 'Germany')
GROUP BY od.ProductID;

--22
SELECT sum(od.UnitPrice * od.Quantity - od.UnitPrice * od.Discount) 'Total amount'
FROM OrderDetails od
INNER JOIN Orders o
	ON o.OrderID = od.OrderID
INNER JOIN Products p
	ON p.ProductID = od.ProductID
INNER JOIN suppliers sp
	ON sp.SupplierID = p.SupplierID
WHERE sp.CompanyName = 'Exotic Liquids' AND o.OrderDate BETWEEN '1997-01-01' AND '1997-01-31';

--23
SELECT o.OrderDate
FROM OrderDetails od
INNER JOIN Orders o
	ON o.OrderID = od.OrderID
INNER JOIN Products p
	ON p.ProductID = od.ProductID
INNER JOIN suppliers sp
	ON sp.SupplierID = p.SupplierID
WHERE sp.CompanyName = 'Tokyo Traders' AND o.OrderDate BETWEEN '1997-01-01' AND '1997-01-31'

EXCEPT

SELECT o.OrderDate
FROM OrderDetails od
INNER JOIN Orders o
	ON o.OrderID = od.OrderID
INNER JOIN Products p
	ON p.ProductID = od.ProductID
INNER JOIN suppliers sp
	ON sp.SupplierID = p.SupplierID
WHERE sp.CompanyName = 'Tokyo Traders' AND o.OrderDate BETWEEN '1997-01-01' AND '1997-01-31';

--24
SELECT e.EmployeeID
FROM Employee e
LEFT JOIN (
	SELECT EmployeeID
	FROM Orders o
	INNER JOIN (
		OrderDetails od INNER JOIN (
			Products p INNER JOIN Suppliers sp
				ON sp.SupplierID = p.SupplierID
			)
			ON p.ProductID = od.ProductID
		)
		ON od.OrderID = o.OrderID
	WHERE sp.CompanyName = 'Ma Maison' AND Month(o.OrderDate) = 5
	) g
	ON g.EmployeeID = e.EmployeeID
WHERE g.EmployeeID IS NULL;

--25
SELECT TOP 1 s.ShipperID, s.CompanyName, count(od.ProductID) AS 'No_Of_Products_Shipped'
FROM OrderDetails od
INNER JOIN Orders o
INNER JOIN Shippers s
	ON s.ShipperID = o.ShipperID
		ON o.OrderID = od.OrderID WHERE o.ShippedDate BETWEEN '1997-09-01' AND '1997-10-31'
GROUP BY s.ShipperID, s.CompanyName
ORDER BY No_Of_Products_Shipped;

--26
SELECT p.ProductID
FROM Products p
LEFT JOIN (
	SELECT DISTINCT od.ProductID
	FROM OrderDetails od
	INNER JOIN Orders o
		ON o.OrderID = od.OrderID
	WHERE o.ShippedDate BETWEEN '1997-08-01' AND '1997-08-31'
	) q
	ON p.ProductID = q.ProductID
WHERE q.ProductID IS NULL;

--27
SELECT employeeid, productid
FROM employee, products

EXCEPT

(
	SELECT o.EmployeeID, p.productId
	FROM products p
	LEFT JOIN (
		OrderDetails od INNER JOIN Orders o
			ON o.OrderID = od.OrderID
		)
		ON p.ProductID = od.ProductID
	)
ORDER BY EmployeeID, ProductID;

--28
SELECT TOP 1 s.ShipperID, s.CompanyName, count(o.shippeddate)
FROM Shippers s
INNER JOIN Orders o
	ON s.ShipperID = o.ShipperID
WHERE month(ShippedDate) IN (4, 5, 6) AND year(ShippedDate) IN (1996, 1997)
GROUP BY s.ShipperID, s.CompanyName
ORDER BY count(o.ShippedDate) DESC;

--29
SELECT TOP 1 sp.Country
FROM OrderDetails od
INNER JOIN Products p
	ON od.ProductID = p.ProductID
INNER JOIN Suppliers sp
	ON sp.SupplierID = p.SupplierID
INNER JOIN Orders o
	ON o.OrderID = od.OrderID
WHERE year(o.OrderDate) = 1997
GROUP BY sp.Country
ORDER BY count(od.ProductID) DESC;

--30
SELECT s.ShipperID, avg(datediff(DAY, o.OrderDate, o.ShippedDate))
FROM orders o
INNER JOIN Shippers s
	ON s.ShipperID = o.ShipperID
GROUP BY s.ShipperID;

--31
SELECT TOP 1 s.ShipperID, avg(datediff(DAY, o.OrderDate, o.ShippedDate)) AS avg_days
FROM orders o
INNER JOIN Shippers s
	ON s.ShipperID = o.ShipperID
GROUP BY s.ShipperID
ORDER BY avg_days;

--32
SELECT TOP 1
WITH ties o.OrderID, e.FirstName + ' ' + e.LastName AS FullName, count(od.ProductID) No_of_Products, (datediff(DAY, o.OrderDate, o.ShippedDate)) AS days_to_deliver, s.CompanyName
FROM orders o
INNER JOIN Shippers s
	ON s.ShipperID = o.ShipperID
INNER JOIN Employee e
	ON e.EmployeeID = o.EmployeeID
INNER JOIN OrderDetails od
	ON od.OrderID = o.OrderID
WHERE o.ShippedDate IS NOT NULL
GROUP BY s.CompanyName, o.OrderDate, o.ShippedDate, o.OrderID, e.FirstName, e.LastName
ORDER BY days_to_deliver;

--33
SELECT TOP 1 '1' result, o.OrderID, e.FirstName + ' ' + e.LastName AS FullName, count(od.ProductID) No_of_Products, datediff(DAY, o.OrderDate, o.ShippedDate) AS days_to_deliver, s.CompanyName
FROM orders o
INNER JOIN Shippers s
	ON s.ShipperID = o.ShipperID
INNER JOIN Employee e
	ON e.EmployeeID = o.EmployeeID
INNER JOIN OrderDetails od
	ON od.OrderID = o.OrderID
WHERE o.ShippedDate IS NOT NULL
GROUP BY s.CompanyName, o.OrderDate, o.ShippedDate, o.OrderID, e.FirstName, e.LastName
HAVING DATEDIFF(day, o.OrderDate, o.ShippedDate) = (
		SELECT min(datediff(day, o.OrderDate, o.ShippedDate))
		FROM orders o
		)

UNION

SELECT TOP 1 '2' result, o.OrderID, e.FirstName + ' ' + e.LastName AS FullName, count(od.ProductID) No_of_Products, (datediff(DAY, o.OrderDate, o.ShippedDate)) AS days_to_deliver, s.CompanyName
FROM orders o
INNER JOIN Shippers s
	ON s.ShipperID = o.ShipperID
INNER JOIN Employee e
	ON e.EmployeeID = o.EmployeeID
INNER JOIN OrderDetails od
	ON od.OrderID = o.OrderID
WHERE o.ShippedDate IS NOT NULL
GROUP BY s.CompanyName, o.OrderDate, o.ShippedDate, o.OrderID, e.FirstName, e.LastName
HAVING DATEDIFF(day, o.OrderDate, o.ShippedDate) = (
		SELECT max(datediff(day, o.OrderDate, o.ShippedDate))
		FROM orders o
		);- 34

SELECT '1' rownum, p.ProductID, p.ProductName, p.UnitPrice
FROM Products p
WHERE p.UnitPrice = (
		SELECT max(p.UnitPrice)
		FROM products p
		INNER JOIN OrderDetails od
			ON p.ProductID = od.ProductID
		INNER JOIN Orders o
			ON o.OrderID = od.OrderID
		WHERE (datepart(day, o.OrderDate) - 1) / 7 + 1 = 2 AND year(o.OrderDate) = 1997 AND MONTH(o.OrderDate) = 10
		)

UNION

SELECT '2' rownum, p.ProductID, p.ProductName, p.UnitPrice
FROM Products p
WHERE p.UnitPrice = (
		SELECT min(p.UnitPrice)
		FROM products p
		INNER JOIN OrderDetails od
			ON p.ProductID = od.ProductID
		INNER JOIN Orders o
			ON o.OrderID = od.OrderID
		WHERE (datepart(day, o.OrderDate) - 1) / 7 + 1 = 2 AND year(o.OrderDate) = 1997 AND MONTH(o.OrderDate) = 10
		);

--35
SELECT s.ShipperID, CASE 
		WHEN s.ShipperID = 2
			THEN 'Express Speedy'
		WHEN s.ShipperID = 3
			THEN 'United Package'
		WHEN s.ShipperID = 1
			THEN 'Shipping Federal'
		END AS Company_Name
FROM Shippers s
INNER JOIN Orders o
	ON o.ShipperID = s.ShipperID
WHERE o.EmployeeID IN (1, 3, 5, 7)
GROUP BY s.ShipperID;