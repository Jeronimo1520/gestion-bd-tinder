CREATE INDEX  idx_coincidencias_espera ON COINCIDENCIAS(estado) WHERE estado ='En espera'; --Creado
CREATE INDEX idx_genero_usuario_hombre ON USUARIO(genero) WHERE genero = 'Hombre'; --CREADO
CREATE INDEX idx_genero_usuario_mujer ON USUARIO(genero) WHERE genero = 'Hombre'; --CREADO
CREATE INDEX idx_genero_usuario_no_binario ON USUARIO(genero) WHERE genero = 'No binario'; --CREADO
CREATE INDEX idx_usuario_emisor_mensaje ON MENSAJE USING HASH(id_usuario_emisor); --CREADO
CREATE INDEX idx_usuario_receptor_mensaje ON MENSAJE USING HASH(id_usuario_receptor); --CREADO

EXPLAIN SELECT * FROM COINCIDENCIAS WHERE estado = 'En espera';

EXPLAIN SELECT u.id_usuario, u.nombre
    FROM USUARIO u
    INNER JOIN MENSAJE me ON u.id_usuario = me.id_usuario_emisor
    WHERE me.id_usuario_receptor = 1;
