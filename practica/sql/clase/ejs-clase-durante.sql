-- https://sqliteonline.com/
-- https://github.com/lerocha/chinook-database/tree/master/ChinookDatabase/DataSources
-- Ej 1
SELECT T."Name", G."Name", MT."Name"
	FROM "Track" as t, "MediaType" as MT, "Genre" as g
    WHERE T."GenreId" = G."GenreId" AND
    	T."MediaTypeId" = MT."MediaTypeId";

-- Ej 2 Listar la cantidad de tracks que tiene cada género
SELECT G."Name", COUNT(*)
	FROM "Track" as T, "Genre" as G
    where T."GenreId" = G."GenreId"
    GROUP BY G."Name";

-- todo lo que va en el select va en el groupby
SELECT G."Name", COUNT(T."TrackId")
	FROM "Genre" as G
    left join "Track" as T on t."GenreId" = g."GenreId"
    GROUP BY G."GenreId", G."Name"; -- O Name

-- Ej 3 obtener los artistas que no tienen albumes
select A."ArtistId", A."Name"
	from "Artist" as A
    where a."ArtistId" not in (select album."ArtistId" from "Album" as album);
  
select ar."ArtistId", ar."Name"
	from "Artist" as ar
    left outer join "Album" as al on ar."ArtistId" = al."ArtistId"
    where al."AlbumId" is NULL;
    
-- Ej 4 listar el nombre y la cantidad de tracks de los artistas con mas de 50 tracks, ordenando por cantidad de tracks de forma ascendente
select ar."Name", COUNT(*)
	FROM "Artist" AS ar, "Track" as tr, "Album" as al
    where 
    	tr."AlbumId" = al."AlbumId" and 
        al."ArtistId" = ar."ArtistId"
    group by ar."ArtistId", ar."Name"
    having count(*) > 50
    order by count(*);

select ar."Name", COUNT(*)w
	FROM "Artist" AS ar
        inner join "Album" as al on al."ArtistId" = ar."ArtistId"
        inner join "Track" as tr on tr."AlbumId" = al."AlbumId" 
    group by ar."ArtistId", ar."Name"
    having count(*) > 50
    order by count(*)
    
-- Ej 5 para cada cliente obtener la cant de empleados que viven en la misma ciudad ordenados descendentemente por cantidad de empleados.
select cu."CustomerId", em."City", COUNT(em."EmployeeId")
	from "Customer" as cu
    	left outer join "Employee" as em on em."City" = cu."City"
    group by cu."CustomerId", em."City"
    order by COUNT(em."EmployeeId") DESC

-- EJ 6 obtener el dinero recaudado por cada empleado durante cada año
-- vamos a tener que extraer el año de la fecha con alguna func. date_part de postgresql
select em."EmployeeId", em."LastName", date_part('year', inv."InvoiceDate") as year, sum(inv."Total") as total
	from "Employee" as em
	left outer join "Customer" as cu on cu."SupportRepId" = em."EmployeeId"
    left outer join "Invoice" as inv on inv."CustomerId" = cu."CustomerId"
    group by em."EmployeeId", em."LastName", year