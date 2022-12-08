-- Ejs taller SQL, turno 1, 2022 1c --

-- Ej 1 - Obtener la cantidad de álbumes por género
SELECT g.name, COUNT(distinct a.album_id) cant_albumes
FROM genre g
    LEFT JOIN track as t ON t.genre_id = g.genre_id
    LEFT JOIN album as a ON t.album_id = a.album_id
GROUP BY g.genre_id, g.name
ORDER BY cant_albumes DESC

-- Ej 2 - Encontrar las facturas que tengan un importe total mayor al promeido de todas las facturas (invoices)

SELECT i.invoice_id, i.total
FROM invoice i
WHERE i.total > (
    SELECT AVG(total) FROM invoice
)

-- Ej 3 - Obtener el género de los tracks que están contenidos en la mayor cantidad de playlist

WITH track_cant AS (
    SELECT pt.track_id, COUNT(pt.playlist_id) as cant_playlist
    FROM playlist_track pt
    GROUP BY pt.track_id
    ORDER BY cant_playlist DESC
)

SELECT DISTINCT g.name
FROM track_cant tc
    JOIN track t ON t.track_id = tc.track_id
    JOIN genre g ON g.genre_id = t.genre_id
WHERE tc.cant_playlist = (SELECT MAX(cant_playlist) FROM track_cant)

--- Sin select en el FROM
SELECT DISTINCT g.name
FROM genre g
    JOIN track t on t.genre_id = g.genre_id
    JOIN playlist_track pt on pt.track_id = t.track_id
GROUP BY pt.track_id, g.name
HAVING COUNT(pt.playlist_id) >= ALL (
    SELECT COUNT(pt.playlist_id)
    FROM playlist_track pt
    GROUP BY pt.track_id
)

-- Ej 4 - Encontrar los nombres de los géneros para los cuales sus tracks fueron vendidos más de dos veces

SELECT g.name, COUNT(il.invoice_id) as num_sales
FROM genre g
    JOIN track t ON t.genre_id = g.genre_id
    JOIN invoice_line il ON il.track_id = t.track_id
GROUP BY t.track_id, g.name
HAVING COUNT(il.invoice_id) >= 2 -- deberia ser > 2 pero no da resultados
ORDER BY num_sales DESC

-- Ej 5 - Realizar una consulta correlacionada que devuelva, si es que las hay, todas las playlists que tengan algún track del álbum "Afrociberdelia"
-- > Una subconsulta correlacionada es una subconsulta que utiliza los valores de la consulta exterior en su cláusula WHERE

-- Sin correlacionada
SELECT DISTINCT pt.playlist_id
FROM playlist_track pt
    JOIN track t ON t.track_id = pt.track_id
    JOIN album al ON t.album_id = al.album_id
WHERE al.title = 'Afrociberdelia'

-- Correlacionada? Pero no tiene sentido
SELECT DISTINCT p.playlist_id
FROM playlist p
WHERE EXISTS (
    SELECT *
    FROM playlist_track pt
        JOIN track t ON t.track_id = pt.track_id
        JOIN album al ON t.album_id = al.album_id
    WHERE 
        al.title = 'Afrociberdelia' AND
        pt.playlist_id = p.playlist_id
)

-- Ej 6 - Listar las playlists cuyos tracks sean de no más que dos álbumes
SELECT pt.playlist_id, COUNT(distinct al.album_id) AS num_albums
FROM playlist_track pt
    JOIN track t ON t.track_id = pt.track_id
    JOIN album al ON al.album_id = t.album_id
GROUP BY pt.playlist_id
HAVING COUNT(distinct al.album_id) <= 2
ORDER BY num_albums DESC

-- Me fijo que onda esas dos, efectivamente no tienen más de dos álbumes porque tienen un solo track cada una
SELECT *
FROM playlist as p
    JOIN playlist_track pt ON pt.playlist_id = p.playlist_id
    JOIN track t ON pt.track_id = t.track_id
WHERE p.playlist_id = 18 OR p.playlist_id = 9