--COINCIDENCIA
CREATE TABLE COINCIDENCIAS_PARTICIONADA (
    id_coincidencia SERIAL,
    estado VARCHAR(10) NOT NULL,
	id_usuario_like_receptor INT NOT NULL,
	id_usuario_like_emisor INT NOT NULL,
	fecha DATE NOT NULL,
	FOREIGN KEY (id_usuario_like_receptor) REFERENCES USUARIO(id_usuario),
	FOREIGN KEY (id_usuario_like_emisor) REFERENCES USUARIO(id_usuario),
	PRIMARY KEY(id_coincidencia,estado)
)PARTITION BY LIST(estado);

CREATE TABLE coincidencias_prt_aceptadas PARTITION OF COINCIDENCIAS_PARTICIONADA
FOR VALUES IN ('Aceptado');

CREATE TABLE coincidencias_prt_rechazadas PARTITION OF COINCIDENCIAS_PARTICIONADA
FOR VALUES IN ('Rechazado');

CREATE TABLE coincidencias_prt_en_espera PARTITION OF COINCIDENCIAS_PARTICIONADA
FOR VALUES IN ('En espera');

SELECT * FROM coincidencias_prt_aceptadas;
SELECT * FROM coincidencias_prt_rechazadas;
SELECT * FROM coincidencias_prt_en_espera;
--BLOQUEO
CREATE TABLE BLOQUEO_PARTICIONADA (
    id_bloqueo SERIAL,
    fecha DATE NOT NULL,
	id_usuario_bloqueado INT NOT NULL,
	id_usuario_bloqueo INT NOT NULL,
	FOREIGN KEY (id_usuario_bloqueado) REFERENCES USUARIO(id_usuario),
	FOREIGN KEY (id_usuario_bloqueo) REFERENCES USUARIO(id_usuario),
	PRIMARY KEY(id_bloqueo,fecha)
)PARTITION BY RANGE(fecha);

CREATE TABLE bloqueos_particionada_2022 PARTITION OF BLOQUEO_PARTICIONADA
FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');

CREATE TABLE bloqueos_particionada_2023_1 PARTITION OF BLOQUEO_PARTICIONADA
FOR VALUES FROM ('2023-01-01') TO ('2023-07-01');

CREATE TABLE bloqueos_particionada_2023_2 PARTITION OF BLOQUEO_PARTICIONADA
FOR VALUES FROM ('2023-07-01') TO ('2024-01-01');

SELECT * FROM bloqueos_particionada_2022;
SELECT * FROM bloqueos_particionada_2023_1;
SELECT * FROM bloqueos_particionada_2023_2;

--MENSAJES
CREATE TABLE mensajes_particionada(
    id_mensaje SERIAL,
	id_usuario_like_receptor INT NOT NULL,
	id_usuario_like_emisor INT NOT NULL,
	id_coincidencia INT NOT NULL,
	fecha DATE NOT NULL,
	contenido VARCHAR(255) NOT NULL,
	FOREIGN KEY (id_usuario_like_receptor) REFERENCES USUARIO(id_usuario),
	FOREIGN KEY (id_usuario_like_emisor) REFERENCES USUARIO(id_usuario),
	FOREIGN KEY (id_coincidencia) REFERENCES COINCIDENCIAS(id_coincidencia),
	PRIMARY KEY(id_mensaje,fecha)
)PARTITION BY RANGE(fecha);
	
CREATE TABLE mensajes_particionada2022 PARTITION OF mensajes_particionada
FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');

CREATE TABLE mensajes_particionada2023_1 PARTITION OF mensajes_particionada
FOR VALUES FROM ('2023-01-01') TO ('2023-07-01');

CREATE TABLE mensajes_particionada2023_2 PARTITION OF mensajes_particionada
FOR VALUES FROM ('2023-07-01') TO ('2024-01-01');

select * from mensajes_particionada2022
select * from mensajes_particionada2023_1
select * from mensajes_particionada2023_2

