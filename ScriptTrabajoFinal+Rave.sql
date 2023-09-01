
DROP DATABASE IF EXISTS  Bromatologia;
CREATE DATABASE Bromatologia;
USE Bromatologia;

-- CURSO MANIPULACION ALIMENTOS --

CREATE TABLE Datos_Personales (
  id_datos_personales INT NOT NULL AUTO_INCREMENT,
  Telefono VARCHAR (20) DEFAULT NULL,
  Email VARCHAR (130) UNIQUE,
  Direccion VARCHAR (50) DEFAULT NULL,
  CONSTRAINT PK_DATOS_PERSONALES PRIMARY KEY (id_datos_personales)
);

CREATE TABLE Inspectores (
  id_inspector INT NOT NULL AUTO_INCREMENT UNIQUE,
  id_datos_personales INT NOT NULL UNIQUE,
  Legajo INT NOT NULL UNIQUE,
  Nombre  VARCHAR (50) NOT NULL,
  Apellido VARCHAR (50) NOT NULL,
  Turno  VARCHAR (10) NOT NULL,
  Cargo VARCHAR (50) NOT NULL,
  CONSTRAINT PK_INSPECTORES PRIMARY KEY (id_inspector),
  FOREIGN KEY (id_datos_personales) REFERENCES Datos_Personales(id_datos_personales) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Profesores (
  id_profesor INT NOT NULL AUTO_INCREMENT UNIQUE,
  id_inspector INT NOT NULL,
  CONSTRAINT PK_PROFESORES PRIMARY KEY (id_profesor),
  FOREIGN KEY (id_inspector) REFERENCES Inspectores(id_inspector) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Curso_Manipulacion (
  id_curso INT NOT NULL AUTO_INCREMENT UNIQUE,
  id_profesor INT NOT NULL,
  id_alumno INT NOT NULL UNIQUE,
  id_nota INT DEFAULT NULL,
  Fecha_inicio DATE NOT NULL,
  Fecha_final DATE DEFAULT NULL,
  CONSTRAINT PK_CURSO PRIMARY KEY (id_curso),
  FOREIGN KEY (id_profesor) REFERENCES Profesores(id_profesor) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Alumnos (
	id_alumno INT NOT NULL AUTO_INCREMENT UNIQUE,
    id_curso INT DEFAULT NULL,
    id_nota INT DEFAULT NULL,
    Nombre  VARCHAR (50) NOT NULL,
	Apellido VARCHAR (50) NOT NULL,
	DNI VARCHAR (20) NOT NULL,
    Telefono VARCHAR (20 ),
	Email VARCHAR (130),
    CONSTRAINT PK_ALUMNOS PRIMARY KEY (id_alumno),
	FOREIGN KEY (id_curso) REFERENCES Curso_Manipulacion(id_curso) ON DELETE RESTRICT ON UPDATE CASCADE,
	INDEX idx_dni (DNI)
);

CREATE TABLE Notas (
	id_nota INT NOT NULL AUTO_INCREMENT,
	id_alumno INT NOT NULL,
    id_curso INT NOT NULL,
    Calificacion INT NOT NULL,
    CONSTRAINT PK_NOTAS PRIMARY KEY (id_nota),
	FOREIGN KEY (id_curso) REFERENCES Curso_Manipulacion(id_curso) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_alumno) REFERENCES Alumnos(id_alumno) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- GRUPO DE INSPECTORES --

CREATE TABLE Grupos (
	id_grupo INT NOT NULL AUTO_INCREMENT UNIQUE,
	Nombre_grupo  VARCHAR (50) NOT NULL UNIQUE,
	CONSTRAINT PK_GRUPOS PRIMARY KEY (id_grupo)
);

CREATE TABLE Grupo_Inspectores (
	id_inspectores INT NOT NULL AUTO_INCREMENT UNIQUE,
    id_grupo INT NOT NULL,
	id_inspector INT NOT NULL,
	CONSTRAINT PK_GRUPO_INSPECTORES PRIMARY KEY (id_inspectores),
    FOREIGN KEY (id_grupo) REFERENCES Grupos(id_grupo) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_inspector) REFERENCES Inspectores(id_inspector) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- VEHICULOS --

CREATE TABLE Vehiculos (
	id_vehiculo INT NOT NULL AUTO_INCREMENT UNIQUE,
    Numero_habilitacion INT NOT NULL UNIQUE,
	Patente  VARCHAR (50) NOT NULL,
    Razon_social  VARCHAR (50) NOT NULL,
	CONSTRAINT PK_VEHICULOS PRIMARY KEY (id_vehiculo),
    INDEX idx_numero_habilitacion (Numero_habilitacion)
);

CREATE TABLE Rubros_vehiculos (
	id_rubro_vehiculo INT NOT NULL AUTO_INCREMENT UNIQUE,
	Rubros  VARCHAR (100) NOT NULL,
	CONSTRAINT PK_RUBROS_VEHICULOS PRIMARY KEY (id_rubro_vehiculo)
);

CREATE TABLE Segundo_control (
	id_segundo_control INT NOT NULL AUTO_INCREMENT UNIQUE,
	Acta_vehiculo  VARCHAR (20) NOT NULL UNIQUE,
    Acta_infraccion  VARCHAR (20) UNIQUE DEFAULT NULL,
    Fecha_control  DATE DEFAULT NULL,
    id_vehiculo INT NOT NULL,
	CONSTRAINT PK_SEGUNDO_CONTROL PRIMARY KEY (id_segundo_control),
    FOREIGN KEY (id_vehiculo) REFERENCES Vehiculos(id_vehiculo) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Habilitacion_vehiculos (
	id_registro INT NOT NULL AUTO_INCREMENT UNIQUE,
	id_vehiculo INT NOT NULL,
    id_rubro_vehiculo INT NOT NULL,
    id_segundo_control INT DEFAULT NULL,
    id_inspector INT NOT NULL,
	Fecha  DATE NOT NULL,
    Observaciones VARCHAR(100) DEFAULT NULL, 
	CONSTRAINT PK_SEGUNDO_CONTROL PRIMARY KEY (id_registro),
    FOREIGN KEY (id_inspector) REFERENCES Inspectores(id_inspector) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_segundo_control) REFERENCES Segundo_control(id_segundo_control) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_rubro_vehiculo) REFERENCES Rubros_vehiculos(id_rubro_vehiculo) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_vehiculo) REFERENCES Vehiculos(id_vehiculo) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- COMERCIOS --

CREATE TABLE Rubros_comercio (
	id_rubro_comercio INT NOT NULL AUTO_INCREMENT UNIQUE,
	Rubros  VARCHAR (100) NOT NULL,
	CONSTRAINT PK_RUBROS_COMERCIO PRIMARY KEY (id_rubro_comercio)
);

CREATE TABLE Comercios (
	id_comercio INT NOT NULL AUTO_INCREMENT UNIQUE,
    id_rubro_comercio INT NOT NULL,
    Razon_social  VARCHAR (50) NOT NULL,
    Direccion  VARCHAR (50) NOT NULL,
    Expediente_habilitacion  VARCHAR (20) UNIQUE,
    Numero_cuenta  VARCHAR (20) DEFAULT NULL,
	CONSTRAINT PK_COMERCIOS PRIMARY KEY (id_comercio),
    FOREIGN KEY (id_rubro_comercio) REFERENCES Rubros_comercio(id_rubro_comercio) ON DELETE RESTRICT ON UPDATE CASCADE,
	INDEX idx_expediente_habilitacion (Expediente_habilitacion)
);

CREATE TABLE Actas (
	id_acta INT NOT NULL AUTO_INCREMENT UNIQUE,
    Acta_inspeccion VARCHAR (20) NOT NULL UNIQUE,
    Acta_constatacion VARCHAR (20) UNIQUE,
    Acta_comiso VARCHAR (20) DEFAULT NULL,
    Acta_clausura VARCHAR (20) DEFAULT NULL,
    Acta_secuentro_intervencion VARCHAR (20) DEFAULT NULL,
	Descripcion  VARCHAR (100) NOT NULL,
	CONSTRAINT PK_ACTAS PRIMARY KEY (id_acta),
    INDEX idx_acta_inspeccion (Acta_inspeccion)
);

CREATE TABLE Denuncias (
	id_denuncia INT NOT NULL AUTO_INCREMENT UNIQUE,
    id_acta INT UNIQUE,
    Direccion VARCHAR (100) NOT NULL,
	Descripcion  VARCHAR (100) NOT NULL,
    Fecha DATE NOT NULL,
    Numero_orden INT NOT NULL UNIQUE,
	CONSTRAINT PK_DENUNCIAS PRIMARY KEY (id_denuncia),
    FOREIGN KEY (id_acta) REFERENCES Actas(id_acta) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Inspecciones (
	id_inspeccion INT NOT NULL AUTO_INCREMENT UNIQUE,
	id_denuncia INT DEFAULT NULL,
    id_acta INT NOT NULL,
	id_comercio INT NOT NULL,
    id_inspectores INT NOT NULL,
    Fecha DATE NOT NULL,
	CONSTRAINT PK_INSPECCIONES PRIMARY KEY (id_inspeccion),
    FOREIGN KEY (id_denuncia) REFERENCES Denuncias(id_denuncia) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_acta) REFERENCES Actas(id_acta) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_comercio) REFERENCES Comercios(id_comercio) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_inspectores) REFERENCES Grupo_Inspectores(id_inspectores) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Habilitacion_comercios (
	id_habilitacion INT NOT NULL AUTO_INCREMENT UNIQUE,
    id_comercio INT NOT NULL,
    id_inspectores INT NOT NULL,
    id_acta INT NOT NULL,
    fecha DATE NOT NULL,
    CONSTRAINT PK_HABILITACIONES_COMERCIO PRIMARY KEY (id_habilitacion),
    FOREIGN KEY (id_acta) REFERENCES Actas(id_acta) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_comercio) REFERENCES Comercios(id_comercio) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_inspectores) REFERENCES Grupo_Inspectores(id_inspectores) ON DELETE RESTRICT ON UPDATE CASCADE
);

ALTER TABLE Curso_Manipulacion ADD CONSTRAINT fk_curso_manipulacion_alumno FOREIGN KEY (id_alumno) REFERENCES Alumnos(id_alumno) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE Curso_Manipulacion ADD CONSTRAINT fk_curso_manipulacion_nota FOREIGN KEY (id_nota) REFERENCES Notas(id_nota) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE Alumnos ADD CONSTRAINT fk_Alumnos_nota FOREIGN KEY (id_nota) REFERENCES Notas(id_nota) ON DELETE RESTRICT ON UPDATE CASCADE;




-- Inserciones --


-- CARGA DE DATOS --

-- Inspectores--

INSERT INTO datos_personales VALUES 
(null, '2236942265', 'prueba@prueba.com', 'Calle falsa 123'),
(null, '2234567865', 'prueba2@prueba.com', 'Calle falsa 234'),
(null, '2234343455', 'prueba3@prueba.com', 'Rivadavia 4435'),
(null, '2234567865', 'prueba4@prueba.com', 'Dorrego 13421'),
(null, '2234567865', 'prueba5@prueba.com', 'Castelli 66'),
(null, '2234562365', 'prueba6@prueba.com', 'Brown 66');


INSERT INTO inspectores VALUES 
(null, 1, 31468, 'Tomas', 'Rave', 'Mañana', 'Profesional'),
(null, 2, 31462, 'Facundo', 'Irazabal', 'Mañana', 'Profesional'),
(null, 3, 31461, 'Javier', 'Gherbi', 'Mañana', 'Profesional'),
(null, 4, 31469, 'Julian', 'Perez', 'Mañana', 'Profesional'),
(null, 5, 10897, 'Juan', 'Colombo', 'Tarde', 'Tecnico superior');

-- Curso --
INSERT INTO profesores VALUES 
(null, 2),
(null, 5);

INSERT INTO alumnos VALUES 
(null, null, null, 'Javier', 'Perez', '34567890', '2235678909', 'perez@gmail.com'),
(null, null, null, 'Pablo', 'Garcia', '43267890', '2235238769', 'garcia@gmail.com'),
(null, null, null, 'Horacio', 'Kan', '12367890', '2235612769', 'Kan@gmail.com'),
(null, null, null, 'Pepe', 'Lanzani', '42267890', '2235228769', 'Lanzani@gmail.com');


INSERT INTO curso_manipulacion VALUES 
(null, 1, 1, null, current_date, null),
(null, 2, 2, null, current_date, null),
(null, 1, 3, null, current_date, null),
(null, 2, 4, null, current_date, null);

INSERT INTO notas VALUES 
(null, 1, 1, 7),
(null, 2, 2, 4);


UPDATE alumnos SET id_nota = 1 WHERE id_alumno = 1;
UPDATE alumnos SET id_nota = 2 WHERE id_alumno = 2;

UPDATE curso_manipulacion SET id_nota = 1 WHERE id_curso = 1;
UPDATE curso_manipulacion SET id_nota = 2 WHERE id_curso = 2;

UPDATE curso_manipulacion SET Fecha_final = current_date + 1 WHERE id_curso = 1;
UPDATE curso_manipulacion SET Fecha_final = current_date + 1 WHERE id_curso = 2;

-- Vehiculos --

INSERT INTO vehiculos VALUES 
(null, 14560, 'VPT123', 'Rabbione'),
(null, 15678, 'AA234CC', 'Juan Perez'),
(null, 678, 'ASD456', 'Julian Massilla'),
(null, 13360, 'VPT153', 'Romagnoli');

INSERT INTO rubros_vehiculos VALUES 
(null, 'No perecederos, bebidas'),
(null, 'Alimentos congelados'),
(null, 'Carnes vacunas'),
(null, 'Articulos de limpieza');

INSERT INTO segundo_control VALUES 
(null, '32567B', null, null, 1);

INSERT INTO habilitacion_vehiculos VALUES 
(null, 1, 3, 1, 1, current_date, null),
(null, 2, 2, null, 1, current_date, null),
(null, 3, 2, null, 1, current_date, null),
(null, 4, 1, null, 1, current_date, null);

-- grupos de inspectores--
INSERT INTO grupos VALUES 
(null, 'grupo 1'),
(null, 'grupo 2'),
(null, 'grupo 3');

INSERT INTO grupo_inspectores VALUES 
(null, 2, 3),
(null, 2, 2),
(null, 2, 4);

-- comercios --

INSERT INTO denuncias VALUES 
(null, null, 'Brown 1234', 'Presencia de ratas', current_date, 55),
(null, null, 'Falucho 233', 'Presencia de cucarachas', current_date, 56);

INSERT INTO actas VALUES 
(null, '3466778B', '623345', null,  '345', null,'Presencia de ratas'),
(null, '3456783B', null, null, null, null, 'Habilitacion de comercio'),
(null, '3466007B', null, '997', null, null,'Inspeccion, comiso'),
(null, '3466997C', null, null, null, null,'Habilitacion de comercio'),
(null, '3783997B', null, null, null, null,'Habilitacion de comercio'),
(null, '3452223B', null, null, null, null, 'Habilitacion de comercio');

INSERT INTO rubros_comercio VALUES
(null, 'Despensa'),
(null, 'Fiambreria, panaderia, despensa'),
(null, 'Carniceria, granja'),
(null, 'Polleria, elaboracion de milanesas'),
(null, 'Fabrica de embutidos');

INSERT INTO comercios VALUES
(null, 3, 'Los Reseros S.R.L.', 'Colon 3344', '123/B/99', '12334'),
(null, 5, 'Los Abuelos S.A', 'Luro 33', '234521/B/08', '12312B'),
(null, 1, 'C.S.A S.A.', 'Gascon 2344', '1222/2/23', '32123'),
(null, 1, 'Muria', 'Gascon 45', '122/A/23', '3123'),
(null, 4, 'Roberto Ruben', 'Colon 2344', '12/Z/23', '223'),
(null, 1, 'Maria Laura.', 'Luro 44', '5/2/23', '12344'),
(null, 2, 'Los Reseros', 'Italia 222', '1234/2/22', '122312A');


INSERT INTO habilitacion_comercios VALUES
(null, 2, 1, 2, current_date),
(null, 7, 1, 4, current_date),
(null, 4, 1, 5, current_date),
(null, 6, 1, 6, current_date);

INSERT INTO inspecciones VALUES
(null, 1, 1, 3, 2, current_date),
(null, null, 3, 1, 2, current_date);

UPDATE denuncias SET id_acta = 1 WHERE id_denuncia = 1;




-- Creacion de vistas --



-- VIEW para visualizar las habilitaciones de vehiculos, se crea para acceder rapidamente a toda la informacion de las habilitaciones de vehiculos --

CREATE OR REPLACE VIEW View_Habilitacion_Vehiculos AS
SELECT
    v.Numero_habilitacion AS numero_habilitacion,
    v.Patente AS patente,
    v.Razon_social AS razon_social,
    rv.Rubros AS Rubros,
    i.apellido AS inspector_apellido,
    hv.fecha,
    CASE
        WHEN hv.id_segundo_control IS NOT NULL
        THEN sc.Acta_vehiculo
        ELSE NULL
    END AS Acta_vehiculo,
     CASE
        WHEN hv.id_segundo_control IS NOT NULL
        THEN sc.Fecha_control
        ELSE NULL
    END AS Fecha_control,
     CASE
        WHEN hv.id_segundo_control IS NOT NULL
        THEN sc.Acta_infraccion
        ELSE NULL
    END AS Acta_infraccion
FROM
    Habilitacion_vehiculos hv
JOIN
    Vehiculos v ON hv.id_vehiculo = v.id_vehiculo
JOIN
    Rubros_vehiculos rv ON hv.id_rubro_vehiculo = rv.id_rubro_vehiculo
JOIN
    Inspectores i ON hv.id_inspector = i.id_inspector
LEFT JOIN
    Segundo_control sc ON hv.id_segundo_control = sc.id_segundo_control;
    
-- VIEW visualizacion habilitacion de comercios, se crea para acceder rapidamente a toda la informacion de las habilitaciones de comercio --


CREATE OR REPLACE VIEW View_Habilitacion_comercios AS
SELECT
    c.Expediente_habilitacion AS Expediente_habilitacion,
    c.Direccion AS Direccion,
    c.Razon_social AS razon_social,
	c.Numero_cuenta AS Numero_cuenta,
    rc.Rubros AS Rubros,
    gi.id_inspectores AS id_inspectores,
    a.Acta_inspeccion AS Acta_inspeccion,
    hc.fecha
FROM
    Habilitacion_comercios hc
JOIN
    Comercios c ON hc.id_comercio = c.id_comercio
JOIN
    Actas a ON hc.id_acta = a.id_acta
JOIN
    Rubros_comercio rc ON c.id_rubro_comercio = rc.id_rubro_comercio
JOIN
    Grupo_inspectores gi ON hc.id_inspectores = gi.id_inspectores;

-- VIEW Inspecciones, se crea para acceder rapidamente a toda la informacion de las inspecciones --


CREATE OR REPLACE VIEW View_Comercio AS
SELECT
    c.Expediente_habilitacion AS Expediente_habilitacion,
    c.Direccion AS Direccion,
    c.Razon_social AS razon_social,
	c.Numero_cuenta AS Numero_cuenta,
    rc.Rubros AS Rubros,
    gi.id_inspectores AS id_inspectores,
    a.Acta_inspeccion AS Acta_inspeccion,
    a.Acta_constatacion AS Acta_constatacion,
    a.Acta_comiso AS Acta_comiso,
    a.Acta_clausura AS Acta_clausura,
    a.Acta_secuentro_intervencion AS Acta_secuentro_intervencion,
    a.Descripcion AS Descripcion,
    i.fecha,
	CASE
        WHEN i.id_denuncia IS NOT NULL
        THEN d.Numero_orden
        ELSE NULL
    END AS Numero_orden
FROM
    Inspecciones i
JOIN
    Comercios c ON i.id_comercio = c.id_comercio
JOIN
    Actas a ON i.id_acta = a.id_acta
JOIN
    Rubros_comercio rc ON c.id_rubro_comercio = rc.id_rubro_comercio
JOIN
    Grupo_inspectores gi ON i.id_inspectores = gi.id_inspectores
LEFT JOIN
    Denuncias d ON i.id_denuncia = d.id_denuncia;

-- VIEW Cursos, se crea para acceder rapidamente a toda la informacion de los cursos de manipulacion de alimentos --

CREATE OR REPLACE VIEW View_Curso_manipulacion AS
SELECT
    p.id_profesor AS id_profesor,
	a.Nombre AS Nombre_alumno,
    a.Apellido AS Apellido_alumno,
    a.DNI AS DNI,
    cm.Fecha_inicio AS Fecha_inicio,
    cm.Fecha_final AS Fecha_final,
    CASE
        WHEN n.id_nota IS NOT NULL
        THEN n.Calificacion
        ELSE NULL
    END AS Calificacion
FROM
    Curso_manipulacion cm
JOIN
    Alumnos a ON cm.id_alumno = a.id_alumno
JOIN
    Profesores p ON cm.id_profesor = p.id_profesor
LEFT JOIN
    Notas n ON cm.id_nota = n.id_nota;

-- VIEW Grupo-inspectores, se crea para acceder rapidamente a toda la informacion de los inspectores --

CREATE OR REPLACE VIEW View_grupo_inspectores AS
SELECT
	i.Nombre AS Nombre,
    i.Apellido As Apellido,
    i.Legajo AS Legajo,
    i.Turno AS Turno,
    g.Nombre_grupo AS Nombre_grupo
FROM
	Grupo_inspectores gi
JOIN
	Inspectores i ON gi.id_inspector = i.id_inspector
JOIN
	Grupos g ON gi.id_grupo = g.id_grupo;
    
    
    
    
    
    
-- Creacion de funciones --

-- Funcion para hacer un conteo rapido de todas las habilitaciones de vehiculos hechas en un periodo de tiempo --

DELIMITER $$
USE bromatologia $$

CREATE FUNCTION `contar_habilitacion_vehiculos` (fecha DATE) 
RETURNS INT
reads sql data
BEGIN
	declare resultado INT;
    SET resultado =  (SELECT COUNT(id_registro) AS Habilitaciones
		FROM bromatologia.habilitacion_vehiculos
        WHERE Fecha BETWEEN fecha AND current_date);
	RETURN resultado;
END$$

-- Funcion para hacer un conteo rapido de todas las habilitaciones de comercios hechas en un periodo de tiempo --

CREATE FUNCTION `contar_habilitacion_comercios` (fecha DATE) 
RETURNS INT
reads sql data
BEGIN
	declare resultado INT;
    SET resultado =  (SELECT COUNT(id_habilitacion) AS Habilitaciones
		FROM bromatologia.habilitacion_comercios
        WHERE Fecha BETWEEN fecha AND current_date);
	RETURN resultado;
END$$

-- Funcion para saber la cantidad de cursos dictados por cada profesor --

CREATE FUNCTION `cursos_profesor` (profesor INT) 
RETURNS INT
reads sql data
BEGIN
	declare resultado INT;
    SET resultado =  (SELECT COUNT(id_curso) AS Cursos_dictados
		FROM bromatologia.curso_manipulacion
        WHERE id_profesor = profesor);
	RETURN resultado;
END$$

-- Funcion creada para saber la cantidad de denuncias sin realizar --

CREATE FUNCTION `denuncias_pendientes` (fecha DATE) 
RETURNS INT
reads sql data
BEGIN
	declare resultado INT;
    SET resultado =  (SELECT COUNT(id_denuncia) AS Denuncias_pendientes
		FROM bromatologia.denuncias
        WHERE id_acta IS NULL AND Fecha BETWEEN fecha AND current_date);
	RETURN resultado;
END$$

DELIMITER ;






-- Creacion de Procedures --

DELIMITER $$
-- Se debe usar uno de los campos precentes en el VIEW de comercios y la direccion en mayusculas (ASC o DESC). Ordena la habilitacion de comercios de forma ascendente o descendente --
DROP PROCEDURE IF EXISTS `sp_vw_comercio_orden` $$
CREATE PROCEDURE `sp_vw_comercio_orden` (IN campo VARCHAR(30), IN direccion VARCHAR(4))
BEGIN
	IF campo IS NOT NULL THEN
		SET @comercio_orden = CONCAT(' ORDER BY ', campo,' ', direccion);
	ELSE 
		SET @comercio_orden = ' ';
	END IF;

	SET @consulta = CONCAT('SELECT * FROM bromatologia.view_comercio', @comercio_orden);
    PREPARE ejecutar FROM @consulta;
    EXECUTE ejecutar;
	DEALLOCATE PREPARE ejecutar;
END $$

-- Se debe usar un DNI de los insertados en alumnos y una nota INT. Actualiza las tablas de curso de manipulacion de alimentos y de alumnos cada vez q se cargue una nota. --
DROP PROCEDURE IF EXISTS `sp_alumnos_nota` $$
CREATE PROCEDURE `sp_alumnos_nota`(IN nota INT, IN alumno_DNI VARCHAR(30))
BEGIN
    DECLARE alumno_variable INT;
    DECLARE curso_variable INT;
    DECLARE nuevo_id_nota INT;

    SELECT id_alumno INTO alumno_variable FROM bromatologia.alumnos WHERE DNI = alumno_DNI;

    SELECT id_curso INTO curso_variable FROM bromatologia.curso_manipulacion WHERE id_alumno = alumno_variable;

    IF nota IS NOT NULL THEN

        INSERT INTO bromatologia.notas (id_nota, id_alumno, id_curso, Calificacion) VALUES (null, alumno_variable, curso_variable, nota);
        SET nuevo_id_nota = LAST_INSERT_ID();
        
        UPDATE bromatologia.curso_manipulacion SET id_nota = nuevo_id_nota WHERE id_alumno = alumno_variable;
        UPDATE bromatologia.alumnos SET id_nota = nuevo_id_nota WHERE id_alumno = alumno_variable;
    END IF;
END $$

DELIMITER ;DELIMITER $$
-- Se debe usar uno de los campos precentes en el VIEW de comercios y la direccion en mayusculas (ASC o DESC). Ordena la habilitacion de comercios de forma ascendente o descendente --
DROP PROCEDURE IF EXISTS `sp_vw_comercio_orden` $$
CREATE PROCEDURE `sp_vw_comercio_orden` (IN campo VARCHAR(30), IN direccion VARCHAR(4))
BEGIN
	IF campo IS NOT NULL THEN
		SET @comercio_orden = CONCAT(' ORDER BY ', campo,' ', direccion);
	ELSE 
		SET @comercio_orden = ' ';
	END IF;

	SET @consulta = CONCAT('SELECT * FROM bromatologia.view_comercio', @comercio_orden);
    PREPARE ejecutar FROM @consulta;
    EXECUTE ejecutar;
	DEALLOCATE PREPARE ejecutar;
END $$

-- Se debe usar un DNI de los insertados en alumnos y una nota INT. Actualiza las tablas de curso de manipulacion de alimentos y de alumnos cada vez q se cargue una nota. --
DROP PROCEDURE IF EXISTS `sp_alumnos_nota` $$
CREATE PROCEDURE `sp_alumnos_nota`(IN nota INT, IN alumno_DNI VARCHAR(30))
BEGIN
    DECLARE alumno_variable INT;
    DECLARE curso_variable INT;
    DECLARE nuevo_id_nota INT;

    SELECT id_alumno INTO alumno_variable FROM bromatologia.alumnos WHERE DNI = alumno_DNI;

    SELECT id_curso INTO curso_variable FROM bromatologia.curso_manipulacion WHERE id_alumno = alumno_variable;

    IF nota IS NOT NULL THEN

        INSERT INTO bromatologia.notas (id_nota, id_alumno, id_curso, Calificacion) VALUES (null, alumno_variable, curso_variable, nota);
        SET nuevo_id_nota = LAST_INSERT_ID();
        
        UPDATE bromatologia.curso_manipulacion SET id_nota = nuevo_id_nota WHERE id_alumno = alumno_variable;
        UPDATE bromatologia.alumnos SET id_nota = nuevo_id_nota WHERE id_alumno = alumno_variable;
    END IF;
END $$

DELIMITER ;





-- Crecacion de triggers --

-- Tablas para almacenar los datos anteriores tanto de UPDATE como DELETE --
DROP TABLE IF EXISTS log_vehiculos_evento_OLD;
CREATE TABLE log_vehiculos_evento_OLD (
	evento VARCHAR(50),
	id_vehiculo INT,
    Numero_habilitacion INT,
    Patente VARCHAR(50),
    Razon_social VARCHAR(50),
    Usuario VARCHAR(50),
    Fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS log_denuncias_evento_OLD;
CREATE TABLE log_denuncias_evento_OLD (
	evento VARCHAR(50),
	id_denuncia INT,
    id_acta INT,
    Direccion VARCHAR(100),
    Descripcion VARCHAR(100),
    Fecha DATE,
    Numero_orden INT,
	Usuario VARCHAR(50),
    Fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS log_alumnos_evento_OLD;
CREATE TABLE log_alumnos_evento_OLD (
	evento VARCHAR(50),
	id_alumno INT,
    id_curso INT,
    id_nota INT,
    Nombre VARCHAR(50),
    Apellido VARCHAR(50),
    DNI VARCHAR(50),
    Telefono VARCHAR(50),
    Email  VARCHAR(130),
    Usuario VARCHAR(50),
    Fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS log_comercio_evento_OLD;
CREATE TABLE log_comercio_evento_OLD (
	evento VARCHAR(50),
    id_comercio INT,
    id_rubro_comercio INT,
    Razon_social VARCHAR(50),
    Direccion VARCHAR(50),
    Expediente_habilitacion VARCHAR(20),
    Numero_cuenta VARCHAR(20),
    Usuario VARCHAR(50),
    Fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- tablas para almacenar los datos nuevos generados en UPDATE e INSERT --

DROP TABLE IF EXISTS log_vehiculos_evento_NEW;
CREATE TABLE log_vehiculos_evento_NEW (
	evento VARCHAR(50),
	id_vehiculo INT,
    Numero_habilitacion INT,
    Patente VARCHAR(50),
    Razon_social VARCHAR(50),
    Usuario VARCHAR(50),
    Fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS log_denuncias_evento_NEW;
CREATE TABLE log_denuncias_evento_NEW (
	evento VARCHAR(50),
	id_denuncia INT,
    id_acta INT,
    Direccion VARCHAR(100),
    Descripcion VARCHAR(100),
    Fecha DATE,
    Numero_orden INT,
	Usuario VARCHAR(50),
    Fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS log_alumnos_evento_NEW;
CREATE TABLE log_alumnos_evento_NEW (
	evento VARCHAR(50),
	id_alumno INT,
    id_curso INT,
    id_nota INT,
    Nombre VARCHAR(50),
    Apellido VARCHAR(50),
    DNI VARCHAR(50),
    Telefono VARCHAR(50),
    Email  VARCHAR(130),
    Usuario VARCHAR(50),
    Fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS log_comercio_evento_NEW;
CREATE TABLE log_comercio_evento_NEW (
	evento VARCHAR(50),
    id_comercio INT,
    id_rubro_comercio INT,
    Razon_social VARCHAR(50),
    Direccion VARCHAR(50),
    Expediente_habilitacion VARCHAR(20),
    Numero_cuenta VARCHAR(20),
    Usuario VARCHAR(50),
    Fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- TRIGGERS --

-- Se creo un trigger por cada tabla importante, que se activan cada vez q se inserta, actualiza o elimina datos --

DELIMITER $$

-- Vehiculos trigger --

DROP trigger IF exists tr_vehiculos_update_OLD $$
CREATE TRIGGER tr_vehiculos_update_OLD
	AFTER UPDATE ON vehiculos
    FOR EACH ROW
    BEGIN
		INSERT INTO log_vehiculos_evento_OLD (evento, id_vehiculo, Numero_habilitacion, Patente, Razon_social, Usuario, Fecha_hora)
		VALUES ('UPDATE datos', OLD.id_vehiculo, OLD.Numero_habilitacion, OLD.Patente, OLD.Razon_social, USER(), NOW());
    END $$
    
DROP trigger IF exists tr_vehiculos_delete_OLD $$
CREATE TRIGGER tr_vehiculos_delete_OLD
	AFTER DELETE ON vehiculos
    FOR EACH ROW
    BEGIN
		INSERT INTO log_vehiculos_evento_OLD (evento, id_vehiculo, Numero_habilitacion, Patente, Razon_social, Usuario, Fecha_hora)
		VALUES ('DELETE datos', OLD.id_vehiculo, OLD.Numero_habilitacion, OLD.Patente, OLD.Razon_social, USER(), NOW());
    END $$
   
DROP trigger IF exists tr_vehiculos_update_NEW $$
CREATE TRIGGER tr_vehiculos_update_NEW
	BEFORE UPDATE ON vehiculos
    FOR EACH ROW
    BEGIN
		INSERT INTO log_vehiculos_evento_NEW (evento, id_vehiculo, Numero_habilitacion, Patente, Razon_social, Usuario, Fecha_hora)
		VALUES ('UPDATE datos', NEW.id_vehiculo, NEW.Numero_habilitacion, NEW.Patente, NEW.Razon_social, USER(), NOW());
    END $$

DROP trigger IF exists tr_vehiculos_insert_NEW $$
CREATE TRIGGER tr_vehiculos_insert_NEW
	BEFORE INSERT ON vehiculos
    FOR EACH ROW
    BEGIN
		INSERT INTO log_vehiculos_evento_NEW (evento, id_vehiculo, Numero_habilitacion, Patente, Razon_social, Usuario, Fecha_hora)
		VALUES ('INSERT datos', NEW.id_vehiculo, NEW.Numero_habilitacion, NEW.Patente, NEW.Razon_social, USER(), NOW());
    END $$

-- Comercios trigger --

DROP trigger IF exists tr_comercios_update_OLD $$
CREATE TRIGGER tr_comercios_update_OLD
	AFTER UPDATE ON comercios
    FOR EACH ROW
    BEGIN
		INSERT INTO log_comercio_evento_OLD (evento, id_comercio, id_rubro_comercio, Razon_social, Direccion, Expediente_habilitacion, Numero_cuenta, Usuario, Fecha_hora)
		VALUES ('Update datos', OLD.id_comercio, OLD.id_rubro_comercio, OLD.Razon_social, OLD.Direccion, OLD.Expediente_habilitacion, OLD.Numero_cuenta, USER(), NOW());
    END $$
    
DROP trigger IF exists tr_comercios_dalete_OLD $$
CREATE TRIGGER tr_comercios_dalete_OLD
	AFTER DELETE ON comercios
    FOR EACH ROW
    BEGIN
		INSERT INTO log_comercio_evento_OLD (evento, id_comercio, id_rubro_comercio, Razon_social, Direccion, Expediente_habilitacion, Numero_cuenta, Usuario, Fecha_hora)
		VALUES ('Delete datos', OLD.id_comercio, OLD.id_rubro_comercio, OLD.Razon_social, OLD.Direccion, OLD.Expediente_habilitacion, OLD.Numero_cuenta, USER(), NOW());
    END $$

DROP trigger IF exists tr_comercios_update_NEW $$
CREATE TRIGGER tr_comercios_update_NEW
	BEFORE UPDATE ON comercios
    FOR EACH ROW
    BEGIN
		INSERT INTO log_comercio_evento_NEW (evento, id_comercio, id_rubro_comercio, Razon_social, Direccion, Expediente_habilitacion, Numero_cuenta, Usuario, Fecha_hora)
		VALUES ('Update datos', NEW.id_comercio, NEW.id_rubro_comercio, NEW.Razon_social, NEW.Direccion, NEW.Expediente_habilitacion, NEW.Numero_cuenta, USER(), NOW());
    END $$
    
DROP trigger IF exists tr_comercios_insert_NEW $$
CREATE TRIGGER tr_comercios_insert_NEW
	BEFORE INSERT ON comercios
    FOR EACH ROW
    BEGIN
		INSERT INTO log_comercio_evento_NEW (evento, id_comercio, id_rubro_comercio, Razon_social, Direccion, Expediente_habilitacion, Numero_cuenta, Usuario, Fecha_hora)
		VALUES ('Insert datos', NEW.id_comercio, NEW.id_rubro_comercio, NEW.Razon_social, NEW.Direccion, NEW.Expediente_habilitacion, NEW.Numero_cuenta, USER(), NOW());
    END $$
    
-- Alumnos triggers --

DROP trigger IF exists tr_alumnos_update_OLD $$
CREATE TRIGGER tr_alumnos_update_OLD
	AFTER UPDATE ON alumnos
    FOR EACH ROW
    BEGIN
		INSERT INTO log_alumnos_evento_OLD (evento, id_alumno, id_curso, id_nota, Nombre, Apellido, DNI, Telefono, Email, Usuario, Fecha_hora)
		VALUES ('Update datos', OLD.id_alumno, OLD.id_curso, OLD.id_nota, OLD.Nombre, OLD.Apellido, OLD.DNI, OLD.Telefono, OLD.Email, USER(), NOW());
    END $$

DROP trigger IF exists tr_alumnos_delete_OLD $$
CREATE TRIGGER tr_alumnos_delete_OLD
	AFTER DELETE ON alumnos
    FOR EACH ROW
    BEGIN
		INSERT INTO log_alumnos_evento_OLD (evento, id_alumno, id_curso, id_nota, Nombre, Apellido, DNI, Telefono, Email, Usuario, Fecha_hora)
		VALUES ('Delete datos', OLD.id_alumno, OLD.id_curso, OLD.id_nota, OLD.Nombre, OLD.Apellido, OLD.DNI, OLD.Telefono, OLD.Email, USER(), NOW());
    END $$

DROP trigger IF exists tr_alumnos_update_New $$
CREATE TRIGGER tr_alumnos_update_New
	BEFORE UPDATE ON alumnos
    FOR EACH ROW
    BEGIN
		INSERT INTO log_alumnos_evento_New (evento, id_alumno, id_curso, id_nota, Nombre, Apellido, DNI, Telefono, Email, Usuario, Fecha_hora)
		VALUES ('Update datos', NEW.id_alumno, NEW.id_curso, NEW.id_nota, NEW.Nombre, NEW.Apellido, NEW.DNI, NEW.Telefono, NEW.Email, USER(), NOW());
    END $$

DROP trigger IF exists tr_alumnos_insert_New $$
CREATE TRIGGER tr_alumnos_insert_New
	BEFORE INSERT ON alumnos
    FOR EACH ROW
    BEGIN
		INSERT INTO log_alumnos_evento_New (evento, id_alumno, id_curso, id_nota, Nombre, Apellido, DNI, Telefono, Email, Usuario, Fecha_hora)
		VALUES ('Insert datos', NEW.id_alumno, NEW.id_curso, NEW.id_nota, NEW.Nombre, NEW.Apellido, NEW.DNI, NEW.Telefono, NEW.Email, USER(), NOW());
    END $$
    
-- Denuncias triggers --

DROP trigger IF exists tr_denuncias_update_OLD $$
CREATE TRIGGER tr_denuncias_update_OLD
	AFTER UPDATE ON denuncias
    FOR EACH ROW
    BEGIN
		INSERT INTO log_denuncias_evento_OLD (evento, id_denuncia, id_acta, Direccion, Descripcion, Fecha, Numero_orden, Usuario, Fecha_hora)
		VALUES ('Update datos', OLD.id_denuncia, OLD.id_acta, OLD.Direccion, OLD.Descripcion, OLD.Fecha, OLD.Numero_orden, USER(), NOW());
    END $$

DROP trigger IF exists tr_denuncias_delete_OLD $$
CREATE TRIGGER tr_denuncias_delete_OLD
	AFTER DELETE ON denuncias
    FOR EACH ROW
    BEGIN
		INSERT INTO log_denuncias_evento_OLD (evento, id_denuncia, id_acta, Direccion, Descripcion, Fecha, Numero_orden, Usuario, Fecha_hora)
		VALUES ('Delete datos', OLD.id_denuncia, OLD.id_acta, OLD.Direccion, OLD.Descripcion, OLD.Fecha, OLD.Numero_orden, USER(), NOW());
    END $$

DROP trigger IF exists tr_denuncias_update_New $$
CREATE TRIGGER tr_denuncias_update_New
	BEFORE UPDATE ON denuncias
    FOR EACH ROW
    BEGIN
		INSERT INTO log_denuncias_evento_OLD (evento, id_denuncia, id_acta, Direccion, Descripcion, Fecha, Numero_orden, Usuario, Fecha_hora)
		VALUES ('Update datos', NEW.id_denuncia, NEW.id_acta, NEW.Direccion, NEW.Descripcion, NEW.Fecha, NEW.Numero_orden, USER(), NOW());
    END $$

DROP trigger IF exists tr_denuncias_insert_New $$
CREATE TRIGGER tr_denuncias_insert_New
	BEFORE UPDATE ON denuncias
    FOR EACH ROW
    BEGIN
		INSERT INTO log_denuncias_evento_NEW (evento, id_denuncia, id_acta, Direccion, Descripcion, Fecha, Numero_orden, Usuario, Fecha_hora)
		VALUES ('Insert datos', NEW.id_denuncia, NEW.id_acta, NEW.Direccion, NEW.Descripcion, NEW.Fecha, NEW.Numero_orden, USER(), NOW());
    END $$
    


DELIMITER ;

-- UPDATES --

UPDATE vehiculos SET Numero_habilitacion = 150987 WHERE id_vehiculo = 1;
UPDATE comercios SET Expediente_habilitacion = '55/S/222' WHERE id_comercio = 1;
UPDATE alumnos SET Nombre = 'Juan' WHERE id_alumno = 1;
UPDATE denuncias SET Numero_orden = 58 WHERE id_denuncia = 2;

-- INSERTS --

INSERT INTO vehiculos VALUES (null, 10030, 'VPT100', 'Rabbione');
INSERT INTO denuncias VALUES  (null, null, 'Brown 1895', 'Presencia de cucarachas', current_date, 4323);
INSERT INTO comercios VALUES (null, 3, 'Los Reseros S.R.L.', 'Colon 3344', '1222/B/99', '12004');
INSERT INTO alumnos VALUES (null, null, null, 'Javier', 'Perez', '34500090', '2235678909', 'perez@gmail.com');

-- No puedo hacer un DELETE porque esta como RESTRICT --


-- Creacion de transacciones --

-- Primera consigna de eliminacion de datos --
 START TRANSACTION;

DELETE FROM habilitacion_comercios WHERE id_habilitacion = 1;
DELETE FROM habilitacion_comercios WHERE id_habilitacion = 2;
DELETE FROM habilitacion_comercios WHERE id_habilitacion = 3;

 ROLLBACK;

-- COMMIT;
 START TRANSACTION;
 
-- Segunda consigna de SAVEPONIT --

INSERT INTO vehiculos VALUES (null, 15990, 'VPT100', 'Rabbione');
INSERT INTO vehiculos VALUES (null, 12, 'VPT100', 'Rabbione');
INSERT INTO vehiculos VALUES (null, 16000, 'VPT100', 'Rabbione');
INSERT INTO vehiculos VALUES (null, 17000, 'VPT101', 'Rabbione');
INSERT INTO vehiculos VALUES (null, 18000, 'VPT102', 'Rabbione');
INSERT INTO vehiculos VALUES (null, 17899, 'VPT103', 'Rabbione');
INSERT INTO vehiculos VALUES (null, 15997, 'VPT104', 'Rabbione');
INSERT INTO vehiculos VALUES (null, 1980, 'VPT105', 'Rabbione');

savepoint primeros_ocho;

INSERT INTO vehiculos VALUES (null, 12312, 'VPT106', 'Rabbione');
INSERT INTO vehiculos VALUES (null, 2020, 'VPT107', 'Rabbione');
INSERT INTO vehiculos VALUES (null, 2023, 'VPT108', 'Rabbione');

savepoint ultimos_datos;

ROLLBACK TO primeros_ocho;
-- release savepoint primeros_ocho;