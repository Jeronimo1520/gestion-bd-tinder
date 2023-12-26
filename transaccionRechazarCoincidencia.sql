CREATE OR REPLACE FUNCTION rechazar_coincidencia(id_like_emisor INT, id_like_receptor INT,fecha DATE)
RETURNS VOID AS $$
DECLARE 
	estado_comparar VARCHAR(10);
	nuevo_estado VARCHAR(10);
BEGIN
SELECT estado 
INTO estado_comparar
FROM COINCIDENCIAS WHERE id_usuario_like_emisor = id_like_receptor AND id_usuario_like_receptor = id_like_emisor;
RAISE NOTICE 'El valor de estado_comparar es %', estado_comparar;
IF estado_comparar = 'En espera' THEN
	UPDATE COINCIDENCIAS SET estado = 'Rechazado' WHERE id_usuario_like_emisor = id_like_receptor
	AND id_usuario_like_receptor = id_like_emisor;
	nuevo_estado := 'Rechazado';
	INSERT INTO AUDITORIA_COINCIDENCIAS(estado,id_usuario_like_receptor,id_usuario_like_emisor,fecha) VALUES(
		nuevo_estado,
		id_like_receptor,
		id_like_emisor,
		fecha
);
ELSEIF estado_comparar ISNULL THEN
	nuevo_estado := 'Rechazado';
	INSERT INTO COINCIDENCIAS(estado,id_usuario_like_receptor,id_usuario_like_emisor,fecha) VALUES(
		nuevo_estado,
		id_like_receptor,
		id_like_emisor,
		fecha
);
	INSERT INTO AUDITORIA_COINCIDENCIAS(estado,id_usuario_like_receptor,id_usuario_like_emisor,fecha) VALUES(
		nuevo_estado,
		id_like_receptor,
		id_like_emisor,
		fecha
);
END IF;
END;
$$ LANGUAGE plpgsql;
--SIN INDICE
SELECT rechazar_coincidencia(2558,7,'2023-09-07'); --Actualiza
SELECT rechazar_coincidencia(3182,9,'2023-09-07'); --Actualiza
SELECT rechazar_coincidencia(3241,10,'2023-09-07'); --Actualiza
SELECT rechazar_coincidencia(4117,12,'2023-09-07'); --Actualiza
SELECT rechazar_coincidencia(3677,17,'2023-09-07'); --Actualiza

--CON INDICE
SELECT rechazar_coincidencia(2558,7,'2023-09-07'); --Actualiza
SELECT rechazar_coincidencia(3182,9,'2023-09-07'); --Actualiza
SELECT rechazar_coincidencia(3241,10,'2023-09-07'); --Actualiza
SELECT rechazar_coincidencia(4117,12,'2023-09-07'); --Actualiza
SELECT rechazar_coincidencia(3677,17,'2023-09-07'); --Actualiza






