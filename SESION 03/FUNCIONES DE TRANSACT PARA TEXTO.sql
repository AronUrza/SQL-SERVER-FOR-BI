
--- ESCENARIO DE DUPLICADOS
-- Creamos un tabla e insertamos datos duplicados en la columna num_telefono

create table t_cliente_c 
(cod_cliente int , 
nombre_cliente varchar(150), 
num_telefono int
)


insert into t_cliente_c
(cod_cliente,nombre_cliente,num_telefono)
values(1,'juan',994567823),
	  (2,'jose',996767823),
	  (3,'maria',996677823), 
	  (4,'raul',996767825),
	  (5,'marco',996677825),
	  (6,'fiorella',996677825)

-- Verifimos los numeros duplicados

select num_telefono , count(*)
from t_cliente_c
group by num_telefono
having count(*) >1

-- Para saber los clientes con valores duplicados debemos usar SUBQUERYS

---------- SUBQUERY 

select *
from t_cliente_c
where num_telefono IN (select num_telefono 
					   from t_cliente_c
					   group by num_telefono
					   having count(*) >1 )


-- TAMBIEN PODEMOS USAR EL WITH
--- WITH CTE --- COMMON TABLE EXPRESION 


WITH T_CANTIDAD AS (select num_telefono , COUNT(*) CANT
					from t_cliente_c
					group by num_telefono)
					---having count(*) >1 )
SELECT *
FROM T_CANTIDAD
WHERE CANT=2

-------------------------------
--DECLARAR UNA TABLA TEMPORAL 

CREATE TABLE #T_PERSONAS(
COD_CLIENTE INT 
)

-- SE ELIMINA CUANDO CERRAMOS SESION 

---EL # , PARA UTILIZARLA EN TU SESION 

---EL ## , PARA QUE OTRA SESION LO PUEDA , GLOBAL 
-----------------------------------------------------------

--------------------------------------------------------------
------- CASE ---------------------------

/* TIPO_VENTA 
	- BAJA 0 A 80
	- MEDIA 80 A 120 
	- ALTA 120 A MAS 
*/

SELECT Freight, 
	   CASE 
			WHEN Freight BETWEEN 0 AND 80 THEN 'BAJA'
			WHEN Freight BETWEEN 80.01 AND 120 THEN 'MEDIA'
			ELSE 'ALTO' END AS TIPO_VENTA
		
FROM Orders


SELECT Freight, 
	   CASE 
			WHEN Freight < 120 THEN 'MEDIA'
			WHEN Freight < 80 THEN 'BAJA'			
			ELSE 'ALTO' END AS TIPO_VENTA
		
FROM Orders


----------------------------------------------------------------
-- ORDEN DE CONSULTAS ------------------------------------------

SELECT *
FROM TABLA 
WHERE CONDICIONAL 
GROUP BY AGRUPACION 
HAVING CONDICIONAL DE AGRUPACION 
ORDER BY ORDENAMIENTO 


-----------------------------------------------------------------
---TRANSACT SQL , SELECT --- FUNCIONES 


--------------------------------------------
--------- FUNCIONES DE TRANSACT - TEXTO ----


-- CONCAT 
-- CONCATENAR LOS VALORES LISTADOS EN UN CONCAT 

SELECT LastName , FirstName , CONCAT(LastName,' ,',FirstName) AS NOM_COMPLETO 
FROM Employees

-- CHARINDEX 
-- BUSCA UN VALOR DE CADENA Y RETORNA LA PRIMERA POSICION DEL VALOR 

SELECT FirstName , CHARINDEX('A',FirstName) AS POSICION
FROM Employees


--- UTILIZANDO EL CHARINDEX PARA FILTRO 

SELECT FirstName , CHARINDEX('A',FirstName) AS POSICION , 
	   CHARINDEX('E',FirstName) AS POSICION2
FROM Employees
WHERE CHARINDEX('A',FirstName) >0 AND CHARINDEX('E',FirstName) >0

--- LEN
---- DEVUELVE LA LONGITUD DE UNA CADENA 

SELECT FirstName , LEN(FirstName) AS LONGITUD
FROM Employees

--- REPLACE 
-- BUSCAS UN VALOR A REMPLAZAR POR OTRO 

SELECT FirstName , REPLACE(FirstName,'A','123') AS REEMPLAZO
FROM Employees


---- LEFT , RIGHT 


SELECT FirstName , 
	   LEFT(FirstName,2 ) AS PRIMERA_LETRA, 
	   RIGHT(FirstName,2) AS DOS_ULTIMAS
FROM Employees 

--- SUBSTRING 
--- CORTAR LA PALABRA DESDE UNA POSICION HASTA LA LONGITUD QUE NECESITEMOS 


SELECT FirstName , SUBSTRING(FIRSTNAME,2,4) AS CORTAR_PALABRA --SUBSTRING(columna,desde,cantidad de valores)
FROM Employees 

--- NECESITO , CORTAR LA PALABRA , 
--- DESDE CUANDO SE ENCUENTRE EL VALOR DOS POSICIONES MAS 


SELECT FirstName , CHARINDEX('A',FirstName), 
		CASE 
		WHEN CHARINDEX('A',FirstName)=0 THEN ' '
		ELSE SUBSTRING(FirstName,CHARINDEX('A',FirstName),2) END  AS PALABRA
FROM Employees


--- LTRIM , RTRIM , TRIM 

-- LTRIM QUITA LOS ESPACIOS EN BLANCO DE LAS PALABRAS AL INICIO
-- RTRIM QUITA LOS ESPACIOS EN BLANCO DE LAS PALABRAS  AL FINAL
-- TRIM QUITA LOS ESPACIOS EN BLANCO DE LAS PALABRAS  AL INICIO Y AL FINAL


SELECT  LTRIM('  JUAN') AS NOMBRE , RTRIM('JUAN  ') AS NOMBRE_2 , 
		RTRIM(LTRIM('  JUAN  ')) AS NOMBRE_3, 
		TRIM('  JUAN  ') AS NOMBRE_4

--- UPPER , LOWER 
-- UPPER CONVIERTE TODA LA PALABRA EN MAYUSCULA
-- LOWER CONVIERTE TODA LA PALABRA EN MINUSCULA

SELECT LastName , 
	   UPPER(LastName) AS MAYUSCULA , 
	   LOWER(LastName) AS MINISCULA 
FROM Employees

