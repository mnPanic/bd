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
    and object_name(cols.object_id) LIKE 'workorder'
    order by object_name(cols.object_id), ind.name;

-- para ver los nulleables
SELECT TABLE_NAME, COLUMN_NAME, IS_NULLABLE, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'WorkOrder';

-- 3
select count(UnitPrice) from sales.SalesOrderDetail;
select count(CarrierTrackingNumber) from sales.SalesOrderDetail;

-- 4
select p.ProductNumber from Sales.SpecialOffer so
join Sales.SpecialOfferProduct sop on so.SpecialOfferID = sop.SpecialOfferID
join Production.Product p on sop.ProductID = p.ProductID

select * from Sales.SpecialOffer so
join Sales.SpecialOfferProduct sop on so.SpecialOfferID = sop.SpecialOfferID
join Production.Product p on sop.ProductID = p.ProductID

-- 5

select AddressID, City, StateProvinceID, ModifiedDate
from  Person.Address
where StateProvinceID = 32

select AddressID, City, StateProvinceID, ModifiedDate
from Person.Address
where StateProvinceID = 20

-- 6

-- buscar indices de la tabla person, confiamos en los nombres para ver según qué está ordenado el índice

 -- puede usar el índice porque está ordenado por ese, hace seek
select * from Person.Person where LastName Like 'Duffy%'

-- no podés usar el índice porque no está ordenado por ese, hace scan
select * from Person.Person where LastName Like '%Duffy' 

-- prueba nuestra, hace un scan porque está ordenado por lastname el indice
select * from Person.Person where FirstName Like 'Duffy%' 

-- 7

-- si es nulleable, no lo tiene que contar, entonces tengo que ver todos los valores a ver si
-- efecdtivamente tengo que contarlos

-- enddate nulleable, tenés que hacer un scan para poder ver los que son null
select count(EndDate) from Production.WorkOrder

-- order qty no nulleable, entonces con contar cualquier fila de la tabla estoy bien
-- y elije scrap reason id, la elije porque es smallint que es más rápido
-- es nulleable, pero no importa porque el non clustered index tiene los nulls
select count(OrderQty) from Production.WorkOrder

-- 8
-- Dada la siguiente consulta:
select e.* from HumanResources.Employee as e where e.Gender = 'F'

-- Ejecutarla y ver el plan de ejecución,
-- Luego crear el siguiente índice:
CREATE INDEX IX_Employee_Test ON HumanResources.Employee (Gender)
--WITH (DROP_EXISTING = ON) ;
-- Volver a ejecutarla. ¿Qué ocurrió con el índice?

-- no lo usa porque son muchas las mujeres, más rápdio leer todo. La selectividad es muy baja.
-- Si la selectividad es más alta, ahí si vale la pena usar el índice

-- 9

select soh.* from Sales.SalesOrderHeader soh
join Sales.SalesOrderDetail sod
    on soh.SalesOrderID = sod.SalesOrderID
where soh.SalesOrderID = 71832 ;

select soh.* from Sales.SalesOrderHeader soh
join Sales.SalesOrderDetail sod
    on soh.SalesOrderID = sod.SalesOrderID

-- en uno hace seek porque tiene que filtrar y en el otro scan porque tiene que agarra todos
-- como están ordenados puede hacer merge y en el otro como son poquitos y desordenados hace nlj

-- ej 10

select distinct(CardType) from Sales.CreditCard;
select distinct(CardNumber) from Sales.CreditCard;

-- como el motor sabe que card type hay pocos, le aplica una func de hash (te trae al mismo lugar
-- los que son los mismos) y se queda con pocos (counting sort)
-- funciona bien para contar hashmap cuando hay pocos valores distintos.

-- en cambio del otro hay muchos
-- card number es unique y por eso le alcanza con recorrer todo el índice