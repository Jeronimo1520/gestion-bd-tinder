CREATE OR REPLACE FUNCTION mostrar_perfiles(id_usuario_mostrar INT)
RETURNS TABLE(
	id_ INT,
    nombre VARCHAR(50)
) AS $$
DECLARE 
	edad_maxima_preferida INT;
	edad_minima_preferida INT;
	genero_preferido VARCHAR(15);
	ubicacion_preferida INT;
	
BEGIN
SELECT ubicacion,genero,edad_minima,edad_maxima 
INTO ubicacion_preferida,genero_preferido,edad_minima_preferida,edad_maxima_preferida
FROM PREFERENCIA as pe WHERE pe.id_usuario = id_usuario_mostrar;

 RETURN QUERY
    SELECT u.id_usuario
    FROM USUARIO u
    WHERE u.edad > edad_minima_preferida
        AND u.edad < edad_maxima_preferida
        AND u.genero = genero_preferido
        AND u.id_ciudad = ubicacion_preferida;
		JOIN
        SELECT u.id_usuario IN (
           SELECT id_usuario_like_emisor
            FROM COINCIDENCIAS
            WHERE id_usuario_like_receptor = id_usuario_mostrar
		);
END;
$$ LANGUAGE plpgsql;
EXPLAIN select mostrar_perfiles(2)
