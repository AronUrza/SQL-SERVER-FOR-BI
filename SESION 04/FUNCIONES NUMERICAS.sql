

------------- FUNCIONES NUMERICAS -------------

-- +´, - , * , / 



select a.UnitPrice, a.Quantity, 
	   a.UnitPrice*a.Quantity as P_FINAL_MULTI, 
	   A.UnitPrice - A.Quantity AS P_FINAL_REST, 
	   A.UnitPrice + A.Quantity AS P_FINAL_SUMA, 
	   A.UnitPrice / A.Quantity AS P_FINAL_DIV, 
	   CASE		       -- Usamos el Case por si el divisor es 0 
			WHEN A.Quantity=0 THEN 0 
			ELSE A.UnitPrice / A.Quantity END AS P_FINAL_DIV2
from [Order Details] a

-------------------------------------------------------------

---- CONVERT , CAST        --> Transforma el tipo de variable


--1.- DE TEXTO A NUMERICO 


SELECT '23' AS VALOR , 
	  CONVERT(INT ,'23') AS VALOR2, 
	  CAST ('23' AS INT ) AS VALOR3


-- Para convertir de Texto a numerico, el texto debe ser numeros de lo contrario saldra error

SELECT  CAST (Extension AS INT) AS VALOR, 
		CAST( FirstName AS INT) AS VALOR_2
FROM [dbo].[Employees]


--2.- UN NUMERO A TEXTO 

SELECT 23  AS NUMERO , 
	   CAST(23 AS VARCHAR(20) ) AS VALOR_1, 
	   CONVERT(VARCHAR(20),23 ) AS VALOR_2

-- 3.- FECHA A TEXTO 

SELECT GETDATE() AS FECHA , 
	   CAST(FORMAT(GETDATE(),'dd-MM-yyyy') AS VARCHAR(50) ) AS VALOR_1, 
	   CONVERT(VARCHAR(50),FORMAT(GETDATE(),'dd-MM-yyyy')  ) AS VALOR_2

--- 4.- FECHA A NUMERICO 

SELECT GETDATE() AS FECHA , 
	   CAST( FORMAT(GETDATE(),'ddMMyyyy') AS INT) AS VALOR_1 , 
	   CONVERT(INT ,FORMAT(GETDATE(),'yyyyMM')) as valor_2

-----------------------------------------------------------------
--- insert , update , delete , 



-----------------------------------------------
----------------- INSERT ----------------------

-- Con el INSERT Tenemos 3 escenarios

-- Creamos una Tabla T_EMPLEADO

CREATE TABLE T_EMPLEADO (
COD_EMPLEADO INT, 
APE_EMP VARCHAR(100), 
NOM_EMP VARCHAR(100)
)


-- 1.- INSERTO UN REGISTRO UNICO 

INSERT INTO T_EMPLEADO 
(COD_EMPLEADO,APE_EMP,NOM_EMP)
VALUES(1,'URIARTE','ARON')

SELECT *
FROM T_EMPLEADO


------ RECIBIENDO NULL POR DEFECTO 


INSERT INTO T_EMPLEADO 
(COD_EMPLEADO,APE_EMP)
VALUES(2,'ROJAS')  -- Dado que no pusimos restriccion podemos insertar datos incompletos



-- 2.- INSERT EN LOTE DE REGISTROS DE UNA TABLA FUENTE 

INSERT INTO T_EMPLEADO 
(COD_EMPLEADO,APE_EMP,NOM_EMP)
SELECT CAST(EmployeeID AS INT) AS COD_EMPLEADO, 
	   LastName , 
	   FirstName
FROM Employees

-- Verificamos

SELECT *
FROM T_EMPLEADO


-- 3.- INSERTO LOS REGISTROS DESDE UN SELECT Y A LA VEZ CREO LA TABLA 


SELECT CustomerID , CompanyName , ContactName INTO T_EMP_GERMANY
FROM Customers
WHERE Country='Germany'


SELECT * FROM T_EMP_GERMANY

-- Tambien podemmos cambiar el tipo de Variable 

SELECT CAST (CustomerID AS VARCHAR(50)) AS COD_CLIENTE , 
	   CompanyName , 
	   ContactName INTO T_EMP_GERMANY2
FROM Customers
WHERE Country='Germany'


----------------------------------------------
------------ DELETE --------------------------


--SINTAXIS 
DELETE FROM NOMBRE_TABLA ; -- Con este comando eliminariamos todos el contenido de una Tabla

--1.- ENCONTRAR LOS REGISTROS A SER ELIMINADOS 

SELECT *
FROM T_EMP_GERMANY
WHERE CustomerID IN ('FRANK','MORGK')

-- 2.- ELIMINAR LOS REGISTROS 

DELETE FROM T_EMP_GERMANY 
WHERE CustomerID IN ('FRANK','MORGK')

-- Comprobamos los datos eliminados

SELECT *
FROM T_EMP_GERMANY


-----------------------------------------------
----------- UPDATE ----------------------------

--- SINTAXIS 

UPDATE NOMBRE_TABLA 
SET CAMPO_UPDATE = VALOR ,CAPO_2_UPDATE=VALOR_2 
WHERE 


--1.- SELECIONAR LOS REGISTROS A SER ACTUALIZADOS 

SELECT *
FROM T_EMP_GERMANY
WHERE CustomerID='KOENE'

--2.- UPODATE DEL REGISTROS 

UPDATE T_EMP_GERMANY
SET CompanyName='AUZ.SAC' , ContactName='ARON URIARTE'
WHERE CustomerID='KOENE'


-------------------------------------------
--- RESTRICCIONES --- A NIVEL TABLA 
-------------------------------------------
---------- PRIMARY KEY --------------------


CREATE TABLE T_CLIEN_PERSONA 
( COD_CLIENTE INT , 
NOMBRE VARCHAR(100), 
APE_PATERNO VARCHAR(100), 
CONSTRAINT PK_T_CLIENTE PRIMARY KEY (COD_CLIENTE)
)


INSERT INTO T_CLIEN_PERSONA 
(COD_CLIENTE,NOMBRE,APE_PATERNO)
VALUES
      (1,'JOSE','RODRIGUEZ'),
      (2,'JUAN','RODRIGUEZ'),
      (1,'ARON','URIARTE') -- No podemos insertar ya que la tabla tiene PK y el COD_CLIENTE no se puede repetir


-- Ahora si 

INSERT INTO T_CLIEN_PERSONA (COD_CLIENTE, NOMBRE, APE_PATERNO)
VALUES
  (1, 'JOSE', 'RODRIGUEZ'),
  (2, 'JUAN', 'RODRIGUEZ'),
  (3, 'ARON', 'URIARTE');


SELECT *
FROM T_CLIEN_PERSONA

---------------------------------------------
-- OTRO METODO DE CREAR TABLA CON PK

CREATE TABLE T_CLIEN_PERSONA_2
( COD_CLIENTE INT PRIMARY KEY , 
NOMBRE VARCHAR(100), 
APE_PATERNO VARCHAR(100))

-----------------------------------------------------------
--SINTAXIS PARA DEFINIR MAS DE DOS CAMPOS DE PRIMARY KEY 
CREATE TABLE T_CLIEN_PERSONA3 
( COD_CLIENTE INT , 
 COD_PROD INT, 
NOMBRE VARCHAR(100), 
APE_PATERNO VARCHAR(100), 
CONSTRAINT PK_T_CLIENTE2 PRIMARY KEY (COD_CLIENTE,COD_PROD)
)




-------------------------------------------
---------- FOREIGN KEY --------------------

CREATE TABLE T_VENTAS 
( ID_VENTA INT , 
 MONTO DECIMAL(19,4), 
 FEC_VENTA DATE , 
 COD_CLIENTE INT , 
 CONSTRAINT FK_CLIENTE_VENTAS FOREIGN KEY (COD_CLIENTE)
 REFERENCES T_CLIEN_PERSONA (COD_CLIENTE)
)

INSERT INTO T_VENTAS 
(ID_VENTA , MONTO , FEC_VENTA, COD_CLIENTE)
VALUES(3,80,'2020-01-01',5)

SELECT *
FROM T_CLIEN_PERSONA

SELECT *
FROM T_VENTAS

