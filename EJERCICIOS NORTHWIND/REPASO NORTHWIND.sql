
-- REPASO EJERCICIOS DE NORTHWIND
---------------------------------------------------------
--               Ejercicios Propuestos                 --
---------------------------------------------------------

-- 1. Obtener todas las columnas de la tabla Region

SELECT * FROM Region

-- 2. Obtener los FirstName y LastName de la tabla Employees.

SELECT FirstName,LastName FROM Employees

-- 3. Obtener las columnas FirstName y LastName de la tabla Employees. Ordenados por la
-- columna LastName.

SELECT FirstName,LastName FROM Employees
ORDER BY LastName

-- 4. Obtener las filas de la tabla orders ordenadas por la columna Freight de mayor a
-- menor; las columnas que presentara son: OrderID, OrderDate, ShippedDate,
-- CustomerID, and Freight.

SELECT OrderID, OrderDate, ShippedDate, CustomerID, Freight FROM Orders
ORDER BY Freight DESC

-- 5. Obtener los empleados tengan el valor null en la columna region.

SELECT FirstName, LastName FROM Employees
WHERE Region IS NULL

-- 6. Obtener los empleados ordenados alfabéticamente por FirstName y LastName

SELECT FirstName,LastName FROM Employees
ORDER BY FirstName, LastName

-- 7. Obtener los empleados cuando la columna title tenga el valor de Sales Representatives
-- y el campo city tenga los valores de Seattle o Redmond.

SELECT EmployeeID, FirstName, LastName, Title , City FROM Employees
WHERE Title = 'Sales Representative' AND (City = 'Seattle' OR City = 'Redmond')

-- OTRA MANERA 

SELECT EmployeeID, FirstName, LastName, Title , City FROM Employees
WHERE Title = 'Sales Representative' AND City IN ('Seattle','Redmond')

-- 8. Obtener las columnas company name, contact title, city y country de los clientes que
-- están en la Ciudad de México o alguna ciudad de España excepto Madrid.

SELECT CompanyName, ContactTitle, City, Country FROM Customers
WHERE Country IN ('Mexico','Spain') AND (City = 'México D.F.' OR City != 'Madrid')

-- OTRA MANERA

SELECT CompanyName, ContactTitle, City, Country
FROM Customers
WHERE (City = 'México D.F.' OR (Country = 'Spain' AND City <> 'Madrid'))

-- 9. Obtener la lista de órdenes, y mostrar una columna en donde se calcule el impuesto
-- del 10% cuando el valor de la columna Freight >= 480.

SELECT OrderID, CustomerID, Freight,  Freight*0.1  FROM  Orders
WHERE Freight >=480

-- 10. Obtener el numero de empleados para cada ciudad.

SELECT City, COUNT(City) NUMERO_EMPLEADOS FROM Employees
GROUP BY City

-- 11. Obtener los clientes que colocaron una orden en Set/1997

SELECT DISTINCT c.CustomerID, c.CompanyName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate >= '1997-09-01' AND o.OrderDate < '1997-10-01';

-- 12. Obtener un reporte en donde se muestre la cantidad de ordenes por cada vendedor

SELECT  e.FirstName, e.LastName, COUNT(o.EmployeeID) CANTIDAD_DE_VENTAS FROM  Employees e
JOIN ORDERS o ON e.EmployeeID= o.EmployeeID
GROUP BY O.EmployeeID,e.FirstName, e.LastName

-- 13. Obtener un reporte por Vendedor que muestre el número de órdenes y el importe
-- vendido para cada año de operaciones

SELECT E.EmployeeID, E.FirstName, E.LastName, YEAR(O.OrderDate) ANIO ,COUNT(O.OrderID) NUMERO_DE_ORDENES ,SUM(OD.UnitPrice*OD.Quantity) IMPORTE_VENDIDO
FROM Employees E
JOIN Orders O ON E.EmployeeID = O.EmployeeID
JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY E.EmployeeID, E.FirstName, E.LastName,YEAR(O.OrderDate)
ORDER BY E.EmployeeID, ANIO 

-- 14. Del reporte obtenido en la respuesta 13; muestre los 5 primeros vendedores para cada
-- año.


WITH RankedVendors AS (

	SELECT E.EmployeeID,
	E.FirstName,
	E.LastName,
	YEAR(O.OrderDate) ANIO,
	COUNT(O.OrderID) NUMERO_DE_ORDENES,
	SUM(OD.UnitPrice*OD.Quantity) IMPORTE_VENDIDO,
	ROW_NUMBER() OVER (PARTITION BY YEAR(o.OrderDate) ORDER BY SUM(od.UnitPrice * od.Quantity) DESC) AS RowNum
	FROM Employees E
	JOIN Orders O ON E.EmployeeID = O.EmployeeID
	JOIN [Order Details] OD ON O.OrderID = OD.OrderID
	GROUP BY E.EmployeeID, E.FirstName, E.LastName,YEAR(O.OrderDate)
	)
SELECT
    EmployeeID,
    FirstName,
    LastName,
    ANIO,
    NUMERO_DE_ORDENES,
    IMPORTE_VENDIDO
FROM
    RankedVendors
WHERE
    RowNum <= 5
ORDER BY
    ANIO, RowNum;

-- 15. Muestre el total de ventas agrupando por categoría de productos.

 SELECT CT.CategoryName,SUM(OD.Quantity*OD.UnitPrice) TOTAL_VENTAS_CATEGORIA FROM Orders O
 JOIN [Order Details] OD ON O.OrderID=OD.OrderID
 JOIN Products P ON OD.ProductID= P.ProductID
 JOIN Categories CT ON P.CategoryID = CT.CategoryID
 GROUP BY CT.CategoryName 
 ORDER BY TOTAL_VENTAS_CATEGORIA DESC



/* 
Ejercicios Propuestos
1. Obtener todas las columnas de la tabla Region
2. Obtener los FirstName y LastName de la tabla Employees.
3. Obtener las columnas FirstName y LastName de la tabla Employees. Ordenados por la
columna LastName.
4. Obtener las filas de la tabla orders ordenadas por la columna Freight de mayor a
menor; las columnas que presentara son: OrderID, OrderDate, ShippedDate,
CustomerID, and Freight.
5. Obtener los empleados tengan el valor null en la columna region.
6. Obtener los empleados ordenados alfabéticamente por FirstName y LastName
7. Obtener los empleados cuando la columna title tenga el valor de Sales Representatives
y el campo city tenga los valores de Seattle o Redmond.
8. Obtener las columnas company name, contact title, city y country de los clientes que
están en la Ciudad de México o alguna ciudad de España excepto Madrid.
9. Obtener la lista de órdenes, y mostrar una columna en donde se calcule el impuesto
del 10% cuando el valor de la columna Freight >= 480.
10. Obtener el numero de empleados para cada ciudad.
11. Obtener los clientes que colocaron una orden en Set/1997
12. Obtener un reporte en donde se muestre la cantidad de ordenes por cada vendedor
13. Obtener un reporte por Vendedor que muestre el número de órdenes y el importe
vendido para cada año de operaciones
14. Del reporte obtenido en la respuesta 13; muestre los 5 primeros vendedores para cada
año.
15. Muestre el total de ventas agrupando por categoría de productos.
16. Del reporte obtenido en la respuesta 14; muestre la evolución de las ventas por
categoría de productos agrupados para cada año de las operaciones.
17. Muestre el reporte de ventas por Region.
18. Del reporte obtenido en la respuesta 17, muestre la evolución de ventas por región
agrupadas para cada año de las operaciones.
19. Muestre un reporte de ventas agrupadas por País de embarque
20. Del reporte anterior, muestre las ventas agrupadas por año de operaciones.  
*/