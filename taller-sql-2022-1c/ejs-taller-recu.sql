-- Ejs taller SQL, recuperatorio, 2022 1c --
-- inicio 18 15 fin 18 45, total 30m

-- Ej 1 - Obtener la cantidad de invoices por track.
-- Deberá responder el id del track, el nombre y la cantidad de invoices en donde participa.

SELECT
    t.track_id,
    t.name AS track_name,
    COUNT(il.invoice_id) as num_invoices
FROM track t
    JOIN invoice_line il ON il.track_id = t.track_id
GROUP BY t.track_id
ORDER BY num_invoices DESC

-- Ej 2 - Listar todos los datos de los tracks cuya duración sea mayor al promedio de la
-- duración de los tracks de rock.

SELECT t1.track_id, t1.name, milliseconds
FROM track t1
WHERE t1.milliseconds > (
    SELECT AVG(t.milliseconds)
    FROM track t
        JOIN genre g ON g.genre_id = t.genre_id
    WHERE g.name = 'Rock'
)

-- Ej 3 - Obtener el nombre y el apellido de los clientes que son atendidos por los empleados que
-- atienden a la mayor cantidad de clientes.
-- La relación entre empleado y cliente se da por la clave foránea en cliente support_rep_id

-- Primero obtengo los clientes atendidos por empleado (count) y después me quedo con los clientes
-- que hayan sido atendidos por uno de ellos

WITH employee_attends AS (
    SELECT e.employee_id, e.title, COUNT(c.customer_id) AS attended
    FROM employee e
        JOIN customer c ON c.support_rep_id = e.employee_id
    GROUP BY e.employee_id
)

SELECT c.first_name, c.last_name
FROM customer c
    JOIN employee e ON c.support_rep_id = e.employee_id
    JOIN employee_attends ea ON ea.employee_id = e.employee_id
WHERE ea.attended = (SELECT MAX(attended) FROM employee_attends)


-- Sin with
SELECT c.first_name, c.last_name
FROM customer c
    JOIN employee e ON c.support_rep_id = e.employee_id
WHERE e.employee_id IN (
    -- Empleados que atienden a la mayor cantidad de clientes
    SELECT e.employee_id
    FROM customer c
        JOIN employee e ON c.support_rep_id = e.employee_id
    GROUP BY e.employee_id
    HAVING COUNT(c.customer_id) >= ALL (
        SELECT COUNT(c.customer_id)
        FROM customer c
            JOIN employee e ON c.support_rep_id = e.employee_id
        GROUP BY e.employee_id
    )
)

-- Ej 4 - Listar los tracks más vendidos. Aquellos tales que no hay un track que tenga más ventas

-- Primero obtengo ventas por track
SELECT t.track_id, t.name, COUNT(il.invoice_line_id) AS num_sales
FROM track t
    JOIN invoice_line il ON il.track_id = t.track_id
GROUP BY t.track_id, t.name
HAVING COUNT(il.invoice_line_id) >= ALL (
    SELECT COUNT(il.invoice_line_id)
    FROM track t
        JOIN invoice_line il ON il.track_id = t.track_id
    GROUP BY t.track_id, t.name
)

-- Ej 5 - Realizar una consulta correlacionada que devuelva las invoices (id, fecha y billing_address)
-- tales que en sus items (invoice line) no haya ningún precio unitario de 0.99

-- Obtengo las que tienen items con precio unitario de 0.99 y después me quedo con las que los ids no estén ahí.

-- No estaría bien hacer una sola query como la inner con il.unit_price <> 0.99 para lo que pide el enunciado, porque
-- en ese caso alcanzaría con que haya una que no es 0.99 en el invoice cuando NINGUNA puede serlo.

-- Sin correlacionar
SELECT i.invoice_id, i.invoice_date, i.billing_address
FROM invoice i
WHERE i.invoice_id NOT IN (
    -- Invoices con algún item con precio unitario 0.99
    SELECT DISTINCT i.invoice_id
    FROM invoice_line il
        JOIN invoice i ON i.invoice_id = il.invoice_id
    WHERE il.unit_price = 0.99
)

-- Correlacionada
SELECT i.invoice_id, i.invoice_date, i.billing_address
FROM invoice i
WHERE NOT EXISTS (
    -- Item con precio unitario 0.99
    SELECT *
    FROM invoice_line il
        WHERE i.invoice_id = il.invoice_id AND
        il.unit_price = 0.99
)

-- Ej 6 - Realizar una consulta que devuelva todos los empleados contratados después que
-- Park Margaret. La fecha de contratación es hire_date

SELECT e.*
FROM employee e
WHERE e.hire_date > (
    SELECT hire_date FROM employee WHERE last_name = 'Park' AND first_name = 'Margaret'
)
