
-------------------------------------
------- TRANSACT SQL ----------------
--- DML --- (MANIPULACION DE LAS TABLAS)

-- SELECT - UPDATE - INSERT - DELETE 

--------------------------------------

---- SELECT ---------------------

SELECT * 
FROM Orders

--- SELECIONANDO CIERTOS CAMPOS 

SELECT OrderID,CustomerID,EmployeeID
FROM Orders

-------------------------------------------------
---- FILTRAR LA INFORMACION DE UNA TABLA 

--- WHERE 

SELECT *
FROM Orders

--- NECESITO SABER LAS ORDENES QUE HAN SIDO ENVIADAS A FRANCIA 
--- TEXTO 

SELECT *
FROM Orders
WHERE ShipCountry='france' -- NO IMPORTAN LAS MAYUSCULAS Y EL TEXTO SIEMPRE ENTRE COMILLAS

---- INDICAME LAS VENTAS QUE SE REALIZARON EN FRANCIA Y BELGICA 

--- OR , 

SELECT *
FROM Orders
WHERE ShipCountry='france' OR ShipCountry='Belgium'

---- indicame todas las ventas que han sido enviadas a francia y 
--- las envio el empleado con codigo 5 

--- AND 

SELECT *
FROM Orders
WHERE ShipCountry='france' AND EmployeeID=5 -- Aqui si podemos poner sin comillas debido a que la columna es de tipo INT


--- NECESITO LAS VENTAS QUE SE ENVIARONA A BELGICA O FRANCIA , Y QUE LO 
--- HIZO EL EMPLEADO 5 

SELECT *
FROM Orders
WHERE (ShipCountry='france' OR ShipCountry='Belgium') AND EmployeeID=5 -- Separamos en parentesis para que se cumplan ambas consultas

---- OTRO METODO

SELECT *
FROM Orders  
WHERE (ShipCountry='france'  AND EmployeeID=5) OR 
	   (ShipCountry='Belgium' AND EmployeeID=5)

--------------
--- NECESITO LAS VENTAS QUE SE HAN ENVIADO HACIA , FRANCIA , AUSTRIA , BRAZIL , 

--- IN , LISTA DE VALORES 

SELECT *
FROM Orders  
WHERE ShipCountry='france' OR ShipCountry='AUSTRIA' OR ShipCountry='BRAZIL'

--- UTILIZANDO EL IN 

SELECT *
FROM Orders
WHERE ShipCountry IN ('france','austria','brazil') -- Utilizamos el IN para poder conultar varios paises

---- necesito las ventas de los empleados con codigo 5 , 4 , 3 

select *
from Orders
where EmployeeID IN (5,4,3)


---- LIKE       (Utilizamos LIKE para buscar una caracteristica x)
---- necesito saber los clientes que empiecen con la palabra li 

select *
from Customers
WHERE ContactName LIKE 'li%' 

--- necesito saber los clientes que terminen con la palabra li 

select *
from Customers
WHERE ContactName LIKE '%li'

--NECESITO SABER LOS CLIENTES QUE CONTENGAN EL VALOR DE LI (PUEDE ESTAR AL INICIO Y AL FINAL)

select *
from Customers
WHERE ContactName LIKE '%li%'

----------------------------------------
--- NUMERICOS

--- Filtrando un valor numerico 

-- Necesito las ventas del empleado con codigo 5 

select *
from Orders
where EmployeeID=5


--- necesito las ventas que sean mayores a 50 
-- mayor a 50 ->  360 REGISTROS
select *
from Orders
where Freight > 50 

select *
from Orders
where Freight >= 51.3 

--- necesito las ventas que esten entre 50 y 100 soles 

select *
from Orders
where Freight >50 and Freight <  100

-- Aqui si icluimos a los valores 50 y 100

select *
from Orders
where Freight >= 50 and Freight <= 100

--- between 

--- necesito las ventas que esten entre 50 y 100 soles (incluyendo 50 y 100)

select *
from Orders 
where Freight between 50 and 100 


--------------------------------------------
--- FECHAS

--- necesito todas las ventas que se realizaron el 
--- 02-03-1998

select *
from Orders
where OrderDate='1998-03-02' -- LAS FECHAS TAMBIEN VAN ENTRE COMILLAS

---- las ventas realizadas entre las fechas de 
---1998-03-01  and 1998-03-05 

select *
from Orders 
where OrderDate >= '1998-01-03' and OrderDate <= '1998-05-03' --FORMATO DE FECHA AÑO/DIA/MES

--between 

select *
from Orders 
where OrderDate between '1998-01-03' and '1998-05-03'

----- NEGACIÓN

--- != , <>  --- diferente de 

SELECT * 
FROM Orders 
WHERE ShipCountry != 'France'


SELECT * 
FROM Orders --830 -- 77
WHERE ShipCountry <> 'France'



-- NOT  (trabaja con in y con like)

--- in 
-- Indicame todos los paises de la tabla orders menos france, austria y brazil
SELECT *
FROM Orders
WHERE ShipCountry NOT IN ('france','austria','brazil') 

--- like 
-- Indicame los registros de los nombre de clientes que no empiezan con li
select *
from Customers
WHERE ContactName NOT LIKE 'li%'


---- NULL 

-- INDICAME TODOS LAS VENTAS QUE NO TIENEN UNA REGION ASIGNADA 

SELECT *
FROM Orders
WHERE ShipRegion IS NULL

----- LAS VENTAS QUE NO HAN SIDO ENVIADAS 

SELECT *
FROM Orders
WHERE ShippedDate IS NULL

-- INDICAME TODAS LAS VENTAS QUE SI HAN SIDO ENVIADAS 

SELECT *
FROM Orders
WHERE ShippedDate IS NOT NULL


----------------------------------------------
---ALIAS  --- CAMPO 
SELECT OrderID, OrderID AS CODIGO_VENTA
FROM Orders

--- ALIAS --- TABLA 

SELECT OrderID , A.OrderID
FROM Orders A
--------------------------------------------


---------------------------------------------------
--- FUNCIONES DE AGREGACION 

---- COUNT , SUM , MAX , MIN , AVG 


SELECT COUNT(*) AS CANTIDAD , 
	   SUM(FREIGHT) AS MONTO_VENTA , 
	   AVG(FREIGHT) AS PROM_VENTA , 
	   MAX(FREIGHT) AS MAXIMA_VENTA, 
	   MIN(FREIGHT) AS MIN_VENTA
FROM Orders



SELECT *
FROM Orders
-----------------------------------------------
------------------------------------
SELECT COUNT(*)
FROM Orders

SELECT COUNT(OrderID)
FROM Orders

-------------------------------------
--- GROUP BY 


---NECESITO SABER EL MONTO DE VENTAS POR EMPLEADO 

SELECT EmployeeID , 
	   SUM(FREIGHT) AS VENTA, 
	   COUNT(*) AS CANT_VENTAS
FROM Orders
GROUP BY EmployeeID 


----- NECESITO SABER EL MONTO DE VENTAS POR EMPLEADO Y LUGAR DE ENVIO 


SELECT EmployeeID , ShipCountry ,SUM(FREIGHT) AS VENTA
FROM Orders
GROUP BY EmployeeID , ShipCountry

----- NECESITO SABER EL MONTO DE VENTAS POR EMPLEADO 1 Y LUGAR DE ENVIO 


SELECT EmployeeID , ShipCountry , SUM(FREIGHT) AS VENTA
FROM Orders
WHERE EmployeeID=1 
GROUP BY EmployeeID , ShipCountry 

--------------------------------------------------------------------
----- NECESITO SABER EL MONTO DE VENTAS POR EMPLEADO 1 Y LUGAR DE ENVIO 
-- Y ADICIONAL QUE LOS MONTOS DE VENTAS SEAN MAYOR A 70 


SELECT EmployeeID , ShipCountry , SUM(FREIGHT) AS VENTA
FROM Orders
WHERE EmployeeID=1 
GROUP BY EmployeeID , ShipCountry 
HAVING SUM(FREIGHT)>70


------ ORDER LA INFORMACION 

SELECT EmployeeID , ShipCountry , SUM(FREIGHT) AS VENTA
FROM Orders
WHERE EmployeeID=1 
GROUP BY EmployeeID , ShipCountry 
HAVING SUM(FREIGHT)>70
ORDER BY   ShipCountry DESC ,VENTA ASC









  


