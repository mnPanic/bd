# Preguntas

## Final 21/07/22 (Cecilia)

- Qué parte del DBMS se encarga de garantizar aislamiento
  - El módulo de control de concurrencia
- Modelás una biblioteca con un DER, dar una interrelación 1-n y una n-m
  - 1-n: Biblioteca libro (ejemplar)
  - n-m: biblioteca libro (abstracto) (pero sería otro modelo), empleado?
- Te daba una query en sql y había que escribirla en ar, dar el árbol canónico, dar 2 planes de ejecución y decir creo que una optimización que se pueda hacer si se tienen estadísticas sobre los datos
- Para qué sirve el logging y explicar undo/redo
  - Logging es el mecanismo que usa el recovery manager para hacer la
    recuperación en caso de fallas
  - UNDO/REDO es un tipo de logging en el cual los registros tienen el valor
    previo y el valor que se quiere escribir. Esto permite hacer UNDO de las
    transacciones incompletas, y REDO de las transacciones que estaban
    commiteadas pero sus valores no estaban en disco.
- Qué es gobierno de datos y su relación con calidad de datos
  - Gobierno de datos dice quien es el responsable de ellos, quien puede acceder
    y a qué cosas. Debe garantizar la calidad de los datos, que es una medida
    que determina que tan adecuados están los datos a su uso.
- Qué es falsa sumarización y qué nivel de aislamiento se necesita en sql para evitarlas

  ```
  T1      T2
  X-=N
          read X
          read Y
  Y+=N
          return x+y -> falsa sumarización!
  ```

  - El más alto: serializable
- Que es árbol de decisión y dar un ejemplo
  - Es un método de aprendizaje supervisado, de data mining
- Que dice el teorema CAP y relacionarlo con ACID
  - La relación con ACID es que en él se elige consistencia sobre disponibilidad.
- Por qué en No Sql se necesita la consistencia eventual
  - Porque se sacrifica para poder proveer disponibilidad y tolerancia a las
    particiones.
- Qué es open data y sus características principales
  - Datos abiertos provistos por diferentes organismos como empresas
- Qué es una ontología y dar un ejemplo
  - ?
- Diferencia entre datos estructurados y datos semi-estructurados
  - Datos estructurados son como XML o JSON que tienen cierta estructura, pero
    no es tan rígida como los estructurados en las bases relacionales.
- Tipos de fragmentación que puede haber en una base distribuida y dar ejemplos
  - Horizontal (sharding)
    - Ej: por pais
  - Vertical (por columna). Hay que duplicar la PK
    - Ej: ?

## Final 13/12/19 (Cecilia)

- Enunciar los métodos para resolver un JOIN y explicar uno de ellos.
  - Los operadores que se pueden usar para resolver un join son
    - Block nested loop join (BNLJ)
      - R |x| S y no tiene índices para ninguna de las dos tablas. Recorre todas
        las filas de R, y para cada una recorre todas las de S.
    - Index nested loop join (INLJ)
      - R |x| S pero tiene índice para S. Recorre todas las filas de R, y para
        cada una indexa en el índice de S.
    - Merge join
      - Ordena y después hace un merge
    - Hash match
- Mencione y explique dos diferencias entre OLTP y OLAP.
  - OLTP: ONline transaction processing. Procesamiento online de transacciones,
    son operaciones con menos filas y que se usan para procesar el negocio
    transaccional
  - OLAP: analytical, se usa para hacer análisis de datos y asistir en la toma
    de decisiones.
- ¿Cuáles son las 3 "Vs" de Big Data? Explicarlas brevemente.
  - Volumen: hay muchos datos para tratar
  - Veracidad: calidad de los datos, es muy mala
  - Variabilidad: están en muchos formatos diferentes
  - Valor: cómo le puedo sacar valor a tantos datos? data mining
  - Velocidad: el volumen incrementa muy rápido
- ¿Cuándo se dice que una transacción "lee" de otra? ¿Cómo se relaciona con la recuperabilidad de los schedules?
  - Una transacción lee de otra cuando lee un item que la otra escribió
  - Un schedule es recuperable cuando cada transacción hace commit luego de
    todas las transacciones de las que leyó (porque puede hacer abort en
    cascada)
- ¿Cuándo se utilizan las entidades débiles en un DER? Dar un ejemplo.
  - Las entidades débiles son una herramienta de modelado que permite modelar
    una entidad pero mostrar que no podría existir sin otra. Por ejemplo, copa
   fútbol y tipo de copa. El tipo de copa es una entidad débil de copa, está en
   su esencia y no podría existir sin ella.
  - No se identifican por si solas, sino que la PK está compuesta con la PK de
    la entidad fuerte de la que son débil.
    > En este sentido, es medio raro que tipo copa sea una tabla a parte.
- Diferencia entre integración de datos e intercambio de datos.
  - No se
- ¿Cuál es la principal diferencia entre el DBA y el administrador de datos?
  - Tiene que ver con la independencia física (el salto del almacenamiento
    físico de bajo nivel y las tablas (conceptual)).
  - El DBA es el administrador de la base de datos en sí, es el que conoce los
    detalles del motor y el lenguaje de consultas.
  - El administrador de datos está un nivel más arriba, es el que se encarga de
    organizar los datos de la organización para luego persistirlos en una DB.
- ¿Qué es el gobierno de datos? ¿Cómo se relaciona con la calidad de datos?
  - El gobierno de datos determina quien tiene acceso a los datos y quien los
    provee. Debería asegurar la calidad de los datos, que es la adecuación de
    los datos a su uso
- Explicar la UNDO rule. ¿Por qué es importante?
  - Dice que si un item fue escrito por una transacción commiteada, y ahora
    tiene que ser escrito por otra, el valor previo debe estar persistido en el
    log (porque sino, si la otra transacción falla, no se puede recuperar el
    valor previo).
  - Es importante para que funcione correctamente UNDO en logging.
- ¿Qué optimizaciones puede hacer una base de datos paralela al recibir una query?
  - Para dividir el trabajo de la query entre procesadores tiene dos opciones:
    intra o inter operation parallelism
  - Intra (dentro): divide las diferentes sub operaciones del AR de la query
    entre los distintos procesadores (join, selection, projection, etc.)
  - Inter (entre): repartir el query entero a un procesador? (no me queda claro este)
- ¿Cuándo se dice que una base de datos distribuida es homogénea?
  - Cuando cada nodo usa el mismo motor de bd (DBMS)
- ¿Cuál es la función del scheduler?
  - Es como un scheduler del SO pero de transacciones y sus operaciones. Tiene
    que garantizar seriabilidad para que no haya problemas de concurrencia.
- Mencione un nivel de aislamiento de SQL para transacciones. ¿Qué implica?
  - Los niveles de aislamiento definen el grado con el que la transacción tiene
    que ser aislada del comportamiento de otras
- ¿Cuáles son los permisos que se le puede asignar a un usuario sobre una tabla de la base de datos?
  - ???
- ¿Qué es el teorema CAP?
  - Es un teorema que muestra que tradeoffs pueden ser tomados en el diseño de
    bases de datos distribuidas. Un sistema de almacenamiento distribuido solo
    puede cumplir 2/3 de
  
  - Consistency: cada read recibe el último write o un error
  - Availability: los requests no reciben error
  - Partition tolerance: si se cae un nodo de la red o sube la latencia, el
    sistema no retorna errores.
- ¿Qué propiedades debe cumplir un conjunto de atributos para ser una clave candidata?
  - Debe ser una super clave minimal
  - Una superclave es aquella que identifica de forma única a las tuplas de una
    relación. Es decir, si tienen los atributos que forman parte de la
    superclave iguales, entonces el resto también lo son.
- ¿Qué propiedades son deseables en una descomposición de una relación?
  - SPI (Sin pérdida de información) y SPDF (Sin pérdida de dependencias funcionales)
- ¿Una relación que está en 2FN está también en 3FN? Justificar.
  - No, 2FN pide que esté en 1FN y que todos los atributos *no primos* dependan
    solo de la clave primaria completa. Por otro lado, 3 FN pide que no haya
    dependencias funcionales transitivas desde la PK para attrs no primos

    Por ej. una relación

    A, B, C, D
    con PK = (A, B)
    DFs = {AB -> C, C -> D}
    estaria en 2FN pero no 3FN, porque tenemos C -> D en donde C no es SC y D no
    es primo (se podría mover C -> D a otra relación)
- Enunciar los axiomas de Armstrong.
  - Son reglas que permiten clausurar un conjunto de dependencias funcionales,
    infiriendo nuevas a partir de las existentes.
    - Reflexiva: si X contiene a Y, entonces X -> Y
    - Incremento: X -> Y implica XZ -> YZ para cualquier Z
    - Transitiva: X -> Y e Y -> Z implica X -> Z
  - Corolarios
    - descomposición o proyección: X -> YZ implica X -> Y
    - unión o aditiva: X -> Y e X -> Z implican X -> YZ
    - pseudotrans: X -> Y e WY -> Z implican WX -> Z

## Clase

- Olap vs OLTP
  - OLAP: Online analytical processing. Recolección de datos analíticos,
    promedios, sumarizaciones, etc.
  - OLTP: Online Transaction Processing: sistema transaccional, por ej. el que
    cobra los pagos

- ACID
  - Atomicity: Las transacciones se ejecutan enteras o no se ejecutan (recovery)
  - Consistency: La base se mueve de un estado consistente a otro. (recovery)
  - Isolation: las transacciones se ejecutan como si fueran las únicas en la DB
    (control de concurrencia)
  - Durability: si una transacción está commiteada, está persistida en la base
    de datos. No se puede perder a causa de fallos. (recovery)

- relación de durabilidad con logging y checkpoints: logging y checkpoint son
  los mecanismos que permiten (entre otras) la durabilidad de las transacciones.
  Ya que cuando una trx hizo commit, o bien ya está en disco o está en el buffer
  pero también en el log (persistido), con lo que se puede recuperar.
- dif entre consistencia y eventual: consistencia se mueve de un estado
  consistente a otro, en todo momento es consistente. eventual es que el algún
  momentdel futuro se converge a un estado consistente. tiene más sentido cuando
  hay replicación (en nosql)

- bases de datos paralelas. Tenés más de un CPU, como aprovechás? Diferencia
  entre inter e intra
  - las bases de datos paralelas pueden tener inter operation o intra operation parallelism
  - inter: entre operaciones. asignan operaciones distintas a CPUs distintos.
  - intra: dentro de la operación. Se reparten en las partes de un (parecido a
    la microarch y el pipelining del procesador)

- Replicación vs fragmentación
  - replicación: duplicar los datos en distintos sitios
  - fragmentación: puede ser hor o ver
    - vertical: partir por columna. Tengo que duplicar la PK para join
    - horizontal (sharding): parto según cierto dato (por ej. país). Tiene que
      ser un criterio uniforme entre todas las tablas que voy a hacer join.

- Qué es una relación. Por qué es importante que sea un conjunto
  - Una relación es un conjunto en el sentido matemático. Está incluida en el
    producto cartesiano de los dominios de sus atributos.
  - Esto quiere decir que no hay duplicados en las tuplas que contiene. Y por lo
    tanto, siempre hay un conjunto de atributos que identifican a cada instancia
    unívocamente, que en el peor de los casos son todos (porque no hay
    repetidos)
  - Cada conjunto de atributos que identifica es una SuperClave
    - Cada clave candidata es una superclave minimal
    - Una PK es una CK arbitraria. El resto son secundarias.

- Qué son las formas normales
  - Son medidas de la calidad de un diseño en términos de la redundancia de los
    datos.
  - Se apoyan sobre la definición de *dependencias funcionales*: cuando un dato
    determina a otro (por ej. DNI o idPersona determina Nombre, apellido, etc.)

- Qué es un índice, que tipos tiene
  - Sirve para buscar de forma más eficiente información en una tabla.
  - Se organizan como árbol B con las hojas linkeadas.
  - Puede ser clustered o unclustered
    - Clustered es por la PK, es la forma en la que están ordenados los datos.
      En las hojas están todos los datos.
    - Unclustered o Nonclutered son índices que no están organizados igual que
      la tabla. En el fondo, tienen un RID o KeyID que se puede usar para
      indexar en el índice cluster y obtener el resto de los datos.

- Qué es un schedule: un orden de ejecución para las operaciones de un conjunto de transacciones
  - qué propiedades deseables tiene: que sea *serializable*, equivalente a un
    orden serial. Para testear esto se hace el grafo de precedencia.

- qué es optimización:
  - el motor toma una query, la parsea, arma el arbol de AR y luego lo
    **optimiza**: busca distintas alternativas (usando propiedades de AR),
    concretiza los operadores (qué tipo de join por ej?) y se queda con el más
    eficiente.

- control de concurrencia: problemas que lo generan. Qué es, que tipos hay
  - hay problemas de concurrencia clásicos que dan la necesidad de tener un
    control.
    - Lost update: dos writes concurrentes y se pierde 1. Clásico de SO.
  - son mecanismos que cuando llega una operación de una transacción, pueden
    ejecutarla, demorarla o rechazarla (abortando la trx)
  - pueden ser pesimistas u optimistas
    - pesimistas: usan locks. pueden ser binarios o RWlocks. Hace falta un
      protocolo de locking para tener seriabilidad, como 2pl
    - optimistas: son lock free.
      - se basan en que la concurrencia suele ser baja y no hay conflictos
      - timestamp: a cada transacción se le asocia un timestamp cuando inicia.
        El orden de los timestamps determina el orden serial.
        Se almacena el max write y max read para cada data item.
        cuando llegan operaciones se comparan con ellos para ver si se
        produjeron comportamientos físicamente irrealizables (read too late,
        write too late) => abort de la trx.

        cuando llega un read, se compara con el max write. Si max write > ts,
        read too late. Tenía que leer un valor previo, pero una transacción
        posterior ya vino y lo escribió.

        cuando llega un write, se compara con max write y max read
        si max write > ts, thomas write rule y se puede saltear
        si max read > ts, read too late. Una trx posterior tenía que leer ese
        valor pero leyó un valor anterior.
      - timestamp multiversión: guarda versiones de cada data item por cada
        timestamp que los escribe. Evita read too late pero no write too late.

- qué es long duration transaction: transacciones que atraviesan las fronteras
  de una sola DB. (me parece que esto está mal)

- qué es open data: datos disponibilizados por distintos organismos como
  empresas o gobiernos para el uso abierto.
- qué es data mesh: la forma en la cual se organiza la explotaciń de los datos
- que es data mining: torturar a los datos hasta que hablen.
- qué es gobierno de datos: determinar quien administra los datos. Quién tiene
  acceso a ellos y qué puede hacer. Asegurar la calidad de cara a los usuarios
- calidad de datos: es la adecuación de los datos a su uso. Se habla de
  problemas o errores de calidad.

- bases nosql, que características tienen
  - Son schemaless. Esto hace que no puedan tener un lenguaje de consultas rico
    que sea estandarizado para todas
  - BASE
    - **Ba**sic availability: según teorema CAP
      - se pueden elegir 2/3 de
        - Consistency: consistencia tipo ACID
        - Availability: no se retorna errores
        - Partition tolerance: no pasa nada si se cae un nodo de la red
        - las nosql suelen proveer Partition tolerance y availability,
          sacrificando consistency (por eso tienen eventual)
    - **S**oft state
    - **E**ventual consistency
- que tipos hay
  - document y key value. parecidas. mongo, redis. Diferencia es que key value
    te deja guardar cualquier cosa en las keys, document te dice que tengas un
    esquema de documentos definido (json, xml, etc.)
  - column (cassandra)
  - stream
  - graph