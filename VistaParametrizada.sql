CREATE TABLE empleados (
    id serial PRIMARY KEY,
    nombre varchar(255) NOT NULL,
    supervisor_id int REFERENCES empleados(id),
    salario numeric(10, 2)
);

INSERT INTO empleados (nombre, supervisor_id, salario)
VALUES ('John CEO', NULL, 1000000.00);

INSERT INTO empleados (nombre, supervisor_id, salario)
VALUES ('Alice Manager', 1, 75000.00);

INSERT INTO empleados (nombre, supervisor_id, salario)
VALUES ('Bob Manager', 1, 75000.00);

INSERT INTO empleados (nombre, supervisor_id, salario)
VALUES ('Charlie Employee', 2, 50000.00);

INSERT INTO empleados (nombre, supervisor_id, salario)
VALUES ('David Employee', 2, 50000.00);

INSERT INTO empleados (nombre, supervisor_id, salario)
VALUES ('Eve Employee', 3, 50000.00);

INSERT INTO empleados (nombre, supervisor_id, salario)
VALUES ('Frank Employee', 3, 50000.00);

INSERT INTO empleados (nombre, supervisor_id, salario)
VALUES ('Grace Employee', 1, 60000.00);

CREATE OR REPLACE FUNCTION obtener_jerarquia_empleados(id_empleado integer)
RETURNS TABLE (
    empleado_id integer,
    empleado_nombre varchar(255),
    empleado_supervisor integer,
    nivel integer
) AS $$
BEGIN
    RETURN QUERY
    WITH RECURSIVE jerarquia AS ( --Itera dentro de la jerarquia
        SELECT
            id AS empleado_id,
            nombre AS empleado_nombre,
            supervisor_id,
            1 AS nivel
        FROM empleados
        WHERE id = id_empleado
        UNION ALL
        SELECT
            e.id AS empleado_id,
            e.nombre AS empleado_nombre,
            e.supervisor_id AS empleado_supervisor,
            j.nivel + 1 AS nivel
        FROM empleados e
        INNER JOIN jerarquia j ON e.supervisor_id = j.empleado_id
    )
    SELECT * FROM jerarquia;
END;
$$ LANGUAGE plpgsql;

CREATE VIEW vista_jerarquia AS
SELECT * FROM obtener_jerarquia_empleados(1); 

SELECT * FROM vista_jerarquia;

SELECT * FROM EMPLEADOS;

CREATE ROLE usuario_vistas LOGIN PASSWORD 'xxxxxx';

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO usuario_vistas;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO usuario_vistas;
GRANT SELECT ON vista_jerarquia TO usuario_vistas;

REVOKE SELECT ON ventas FROM usuario_vistas;

-- Concede permisos de lectura en la tabla "compras"
GRANT SELECT ON compras TO tu_usuario;

-- Concede permisos de lectura en la tabla "productos"
GRANT SELECT ON productos TO tu_usuario;


-- Revoca permisos de lectura en todas las tablas en el esquema público, excepto "compras" y "productos"
REVOKE SELECT ON ALL TABLES IN SCHEMA public FROM tu_usuario;

GRANT SELECT ON TABLE tabla1, tabla2, tabla3 TO tu_usuario;

