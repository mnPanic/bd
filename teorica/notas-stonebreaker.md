# Notas stonebreaker

- Video 1: https://slideshot.epfl.ch/play/suri_stonebraker
- Video 2: https://www.postgresbuild.com/keynote_michael-stonebraker-2021

video 2:

- Cloud ->
  - save money
  - elasticidad (black friday para picos de tráfico, graveyard shifts en donde
    no hay)
- El pricing es complicado
  - Diferencia entre PaaS y DBaaS (te da elasticidad)
- Column store se comprime mejor que row store. Se usan para data warehouse
  - Column store con row executor: postgres, greenplum. Toma una fila, ve si le
    sirve y la guarda, sino la descarta y sigue con la siguiente.
  - con column executor: vertica, redshift, snowflake. Toma una columna (como
    vector de valores) y hace algo con ella.
  - En general en una query de un DW tiene muchísimas filas y pocas columnas.
    Entonces se ahorra mucho CPU con column excecutor (3-5x)
  - Star, snowflake schemas para DW
- Estrategias de performance
  - Reprogramar app para evPitar contención por control de concurrencia

QnA

- Diferencias en modelos de datos, que opina. 2005 -> modelo relacional. Ahora
  -> Sigue ganando el relacional (tenían un paper en draft, seguro ya salió)
- Post relational era? No va a estar, para él los sistemas relacionales son la
  respuesta.

  Todos crearon *on prem* messes, y estás bought in con sistemas legacy. No
  equivocarse con lo mismo de vuelta.
- 

Pensamientos

- Parece pedante (cambio de diapos, network problems que no fueron su culpa)

## Notas de la clase

Punto esencial: Las relacionales son lentas, el real work es una porción
chiquita (4%). El resto es "administrativo". 4 partes:

- Logging
  - Command logging: Guarda las queries que se ejecutan. Recuperación muy lenta.
    Hay que resolver la query y después.
  - El logging común es dato por dato, la recuperación es rápida
- Control de concurrencia
  - Solución: Single thread.
  - El que rescata es el de timestamp pero sin multiversión.
- Latching (esperar un recurso compartido)
- Buffering (para el disco)
  - Solución: Lo metes en memoria (se agrandan mas lento de lo que se abarata el HW)

Propone formas de arreglar cada una. Es importante arreglar todos y no solo uno.
Sino arreglas todo, sigue siendo lento

Mercado de base de datos:

- OLTP: Online transaction processing
- OLAP: Analitica

Solución para DBs DW: columnar. Normalmente quiero pocas columnas y muchas
filas, entonces si tengo guardado por columna en un bloque entran muchos datos.
Si tengo por fila, tengo que leer mucho más bloques para leer todas las columnas
de esa fila.

Por qué las bases nosql no sirven? Sirven siempre y cuando las relaciones son
conmutativas (por ej. publicaciones de facebook). Consistencia eventual: en
algún momento del tiempo, la bd va a estar toda uniforme, pero puede ser que no
lo esté.

En relacionales por qué no pasa? Tengo una DB con dos sitios, no pasa porque son
ACID. Son equivalentes a tener una sola copia de los datos. Hace que sea todo
consistente. Se comporta como si hubiera una sola copia de los datos (hay two
phase commit)

Bases de datos paralelas:

- Inter operation parallelism: reparte operaciones
- Intra operation parallelism: agarrar una operación y repartirla

como atacan las bd relacionales las queries muy grandes: agarran el query y lo
recortan. O recortan por operación o agarran el query y lo reparten.

Replicación vs fragmentación: 

- Siempre piensa en fragmentación en filas pero también se puede por columnas
  (normal por filas, y se llama sharding [horizontal])
- Duplicar los datos en diferentes lugares

Si hago fragmentación horizontal, lo hago para cada tabla? No, tiene que ser el
mismo criterio para todas las tablas. Para que las búsquedas sean locales, sino
tengo que ir a otro shard para las tablas a las que hago join.

> No hace falta usar criterios unificados entre tablas que no vas a joinear.
>
> Ejemplo AFIP: partis por contribuyentes y por empleados, fragmentas con
> lógicas diferentes. No tienen punto en común entonces no pasa nada.

Primera parte de la materia

- DER: Modelo de los datos.
- Tenés un modelo relacional, y lo pasamos al modelo relacional (MR).
  Características de las relaciones. Qué es una relación?

  Relación = conjunto (en el término más básico de conjunto), está incluida en
  el producto cartesiano.

  Importante que sea un conjunto porque **No hay duplicados**. Como no hay
  duplicados, implica que si o si hay un conjunto de attrs que identifican
  (clave candidata) y la que elijo es la primary key

- Formas normales = anomalías de redundancias de los datos.
  - Son una medida de la calidad del diseño de una tabla o una BD en término de
  la redundancia.
  - Dependencia funcional: una cosa que determina a la otra

- Índice: tabla ordenada igual que la columna: cluster. Sino unclustered.
  - Clave para hacer el key lookup o el row id si no tiene índice cluster.
- Schedule: una forma de ordenar las operaciones de una transacción
  - Propiedades deseables. Mecanismo ideal asegura serial
  - Historia equivalente a una historia ejecutada de manera serial
  - Isolation (I de ACID)
  - Ejemplo de atender facturas
- Data mesh
  - Forma en la que se organiza la explitación de datos.
- Data mining: torturar a los datos hasta que hablen
- Gobierno de datos: determinar quien es el administrador de los datos y
  asegurar la calidad hacia los usuarios

  > Antes se decía dueño y ahora ya no

  - Calidad: adecuación de los datos al uso. Habla de problemas o errores de
    calidad.

- bases nosql
  - Por qué surgen? Necesidades de escalabilidad que no pueden satisfacer las
    relacionales.
  - Características de nosql
    - Consistencia eventual
    - Redundancia
    - Flexibilidad: son schemaless, no tienen un esquema fijo como las
      relacionales.
    - Escalabilidad horizontal
  - Tipos: documentos, grafos, key value, column family, column store, in
    memory, stream
  - Stream: flujo de datos continuos. Se usan mucho para sensores. 

- Optimización: que las queries se ejecuten más rápido
  - Se encarga el optimizador, que toma el plan de ejecución
  - plan: es una **estrategia** para ejecutar una query

- Open data: datos de uso público que están abiertos.  

- Seguridad: 
  - Ley de datos personales: afecta privacidad.

- Control de concurrencia
  - Problemas que lo hacen necesario: modificion perdida, phantom problem, una más
  - y qué es? mecanismos que cuando llega una operación de un schedule dice si
    hay que procesarlo, rechazarlo o hacerlo esperar. El algoritmo que hace eso
   el control de concurrencia: optimista y pesimista.
  - binario, lock, timestamp
  - ts: a cada trx se le asigna un ts.

- long duration transaction:
  - ejemplo de la sube: varias etapas.
  - Pasan fronteras de distintas bases, el rollback es manual

Comentarios finales:

- final teórico, conceptual
  - puede haber estos campos, cuales son las claves candidatas
  - son cortitas y al pié, no hay que guitarrear
- Que diferencia hay entre consistencia y consistencia eventual
- durabilidad -> relación de las trx con checkpoints o logging
  - si hizo commit, está en la db
- vani está en la última fecha, cecilia en las primeras dos
- Chivo: Cecilia está dando dos optativas, una de calidad y gobierno de datos
  (más soft, más blanda) y otra de reglas de asociación

- Normalmente en diciembre es escrito. Orales 15m. Toma oral cuando hay pocos, y
  además virtual.
- De dónde estudiamos?
  - Calidad, data mining, data mesh, alcanza con las diapos (de las últimas
    clases)
  - Los del principio puede ayudar complementar con los libros. Por ej.
    optimización no alcanza con los slides.
  - Normalización: antes se daban más temas, en los libros seguro está más
    ampliado.

> Recomendación de película: Moneyball