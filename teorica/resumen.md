# Resumen BD

## Bases de datos

Es una colección de datos relacionados y organizados. Logicamente coherente, con
un significado que depende del dominio en donde se aplica.

Tiene un software adhoc (DMBS) que la administra. Es,

- Persistente
- Tiene consultas (SQL) junto con un módulo que las optimiza (le doy la
  consulta, declarativa, pero no le digo como implementarla físicamente)
- Transacciones: un conjunto de operaciones *atómicas*
  - Ejemplo clásico: Transferencia bancaria de A hacia B tiene 3 operaciones
    - A resta 100
    - B suma 100
    - registro
  - Si esto no es un bloque, puedo tener inconsistencias
  - Cuentan con un mecanismo de rollback y recovery (logging)
- Control de concurrencia
- Backups

Son *autodescriptivas*: saben sus tablas.

Dos grandes lenguajes provistos por los DBMS

- DDL: Data Definition Language. Define las estructuras, el esquema (schema).
- DML: Data Manipulation Language. Permite operar sobre las instancias

## MER / DER

MER = Modelo de Entidad Relación. Es un modelo *conceptual* de alto nivel de los
datos. Representa entidades del mundo real y las relaciones entre ellas.

DER = Diagrama de Entidad Relación

Sirve para modelar los datos. Muesta como se **vinculan** los objetos entre sí.

Conceptos:

- **Entidad**: Objeto *relevante* para mi sistema
  - El desafío es decidir qué % del mundo real recorto
- **Atributo**: Característica *relevante* de una entidad
  - Identificatorios: Puede haber uno o más de uno (elegimos uno solo como PK)
  - Compuestos (por varios sub atributos, por ej. fecha+hora = timestamp)
  - Multivaluados (por ej. mail)
- **Interrelación**: Vínculo entre dos entidades

  - Tienen diferentes *cardinalidades*

    - 1 a 1 (*uno a uno*).
      - Presidente-País
      - Edificio-Terreno
    - 1 a N (*uno a muchos*)
      - Biblioteca-Libro
      - Aplicación-Versión
    - N a M (*muchos a muchos*)
      - Empleado-Empresa
      - App-Usuario
      - Libro-Autor

  - Pueden tener participación parcial o no.

    > Por ejemplo, si tenemos la interrelación "aprobó" entre alumno y materia,
    > puede ser que haya alumnos que no hayan aprobado ninguna materia.

  - Pueden tener atributos
    - Las 1-n no, por definición (Duda: y las 1-1?)
  - Tipos: Unarias (loops), binarias, ternarias.

Crítica al modelo relacional: tenés muchas tablas de referencias (relaciones)

### Datos tabulados

Un motivo para crear una entidad puede ser que tenga una lista de valores
**tabulados**. De esa forma, si tengo que cambiar las posibilidades o un valor
puedo hacerlo en un solo lugar. Ejemplos: País, Provincia, Marcas, etc.

> Esto también se podría hacer con tipos enumerados. Pero la diferencia es que
si quiero modificar un enum, tengo que hacer un ALTER para cambiar el schema. En
cambio, si los tengo en una tabla, alcanza con hacer un INSERT que es más
sencillo.
> También me sirve para ponerle otros atributos además del nombre.

### Entidades débiles

Puede haber *entidades débiles*. Por ejemplo, copa de futbol y tipo copa. Tipo
copa es una entidad débil de copa. Está en su esencia, no puede existir tipo sin
copa.

### Especializaciones

Se pueden hacer especializaciones de las entidades. Por ejemplo, Persona se
especializa en Alumno y Profesor (que a su vez se generalizan en Persona). Estas
pueden ser **overlapping** (como es este caso) o **disjoint**.

Las hacemos si tienen atributos o interrelaciones diferentes entre sí. Sino, no
tiene sentido especializar.

### Ternarias

Necesito las tres en el mismo momento. La cardinalidad se ve 2 contra 1. Por
ejmeplo, Jugador, equipo y rol.

- Para un equipo y rol, tengo N jugadores
- Para un rol y jugador, tengo 1 equipo
- para un equipo y jugador, tengo 1 rol.

![](img/ej-ternaria.svg)

### Agregaciones

- Una abstracción de una interrelación entre dos entidades.
- La hago cuando necesito vincular una interrelación con una entidad.
- Solo se puede con M-N (porque en el pasaje a relacional termina siendo una
  tabla a la que le puedo agregar un ID)
- Tiene que suceder temporalmente antes la agregación que la de afuera. Sino,
  sería una ternaria (y si sucede temporalmente antes, no pueden estar los tres
  a la vez, entonces no puede ser una ternaria)

Un ejemplo es alumno, curso, encuesta y materia

![](img/ej-agregacion.svg)

Donde hay participación parcial entre la agregación y la encuesta porque no toda
tupla de la agregación tiene una encuesta

## Modelo relacional

Antes, los datos estaban en texto plano, y no era transparente para el usuario
su ubicación y formato. Las DBs relacionales traen la *independencia física* de
los datos.

Niveles de abstracción

- Vistas (Externo), usado por usuarios finales
  - Abstracción de las tablas. Se usa para proveer políticas de acceso, vistas
    de varios esquemas, etc.
- Tablas (Conceptual), usado por desarrolladores
  - Modelo de datos: Una abstracción del mundo real que está representada
    conceptualmente en la BD
- Interno (Físico), usado por DBAs
  - Colección de archivos, índices y otras estructuras que se usan para acceder
    a datos de forma eficiente.

- externo a conceptual es la *independencia lógica*, uno de los grandes logros
  del modelo relacional. La capacidad del sistema de cambiar el esquema
  conceptual, sin cambiar la vista lógica que el usuario tiene de los datos.

- Y de conceptual a interno la *independencia física*: la capacidad del sistema
de ejecutar cambios sobre la definición y estructura de los datos sin que eso
afecte la BD conceptual.

En el modelo relacional, los registros se abstraen en **relaciones** (que son
*predicados*, inspirados en LPO). Por ejemplo `Estudiante(id, nombre, direccion)`

- Estudiante es el nombre de la relación
- `id`, `nombre`, `direccion` son sus atributos. Cada atributo tiene un dominio

Los registros que pertenecen a la relación son llamados **tuplas**, y no están
ordenados (son conjuntos)

Una relación es un conjunto, que está incluido en el producto cartesiano de
todos los dominios de sus atributos. => no puede haber
repetidos.

> Por esto Codd dice que los modelos anteriores no eran relacionales

Como no hay tuplas duplicadas, si o si hay un conjunto de atributos que
identifican a cada una, que en el peor caso puede ser la unión de todos los
campos. Por lo tanto siempre hay al menos una clave candidata. La que elijo es
la **primary key**.

Se pueden tener claves **foráneas** (que identifican tuplas de otra entidad),
que da *integridad referencial*. Se puede validar al borrar o hacer un update
que la otra exista.

### Pasaje DER a MR

Hay una forma automática de pasar de un DER a las tablas. Es una tarea de **mono
amaestrado**, no hay que tomar decisiones.

Reglas:

1. Cada entidad tiene su tabla
2. Cada atributo es una columna
3. Todas las relaciones m-n dan lugar a una nueva tabla

    > por esto estas relaciones pueden tener atributos

4. Las relaciones 1-n las logramos poniendo el atributo que identifica del lado
   la n
5. Las 1-1 va del lado en donde no haya participacion parcial (para evitar
   NULLs). Si no hay en ninguno, en cualquiera.

## Lenguajes de consulta

### AR (Álgebra Relacional)

Es un lenguaje de consultas **procedural** para el modelo relacional.

Por qué es importante?

- Provee un fundamento formal a las operaciones asociadas al modelo relacional.
  (SQL es la implementación más famosa de algebra relacional)
- Se usa de base para implementar y optimizar queries en RDBMS (usando
propiedades de conmutatividad y eso de las operaciones, que acá no las puse pero
están en las diapos de Vani).

Tiene las siguientes operaciones:

- **Proyección** ($\pi$): Obtiene uno o más campos de una tabla.
  - Genera una *partición vertical* de la relación
  - Ej: $\pi_\text{legajo}$(Alumno)
  - En SQL suele ser WHERE
- **Selección** ($\sigma$): Elige registros que cumplan cierta condición
  - Genera una *partición horizontal* de la relación
  - Ej: $\sigma_\text{codCarrera='A'}$(Alumno)
  - En SQL es SELECT DISTINCT
- **Renombre** ($\rho$): Cambia el nombre de la salida. También permite ordenar
  y guardar soluciones parciales.
  - Notación: $\rho(A_1 \to B_1, \dots, A_n \to B_n, R)$ o $\rho(S, R)$
  - Ej: $\rho(S, \sigma_{attr=val}(R))$
  - En SQL es AS
- Unión, intersección, resta (conjuntos), prod cartesiano
- Join
- Division (no suele ser implementada por SQL)
  
### CRT (Cálculo Relacional de Túplas)

Es un lenguaje de consultas para el modelo relacional. Es **declarativo**,
permite expresar cómo es el conjunto de respuestas que se busca, pero no dice
cómo hacerlo (no es procedural)

Por qué es importante?

- Tiene un sólido fundamento en lógica matemática
- SQL tiene sus bases fundacionales en CRT.

Las expresiones tienen la pinta

$$\{ t \mid COND(t) \}$$

donde

- t es una variable de tipo tupla, la única libre en la expresión.
- COND(t) es una expresión booleana condicional, una fórmula bien formada de CRT
- El resultado es el conjunto de TODAS Las tuplas que satisfacen COND

Las diapos hablan de qué es una fórmula bien formada, es muy parecido a LPO
agregando pertenencia (ej $t \in EMPLEADO$) y operaciones entre constantes y
atributos de las tuplas (ej $r.Depto = s.IDD$ o $r.Salario > 2000$)

(tip: con el $\exists$ va $\wedge$ y con el $\forall$ va $\Rightarrow$)

#### Expresiones seguras

Las **expresiones seguras** son aquellas que garantizan producir una *cantidad
finita de tuplas*. Sino, se dice **expresión insegura**

> Por ejemplo, $\{ t | \neg (t \in \text{EMPLEADO}) \}$ es insegura, porque
> genera una cantidad infinita de tuplas: todas las que no pertenecen a la
> relación EMPLEADO.

Decimos que el *dominio* de una expresión de CRT son los dominios de las
subexpresiones (atributos de las tuplas, y constantes). Una expresión es segura
si todos los valores en el resultado son parte del dominio de la expresión.

> Con esta definición, la expresión anterior es insegura porque el resultado
> incluye elementos que están fuera del dominio de la relación EMPLEADO

### Comparación de poder expresivo

La *expresividad* de un lenguaje es la amplitud de ideas que pueden ser
representadas y comunicadas en él. La de un lenguaje de consulta de bases de
datos equivale al conjunto de consultas que se le pueden hacer a la DB por medio
de él

- ¿Que se puede expresar con AR y CRT?
- ¿Son equivalentes?
  - Si restringimos CRT a expresiones seguras, es equivalente en poder expresivo
    a AR básica
- Qué relación tienen con LPO?
  - CRT es una especialización de LPO para bases de datos (solo interesan las
    relaciones)
- Cómo se relacionan estos lenguajes teóricos con SQL?
  - La semántica de SQL está basada en safe CRT, por la que es equivalente a AR
  - Distintas implementaciones proveen predicados *extra lógicos* que permiten
    que tenga más poder expresivo: recursión, funciones de agregación y
    agrupamiento (group by, sum, count, etc.), stored procedures, etc.

Hay consultas que podríamos querer hacer que no son expresables en LPO. Teorema Ehrenfeucht-Fraisse.

## Normalización

Las **formas normales** son medidas de la calidad de un diseño en cuanto a la
redundancia. La redundancia no es gratis. Tengo que mantener actualizadas todas
las copias de los datos, lo que puede llevar a

- Anomalías de inserción
- Anomalías de eliminación
- Anomalías de actualización

> por ej hay una tabla que no está en 2FN que tiene todos los datos de los
> empleados y los departamentos.
>
> - inserción: se quiere insertar un nuevo empleado y no tiene asignado (o no se
> sabe) el departamento. Entonces hay que poner nulls. Y agregar un nuevo
> empleado asociado a un depto requiere que los datos sean consistentes con el
> resto de los empleados de ese depto (por ej. que no escriban diferente el
> nombre)
> - eliminación: si se elimina un empleado que es el único de un departamento,
>   se pierde toda la info referida a él
> - actualización: si se quiere cambiar por ej. el nombre del depto, hay que
>   cambiarlo en todos los registros. Sino, hay inconsistencias.

### Dependencias funcionales

Para definir las formas normales usamos las *dependencias funcionales*. Son una
herramienta formal para el análisis de esquemas. Permiten detectar y describir
los problemas que tienen que ver con redundancia.

Un conjunto determina funcionalmente a otro si en un conjunto de tuplas
coinciden en un atributo entonces tienen qeu coincidir en otro. Se analizan
sobre la misma tabla. Representan la *semántica*.

$$X \rightarrow Y \text{ si } \forall t_1, t_2\ t_1[x] = t_2[x] \Rightarrow t_1[Y]
= t_2[Y]$$

Por ejemplo, codigo de departamento => nombre de departamento, dni => nombre.
Para determinarlas tenemos que tener conocimiento del negocio.

Propiedades:

- Es reflexiva
- No es simétrica
  - Dos alumnos pueden tener mismo nombre pero distinta LU
- No es asimétrica
  - LU -> DNI y DNI -> LU pero son diferentes
- Es transitiva

### Claves

- Una **super clave** (SK) de una relación R es un subconjunto de atributos S
  tales que no hay dos tuplas que tienen los mismos valores para los atributos
  de S (i.e no hay $t_1, t_2 \in R$ tales que $t_1(S) = t_2(S)$)
- Una **clave** (K) es una SK minimal (si se saca un atributo, deja de ser SK)
- Las **clave candidatas** (CK o CC) son todas las claves K de un esquema
  - La **clave primaria** (PK) es una CK que fue designada arbitrariamente como tal
  - El resto son claves secundarias
- Un atributo primo es alguno tal que pertenece a *alguna* CK de R

Decimos que $X \subseteq R$ es una **clave candidata** de la relación R si

- X -> R (unicidad)
- $\not\exists Y \subseteq X$ tal que Y -> R (minimalidad)

### Formas normales

Una DB tiene un buen diseño cuando tiene *baja redundancia* (hay veces que por
temas de performance, puede ser necesaria).

Formas normales:

- 1 FN: Está en 1FN si todos sus atributos son atómicos (simples e indivisibles)
  
  > Por ej Empleado(codigo, nombre, {tel1, tel2, tel3}) no está en 1FN

- 2 FN: R está en 2FN si está en 1ra y todos los atributos no primos dependen
  **en forma completa** de la PK (no hay dependencias funcionales parciales)

  > R(codArticulo, codProveedor, nombreArticulo, precio)
  >
  > Con clave (codArticulo, codProveedor). Con el código del artículo me alcanza
  > para encontrar el nombre. No está en 2FN.

- 3FN: R está en 3FN si todos los attrs no primos dependen de forma no
  transitiva de la clave primaria (y está en 2da).

  Los atributos que no son parte de la clave dependen **solo** de la clave
  completa.

  Definición alternativa: Un esquema R está en 3FN si, para toda dependencia
  funcional *no trivial* X -> A de R, se cumple alguna de las siguientes conds

  - X es SK de R
  - A es atributo primo de R

  (B -> A es trivial si B es un subconj de attrs de A)

  Siempre se puede llevar a una relación a 3FN SPI SPDF

- FNBC (4FN) (forma normal de Boyce Codd): Las columnas incluyendo las que
  componen las claves candidatas no tienen que tener dependencias entre sí.

  R está en FNBC si para toda DF no trivial X -> A de R, X es SK de R.

  Siempre se puede llevar SPI, pero no siempre SPDF.

  ![](img/normalizacion/ej-fnbc-vs-3fn.png)

Y cómo solucionamos los problemas de redundancia? Descomponemos la relación en
otras más chicas que no tienen las violaciones. Queremos que eso sea

- **Sin pérdida de información** (SPI) o *lossless join*. La relación original
  tiene que poder ser recuperada de la descomposición.
- **Sin pérdida de dependencias funcionales** (SPDF). Cada DF se encuentra
  representada en algún esquema de la descomp.

Se pueden inferir dependencias funcionales a partir de otras con reglas de
inferencia, los axiomas de armstrong. De esa forma se puede **clausurar** un
conjunto de DFs infiriendo a partir de él. Esto se usa para normalizar.

## Optimización

### Parte física

## Transacciones

## Control de concurrencia

## Recuperación (Logging)

## NoSQL

## Temas extra

### Big Data

### Open Data

### Data Mining

### Gobierno de datos


