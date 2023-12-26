CREATE OR REPLACE FUNCTION insertar_o_actualizar_coincidencia(id_like_emisor INT, id_like_receptor INT,fecha DATE)
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
	UPDATE COINCIDENCIAS SET estado = 'Aceptado' WHERE id_usuario_like_emisor = id_like_receptor
	AND id_usuario_like_receptor = id_like_emisor;
	INSERT INTO AUDITORIA_COINCIDENCIAS(estado,id_usuario_like_receptor,id_usuario_like_emisor,fecha) VALUES(
		'Aceptado',
		id_like_receptor,
		id_like_emisor,
		fecha);
ELSEIF estado_comparar ISNULL THEN
	nuevo_estado := 'En espera';
	RAISE NOTICE 'El nuevo estado es %', nuevo_estado;
	INSERT INTO COINCIDENCIAS(estado,id_usuario_like_receptor,id_usuario_like_emisor,fecha) VALUES(nuevo_estado,
		id_like_receptor,
		id_like_emisor,
		fecha);
	INSERT INTO AUDITORIA_COINCIDENCIAS(estado,id_usuario_like_receptor,id_usuario_like_emisor,fecha) VALUES(
		nuevo_estado,
		id_like_receptor,
		id_like_emisor,
		fecha);
ELSEIF estado_comparar = 'Rechazado' THEN
		INSERT INTO AUDITORIA_COINCIDENCIAS(estado,id_usuario_like_receptor,id_usuario_like_emisor,fecha) VALUES(
		'Rechazado',
		id_like_receptor,
		id_like_emisor,
		fecha);
END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE AUDITORIA_COINCIDENCIAS(
	id_coincidencia INT NOT NULL,
	estado VARCHAR(10) NOT NULL,
	id_usuario_like_receptor INT NOT NULL,
	id_usuario_like_emisor INT NOT NULL,
	fecha DATE
);
--SIN INDICE
SELECT insertar_actualizar_coincidencia(1,5000,'2023-09-07'); --Inserta
SELECT insertar_actualizar_coincidencia(2,4999,'2023-09-07'); --Inserta
SELECT insertar_actualizar_coincidencia(3,4998,'2023-09-07'); --Inserta
SELECT insertar_actualizar_coincidencia(4,4997,'2023-09-07'); --Inserta
SELECT insertar_actualizar_coincidencia(5,4996,'2023-09-07'); --Inserta
SELECT insertar_actualizar_coincidencia(6,4995,'2023-09-07'); --Inserta
SELECT insertar_actualizar_coincidencia(7,4994,'2023-09-07'); --Inserta
SELECT insertar_actualizar_coincidencia(8,4993,'2023-09-07'); --Inserta
SELECT insertar_actualizar_coincidencia(5000,1,'2023-09-07'); --Actualiza
SELECT insertar_actualizar_coincidencia(4999,2,'2023-09-07'); --Actualiza
SELECT insertar_actualizar_coincidencia(4998,3,'2023-09-07'); --Actualiza
SELECT insertar_actualizar_coincidencia(4997,4,'2023-09-07'); --Actualiza
SELECT insertar_actualizar_coincidencia(4996,5,'2023-09-07'); --Actualiza
SELECT insertar_actualizar_coincidencia(4995,6,'2023-09-07'); --Actualiza
SELECT insertar_actualizar_coincidencia(4994,7,'2023-09-07'); --Actualiza
SELECT insertar_actualizar_coincidencia(4993,8,'2023-09-07'); --Actualiza

--CON INDICE
SELECT insertar_actualizar_coincidencia(9,4992,'2023-09-07'); --Inserta
SELECT insertar_actualizar_coincidencia(10,4991,'2023-09-07'); --Inserta
SELECT insertar_actualizar_coincidencia(11,4990,'2023-09-07'); --Inserta
SELECT insertar_actualizar_coincidencia(12,4989,'2023-09-07'); --Inserta
SELECT insertar_actualizar_coincidencia(13,4988,'2023-09-07'); --Inserta
SELECT insertar_actualizar_coincidencia(14,4987,'2023-09-07'); --Inserta
SELECT insertar_actualizar_coincidencia(15,4986,'2023-09-07'); --Inserta
SELECT insertar_actualizar_coincidencia(16,4985,'2023-09-07'); --Inserta
SELECT insertar_actualizar_coincidencia(4992,9,'2023-09-07'); --Actualiza
SELECT insertar_actualizar_coincidencia(4991,10,'2023-09-07'); --Actualiza
SELECT insertar_actualizar_coincidencia(4990,11,'2023-09-07'); --Actualiza
SELECT insertar_actualizar_coincidencia(4989,12,'2023-09-07'); --Actualiza
SELECT insertar_actualizar_coincidencia(4988,13,'2023-09-07'); --Actualiza
SELECT insertar_actualizar_coincidencia(4987,14,'2023-09-07'); --Actualiza
SELECT insertar_actualizar_coincidencia(4986,15,'2023-09-07'); --Actualiza
SELECT insertar_actualizar_coincidencia(4985,16,'2023-09-07'); --Actualiza


