--Vista materializada ya que ayuda a mejorar el rendimiento y no necesita mantenimiento
CREATE MATERIALIZED VIEW coincidencias_aceptadas_año_2022 AS
SELECT * 
FROM COINCIDENCIAS
WHERE estado = 'Aceptado' AND (fecha >= '2022-01-01' AND fecha <= '2022-12-31')


CREATE MATERIALIZED VIEW coincidencias_rechazadas_año_2022 AS
SELECT * 
FROM COINCIDENCIAS
WHERE estado = 'Rechazado' AND (fecha >= '2022-01-01' AND fecha <= '2022-12-31')

--Cuantos usuarios tiene cada pais, tiene que actualizarse
CREATE MATERIALIZED VIEW vista_cantidad_usuarios_por_pais AS
SELECT COUNT(*) AS "Cantidad_de_usuarios", p.nombre AS "País"
FROM USUARIO u 
INNER JOIN ciudad ci 
ON u.id_ciudad = ci.id_ciudad
INNER JOIN pais p
ON ci.id_pais = p.id_pais
GROUP BY p.nombre 
ORDER BY p.nombre 

--Cuantos usuarios tiene cada ciudad, tiene que actualizarse
CREATE MATERIALIZED VIEW vista_cantidad_usuarios_por_ciudad AS
SELECT COUNT(*) AS "Cantidad_de_usuarios", ci.nombre AS "Ciudades"
FROM USUARIO u 
INNER JOIN ciudad ci 
ON u.id_ciudad = ci.id_ciudad
GROUP BY ci.nombre 
ORDER BY ci.nombre 

CREATE OR REPLACE FUNCTION chat_entre_2_usuarios(id_usuario1 INT, id_usuario2 INT)
RETURNS TABLE (FECHA DATE, CONTENIDO VARCHAR(255)) AS $$
BEGIN
    RETURN QUERY
    SELECT m.FECHA, m.CONTENIDO
    FROM MENSAJE m
    WHERE (id_usuario1 = id_usuario_receptor OR id_usuario1 = id_usuario_emisor)
    OR (id_usuario2 = id_usuario_receptor OR id_usuario2 = id_usuario_emisor);
END;
$$ LANGUAGE plpgsql;


CREATE VIEW vista_chat_entre_2_usuarios_1_5000 AS
SELECT * FROM chat_entre_2_usuarios(1,5000)

SELECT * FROM vista_chat_entre_2_usuarios_1_5000


