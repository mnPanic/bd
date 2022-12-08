-- Ejs taller SQL, turno 2, 2022 1c --

-- Ej 1 - Obtener la cantidad de tracks por género

SELECT g.name, COUNT(t.track_id) as num_tracks
FROM genre g
    LEFT JOIN track t ON t.genre_id = g.genre_id
GROUP BY g.genre_id, g.name
ORDER BY num_tracks DESC

-- Ej 2 - Encontrar las facturas que tengan una cantidad de items mayor al promedio de todas las facturas (invoices)

-- Creo que no se puede hacer sin CTL, porque es una agregación (average) de otra agregación (count de items)

WITH items_by_invoice AS (
    SELECT i.invoice_id, COUNT(il.invoice_line_id) as num_items
    FROM invoice i
        JOIN invoice_line il ON il.invoice_id = i.invoice_id
    GROUP BY i.invoice_id
)

-- SELECT AVG(num_items) FROM items_by_invoice ~~~> aprox 5.4 que tiene sentido segun los datos

SELECT i.invoice_id, ii.num_items
FROM items_by_invoice ii
    JOIN invoice i ON i.invoice_id = ii.invoice_id
WHERE ii.num_items > (SELECT AVG(num_items) FROM items_by_invoice)

-- Ej 3 - Obtener las playlists que tienen los tracks más vendidos

--- Primero lo hago con with y después lo adapto (porque se va a poder sin)

-- Para saber cuales son los más vendidos, primero obtengo ventas por track
WITH sales_by_track AS (
    SELECT t.track_id, COUNT(il.invoice_line_id) as num_sales
    FROM track t
        JOIN invoice_line il ON il.track_id = t.track_id
    GROUP BY t.track_id
    ORDER BY num_sales DESC
)

-- Ahora puedo obtener los tracks más vendidos
-- SELECT st.track_id, st.num_sales
-- FROM sales_by_track st
-- WHERE st.num_sales = (SELECT MAX(num_sales) FROM sales_by_track)

-- Joineando con playlist me quedo con las playlists que contienen a esos tracks
SELECT DISTINCT pl.*
FROM sales_by_track st
    JOIN playlist_track pt ON pt.track_id = st.track_id
    JOIN playlist pl ON pl.playlist_id = pt.playlist_id
WHERE st.num_sales = (SELECT MAX(num_sales) FROM sales_by_track)

--- Lo hago sin with
SELECT DISTINCT pl.*
FROM track t
    JOIN playlist_track pt ON pt.track_id = t.track_id
    JOIN playlist pl ON pl.playlist_id = pt.playlist_id
    JOIN invoice_line il ON il.track_id = t.track_id
GROUP BY t.track_id, pl.playlist_id, pl.name
-- distinct porque como diferentes playlists pueden tener el mismo track, se puede repetir el invoice line
HAVING COUNT(distinct il.invoice_line_id) >= ALL (
    SELECT COUNT(il.invoice_line_id)
    FROM track t
        JOIN invoice_line il ON il.track_id = t.track_id
    GROUP BY t.track_id
)

-- Ej 4 - Encontrar los nombres de géneros para los cuales todos sus tracks fueron vendidos

-- Estrategia: obtengo los géneros con tracks no vendidos, y me quedo con los géneros que no son esos
SELECT DISTINCT g.name
FROM genre g
WHERE g.genre_id NOT IN (
    SELECT DISTINCT g.genre_id
    FROM genre g
        JOIN track t ON t.genre_id = g.genre_id
        LEFT JOIN invoice_line il ON il.track_id = t.track_id
    WHERE il.invoice_line_id IS NULL
)

-- Ej 5 - Realizar una consulta correlacionada que devuelva, si es que lo hay, todos los customers
-- que tengan alguna invoice cuya billing city sea diferente a la city del customer

-- Primero sin correlacionar
SELECT c.customer_id, i.billing_city, c.city
FROM customer c
    JOIN invoice i ON i.customer_id = c.customer_id
WHERE i.billing_city <> c.city

-- No hay ninguna. Ahora con correlacionada (al pedo)
SELECT c.customer_id
FROM customer c
WHERE EXISTS (
    SELECT *
    FROM invoice i 
    WHERE i.customer_id = c.customer_id AND 
        i.billing_city <> c.city
)

-- Ej 6 - Listar los tracks cuyos artistas tienen tracks en más de dos playlists

SELECT t.track_id, t.name as track, ar.name as artist
FROM track t
    JOIN album al ON al.album_id = t.album_id
    JOIN artist ar ON ar.artist_id = al.artist_id
    WHERE ar.artist_id IN (
        -- Artistas con tracks en más de dos playlists
        SELECT ar2.artist_id
        FROM artist ar2
            JOIN album al2 ON al2.artist_id = ar2.artist_id
            JOIN track t ON t.album_id = al2.album_id
            JOIN playlist_track pt ON pt.track_id = t.track_id
        GROUP BY ar2.artist_id
        HAVING COUNT(distinct pt.playlist_id) > 2
    )