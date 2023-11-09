---------------------------------------
-------- FUNCIONES DE FECHAS ----------

--- COMO OBTENER LA FECHA DEL MOMENTO 

-- GETDATE()   --> nos arroja la fecha, hora, minuto y segundo actual

SELECT GETDATE()

--- DATEDIFF()   --> nos da la diferencia de fechas

SELECT BirthDate , HireDate , 
	   DATEDIFF(YEAR,BirthDate,HireDate) AS EDAD_INGRESO, 
	   DATEDIFF(YEAR,BirthDate,GETDATE()) AS EDAD , 
	   (DATEDIFF(YEAR,BirthDate,GETDATE())) / 12 AS EDAD_EXACTA
FROM Employees

---- DATEADD   --> Agregar o quitar dias, meses o a�os a una fecha

SELECT BirthDate, 
	   DATEADD(DAY,5,BirthDate) AS A_5_DIAS_DESPUES, 
	   DATEADD(DAY,-5,BirthDate) AS A_MENOS_5_DIAS, 
	   DATEADD(HOUR,2,GETDATE()) AS HORA_BRAZIL
FROM Employees 

------------------------------------------

--- DATENAME --> Nos da el dia, mes, a�o de una fecha

SET LANGUAGE SPANISH -- Para que la consulta salga en espa�ol
SELECT OrderDate , 
	   YEAR(OrderDate) AS A�O , 
	   DATENAME(YEAR,OrderDate ) AS A�O2, 
	   MONTH(OrderDate) AS MES , 
	   DATENAME(MONTH,OrderDate ) AS MES_NOMBRE, 
	   DAY(OrderDate) AS DIA, 
	   DATENAME(DAY,OrderDate) AS DIA_2, 
	   DATENAME (DAYOFYEAR,OrderDate ) AS DIA_DEL_A�O, 
	   DATENAME (WEEK,OrderDate) AS SEMANA_DEL_A�O , 
	   DATENAME (WEEKDAY,OrderDate ) AS NOMBRE_DIA_SEMANA, 
	   DATENAME (QUARTER,OrderDate) AS TRIMESTRE 
FROM Orders

--- FORMAT , PARA LAS FECHA 

SELECT   GETDATE() , FORMAT (GETDATE(),'HH:mm') ,   -- GETDATE()
		  FORMAT (GETDATE(),'hh:mm'),               -- HORA
		  format (getdate(),'yyyymmm') corte_mes , 
		  format (getdate(),'yyyymmmdd') corte_dia

	
--- EOMONTH --> Nos da el ultimo dia del mes y a�o selecionado

SELECT BirthDate , EOMONTH(BirthDate) AS ULT_DIA
FROM Employees

