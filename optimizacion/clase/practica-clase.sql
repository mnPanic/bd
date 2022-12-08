-- Practica clase SQL

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
    and object_name(cols.object_id) LIKE 'Employee'
    order by object_name(cols.object_id), ind.name;

-- PK_ Primary Key, clustered
-- AK_ unclustered, unique
-- IX_ unclustered, no unique

--- Para ver los nulleables
SELECT TABLE_NAME, COLUMN_NAME, IS_NULLABLE, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
--WHERE table_name = 'SalesOrderDetail';
--WHERE table_name = 'WorkOrder';
WHERE table_name = 'CreditCard';

-- Consultas

--- Consulta 1
select NationalIDNumber, HireDate from HumanResources.Employee
where NationalIDNumber='121491555';

select NationalIDNumber, BusinessEntityID from HumanResources.Employee
where NationalIDNumber= '121491555';

--- Consulta 2
select NationalIDNumber, BusinessEntityID from HumanResources.Employee
where NationalIDNumber= '121491555';

select NationalIDNumber, BusinessEntityID from HumanResources.Employee
where NationalIDNumber= 121491555;

--- Consulta 3
select count(UnitPrice) from sales.SalesOrderDetail;
select count(CarrierTrackingNumber) from sales.SalesOrderDetail;

--- Consulta 4
select p.ProductNumber from Sales.SpecialOffer so
join Sales.SpecialOfferProduct sop on so.SpecialOfferID = sop.SpecialOfferID
join Production.Product p on sop.ProductID = p.ProductID;

select * from Sales.SpecialOffer so
join Sales.SpecialOfferProduct sop on so.SpecialOfferID = sop.SpecialOfferID
join Production.Product p on sop.ProductID = p.ProductID;

-- Consulta 5
select AddressID, City, StateProvinceID, ModifiedDate
from  Person.Address
where StateProvinceID = 32;

select AddressID, City, StateProvinceID, ModifiedDate
from Person.Address
where StateProvinceID = 20;

-- Consulta 6
select * from Person.Person where LastName Like 'Duffy%';
select * from Person.Person where LastName Like '%Duffy';

-- Consulta 7
select count(EndDate) from Production.WorkOrder;
select count(OrderQty) from Production.WorkOrder;

-- Consulta 8
select e.* from HumanResources.Employee as e where e.Gender = 'F';

CREATE INDEX IX_Employee_Test ON HumanResources.Employee (Gender);
--WITH (DROP_EXISTING = ON) ;

select e.Gender from HumanResources.Employee as e where e.Gender = 'F';

-- Consulta 9

select soh.* from Sales.SalesOrderHeader soh
join Sales.SalesOrderDetail sod
    on soh.SalesOrderID = sod.SalesOrderID
where soh.SalesOrderID = 71832 ;

select soh.* from Sales.SalesOrderHeader soh
join Sales.SalesOrderDetail sod
    on soh.SalesOrderID = sod.SalesOrderID

-- Consulta 10
select distinct(CardType) from Sales.CreditCard;
select distinct(CardNumber) from Sales.CreditCard;