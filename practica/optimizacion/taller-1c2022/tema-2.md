# Tema 2

## Consulta 1

El primero es SARGable y el 2do no.

Query 1

- Como hay un índice nonclustered por LastName, FirstName y MiddleName que está
  ordenado por esos campos, puede navegar hasta la pirmera hoja que cumple que
  LastName > Adam (el primer campo por el que se ordena en el índice) y revisar
  desde ahí los que tienen FirstName > Lili.

  Como la query solamente pide FirstName y LastName, no es necesario hacer un
  Key Lookup para ir a la tabla a obtener el resto de las columnas, ya que el
  índice cubre a la query (todo lo necesario está ahí).

Query 2

- Como la condición es que sea diferente, no queda otra que hacer un scan de
  todos y comparar uno por uno. No es SARGable.

- De todas formas, hace el Scan sobre el índice nonclustered en vez del
  clustered porque cubre a la query y es más chico que el clustered (ocupa menos
  páginas y es más rápido de scannear).

## Consulta 2

Query 1

- Hace primero el where con un seek por la PK de SalesOrderHeader y luego join
  con SalesOrderDetail aprovechando que está indexado por lo mismo

- Como son pocos es más rápido esto que hacer un scan y merge

Query 2

- Como hay que devolver todas las filas y están indexadas por el mismo campo en
  un índice clustered, se puede usar merge join haciendo scan de ambos clustered
  index que devuelven el resultado ordenado bajo el mismo criterio.

## Consulta 3

Query 1

- Product tiene un clustered index por ProductID porque es su PK
- En cambio ProductReview tiene un nonclustered por ProductID.
- Hace un Scan del nonclustered, por cada row un key lookup (porque es necesario
  obtener todas las columnas) y eso le da una tabla que está ordenada de la
  misma forma que ProductID
- Como es un right join y tiene que quedarse con todos los productos sin
  importar que tengan review, como por las estadísticas sabe que son muchos
  productos, es más rápido hacer un merge join.

Query 2

- Como tiene que hacer un inner join y quedarse con los productos que tienen
  reviews y son pocos, es más rápido hacer directamente un nested loops.
- Puede hacer un clustered index scan de ProductReview tiene dentro el ProductID
  (por el tipo de relación) y luego hacer un seek por cada uno en el índice
  clustered de Product, que es eficiente.

## Consulta 4

Query 1

- Como sabe que son muchos resultados, hace un Scan del clustered index, que es
  más rápido que hacer el scan en el otro índice y keylookup por cada uno.

Query 2

- Como conoce la demografía de los datos, sabe que son pocas las direcciones de
  la City Newark.
- No tiene un índice por el que pueda hacer seek, dado que el índice existente
  ordena primero por AddressLine1 y no por city. Pero de todas formas es más
  rápido hacer un scan hasta encontrar el único que es de esa ciudad y luego
  hacer un Key Lookup para obtener el resto de las columnas.

## Consulta 5

MinOrderQTY (int) no es nulleable y OnOrderQty (int) si.

Query 1

- Como MinOrderQTY no es nulleable, la cantidad de apariciones es la misma que
  la cantidad de filas. Por lo tanto, es más rápido contar la cantidad haciendo
  un scan de un índice nonclustered porque es más chico que el clustered (tiene
  menos columnas, entonces ocupa menos páginas y toma menos accesos a disco para
  leer).

Query 2

- Como OnOrderQty si es nulleable, no le queda otra que hacer un scan del
  clustered index (no hay un nonclustered por esa columna) e ir fila por fila
  viendo si es null o no para contarlo.

## Consulta 6

Las dos consultas se implementan mediante seeks

- En la query 1, puede hacer tres seeks
- En la query 2, el between es SARGable (puede ir a la primera hoja que cumple y
como estan ordenados puede leer las siguientes desde ahí)