-- Ejs taller 2022 2c, Turno 2 --

-- Manuel Panichelli, L.U 72/18
-- Orden 16

-- Ej 1 --
-- Obtener la cantidad de ventas por año discriminando por país

SELECT
    date_part('year', i.invoice_date) as year,
    i.billing_country,
    COUNT(i.invoice_id) as num_sales
FROM invoice i
GROUP BY year, i.billing_country
ORDER BY year, num_sales -- no está pedido por el enunciado pero me gusta más como queda con esto

-- Ej 2 --
-- Cuáles son lo artistas que tienen más álbumes

-- Estrategia: quiero contar la cantidad de álbumes que tiene cada artista, y luego
-- me quedo con los que tienen cantidad mayor a la de todos los otros artistas.

-- Para este y otros ejercicios, si me hubieran pedido dar la cantidad de álbumes por artista
-- debería haber hecho un left join para contemplar a los artistas que no tienen álbumes (y que de 0).
-- Como sé que hay artistas que tienen álbumes, el resultado de la query no cambia poniendo inner o
-- left join. Si quisiera que la query sea agnóstica a los datos y más correcta, debería haber
-- puesto left join, pero para simplificar lo dejé con inner.

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

-- Ej 3 --
-- Obtener el precio del track más caro para cada género indicando el álbum al que pertenece

-- Agrego DISTINCT porque puede haber más de un track que tenga el precio máximo,
-- y que más de uno de ellos pertenezca al mismo álbum.

SELECT DISTINCT
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
)

-- Ej 4 --
-- Cuales son los artistas que más tracks vendieron

-- Un track está vendido si aparece en un invoice line, entonces la cantidad de ventas de un track
-- está determinada por la cantidad de invoice lines con los que se relaciona.

SELECT ar.artist_id, ar.name, COUNT(il.invoice_line_id) AS tracks_sold
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

-- Ej 5 --
-- Listar playlists cuyos tracks tengan al menos dos álbumes

-- Tengo que hacer count distinct porque una playlist puede tener varios tracks del mismo álbum

SELECT pt.playlist_id, p.name, COUNT(distinct al.album_id) AS num_albums
FROM playlist_track pt
    JOIN track t ON t.track_id = pt.track_id
    JOIN album al ON al.album_id = t.album_id
    JOIN playlist p ON p.playlist_id = pt.playlist_id -- este join no es estrictamente necesario pero me gusta agregar el nombre
GROUP BY pt.playlist_id, p.name
HAVING COUNT(distinct al.album_id) >= 2
ORDER BY num_albums DESC

-- Ej 6 --
-- Realizar una consulta correlacionada que devuelva, si es que lo hubiera, todas las 
-- playlists que tengan algún track cuyo álbum incluya la palabra "Live"

SELECT p.playlist_id, p.name
FROM playlist p
WHERE EXISTS (
    -- Existe un track de la playlist cuyo álbum incluye la palabra "Live"
    SELECT t.track_id
    FROM track t
        JOIN playlist_track pt ON pt.track_id = t.track_id
        JOIN album al ON t.album_id = al.album_id
    WHERE 
        al.title LIKE '%Live%' AND
        p.playlist_id = pt.playlist_id -- Correlacionada porque está usando p que es de la outer query
)