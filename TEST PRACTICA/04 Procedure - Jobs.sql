USE AdventureWorksLT2019;

GO

--SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID=71774 ;

--SELECT TOP 100 * FROM SalesLT.SalesOrderDetail WHERE SalesOrderID=71774;

--select top 100 * from SalesLT.Product where ProductID=836

DROP TABLE  dbo.SalesSummary

CREATE TABLE dbo.SalesSummary(

 SalesSummaryID int IDENTITY(1,1) PRIMARY KEY,

 YEAR INT,

 PRODUCT NVARCHAR(100),

 TOTALSALES DECIMAL(18,2),

 CANTIDADPRODUCTOS INT,

 PROCESSINGDATE DATETIME DEFAULT GETDATE()

);


------------------------------------------------------------------------------
---------- INSERTAMOS DATOS A NUESTRA TABLA CREADA ---------------------------
------------------------------------------------------------------------------

INSERT INTO SalesSummary (YEAR,PRODUCT,TOTALSALES,CANTIDADPRODUCTOS)
select 

 year(soh.orderDate) as Year,

 p.name,

 SUM(sod.LineTotal) AS SALESTOTAL,

 SUM(sod.orderQty) as qty

from SalesLT.SalesOrderHeader soh

inner join SalesLT.SalesOrderDetail sod on soh.SalesOrderID=sod.SalesOrderID

inner join SalesLT.Product p on p.ProductID=sod.ProductID

GROUP BY 

 year(soh.orderDate),

 p.name

 

 ----------------------------------------------------------------
 ---------------------- CREACION DE PROCEDURE .------------------
 ----------------------------------------------------------------

 CREATE PROCEDURE dbo.UpdateSalesSummaryTable

as

begin

 INSERT INTO dbo.SalesSummary(YEAR,product,TOTALSALES,CANTIDADPRODUCTOS)

 select 

  year(soh.orderDate) as Year,

  p.name,

  SUM(sod.LineTotal) AS SALESTOTAL,

  SUM(sod.orderQty) as qty

 from SalesLT.SalesOrderHeader soh

 inner join SalesLT.SalesOrderDetail sod on soh.SalesOrderID=sod.SalesOrderID

 inner join SalesLT.Product p on p.ProductID=sod.ProductID

 GROUP BY 

  year(soh.orderDate),

  p.name

End;


EXEC UpdateSalesSummaryTable

select * from SalesSummary

----------------------------------------------------------------------------------------
-- CREACION DE JOB ----------------------------------------------------------------------
----------------------------------------------------------------------------------------


use msdb

exec sp_add_job @job_name = 'UpdateSalesSummaryTable';

EXEC sp_add_jobstep 

    @job_name = 'UpdateSalesSummaryTable',

    @step_name = 'ActualizarTabla',

    @subsystem = 'TSQL',

    @command = 'EXEC AdventureWorksLT2019.dbo.UpdateSalesSummaryTable';

EXEC sp_add_schedule 

    @schedule_name = 'Every 1 minute',

    @freq_type = 4, -- minute

    @freq_interval = 1, -- every 1 minute

    @active_start_time = 000000; -- start time (00:00:00)

EXEC sp_attach_schedule 

    @job_name = 'UpdateSalesSummaryTable',

    @schedule_name = 'Every 1 minute';

EXEC sp_start_job @job_name = 'UpdateSalesSummaryTable';

EXEC sp_add_jobserver 

    @job_name = 'UpdateSalesSummaryTable', 

    @server_name = '(local)';
