--- Armar un Query 
--- La informacion de los vendedores por region , cuanto se vendio por cada region 


select *
from Orders


select * from Employees 
select * from EmployeeTerritories
select * from Territories
select * from Region



SELECT DISTINCT A.EmployeeID , D.RegionDescription
FROM Employees A 
LEFT JOIN EmployeeTerritories B ON A.EmployeeID=B.EmployeeID
LEFT JOIN Territories C ON B.TerritoryID=C.TerritoryID
LEFT JOIN REGION D ON C.RegionID=D.RegionID


SELECT  A.EmployeeID , D.RegionDescription INTO T_EMP_REGION 
FROM Employees A 
LEFT JOIN EmployeeTerritories B ON A.EmployeeID=B.EmployeeID
LEFT JOIN Territories C ON B.TerritoryID=C.TerritoryID
LEFT JOIN REGION D ON C.RegionID=D.RegionID
GROUP BY A.EmployeeID , D.RegionDescription


----- LA VENTA POR REGION 

SELECT A.RegionDescription , YEAR(OrderDate) AS ANIO , SUM(B.FREIGHT) AS VENTA
FROM T_EMP_REGION A 
LEFT JOIN Orders B ON A.EmployeeID=B.EmployeeID
GROUP BY A.RegionDescription , YEAR(OrderDate)


--- PIVOT 

--SELECT 
-- FROM ( QUERY 
--			) PV 
-- PIVOT ( SUM (CAMPO1)  -- FUNCION DE AGREGACION 
--		 FOR CAMPO2 IN ([1998],[1997])	   --CAMPO Y VALORES QUE SERAN AHORA COLUMNAS 
--		) AS RP 

-----------------------------

SELECT RP.RegionDescription AS REGION , 
	   RP.[1996] , RP.[1997],RP.[1998], 
	   ISNULL(RP.[1999],0) AS [1999]   
	   ,ISNULL(RP.[2000],0) AS [2000] into TP_PIVOT 
FROM (SELECT A.RegionDescription , YEAR(OrderDate) AS ANIO , SUM(B.FREIGHT) AS VENTA
	  FROM T_EMP_REGION A 
	  LEFT JOIN Orders B ON A.EmployeeID=B.EmployeeID
	  GROUP BY A.RegionDescription , YEAR(OrderDate)
		) PVT
PIVOT ( SUM(VENTA)
		FOR ANIO IN ([1996],[1997],[1998],[1999],[2000])
) AS RP


SELECT * FROM TP_PIVOT
--- UNPIVOT 

SELECT *
FROM TP_PIVOT AS UNPVT
UNPIVOT ( MONTO FOR ANIOS IN ([1996],[1997],[1998],[1999],[2000]) 
			) AS RPT 

------ FUNCIONES DE AGRUPACION 

-- insumo 
--- 77 FILAS 
select c.CategoryName,  p.ProductName, sum(od.Quantity * od.UnitPrice) SubTotal
from [Order Details] od
left join Products p ON p.ProductID = od.ProductID
left join Categories c ON c.CategoryID = p.CategoryID
group by c.CategoryName, p.ProductName
order by 1


--ROLL UP 
-- 86 FILAS 
select c.CategoryName,  p.ProductName, 
	   GROUPING_ID(c.CategoryName, p.ProductName) AS ID_GRUPO,
	   sum(od.Quantity * od.UnitPrice) SubTotal
from [Order Details] od
left join Products p ON p.ProductID = od.ProductID
left join Categories c ON c.CategoryID = p.CategoryID
group by ROLLUP (c.CategoryName, p.ProductName) 

-- CUBE 
-- 163 FILAS 
select c.CategoryName,  p.ProductName, 
	   GROUPING_ID(c.CategoryName, p.ProductName) AS ID_GRUPO,
	   sum(od.Quantity * od.UnitPrice) SubTotal
from [Order Details] od
left join Products p ON p.ProductID = od.ProductID
left join Categories c ON c.CategoryID = p.CategoryID
group by CUBE (c.CategoryName, p.ProductName) 


--- GROUPING SET 

select c.CategoryName,  p.ProductName, 
	   GROUPING_ID(c.CategoryName, p.ProductName) AS ID_GRUPO,
	   sum(od.Quantity * od.UnitPrice) SubTotal
from [Order Details] od
left join Products p ON p.ProductID = od.ProductID
left join Categories c ON c.CategoryID = p.CategoryID
group by GROUPING SETS (c.CategoryName, p.ProductName) 

--- SUB CONSULTAS 


--- CUANDO EL RESULTADO ES INSUMO PARA EL FILTRADO DE OTRO QUERY 

-- 91 
SELECT *   -- 89 REALIZARON UNA COMPRA 
FROM CUSTOMERS 
WHERE CustomerID IN (SELECT CustomerID
					 FROM Orders )

--- EXISTS , NOT EXISTS 

SELECT *   --- 89 
FROM Customers A 
WHERE EXISTS ( SELECT CUSTOMERID
			   FROM Orders B 
			   WHERE B.CustomerID=A.CustomerID)

--- JOIN 

SELECT DISTINCT A.* 
FROM Customers A 
INNER JOIN Orders B ON A.CustomerID=B.CustomerID

------------------------------------------------------
  --- OBTENER LAS ORDENES DEL PRODUCTO CON ID 42 
  --- CUANDO LAS UNIDADES SUPERE LA CANT DE 10 

  SELECT *
  FROM Orders A 
  WHERE ( SELECT Quantity
		  FROM [Order Details] B 
		  WHERE B.ProductID=42 AND B.OrderID=A.OrderID) > 10

---- CTE  COMMON TABLE EXPRESION 


WITH TP_RESULTADO AS (select c.CategoryName,  p.ProductName, 
					   GROUPING_ID(c.CategoryName, p.ProductName) AS ID_GRUPO,
					   sum(od.Quantity * od.UnitPrice) SubTotal
						from [Order Details] od
						left join Products p ON p.ProductID = od.ProductID
						left join Categories c ON c.CategoryID = p.CategoryID
						group by GROUPING SETS (c.CategoryName, p.ProductName) )

SELECT *
FROM TP_RESULTADO A
WHERE A.ID_GRUPO=2