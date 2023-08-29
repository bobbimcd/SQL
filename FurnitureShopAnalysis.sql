Use Furnshop;

-- Customers who have not placed any orders. Your solution should use a SubQuery.

SELECT 	Customer.CustomerID
FROM 	Customer
WHERE 	Customer.CustomerID
		NOT IN (SELECT CustomerID from Orders);




-- List of the product line names and for each product line the total number of products and average product price.

SELECT 	ProductLineName,
		COUNT(ProductID),
		AVG(ProductStandardPrice)
FROM 	Productline 
   INNER JOIN  Product
   ON Product.ProductLineID = Productline.ProductLineID
GROUP BY Productline.ProductLineID, ProductLineName;



-- Amend Question 2 to now include only those product lines where the average product price is higher than 500.

SELECT 	ProductLineName,
		COUNT(ProductID),
		AVG(ProductStandardPrice)
FROM 	Productline 
   INNER JOIN  Product
   ON Product.ProductLineID = Productline.ProductLineID
GROUP BY Productline.ProductLineID, ProductLineName
HAVING 	AVG(ProductStandardPrice)>500;


-- List the names of employees and number of employees they supervise (label this value Supervision Number).
-- Only display results for those employees who supervise more than one employee.

SELECT	S.EmployeeName,
		COUNT(E.EmployeeID) AS 'Supervision Number'
FROM 	Employee AS S
INNER JOIN 	Employee AS E
ON 	S.EmployeeID = E.EmployeeSupervisor
GROUP BY	S.EmployeeName
HAVING	COUNT(E.EmployeeID) > 1;



-- The names of employees, employee date of births, their managers name, managers date of birth
-- but only for those employees born before their manager (older than their manager).  Label all columns as seen in output below.

SELECT 	E1.EmployeeName AS 'Employee Name',
		E1.EmployeeBirthdate AS 'Employee DOB',
		E2.EmployeeName AS 'Manager Name',
		E2.EmployeeBirthdate AS 'Manager DOB'
FROM 	Employee AS E1
	INNER JOIN 	Employee AS E2
	ON 	E1.EmployeeID = E2.EmployeeSupervisor
WHERE E1.EmployeeBirthdate < E2.EmployeeBirthdate;


-- the number of products produced in each work centre (label this result as Total Products). 
-- If a work centre does not produce any products, the result will display with a total of 0.

SELECT 	WorkCenter.WorkCenterID, WorkCenterLocation,
		COUNT(ProductID) AS 	'Total Products'
FROM 	WorkCenter LEFT OUTER JOIN ProducedIn
ON WorkCenter.WorkCenterID=ProducedIn.WorkCenterID
GROUP BY	WorkCenter.WorkCenterID, WorkCenterLocation;


-- All customer names along with a tally of the number of vendors from the same state
-- as that customer (label this computed result Number of Vendors)

SELECT	CustomerName, COUNT(VendorID) AS 'Number of Vendors'
FROM		Customer C LEFT OUTER JOIN Vendor V
		ON C.CustomerState = V.VendorState
GROUP BY	CustomerName;


-- All the products and the number of times each product has been ordered.


SELECT 	Product.ProductID,
		ProductDescription,
		COUNT(*) as 'No Times Ordered'
FROM 	Product 
INNER JOIN OrderLine 
ON 	Product.ProductID = OrderLine.ProductID
GROUP BY	Product.ProductID, ProductDescription
UNION
SELECT 	ProductID,
		ProductDescription, 0
FROM 	Product
WHERE 	NOT EXISTS
		(SELECT *
		FROM 	OrderLine
		WHERE OrderLine.ProductID = Product.ProductID);



-- The names of all customers who have ordered (on same or different orders) both products 
-- 3 and 4 using a set operator


SELECT C.CustomerID, CustomerName
FROM Customer AS C
INNER JOIN Orders AS O1 ON C.CustomerID = O1.CustomerID
INNER JOIN OrderLine OL1 ON O1.OrderID = OL1.OrderID
WHERE OL1.ProductID = 3
AND C.CustomerID IN (
    SELECT C2.CustomerID
    FROM Customer AS C2
    INNER JOIN Orders AS O2 ON C2.CustomerID = O2.CustomerID
    INNER JOIN OrderLine OL2 ON O2.OrderID = OL2.OrderID
    WHERE OL2.ProductID = 4
);



-- List  of the order number, product ID and ordered quantity for all customer orders 
--  for which the ordered quantity is greater than the average ordered quantity of that product.
-- using a correlated subquery

SELECT
OrderID AS 'Order ID',
OrderedQuantity AS 'Qty Ordered',
ProductID  AS 'Product ID'
FROM OrderLine o
WHERE OrderedQuantity > (SELECT AVG(OrderedQuantity) FROM OrderLine ol WHERE ol.ProductID = o.ProductID)




