----------------------------------
------ LAS VISTAS ----------------


CREATE VIEW V_VENTAS AS
select c.CustomerID, DATEPART(Year, o.OrderDate) Anio, 
							od.Quantity * od.UnitPrice SubTotal
					from Customers c
					join Orders o on c.CustomerID = o.CustomerID
					join [Order Details] od on od.OrderID = o.OrderID
					join Products p on p.ProductID = od.ProductID
				


SELECT * FROM V_VENTAS

--- ELIMINAR UNA VISTA 

DROP VIEW V_VENTAS

		  
--- ACTUALIZAR LA VISTA 


ALTER VIEW V_VENTAS AS
select c.CustomerID, DATEPART(MONTH, o.OrderDate) Anio, 
							od.Quantity * od.UnitPrice SubTotal
					from Customers c
					join Orders o on c.CustomerID = o.CustomerID
					join [Order Details] od on od.OrderID = o.OrderID
					join Products p on p.ProductID = od.ProductID

 --- CONTEMPLANDO AMBAS SITUACIONES , 

CREATE OR ALTER VIEW V_VENTAS AS
select c.CustomerID, DATEPART(MONTH, o.OrderDate) Anio, 
							od.Quantity * od.UnitPrice SubTotal
					from Customers c
					join Orders o on c.CustomerID = o.CustomerID
					join [Order Details] od on od.OrderID = o.OrderID
					join Products p on p.ProductID = od.ProductID