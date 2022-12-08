# Practica clase

## Consulta 1

Query 1:

- Como el where es por `NationalIDNumber` y hay un índice nonclustered por ese
  campo, se hace un seek para ir a la hoja en donde está y encontrarlo eficientemente.
- Como también se pide la columna `HireDate` que no forma parte del índice (al
  no ser parte de la clave unclustered ni haber sido agregada con `INCLUDE`), es
  necesario tomar la clave clustered (PK) y hacer un key lookup en la tabla
  original. Luego los resultados se juntan con nested loops (como siempre es el
  caso con los key lookups)

Query 2:

- Hace un seek en el mismo índice nonclustered de antes (por `NationalIDNumber`,
  que es lo que se usa en el where).
- Pero como `BusinessEntityID` es la PK, ya está en el índice nonclustered (que
  es necesario para poder hacer los key lookups), entonces no hace falta hacer
  un key lookup y nested loops para ir a buscarla a la tabla original. Ya está
  en la hoja.

## Consulta 2

Las queries son iguales, pero cambia que en la 2da es necesario hacer una
conversión implicita del ID.

- En la primera hace uso del seek para encontrar el resultado eficientemente
- En la segunda, no puede hacer un seek porque tiene que hacer la conversión de
  integer a string. Debe escanear los índices hasta encontrar el que matchea con
  el valor convertido.

## Consulta 3

`UnitPrice` no es nulleable, y `CarrierTrackingNumber` si.

Query 1

- Como estamos haciendo un COUNT y va a ser necesario barrer toda la columna,
  vale la pena hacer un Scan en vez de un Seek sobre algún índice.
- Como `UnitPrice` no es nulleable, la cantidad que haya va a ser igual a la
  cantidad de filas/registros, entonces en vez de hacer un Scan del índice
  clustered de la tabla, se puede hacer sobre cualquier índice nonclustered más
  chico y será más rápido. Como están ordenados se puede usar stream aggregate.
- Al ser la cantidad de UnitPrice igual a la cantidad de ProductID (tampoco
  nulleable), basta con contar cualquiera para obtener la cantidad de registros
  de la tabla.

Query 2

- En cambio para el segundo, como es nulleable, para cada fila es necesario
  ver si es null para no contarla. Por lo tanto, es necesario scannear el índice
  clustered (PK) que tiene esa columna.

## Consulta 4

Query 1

- Se omite la tabla `SpecialOffer` en el join porque no aporta nada al query, ya
  que en el resultado solo se pide una columna de la tabla `Product`.

  Devuelve los ProductNumber que surgen del matcheo entre SpecialOfferProduct y
  Product a través de ProductID. Pero por integridad referencial, sabe que
  SpecialOffer no tiene vínculo con Product, entonces no agrega nada que se haga
  ese join.

- El join entre `SpecialOfferProduct` y `Product` se hace por `ProductID`, que
  es la PK de `Product` (entonces tiene índice clustered por él). Como además
  `SpecialOfferProduct` tiene un índice nonclustered por esa columna, se puede
  hacer un merge join ya que ambos devuelven resultados ordenados de la misma
  manera.

Query 2

- Como en esta query se piden todas las columnas resultantes, es necesario hacer
  todos los joins y no se puede saltear como antes.

- El join entre `SpecialOfferProduct` y `SpecialOffer` se hace por
  `SpecialOfferID` (PK de `SpecialOffer`). Se implementa con nested loops porque
  no hay índice con esa columna en `SpecialOfferProduct`. Es rápido porque puede
  usar el índice clustered de SpecialOffer para buscar los matches
- Para el join final se usa un hash match porque el resultado del join anterior
  no viene ordenado (ni tiene un índice) y tiene un volúmen alto.

## Consulta 5

Query 1

- Como la tabla `Address` tiene un índice nonclustered por StateProvinceID, se
  hace un seek y luego un key lookup porque el índice no cubre la consulta (hay
  columnas que no forman parte del índice y es necesario buscarlas en la tabla)

- Se hace seek en vez de scan porque por estadísticas se estima que hay pocas
  con id 32 (1 sola actual)

Query 2

- Se hace scan de toda la tabla directamente porque las estadísticas dicen que
  hay muchas con id 20 (308 actual)

## Consulta 6

Hay un índice por Last name, first name y middle name

Query 1

- El optimizador convierte el like 'Duffy%' en un un rango. Esto permite que
  haga un seek.

  Se puede ver en "seek predicates"

    [AdventureWorks2017].[Person].[Person].LastName >= Scalar
    Operator(N'Duffy'), End: [AdventureWorks2017].[Person].[Person].LastName <
    Scalar Operator(N'DuffZ')

- Como el like comienza con un prefijo constante, puede ir directo al valor (ya
  que están ordenados en la estructura de arbol B) y comenzar la búsqueda desde
  allí de todos los que matchean.

- Luego hace key lookup porque el índice no cubre la consulta (se piden todas
  las cols)

Query 2

- El optimizador no puede convertir el like en algo que permita hacer seek
  (arranca con un prefijo variable, `%`), por lo que no le queda otra que
  scannear todo el índice y ver los que matchean.

> Duda: Por qué elige hacer scan sobre el índice nonclustered de nombres en vez
> de sobre la tabla directamente para evitarse el key lookup? (debe ser más
> caro, pero por qué)

En ambos es casos es posible hacer un key-lookup porque si bien las hojas de los
índices non-clustered no contienen toda la información de la fila, lo que sí
contienen es el row identifier, que será la primary key (clustered index) si la
tabla la tiene y rowid (dirección física del heap) en caso de que la tabla no
tenga primary key.

Experimento:

```sql
-- prueba nuestra, hace un scan porque está ordenado por lastname el indice
select * from Person.Person where FirstName Like 'Duffy%' 
```

El índice está ordenado lexicográficamente por tres cosas a la vez. Si busco
algo que no es el primero, no voy a poder usar ese orden, y voy a tener que
hacer un scan.

## Consulta 7

`EndDate` (`datetime`) es nulleable y `OrderQty` (`int`) no

`ScrapReasonID` es smallint nulleable

Query 1

- Como EndDate es nulleable, tiene que hacer un scan del clustered index de la
  PK para ver fila por fila si es null o no y contarlo

Query 2

- Como OrderQty no es nulleable, la cantidad de apariciones va a ser igual a la
  cantidad de filas, entonces puede hacer un scan de cualquier índice

- Elige hacerlo en el unclustered de ScrapReasonID ya que es smallint, por lo
  que va a ser más chico el índice y más rápido.

  Como small int es más chico que int, entran más entries en una página y el
  índice ocupa menos páginas, con lo que con menos IO reads lo lees todo.

- Sin embargo, ScrapReasonID es nulleable. Pero eso no es un problema, porque el
  unclustered tiene una entry para null que lleva a todas las rows que tienen el
  campo como null.

## Consulta 8

Pre indice:

- Como no hay un índice por género, tiene que escanear toda la tabla
  (clustered de la PK) para comparar el género (filtrando)

Post indice

- De todas formas hace un scan en vez de un seek. Esto es porque al ser 84/290
  resultados, es más rápido hacer un scan en vez de un seek + key lookup por
  cada uno.

- Problema: **Selectividad** del índice. Como la selectividad de Gender es baja,
  no conviene usar un índice

Experimento mío:

Si la query se cambia por esto

```sql
select e.Gender from HumanResources.Employee as e where e.Gender = 'F';
```

como solo es necesario tomar el género y no hace falta hacer el key lookup para
cada uno, hace seek.

## Consulta 9

- SalesOrderDetail tiene una PK compuesta en parte por SalesOrderID (es una
  entidad débil)
- SalesOrderHeader tiene una PK por sales order ID

Query 1

- Como se puede en ambos porque tienen un índice clustered que permite buscar
  por SalesOrderID, y estadísticamente se sabe que van a ser pocas, primero se
  filtra los que tengan de ese ID en ambas tablas por separado y después se hace
  el join con nested loops

Query 2

- Como no hay filtrado, hay que hacer un join entre ambas columnas como están.
- Como ambas están ordenadas por el mismo criterio (porque tienen índices
  clustered por ese ID) y la condición del join es por igualdad (equijoin) los
  resultados vienen ordenados y se puede usar un merge join

## Consulta 10

Query 1

- Como hay pocos tipos de tarjetas de crédito (tiene la información por
  estadísticas), arma una tabla de hash para ir contando (es como si fuera un
  counting sort)
- El hash match es eficiente en tablas grandes donde los datos no están
  ordenados y su cardinalidad se estima en pocos grupos.

Query 2

- En cambio la query 2 al tener más variación de los valores (es unique), no
  puede usar un hash match y tiene que contar todos los distintos.
- Como hay un índice nonclustered por CardNumber, cuenta las ocurrencias de ese
  haciendo un scan en vez de usar el índice clustered que sería más lento (al
  ser más largo)
- No hace filtro ni agregación porque sabe que todos los valores van a ser
  distintos.