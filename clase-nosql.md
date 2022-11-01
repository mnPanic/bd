# Clase no sql

14/10/22

el RDBMS no cambió mucho desde su concepción
desde 2004 arranca la movida nosql
2008 newsql

nosql

- escalabilidad horizontal (las relacionales pueden escalar verticalmente fácil pero horizontal no tan fácil). Replicación más fácil y que el motor lo pueda administrar
- consistencia eventual
- ACID vs BASE
- sin esquema o esquema flexible

4 familias

- key value: tipo un dict de algo2
- wide column: particular para un problema
- document: ej. mongo
- graph database

## Document databases

bson: json binario

el documento es una colección de pares, pueden ser json, xml, etc.
la que más se usa es mongodb

cómo ordenás todos los documentos? la mayoría en _colecciones_. 

y cual es el DER de acá?

antes: guardo la información según un modelo, y después me encargo de consultarlo con SQL
ahora: tenés que modelar la información de forma que te permita queryarla. ACá no hay sql y los lenguajes son más limitados.

antes normalizabamos. Ahora la normalización nos penaliza que no podemos hacer join, entonces la estructura no nos devuelve lo que queremos en la búsqueda (está partida en muchas entidades)

ahora vamos a hacer una estructura que puede tener info repetida y la clave se quedó en el camino. Está desnormalizada.

como resolvemos la interrelacion entre documentos? en el DER estaban las FK con las interrelciones. Y en los documentos no lo tengo

dos herramientas que hacen variar el grado de desnormalización:

- incrustar
- referenciar

### DER a DID

arrancamos del DER y las consultas y pasamos a un DID

diapo cardinalidad 1 - n, 1 - 1

empleado {

}

departamento {

}

A -- 1 -- N -- B

si yo quiero saber dado b cual es a, agrego una flechita que me dice que en el documento B va a ir el id de cada A.

si yo quiero saber dado A cual es B, en A me genera un arreglo de IDs

A: {
    a1: string
    a2: string
    b: [string]
}

B: {
    b1: string,
    b2: string,
    b3: string
    a1: string
}

la otra opción, incrustar (se representa con una llave) es que en vez de poner el id pone todo


A: {
    a1: string
    a2: string
    collection: [ 
        b1: string,
        b2: string,
        b3: string
     ]
}

se puede incrustar parcialmente, si la consulta solo necesita ciertos campos. Se representa con un doble corchetes debajo de la llave

si ahora además tenemos

A - 1 -- N - C

y C no se usa para nada en ningún query, se pone una cruz abajo a la izquierda. Elimino la entidad para que no se pase a documento

importante: no nos olvidamos de las claves. Cuando estoy incrustando, por lo general incrusto la clave porque sino cuando tengo cosas repetidas no se como distinguirlo. (en general, puede haber casos en los que no sea así). Pero no se puede incrustar solo el ID porque eso es referenciar (para eso está la flecha)

usamos casi siempre con las entidades débiles incrustarlo totalmente en el padre (salvo que la débil sea súper grande y justo haya una consulta que sea solo por la débil)

- referenciar: ids o listas de ids. parecido a fk de 1-n
- incrustar: en un documento se incluyen todos los datos (en principio) de otro documento

#### Casos excepcionales

- Documentos auxiliares

    "si tengo que particionar por día, me pego un tiro" - nacho

    "no levantas un pedazo" - nacho

  Los 3 puntitos te dicen que se generan con datos de la interrelación

- ternarias: hacemos un documento para la relación, igual que en MR
- jerarquias

    en la diapo de mantener ingeniero falta poner el id en el filtro (idemployee)}
