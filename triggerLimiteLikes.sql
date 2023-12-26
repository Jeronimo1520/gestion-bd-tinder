CREATE OR REPLACE FUNCTION validar_numero_coincidencias()
RETURNS TRIGGER AS $$
DECLARE
	id_emisor INT:= NEW.id_usuario_like_emisor;
	coincidencias_emisor INT;
	es_premium BOOLEAN;
BEGIN
	RAISE NOTICE 'ID EMISOR: %', id_emisor;
	RAISE NOTICE 'FECHA: %',current_date-1;
	
	SELECT premium
    INTO es_premium
    FROM USUARIO
    WHERE id_usuario = id_emisor;
	
	SELECT COUNT(*)
    INTO coincidencias_emisor
    FROM COINCIDENCIAS 
    WHERE id_emisor = id_usuario_like_emisor 
   	AND fecha = current_date-1;
	RAISE NOTICE 'El número de coincidencias para el emisor es: %', coincidencias_emisor;
	RAISE NOTICE 'El usuario es premium: %',es_premium;
	IF es_premium THEN
        RETURN NEW;
	ELSE
		IF coincidencias_emisor > 2 THEN
        	RAISE EXCEPTION 'Se ha alcanzado el límite de 20 coincidencias para el emisor.';
		ELSE
			RETURN NEW;
    	END IF;
	END IF;
END;
$$ LANGUAGE plpgsql;
	
CREATE TRIGGER limite_coincidencias
BEFORE INSERT ON
COINCIDENCIAS
FOR EACH ROW
EXECUTE FUNCTION validar_numero_coincidencias();

DROP TRIGGER limite_coincidencias ON COINCIDENCIAS ;


INSERT INTO COINCIDENCIAS(estado,id_usuario_like_receptor,id_usuario_like_emisor,fecha)
VALUES('En espera',1,2,'2023-10-31');

INSERT INTO COINCIDENCIAS(estado,id_usuario_like_receptor,id_usuario_like_emisor,fecha)
VALUES('En espera',3,2,'2023-10-27');

INSERT INTO COINCIDENCIAS(estado,id_usuario_like_receptor,id_usuario_like_emisor,fecha)
VALUES('En espera',4,2,'2023-10-27');