-- Listing 3-1: Ejemplo de clustered index scan
SELECT e.LoginID, e.JobTitle, e.BirthDate
FROM HumanResources.Employee AS e
WHERE e.BirthDate < DATEADD(YEAR, -50, GETUTCDATE())
ORDER BY e.BusinessEntityID;

-- Listing 3-2: Ejemplo de Index scan (nonclustered)
-- Elije hacer un index scan del índice de LoginID porque tiene el buisness entity id al ser la PK.
-- Entonces se ahorra el paso de ir a buscarlo y es más rápido.
SELECT e.LoginID, e.BusinessEntityID
FROM HumanResources.Employee AS e;

-- Listing 3-3 - Clustered index seek
-- 
-- SQL Server's use of that index becomes analogous to looking up a word in the index of a book to get the exact pages that contain that word@
SELECT e.BusinessEntityID, e.NationalIDNumber,
e.LoginID, e.VacationHours, e.SickLeaveHours
FROM HumanResources.Employee AS e WHERE e.BusinessEntityID = 226;

-- Listing 3-4 - Index seek (nonclustered)
-- Aprovecha un índice nonclustered que tiene tanto lastname, firstname y middlename.
-- No hace keylookup porque están todas las columnas cubiertas por el índice
SELECT  p.BusinessEntityID,
        p.LastName,
        p.FirstName
FROM    Person.Person AS p
WHERE   p.LastName LIKE 'Jaf%';

-- Listing 3-5 - Key lookup
-- Modificación leve del 4 que agrega NameStyle, que no esta cubierto por el indice.
-- Se usa un nested loop para combinar los resultados de las dos operaciones.
SELECT p.BusinessEntityID, p.LastName,
p.FirstName,
p.NameStyle
FROM Person.Person AS p
WHERE p.LastName LIKE 'Jaf%';