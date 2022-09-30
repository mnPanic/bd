-- Ejs parcial ale --

-- Ej 1 - Calcular para cada artista el o los albums con las canciones de mayor duración

SELECT DISTINCT ar.name, al.title
FROM artist ar
    JOIN album al ON al.artist_id = ar.artist_id
    JOIN track t ON t.album_id = al.album_id
WHERE t.milliseconds = (
    -- Canciones de mayor duración
    SELECT MAX(milliseconds) FROM track
)

-- Duda: tal vez debería filtrar por media type name LIKE %audio%, porque el que dio más alto es una película.
SELECT * 
FROM track t
    JOIN album al ON t.album_id = al.album_id
    JOIN media_type m ON t.media_type_id = m.media_type_id
ORDER BY milliseconds DESC

SELECT DISTINCT name FROM media_type

-- Ej 2 - Realizar una consulta que liste fecha, dirección, país y ciudad de facturación de las
-- invoices cuyo total sea superior al promedio de todos los total de las invoices de Belgium

SELECT i.invoice_date, i.billing_address, i.billing_country, i.billing_city
FROM invoice i
WHERE i.total > (
    SELECT AVG(total)
    FROM invoice
    WHERE billing_country = 'Belgium'
)

-- Ej 3 - Obtener el promedio de tracks por album en las playlists. El resultado debe ser Album,
-- Promedio (donde promedio es el promedio de tracks de ese artista en las playlist)

-- Ejercicio raro, no se si estoy interpretando mal la consigna o que

WITH tracks_by_artist AS (
    SELECT ar.artist_id, pt.playlist_id, COUNT(pt.track_id) num_tracks
    FROM artist ar
        LEFT JOIN album al ON al.artist_id = ar.artist_id
        LEFT JOIN track t ON t.album_id = al.album_id
        LEFT JOIN playlist_track pt ON pt.track_id = t.track_id
    GROUP BY ar.artist_id, pt.playlist_id
    ORDER BY num_tracks DESC
)

SELECT al.album_id, ar.artist_id, ar.name, AVG(ta.num_tracks) avg_tracks
FROM album al
    JOIN artist ar ON al.artist_id = ar.artist_id
    JOIN tracks_by_artist ta ON ta.artist_id = ar.artist_id
GROUP BY al.album_id, ar.artist_id
ORDER BY avg_tracks DESC

-- Ej 4 - Realizar una consulta correlacionada que me devuelva si es que lo hubiera todas las
-- playlists que tengan algún track del álbum "the best of billy cobham"

SELECT p.*
FROM playlist p
WHERE EXISTS (
    SELECT *
    FROM playlist_track pt
        JOIN track t ON t.track_id = pt.track_id
        JOIN album al ON t.album_id = al.album_id
    WHERE al.title = 'The Best Of Billy Cobham'
        AND pt.playlist_id = p.playlist_id
)
