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
    password VARCHAR(255) NOT NULL, -- Se recomienda espacio para contraseñas cifradas
    rol_id INT NOT NULL,
    estado VARCHAR(20) DEFAULT 'ACTIVO', -- ACTIVO, BLOQUEADO
    intentos_fallidos INT DEFAULT 0,
    bloqueado_hasta TIMESTAMP NULL,
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

-- Usuarios (contraseña inicial en texto plano para el ejemplo de login: '123456')
-- En producción/despliegue final se debe usar un hash (SHA-256 o BCrypt).
INSERT INTO usuarios (codigo_o_correo, password, rol_id) VALUES
('admin@usil.edu.pe', '123456', 1),
('docente@usil.edu.pe', '123456', 2),
('alumno@usil.edu.pe', '123456', 3);

-- Perfil de Docente
INSERT INTO docentes (usuario_id, nombre, apellido, codigo_docente, especialidad) VALUES
(2, 'Juan Carlos', 'Pérez Silva', 'D20210001', 'Ingeniería de Software');

-- Perfil de Alumno (asociado al usuario alumno)
INSERT INTO alumnos (usuario_id, nombre, apellido, codigo_alumno, carrera, ciclo) VALUES
(3, 'Sofía Rossel', 'Mendoza Quispe', 'U20221045', 'Ingeniería de Sistemas de Información', 4);

-- Cursos de Prueba
INSERT INTO cursos (codigo, nombre, creditos) VALUES
('POO2', 'Programación Orientada a Objetos II', 5),
('BD1', 'Diseño de Base de Datos', 4),
('CAL2', 'Cálculo Multivariable', 4);

-- Matrícula del Alumno en Cursos
-- Aquí el alumno_id es 1 porque es el primer registro de la tabla alumnos
INSERT INTO matriculas (alumno_id, curso_id, semestre) VALUES
(1, 1, '2026-1'), -- Alumno 1 matriculado en POO2
(1, 2, '2026-1'), -- Alumno 1 matriculado en BD1
(1, 3, '2026-1'); -- Alumno 1 matriculado en CAL2

-- Notas Iniciales
INSERT INTO notas (matricula_id, pc1, pc2, pc3, examen_parcial, examen_final, promedio_final) VALUES
(1, 15.00, 16.00, 14.00, 15.00, 17.00, 15.60), -- Notas para POO2
(2, 12.00, 14.00, 15.00, 11.00, 13.00, 12.90), -- Notas para BD1
(3, 10.00, 11.00, 12.00, 09.00, 11.00, 10.40); -- Notas para CAL2
