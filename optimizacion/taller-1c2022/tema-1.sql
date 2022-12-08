-- Taller tema 1
-- Queries auxiliares

--- Para ver índices
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
    and object_name(cols.object_id) LIKE 'SalesOrderDetail'
    order by object_name(cols.object_id), ind.name;

-- PK_ Primary Key, clustered
-- AK_ unclustered, unique
-- IX_ unclustered, no unique

--- Para ver los nulleables
SELECT TABLE_NAME, COLUMN_NAME, IS_NULLABLE, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'SalesOrderDetail';
--WHERE table_name = 'WorkOrder';
--WHERE table_name = 'ShipMethod';

-- Consulta 1
select * from  Purchasing.ShipMethod order by Name;

select * from  Purchasing.ShipMethod where Name is not null;

-- Consulta 2
select CardType from Sales.CreditCard group by CardType;
select CardNumber from Sales.CreditCard group by CardNumber;

-- Consulta 3
select * from sales.SalesOrderDetail where UnitPrice > all (select UnitPrice from
Sales.SalesOrderDetail where OrderQty >12);

select * from sales.SalesOrderDetail where UnitPrice > (select Max(UnitPrice) from
Sales.SalesOrderDetail where OrderQty >12);

-- Consulta 4
select AddressID, City, StateProvinceID, ModifiedDate
from  Person.Address
where StateProvinceID = 32;

select AddressID, City, StateProvinceID, ModifiedDate
from Person.Address
where StateProvinceID = 20;

-- Consulta 5
select count(UnitPrice) from sales.SalesOrderDetail;
select sum(UnitPrice) from sales.SalesOrderDetail;

-- Consulta 6
select * from Person.Person where LastName Like 'Duffy%'
select * from Person.Person where LastName Like '%Duffy'
