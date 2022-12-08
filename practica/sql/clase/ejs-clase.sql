-- Ej 1 - Listar para cada track el nombre del mismo, el genero y el media type.

SELECT
    t.name AS track, 
    mt.name AS media, 
    g.name AS genre
FROM track AS t
    join media_type AS mt ON t.media_type_id = mt.media_type_id
    join genre AS g ON t.genre_id = g.genre_id

-- Ej 2 - Listar la cantidad de tracks que tiene cada género

SELECT g.name, COUNT(t.track_id)
FROM genre g
    LEFT JOIN track AS t ON t.genre_id = g.genre_id
GROUP BY g.genre_id, g.name

-- Ej 3 - Obtener los artistas que no tienen álbumes. Dar al menos dos soluciones distintas.

--- Sol 1
SELECT ar.*
FROM artist ar
    WHERE 0 = (
        SELECT COUNT(al.album_id)
        FROM album AS al
        WHERE al.artist_id = ar.artist_id
    )


--- Sol 2
SELECT ar.*
FROM artist ar
    LEFT JOIN album AS al ON al.artist_id = ar.artist_id
WHERE al.album_id IS NULL

--- Sol 3
SELECT ar.*
FROM artist ar
where ar.artist_id NOT IN (
    SELECT DISTINCT artist_id FROM album
)

-- Ej 4 - Listar el nombre y la cantidad de tracks de los artistas con más de 50 tracks, ordenando por cantidad de forma ascendente

SELECT 
    ar.name,
    COUNT(tr.track_id) as num_tracks
FROM artist ar
    JOIN album al ON al.artist_id = ar.artist_id
    JOIN track tr ON tr.album_id = al.album_id
GROUP BY ar.artist_id, ar.name
HAVING COUNT(tr.track_id) > 50
ORDER BY num_tracks ASC

-- Ej 5 - Para cada cliente obtener la cantidad de empleados que viven en la misma ciudad ordenados descendentemente por cantidad de empleados

SELECT cu.customer_id, cu.first_name, cu.last_name, COUNT(em.employee_id) AS num_employees
FROM customer cu
    left JOIN employee em ON
        cu.country = em.country AND
        cu.state = em.state AND
        cu.city = em.city
GROUP BY cu.customer_id, cu.first_name, cu.last_name
ORDER BY num_employees DESC

-- Ej 6 - Obtener el dinero recaudado por cada empleado durante cada año

SELECT em.employee_id, em.last_name, SUM(i.total) as total, date_part('year', i.invoice_date) as year
FROM employee em
    JOIN customer cu ON em.employee_id = cu.support_rep_id
    JOIN invoice i ON i.customer_id = cu.customer_id
    GROUP BY em.employee_id, em.last_name, year
ORDER BY year, total

-- Ej 7 - Obtener la cantidad de pistas de audio que tengan una duración superior a la duración promedio de todas las pistas de audio.
-- Además, obtener la sumatoria de la duración de todas esas pistas en minutos.

SELECT COUNT(t.track_id), SUM(t.milliseconds / (1000 * 60)) as duration_minutes
FROM track t
    JOIN media_type m ON t.media_type_id = m.media_type_id
WHERE 
    m.name LIKE '%audio%' AND
    t.milliseconds > (
        SELECT AVG(t2.milliseconds)
        FROM track t2
            JOIN media_type m2 ON t2.media_type_id = m2.media_type_id
        WHERE m2.name LIKE '%audio%'
    )

-- Ej 8
-- (a) Crear una vista que devuelva las playlists que tienen al menos una pista del g ́enero “Rock”.
-- (b) Utilizando la vista, obtener la cantidad de playlists que no poseen pistas de dicho g ́enero.

CREATE OR REPLACE VIEW playlists_with_rock_tracks AS
    SELECT DISTINCT p.playlist_id, p.name
    FROM playlist p
        JOIN playlist_track pt ON pt.playlist_id = p.playlist_id
        JOIN track t ON t.track_id = pt.track_id
        JOIN genre g ON t.genre_id = g.genre_id
        WHERE t.track_id IN (
            SELECT t.track_id
            FROM track t
                JOIN genre g ON t.genre_id = g.genre_id
            WHERE g.name = 'Rock'
        )

-- alternativa de la cátedra para lo del AS
-- SELECT DISTINCT p.playlist_id, p.name FROM playlist p WHERE p.playlist_id = ANY (
-- SELECT pt.playlist_id FROM playlist_track pt
-- INNER JOIN track t ON pt.track_id = t.track_id
-- INNER JOIN genre g ON t.genre_id = g.genre_id WHERE g.name = 'Rock' )

SELECT COUNT(playlist_id)
FROM playlist
WHERE playlist_id NOT IN ( SELECT playlist_id FROM playlists_with_rock_tracks)

-- Ej 9: Obtener las playlists más caras
-- Hint: Obtener primero el precio de cada playlist

WITH playlist_price AS (
    SELECT pt.playlist_id, SUM(t.unit_price) as price
    FROM playlist_track pt
        JOIN track t ON t.track_id = pt.track_id
    GROUP BY pt.playlist_id
)

SELECT pl.*, pp.price
FROM playlist pl
    JOIN playlist_price pp ON pp.playlist_id = pl.playlist_id
    WHERE pp.price >= ALL (SELECT price from playlist_price)
    -- Alternativa de la catedra
    --WHERE pp.price = (SELECT MAX(price) from playlist_price)