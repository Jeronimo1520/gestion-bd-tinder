CREATE OR REPLACE FUNCTION listado_de_chats(id_usuario_chat INT)
RETURNS TABLE(
    id_usuario INT,
    nombre VARCHAR(255)
) AS $$
BEGIN 
    RETURN QUERY
    SELECT u.id_usuario, u.nombre
    FROM USUARIO u
    INNER JOIN MENSAJE me ON u.id_usuario = me.id_usuario_receptor
    WHERE me.id_usuario_emisor = id_usuario_chat
    UNION
    SELECT u.id_usuario, u.nombre
    FROM USUARIO u
    INNER JOIN MENSAJE me ON u.id_usuario = me.id_usuario_emisor
    WHERE me.id_usuario_receptor = id_usuario_chat;
END;
$$ LANGUAGE plpgsql;
DROP FUNCTION listado_de_chats(integer)

SELECT listado_de_chats(1)

CREATE OR REPLACE FUNCTION listado_de_chats_particionada(id_usuario_chat INT)
RETURNS TABLE(
    id_usuario INT,
    nombre VARCHAR(255)
) AS $$
BEGIN 
    RETURN QUERY
    SELECT u.id_usuario, u.nombre
    FROM USUARIO u
    INNER JOIN MENSAJES_PARTICIONADA me ON u.id_usuario = me.id_usuario_receptor
    WHERE me.id_usuario_emisor = id_usuario_chat
    UNION
    SELECT u.id_usuario, u.nombre
    FROM USUARIO u
    INNER JOIN MENSAJES_PARTICIONADA me ON u.id_usuario = me.id_usuario_emisor
    WHERE me.id_usuario_receptor = id_usuario_chat;
END;
$$ LANGUAGE plpgsql;
SELECT listado_de_chats_particionada(1)

DROP FUNCTION listado_de_chats_particionada