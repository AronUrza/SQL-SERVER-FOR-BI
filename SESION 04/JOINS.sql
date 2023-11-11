-----------------------------------------------------
--------------- INNER JOIN --------------------------

-- NECESITO LAS VENTAS EN MONTO POR CADA NOMBRE EMPLEADO 

SELECT *
FROM Employees

SELECT *
FROM Orders

-- RELACIONANDO DOS TABLAS 

SELECT A.FirstName,A.LastName, SUM(B.Freight) AS MONTO_VENTA
FROM Employees A 
INNER JOIN Orders B ON A.EmployeeID=B.EmployeeID
GROUP BY A.FirstName,A.LastName 
ORDER BY MONTO_VENTA DESC

--- RELACIONAR 3 A MAS TABLAS 


---- NECESITO SABER EL MONTO DE VENTA QUE HA HECHO CADA EMPLEADO A CADA CLIENTE 

SELECT * FROM Orders
SELECT * FROM Employees
SELECT * FROM Customers


SELECT A.LastName,A.FirstName, C.CompanyName, SUM(B.Freight) as venta
FROM Employees A 
INNER JOIN Orders B ON A.EmployeeID=B.EmployeeID
INNER JOIN Customers C ON B.CustomerID=C.CustomerID
GROUP BY A.LastName,A.FirstName, C.CompanyName
order by a.LastName,a.FirstName,venta desc


---------------------------------------------------
---LEFT JOIN 

--- NECESITO SABER CUANTO VENDIO CADA EMPLEADO Y NO SOLO LOS QUE VENDIEON SINO LOS QUE NO


SELECT A.FirstName,A.LastName , SUM(B.Freight) AS VENTA
FROM Employees A 
LEFT JOIN Orders B ON A.EmployeeID=B.EmployeeID
GROUP BY A.FirstName,A.LastName

----- NECESITO SABER A QUE CLIENTE SE LE VENDIO Y NO SE LE VENDIO 

SELECT CompanyName, SUM(Freight) AS COMPRA
FROM Customers A 
LEFT JOIN Orders B ON A.CustomerID=B.CustomerID
GROUP BY CompanyName 
ORDER BY COMPRA DESC

-- NECESITO LOS CLIENTES QUE NO SE LE HAN HECHO UNA VENTA 

SELECT * 
FROM Customers A 
LEFT JOIN Orders B ON A.CustomerID=B.CustomerID
WHERE B.CustomerID IS NULL

--- RIGHT JOIN 


SELECT * 
FROM Orders B
RIGHT JOIN Customers A   ON A.CustomerID=B.CustomerID



-----------------------------------------------------------

-- EL TOP 5 DE VENDEDORES 



SELECT  TOP 5   A.FirstName,A.LastName, SUM(B.Freight) AS MONTO_VENTA
FROM Employees A 
INNER JOIN Orders B ON A.EmployeeID=B.EmployeeID
GROUP BY A.FirstName,A.LastName 
ORDER BY MONTO_VENTA DESC

--------------------------------------------------

---- ROW_NUMBER()
-- GENERA UN CORELATIVO ORDERNADO BASADO EN ALGUN CAMPO DEL SELECT 

SELECT  A.FirstName,A.LastName, SUM(B.Freight) AS MONTO_VENTA , 
		ROW_NUMBER() OVER(ORDER BY SUM(B.Freight) DESC) AS NUM
FROM Employees A 
INNER JOIN Orders B ON A.EmployeeID=B.EmployeeID
GROUP BY A.FirstName,A.LastName 


--- ROW_NUMBER OVER (PARTITION )

		SELECT A.LastName,A.FirstName, C.CompanyName, SUM(B.Freight) as venta, 
			   ROW_NUMBER() OVER(PARTITION BY A.LastName,A.FirstName ORDER BY SUM(B.Freight) DESC ) AS NUM
		FROM Employees A 
		INNER JOIN Orders B ON A.EmployeeID=B.EmployeeID
		INNER JOIN Customers C ON B.CustomerID=C.CustomerID
		GROUP BY A.LastName,A.FirstName, C.CompanyName

------ NECESITO SABER LOS TOP 1 DE VENTAS DE CLIENTE POR CADA EMPLEADO 

WITH TABLA AS (	SELECT A.LastName,A.FirstName, C.CompanyName, SUM(B.Freight) as venta, 
			    ROW_NUMBER() OVER(PARTITION BY A.LastName,A.FirstName ORDER BY SUM(B.Freight) DESC ) AS NUM
				FROM Employees A 
				INNER JOIN Orders B ON A.EmployeeID=B.EmployeeID
				INNER JOIN Customers C ON B.CustomerID=C.CustomerID
				GROUP BY A.LastName,A.FirstName, C.CompanyName) 
SELECT *
FROM TABLA 
WHERE NUM IN ( 1,2,3,4,5)

