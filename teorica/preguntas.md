# Preguntas

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