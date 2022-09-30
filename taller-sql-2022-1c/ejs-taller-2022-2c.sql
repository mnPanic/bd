-- Ejs taller 2022 2c --
-- Orden 16
-- Ej 1 - Obtener la cantidad de ventas por año discriminando por país

SELECT
    date_part('year', i.invoice_date) as year,
    i.billing_country,
    COUNT(i.invoice_id) as num_sales
FROM invoice i
GROUP BY year, i.billing_country
ORDER BY year, i.billing_country

-- Ej 2 - Cuáles son lo artistas que tienen más álbumes

-- Estrategia: quiero contar la cantidad de álbumes que tiene cada artista, y luego
-- me quedo con los que esa cantidad es mayor a la del resto de todos los artistas.
SELECT a.artist_id, a.name, COUNT(al.album_id) AS num_albums
FROM artist a
    JOIN album al ON al.artist_id = a.artist_id
GROUP BY a.artist_id
HAVING COUNT(al.album_id) >= ALL (
    SELECT COUNT(al.album_id)
    FROM artist a
        JOIN album al ON al.artist_id = a.artist_id
    GROUP BY a.artist_id
)

-- Ej 3 - Obtener el precio del track más caro para cada género indicando el álbum al que pertenece

-- Duda: está bien devolver más de un álbum?

SELECT
    g.genre_id,
    g.name,
    t.unit_price as max_track_price,
    al.title as album
FROM genre g
    JOIN track t ON t.genre_id = g.genre_id
    JOIN album al ON t.album_id = al.album_id
WHERE t.unit_price = (
    SELECT MAX(t2.unit_price)
    FROM track t2
    WHERE t2.genre_id = g.genre_id


-- Ej 4: Cuales son los artistas que más tracks vendieron

-- Un track está vendido si aparece en un invoice line, entonces la cantidad de ventas de un track
-- está determinada por la cantidad de veces que aparece en un invoice line.

SELECT ar.artist_id, ar.name, COUNT(il.invoice_line_id) AS sold_tracks
FROM artist ar
    JOIN album al ON al.artist_id = ar.artist_id
    JOIN track t ON t.album_id = al.album_id
    JOIN invoice_line il ON il.track_id = t.track_id
GROUP BY ar.artist_id, ar.name
HAVING COUNT(il.invoice_line_id) >= ALL (
    SELECT COUNT(il.invoice_line_id)
    FROM artist ar
        JOIN album al ON al.artist_id = ar.artist_id
        JOIN track t ON t.album_id = al.album_id
        JOIN invoice_line il ON il.track_id = t.track_id
    GROUP BY ar.artist_id
)

-- Ej 5 - Listar playlists cuyos tracks tengan al menos dos álbumes

-- Está bien partir de playlist_track en vez de playlist y hacer inner en vez de left join
-- para hacer el select dado que si la playlist no tiene tracks, entonces no van a poder ser
-- de al menos dos álbumes.
--
-- Tengo que hacer count distinct porque una playlist puede tener varios tracks del mismo álbum
SELECT pt.playlist_id, p.name, COUNT(distinct al.album_id) AS num_albums
FROM playlist_track pt
    JOIN track t ON t.track_id = pt.track_id
    JOIN album al ON al.album_id = t.album_id
    JOIN playlist p ON p.playlist_id = pt.playlist_id -- este join no es estrictamente necesario pero me gusta agregar el nombre
GROUP BY pt.playlist_id, p.name
HAVING COUNT(distinct al.album_id) >= 2
ORDER BY num_albums DESC

-- Ej 6 - Realizar una consulta correlacionada que devuelva, si es que lo hubiera, todas las 
-- playlists que tengan algún track cuyo álbum incluya la palabra "Live"

WITH foo AS (
SELECT p.playlist_id, p.name
FROM playlist p
WHERE EXISTS (
    -- Existe un track cuyo álbum incluye la palabra "Live"
    SELECT t.track_id
    FROM track t
        JOIN playlist_track pt ON pt.track_id = t.track_id
        JOIN album al ON t.album_id = al.album_id
    WHERE 
        al.title LIKE '%Live%' AND
        p.playlist_id = pt.playlist_id -- Correlacionada porque está usando p que es de la outer query
)
)

SELECT p.playlist_id, p.name, t.name, al.title
FROM foo f
    JOIN playlist p ON p.playlist_id = f.playlist_id
    JOIN playlist_track pt ON pt.playlist_id = p.playlist_id
    JOIN track t ON t.track_id = pt.track_id
    JOIN album al ON t.album_id = t.album_id