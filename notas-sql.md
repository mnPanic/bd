# Notas apunte SQL

Tipos de sentencias:

- DDL (Data Definition Language): Crear, modificar, borrar estructuras de datos
- DML (Data Manipulation Language): Manipular datos
- DCL (Data Control Language): Dar y revocar permisos de acceso

## DDL

- Crear tablas: `CREATE TABLE`
- Eliminar tablas: `DROP TABLE`
- Modificar esquemas de tablas: `ALTER TABLE`

## DML

Cuatro instrucciones

- `INSERT`: Crear nuevas filas
- `SELECT` seleccionar filas (o columnas) de tablas
- `UPDATE`: modificar filas existentes
- `DELETE`: borrar filas de una tabla

  La sentencia DELETE sin parte WHERE borra todas las filas, pero la tabla
  permanece creada (sin filas)

- `JOIN`s

  - Inner join (intersección)
  - Left outer join
  Union is vertical - rows from table1 followed by rows from table2 (distinct for union, all for union all) and both table must have same number of columns with compatible datatypes. Full outer join is horizontal
