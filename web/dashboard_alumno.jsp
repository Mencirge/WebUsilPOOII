<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="pe.edu.usil.poo2.model.entity.Usuario" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Sesion+no+iniciada");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Alumno - USIL</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            color: #333333;
        }

        /* Cabecera Simple */
        .header {
            background-color: #0c2340;
            color: #ffffff;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            margin: 0;
            font-size: 20px;
        }

        .user-menu {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .user-details {
            font-size: 14px;
            text-align: right;
        }

        .btn-salir {
            background-color: #cc0000;
            color: #ffffff;
            border: none;
            padding: 8px 12px;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 13px;
            font-weight: bold;
        }

        .btn-salir:hover {
            background-color: #aa0000;
        }

        /* Contenedor */
        .container {
            max-width: 1050px;
            margin: 20px auto;
            background-color: #ffffff;
            padding: 20px;
            border: 1px solid #dddddd;
            border-radius: 6px;
        }

        h2 {
            color: #0c2340;
            border-bottom: 2px solid #0c2340;
            padding-bottom: 5px;
            margin-top: 0;
        }

        .profile-summary {
            background-color: #eef2f7;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 25px;
            font-size: 15px;
            line-height: 1.5;
        }

        /* Cursos y Notas */
        .curso-box {
            border: 1px solid #cccccc;
            border-radius: 6px;
            margin-bottom: 20px;
            background-color: #ffffff;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .curso-header {
            background-color: #eef2f7;
            padding: 10px 15px;
            font-weight: bold;
            font-size: 15px;
            border-bottom: 1px solid #cccccc;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .curso-info-header {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }

        .bloque-tag {
            font-size: 11px;
            color: #666666;
            font-weight: normal;
        }

        .curso-body {
            padding: 15px;
            display: flex;
            gap: 20px;
        }

        @media (max-width: 768px) {
            .curso-body {
                flex-direction: column;
            }
        }

        .notas-section {
            flex: 2.2;
        }

        .materiales-section {
            flex: 1.2;
            background-color: #fafafa;
            border: 1px solid #eeeeee;
            padding: 12px;
            border-radius: 4px;
            font-size: 13px;
        }

        /* Tabla de Notas Básica */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 5px;
            font-size: 13px;
        }

        table, th, td {
            border: 1px solid #dddddd;
        }

        th {
            background-color: #f2f2f2;
            padding: 8px;
            text-align: center;
            font-weight: bold;
        }

        td {
            padding: 8px;
            text-align: center;
        }

        .aprobado {
            color: green;
            font-weight: bold;
        }

        .desaprobado {
            color: red;
            font-weight: bold;
        }

        /* Materiales */
        .info-list {
            margin: 5px 0 0 0;
            padding-left: 18px;
        }

        .info-list li {
            margin-bottom: 6px;
        }

        .info-list a {
            color: #0056b3;
            text-decoration: none;
        }

        .info-list a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <!-- Cabecera -->
    <div class="header">
        <h1>USIL - Portal Académico</h1>
        <div class="user-menu">
            <div class="user-details">
                <strong><%= usuario.getNombreCompleto() %></strong><br>
                <span>Código: <%= usuario.getCodigoAlumnoODocente() %> | Correo: <%= usuario.getCodigoOCorreo() %></span>
            </div>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn-salir">Cerrar Sesión</a>
        </div>
    </div>

    <!-- Contenido Principal -->
    <div class="container">
        
        <h2>Ficha Académica de Calificaciones</h2>
        
        <div class="profile-summary">
            <strong>Alumno:</strong> <%= usuario.getNombreCompleto() %> (<%= usuario.getCodigoAlumnoODocente() %>)<br>
            <strong>Carrera:</strong> Ingeniería de Sistemas de Información | <strong>Semestre:</strong> (PRE-GRADO) 2026-01
        </div>

        <h3>Mis Cursos Matriculados</h3>

        <!-- Curso 1 -->
        <div class="curso-box">
            <div class="curso-header">
                <div class="curso-info-header">
                    <strong>CÁLCULO DE UNA VARIABLE</strong>
                    <span class="bloque-tag">Bloque: FC-PREIEM02C01 | Docente: BRAVO QUISPE, CARLOS JUAN</span>
                </div>
                <span class="aprobado">Promedio: 15.20</span>
            </div>
            <div class="curso-body">
                <div class="notas-section">
                    <table>
                        <thead>
                            <tr>
                                <th>PC1</th>
                                <th>PC2</th>
                                <th>PC3</th>
                                <th>Ex. Parcial</th>
                                <th>Ex. Final</th>
                                <th>Prom. Final</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>14.0</td>
                                <td>16.0</td>
                                <td>15.0</td>
                                <td>15.0</td>
                                <td>16.0</td>
                                <td class="aprobado">15.20</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="materiales-section">
                    <strong>Detalles del Curso:</strong>
                    <ul class="info-list">
                        <li><strong>Inasistencia:</strong> 11.25%</li>
                        <li><strong>Asistencia Zoom:</strong> 27%</li>
                        <li><strong>Horario:</strong> Martes 13:00 - 14:40 | Viernes 13:00 - 15:50</li>
                        <li><a href="#">Descargar Sílabo del Curso</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Curso 2 -->
        <div class="curso-box">
            <div class="curso-header">
                <div class="curso-info-header">
                    <strong>ESTADÍSTICA DESCRIPTIVA E INFERENCIA ESTADÍSTICA</strong>
                    <span class="bloque-tag">Bloque: FC-VIREMP03E01 | Docente: TORRES APONTE, TANIA</span>
                </div>
                <span class="aprobado">Promedio: 14.10</span>
            </div>
            <div class="curso-body">
                <div class="notas-section">
                    <table>
                        <thead>
                            <tr>
                                <th>PC1</th>
                                <th>PC2</th>
                                <th>PC3</th>
                                <th>Ex. Parcial</th>
                                <th>Ex. Final</th>
                                <th>Prom. Final</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>13.0</td>
                                <td>15.0</td>
                                <td>14.0</td>
                                <td>13.0</td>
                                <td>15.0</td>
                                <td class="aprobado">14.10</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="materiales-section">
                    <strong>Detalles del Curso:</strong>
                    <ul class="info-list">
                        <li><strong>Inasistencia:</strong> 8.75%</li>
                        <li><strong>Horario:</strong> Miércoles 17:00 - 18:40 | Viernes 15:50 - 18:40</li>
                        <li><a href="#">Descargar Sílabo del Curso</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Curso 3 -->
        <div class="curso-box">
            <div class="curso-header">
                <div class="curso-info-header">
                    <strong>INTERACCIÓN HUMANO COMPUTADOR</strong>
                    <span class="bloque-tag">Bloque: FC-PREISF05B01M | Docente: SALAZAR MARIÑOS, LUIS ALBERTO</span>
                </div>
                <span class="aprobado">Promedio: 16.70</span>
            </div>
            <div class="curso-body">
                <div class="notas-section">
                    <table>
                        <thead>
                            <tr>
                                <th>PC1</th>
                                <th>PC2</th>
                                <th>PC3</th>
                                <th>Ex. Parcial</th>
                                <th>Ex. Final</th>
                                <th>Prom. Final</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>17.0</td>
                                <td>16.0</td>
                                <td>17.0</td>
                                <td>16.0</td>
                                <td>17.0</td>
                                <td class="aprobado">16.70</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="materiales-section">
                    <strong>Detalles del Curso:</strong>
                    <ul class="info-list">
                        <li><strong>Inasistencia:</strong> 2.08%</li>
                        <li><strong>Horario:</strong> Lunes 13:00 - 14:40 | Jueves 13:00 - 16:40</li>
                        <li><a href="#">Descargar Sílabo del Curso</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Curso 4 -->
        <div class="curso-box">
            <div class="curso-header">
                <div class="curso-info-header">
                    <strong>MATEMÁTICA DISCRETA</strong>
                    <span class="bloque-tag">Bloque: FC-PREISF02A01M | Docente: BETETA SALAS, MARISEL ROCIO</span>
                </div>
                <span class="desaprobado">Promedio: 10.90</span>
            </div>
            <div class="curso-body">
                <div class="notas-section">
                    <table>
                        <thead>
                            <tr>
                                <th>PC1</th>
                                <th>PC2</th>
                                <th>PC3</th>
                                <th>Ex. Parcial</th>
                                <th>Ex. Final</th>
                                <th>Prom. Final</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>11.0</td>
                                <td>10.0</td>
                                <td>12.0</td>
                                <td>09.0</td>
                                <td>12.0</td>
                                <td class="desaprobado">10.90</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="materiales-section">
                    <strong>Detalles del Curso:</strong>
                    <ul class="info-list">
                        <li><strong>Inasistencia:</strong> 3.13%</li>
                        <li><strong>Asistencia Zoom:</strong> 0%</li>
                        <li><strong>Horario:</strong> Miércoles 07:00 - 10:40</li>
                        <li><a href="#">Descargar Sílabo del Curso</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Curso 5 -->
        <div class="curso-box">
            <div class="curso-header">
                <div class="curso-info-header">
                    <strong>PROGRAMACIÓN ORIENTADA A OBJETOS II</strong>
                    <span class="bloque-tag">Bloque: FC-PREIEM04B01T | Docente: DELGADO ENRIQUEZ, HECTOR ODIN</span>
                </div>
                <span class="aprobado">Promedio: 15.60</span>
            </div>
            <div class="curso-body">
                <div class="notas-section">
                    <table>
                        <thead>
                            <tr>
                                <th>PC1</th>
                                <th>PC2</th>
                                <th>PC3</th>
                                <th>Ex. Parcial</th>
                                <th>Ex. Final</th>
                                <th>Prom. Final</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>15.0</td>
                                <td>16.0</td>
                                <td>14.0</td>
                                <td>15.0</td>
                                <td>17.0</td>
                                <td class="aprobado">15.60</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="materiales-section">
                    <strong>Detalles del Curso:</strong>
                    <ul class="info-list">
                        <li><strong>Inasistencia:</strong> 0.00%</li>
                        <li><strong>Horario:</strong> Lunes y Jueves 18:00 - 20:40</li>
                        <li><a href="#">Descargar Sílabo del Curso</a></li>
                    </ul>
                </div>
            </div>
        </div>

    </div>

</body>
</html>
