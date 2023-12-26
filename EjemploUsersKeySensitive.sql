CREATE USER mi_usuario_lectura PASSWORD 'Jer*onimO_123456789';
GRANT CONNECT ON DATABASE "Tinder" TO mi_usuario_lectura;
GRANT USAGE ON SCHEMA PUBLIC TO mi_usuario_lectura;
GRANT SELECT ON TABLE pais TO mi_usuario_lectura ;


CREATE TABLE USUARIOSSSS(
	id serial,
	"Nombre" VARCHAR(150)
);

CREATE TABLE "USUARIOSS"(
	id serial,
	nombre VARCHAR(150)
);


SELECT * FROM USUARIOSSSS where "Nombre" ='Luis';