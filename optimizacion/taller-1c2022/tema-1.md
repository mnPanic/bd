# Practica taller, tema 1 1c2022

## Consulta 1

Query 1

- Como pide ordenar por nombre, y cuenta con un índice unclustered por esa
  columna, hace Scan de él para obtenerlos ordenados y omitir ordenar.
- Luego, por cada fila tiene que hacer el lookup del resto de las columnas de la
  tabla. Esto es necesario porque el índice al ser unclustered y solo de Name,
  solo tiene la clave del índice clustered (de la PK) y no el resto de las
  columnas (el índice no cubre a la consulta.)

- La alternativa hubiera sido hacer scan de la columna con el índice clustered y
  después ordenar, pero esto es más rápido porque son pocos lookups (tiene los
  datos estadísticos).

Query 2

- Name no es nulleable, entonces va a tener que buscar todas las filas.
- Acá sí es más rápido hacer scan directo del índice clustered que tiene todos
  los datos, ya que se van a tener que ver todas las filas (dado que no es
  nulleable)

## Consulta 2

Vista en la clase

## Consulta 3

Query 1

- Como hace un > all y luego un select, la query del select se debería
  recomputar para cada una de la outer query. Usa un Table Spool para guardar el
  resultado y poder reutilizarlo.

Query 2

- Para calcular el max, hace un scan del clustered index que le da los datos
  ordenados, y luego usa Stream Aggregate que tiene ese requerimiento. Luego
  hace un nested loops para comparar cada uno con el max a ver con cual se queda.

- Como necesita todas las columnas, también usa el clustered index.

## Consulta 4

Vista en la clase

## Consulta 5

Query 1

- Como UnitPrice no es nulleable, su count coincide con la cantidad de filas.
  Por lo tanto puede hacer un scan de cualquier índice más chico para contar
  cuantos hay.

  UnitPrice es money y SalesOrderID es int que es más chico, por lo que entran
  más en una página y tiene que leer menos páginas para scannearlo todo.

Query 2

- Como tiene que hacer una suma de un valor que no está en un índice
  nonclustered, tiene que hacer el scan de toda la tabla (con el índice
  clustered) para obtener los valores ordenados y poder usar Stream Aggregate.

## Consulta 6

Vista en la clase