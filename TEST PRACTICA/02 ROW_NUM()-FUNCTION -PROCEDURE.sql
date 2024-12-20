-- Crear la tabla de ejemplo
CREATE TABLE Ventas (
    id INT PRIMARY KEY,
    fecha DATE,
    producto VARCHAR(50),
    cantidad INT,
    precio DECIMAL(10, 2)
);

-- Insertar datos de ejemplo
INSERT INTO Ventas (id, fecha, producto, cantidad, precio)
VALUES
    (1, '2022-01-01', 'Producto A', 10, 100.00),
    (2, '2022-01-02', 'Producto A', 15, 120.00),
    (3, '2022-01-03', 'Producto B', 20, 150.00),
    (4, '2022-01-04', 'Producto A', 12, 110.00),
    (5, '2022-01-05', 'Producto B', 18, 140.00),
    (6, '2022-01-01', 'Producto A', 10, 120.00),
    (7, '2022-01-01', 'Producto A', 0, 0.00),
    (8, '2022-01-01', 'Producto A', 10, 120.00),
    (9, '2022-01-01', 'Producto A', 0, 0.00);

-- Consultar todos los registros de la tabla Ventas
SELECT * FROM Ventas;

-- Análisis de ventas por producto y fecha
SELECT 
    producto,
    fecha,
    COUNT(*) AS NUM_VENTAS,
    SUM(precio) AS SUMA_PRECIO,
    AVG(precio) AS PROMEDIO_PRECIO,
    LAG(AVG(precio), 1, 0) OVER (PARTITION BY producto ORDER BY fecha) AS VENTA_ANT_PROM,
    LAG(AVG(precio), 1, 0) OVER (PARTITION BY producto ORDER BY fecha DESC) AS VENTA_POS_PROM,
    LEAD(AVG(precio), 1, 0) OVER (PARTITION BY producto ORDER BY fecha) AS VENTA_PO_PROM
FROM 
    Ventas
GROUP BY 
    producto,
    fecha;

-- Análisis de ventas con numeración y ranking
SELECT 
    producto,
    fecha,
    cantidad,
    precio,
    ROW_NUMBER() OVER (PARTITION BY producto ORDER BY fecha) AS FILA_NUMERO,
    ROW_NUMBER() OVER (PARTITION BY producto ORDER BY precio DESC) AS RANKING_PRECIO_MAYOR,
    RANK() OVER (PARTITION BY producto ORDER BY precio DESC) AS RANKING_PRECIO_MAYOR2,
    DENSE_RANK() OVER (PARTITION BY producto ORDER BY precio DESC) AS RANKING_PRECIO_MAYOR3
FROM 
    Ventas;

-- Análisis de cantidad vendida por producto
SELECT 
    producto,
    SUM(cantidad) AS TOTAL_CANTIDAD,
    ROW_NUMBER() OVER (ORDER BY SUM(cantidad) DESC) AS RANKING_CANTIDAD,
    RANK() OVER (ORDER BY SUM(cantidad) DESC) AS RANKING_CANTIDAD2,
    DENSE_RANK() OVER (ORDER BY SUM(cantidad) DESC) AS RANKING_CANTIDAD3
FROM 
    Ventas
GROUP BY 
    producto;

-- Declaración de variables y cálculo de cantidad total para un producto específico
DECLARE @PRODUCTO NVARCHAR(50);
SET @PRODUCTO = 'PRODUCTO A';
DECLARE @CANTIDAD INT;

SELECT @CANTIDAD = SUM(CAST(cantidad AS INT))
FROM Ventas 
WHERE CAST(producto AS NVARCHAR(50)) = @PRODUCTO;

SELECT @CANTIDAD AS CANTIDAD, @PRODUCTO AS PRODUCTO;

-- Función para sumar dos números
CREATE FUNCTION SUMA(@A INT, @B INT)
RETURNS INT 
AS  
BEGIN
    RETURN @A + @B;
END;

-- Ejemplo de uso de la función SUMA
SELECT dbo.SUMA(1, 2) AS RESULTADO;

-- Procedimiento almacenado para insertar en la tabla Ventas
CREATE PROCEDURE SP_INSERTARTBVENTA 
    @ID INT,
    @FECHA DATE,
    @PRODUCTO VARCHAR(50),
    @CANTIDAD INT,
    @PRECIO DECIMAL(10, 2)
AS 
BEGIN 
    INSERT INTO Ventas (id, fecha, producto, cantidad, precio)
    VALUES (@ID, @FECHA, @PRODUCTO, @CANTIDAD, @PRECIO);
END;

-- Ejemplo de ejecución del procedimiento almacenado
EXEC SP_INSERTARTBVENTA 15, '2022-01-10', 'PRODUCTO Z', 10, 50.00;