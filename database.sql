-- 1. Eliminar tablas si existen para permitir recreación limpia
DROP TABLE IF EXISTS notas CASCADE;
DROP TABLE IF EXISTS matriculas CASCADE;
DROP TABLE IF EXISTS cursos CASCADE;
DROP TABLE IF EXISTS alumnos CASCADE;
DROP TABLE IF EXISTS docentes CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;
DROP TABLE IF EXISTS roles CASCADE;

-- 2. Tabla de Roles (ALUMNO, DOCENTE, ADMIN)
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(150)
);

-- 3. Tabla de Usuarios (Credenciales y Seguridad)
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    codigo_o_correo VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rol_id INT NOT NULL,
    estado VARCHAR(20) DEFAULT 'ACTIVO', -- ACTIVO, BLOQUEADO
    intentos_fallidos INT DEFAULT 0,
    bloqueado_hasta TIMESTAMP NULL,
    correo_personal VARCHAR(150) DEFAULT NULL,
    telefono VARCHAR(20) DEFAULT NULL,
    FOREIGN KEY (rol_id) REFERENCES roles(id) ON DELETE RESTRICT
);

-- 4. Tabla de Alumnos
CREATE TABLE alumnos (
    id SERIAL PRIMARY KEY,
    usuario_id INT NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    codigo_alumno VARCHAR(10) NOT NULL UNIQUE,
    carrera VARCHAR(100),
    ciclo INT DEFAULT 1,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- 5. Tabla de Docentes
CREATE TABLE docentes (
    id SERIAL PRIMARY KEY,
    usuario_id INT NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    codigo_docente VARCHAR(10) NOT NULL UNIQUE,
    especialidad VARCHAR(100),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- 6. Tabla de Cursos
CREATE TABLE cursos (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    creditos INT NOT NULL
);

-- 7. Tabla de Matrículas (Relación N a N entre Alumnos y Cursos)
CREATE TABLE matriculas (
    id SERIAL PRIMARY KEY,
    alumno_id INT NOT NULL,
    curso_id INT NOT NULL,
    semestre VARCHAR(10) NOT NULL, -- Ej: '2026-1'
    FOREIGN KEY (alumno_id) REFERENCES alumnos(id) ON DELETE CASCADE,
    FOREIGN KEY (curso_id) REFERENCES cursos(id) ON DELETE CASCADE,
    UNIQUE(alumno_id, curso_id, semestre)
);

-- 8. Tabla de Notas
CREATE TABLE notas (
    id SERIAL PRIMARY KEY,
    matricula_id INT NOT NULL UNIQUE, -- Una nota por matrícula
    pc1 NUMERIC(4,2) DEFAULT 0.00,
    pc2 NUMERIC(4,2) DEFAULT 0.00,
    pc3 NUMERIC(4,2) DEFAULT 0.00,
    examen_parcial NUMERIC(4,2) DEFAULT 0.00,
    examen_final NUMERIC(4,2) DEFAULT 0.00,
    promedio_final NUMERIC(4,2) DEFAULT 0.00,
    FOREIGN KEY (matricula_id) REFERENCES matriculas(id) ON DELETE CASCADE
);

-- =========================================================================
-- DATOS SEMILLA (INSERT DATA)
-- =========================================================================

-- Roles
INSERT INTO roles (nombre, descripcion) VALUES
('ADMIN', 'Administrador del sistema con acceso total'),
('DOCENTE', 'Docente que registra notas y visualiza alumnos'),
('ALUMNO', 'Alumno que visualiza sus cursos, notas y material');

-- Usuarios (contraseña por defecto para todos: '2345678')
INSERT INTO usuarios (id, codigo_o_correo, password, rol_id, estado, intentos_fallidos, bloqueado_hasta) VALUES
(1, 'admin@usil.edu.pe', '2345678', 1, 'ACTIVO', 0, NULL),
(2, 'docente@usil.edu.pe', '2345678', 2, 'ACTIVO', 0, NULL),
(3, 'alumno@usil.edu.pe', '2345678', 3, 'ACTIVO', 0, NULL),
(4, 'bloqueado_test@usil.edu.pe', '2345678', 3, 'BLOQUEADO', 3, NULL),
(5, 'carlos.bravo@usil.pe', '2345678', 2, 'ACTIVO', 0, NULL),
(6, 'tania.torresa@usil.pe', '2345678', 2, 'ACTIVO', 0, NULL),
(7, 'luis.salazarma@epg.usil.pe', '2345678', 2, 'ACTIVO', 0, NULL),
(8, 'marisel.beteta@epg.usil.pe', '2345678', 2, 'ACTIVO', 0, NULL),
(9, 'hector.delgadoe@usil.pe', '2345678', 2, 'ACTIVO', 0, NULL),
(10, 'guillermo.hoyos@usil.pe', '2345678', 3, 'ACTIVO', 0, NULL),
(11, 'javier.costa@usil.pe', '2345678', 3, 'ACTIVO', 0, NULL),
(12, 'victor.ariasr@usil.pe', '2345678', 3, 'ACTIVO', 0, NULL),
(13, 'alexandra.anazco@usil.pe', '2345678', 3, 'ACTIVO', 0, NULL),
(14, 'piero.bernardo@usil.pe', '2345678', 3, 'ACTIVO', 0, NULL),
(15, 'nayely.castillo@usil.pe', '2345678', 3, 'ACTIVO', 0, NULL),
(16, 'yarel.chanca@usil.pe', '2345678', 3, 'ACTIVO', 0, NULL),
(17, 'fabian.chavezv@usil.pe', '2345678', 3, 'ACTIVO', 0, NULL),
(18, 'rodrigo.correa@usil.pe', '2345678', 3, 'ACTIVO', 0, NULL),
(19, 'marco.garciar@usil.pe', '2345678', 3, 'ACTIVO', 0, NULL),
(20, 'jahlove.guerrero@usil.pe', '2345678', 3, 'ACTIVO', 0, NULL),
(21, 'thiago.ibarra@usil.pe', '2345678', 3, 'ACTIVO', 0, NULL),
(22, 'marco.nakashima@usil.pe', '2345678', 3, 'ACTIVO', 0, NULL),
(23, 'renato.patino@usil.pe', '2345678', 3, 'ACTIVO', 0, NULL),
(24, 'juan.perezco@usil.pe', '2345678', 3, 'ACTIVO', 0, NULL),
(25, 'solange.rivero@usil.pe', '2345678', 3, 'ACTIVO', 0, NULL),
(26, 'paola.romero@usil.pe', '2345678', 3, 'ACTIVO', 0, NULL),
(27, 'kevin.ruizb@usil.pe', '2345678', 3, 'ACTIVO', 0, NULL),
(28, 'rodrigo.salcedom@usil.pe', '2345678', 3, 'ACTIVO', 0, NULL),
(29, 'yosselin.serpa@usil.pe', '2345678', 3, 'ACTIVO', 0, NULL),
(30, 'daira.solis@usil.pe', '2345678', 3, 'ACTIVO', 0, NULL),
(31, 'gianella.valenzuela@usil.pe', '2345678', 3, 'ACTIVO', 0, NULL),
(32, 'gianpierre.walde@usil.pe', '2345678', 3, 'ACTIVO', 0, NULL),
(33, 'henry.yeren@usil.pe', '2345678', 3, 'ACTIVO', 0, NULL);

-- Perfiles de Docentes
INSERT INTO docentes (usuario_id, nombre, apellido, codigo_docente, especialidad) VALUES
(2, 'Juan Carlos', 'Pérez Silva', 'D20210001', 'Ingeniería de Software'),
(5, 'Carlos Juan', 'Bravo Quispe', 'D20220101', 'Cálculo de una Variable'),
(6, 'Tania', 'Torres Aponte', 'D20230202', 'Estadística'),
(7, 'Luis Alberto', 'Salazar Mariños', 'D20210303', 'Interacción Humano Computador'),
(8, 'Marisel Rocio', 'Beteta Salas', 'D20240404', 'Matemática Discreta'),
(9, 'Hector Odin', 'Delgado Enriquez', 'D20200505', 'Programación Orientada a Objetos II');

-- Perfiles de Alumnos (incluye a tus 24 compañeros de clase)
INSERT INTO alumnos (usuario_id, nombre, apellido, codigo_alumno, carrera, ciclo) VALUES
(3, 'Sofía Rossel', 'Mendoza Quispe', 'U20221045', 'Ingeniería de Sistemas de Información', 4),
(4, 'Usuario de Prueba', 'Bloqueado', 'U20249999', 'Ingeniería de Sistemas de Información', 1),
(10, 'GUILLERMO ENRIQUE', 'HOYOS PALOMARES', '2510682', 'ING SIST. INFORMACION', 1),
(11, 'JAVIER ENRIQUE', 'COSTA SARAVIA', '2510668', 'ING SIST. INFORMACION', 1),
(12, 'VICTOR JOAQUIN', 'ARIAS RODRIGUEZ', '2512854', 'ING SIST. INFORMACION', 1),
(13, 'ALEXANDRA XIOMARA', 'AÑAZCO VALVERDE', '2410212', 'ING SIST. INFORMACION', 1),
(14, 'PIERO SAMUEL', 'BERNARDO RUIZ', '2320477', 'ING SIST. INFORMACION', 1),
(15, 'NAYELY MISHELL', 'CASTILLO GARAY', '2512810', 'ING. EMPRESARIA', 1),
(16, 'YAREL JOSHUA', 'CHANCA MELGAR', '2411997', 'ING. SOFTWARE', 1),
(17, 'FABIAN AUGUSTO', 'CHAVEZ VILLAVICENCIO', '2510158', 'ING SIST. INFORMACION', 1),
(18, 'RODRIGO ANDRE', 'CORREA YACILA', '2410590', 'ING. SOFTWARE', 1),
(19, 'MARCO ANTONIO', 'GARCIA RAYME', '2412712', 'ING SIST. INFORMACION', 1),
(20, 'JAHLOVE SABAH', 'GUERRERO VALENCIA', '2310819', 'ING. EMPRESARIA', 1),
(21, 'THIAGO ANDRE', 'IBARRA DEL CASTILLO', '2410309', 'ING SIST. INFORMACION', 1),
(22, 'MARCO ANTONIO', 'NAKASHIMA ESPINOZA', '2411946', 'ING. SOFTWARE', 1),
(23, 'RENATO ENRIQUE', 'PATIÑO QUISPE', '2410049', 'ING. SOFTWARE', 1),
(24, 'JUAN ANTONIO', 'PEREZ CONCHA', '2320386', 'ING. SOFTWARE', 1),
(25, 'SOLANGE DAFNE', 'RIVERO CAILLAUX', '2312167', 'ING. IND ALIMEN', 1),
(26, 'PAOLA ROSMERY', 'ROMERO RAMIREZ', '2221241', 'ING SIST. INFORMACION', 1),
(27, 'KEVIN JESUS', 'RUIZ BALDOCEDA', '2411109', 'ING SIST. INFORMACION', 1),
(28, 'RODRIGO STEPHANO', 'SALCEDO MENDIVIL', '2410409', 'ING SIST. INFORMACION', 1),
(29, 'YOSSELIN NICOLE', 'SERPA QUIÑONES', '2411272', 'ING. EMPRESARIA', 1),
(30, 'DAIRA BERENICE', 'SOLIS LARRAURI', '2410167', 'ING. SOFTWARE', 1),
(31, 'GIANELLA MAGALY', 'VALENZUELA MIGUEL', '2422005', 'ING. SOFTWARE', 1),
(32, 'GIANPIERRE JHON', 'WALDE CHAUCA', '2410764', 'ING. SOFTWARE', 1),
(33, 'HENRY EDUARDO', 'YEREN ALMEYDA', '2411036', 'ING SIST. INFORMACION', 1);

-- Cursos de Prueba
INSERT INTO cursos (codigo, nombre, creditos) VALUES
('POO2', 'Programación Orientada a Objetos II', 5),
('BD1', 'Diseño de Base de Datos', 4),
('CAL2', 'Cálculo Multivariable', 4);

-- Matrícula del Alumno en Cursos
INSERT INTO matriculas (alumno_id, curso_id, semestre) VALUES
(1, 1, '2026-1'), 
(1, 2, '2026-1'), 
(1, 3, '2026-1'); 

-- Notas Iniciales
INSERT INTO notas (matricula_id, pc1, pc2, pc3, examen_parcial, examen_final, promedio_final) VALUES
(1, 15.00, 16.00, 14.00, 15.00, 17.00, 15.60);

-- Sincronizar secuencias
SELECT setval(pg_get_serial_sequence('usuarios', 'id'), coalesce(max(id), 1)) FROM usuarios;
SELECT setval(pg_get_serial_sequence('docentes', 'id'), coalesce(max(id), 1)) FROM docentes;
SELECT setval(pg_get_serial_sequence('alumnos', 'id'), coalesce(max(id), 1)) FROM alumnos;
