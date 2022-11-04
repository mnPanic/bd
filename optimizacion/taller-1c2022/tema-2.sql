-- Taler 1c2022 tema 2

SELECT 
    object_name(cols.object_id) tabla
    ,cols.name columna
    ,ind.name indice
    ,ind.type_desc tipo
    ,ind.is_unique 
    FROM 
    sys.columns cols, sys.indexes ind , sys.index_columns ind_cols
    where 
    cols.object_id = ind.object_id
    and cols.object_id = ind_cols.object_id
    and cols.column_id = ind_cols.column_id
    and ind.index_id = ind_cols.index_id
    and object_name(cols.object_id) LIKE 'ProductVendor'
    order by object_name(cols.object_id), ind.name;

-- PK_ Primary Key, clustered
-- AK_ unclustered, unique
-- IX_ unclustered, no unique

--- Para ver los nulleables
SELECT TABLE_NAME, COLUMN_NAME, IS_NULLABLE, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'ProductVendor';
--WHERE table_name = 'WorkOrder';
--WHERE table_name = 'ShipMethod';

-- Consulta 1
select FirstName,LastName from Person.Person where FirstName > 'Lili' and LastName > 'Adam';
select FirstName,LastName from Person.Person where FirstName <> 'Lili';

-- Consulta 2
select soh.* from Sales.SalesOrderHeader soh
join Sales.SalesOrderDetail sod  on soh.SalesOrderID = sod.SalesOrderID
where soh.SalesOrderID = 43665;

select soh.* from Sales.SalesOrderHeader soh
join Sales.SalesOrderDetail sod  on soh.SalesOrderID = sod.SalesOrderID;

-- Consulta 3
select * from Production.ProductReview pr  right join
Production.Product p on p.ProductID = pr.ProductID;

select * from Production.ProductReview pr,Production.Product p
where p.ProductID = pr.ProductID;

-- Consulta 4

select *  from Person.Address where City ='Sooke';
select *  from Person.Address where City ='Newark';

-- Consulta 5

select count(MinOrderQTY) from Purchasing.ProductVendor;
select count(OnOrderQty) from Purchasing.ProductVendor;

-- Consulta 6
select * from Production.WorkOrder where WorkOrderID in (63505, 63506, 63508); -- test mio
select * from Production.WorkOrder where WorkOrderID in (63505, 63506, 63507);
select * from Production.WorkOrder where WorkOrderID between 63505 and 63507;