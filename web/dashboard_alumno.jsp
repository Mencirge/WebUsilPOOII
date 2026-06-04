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
            max-width: 1000px;
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
        }

        /* Cursos y Notas */
        .curso-box {
            border: 1px solid #cccccc;
            border-radius: 6px;
            margin-bottom: 20px;
            background-color: #ffffff;
        }

        .curso-header {
            background-color: #eef2f7;
            padding: 10px 15px;
            font-weight: bold;
            font-size: 16px;
            border-bottom: 1px solid #cccccc;
            display: flex;
            justify-content: space-between;
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
            flex: 2;
        }

        .materiales-section {
            flex: 1;
            background-color: #fafafa;
            border: 1px solid #eeeeee;
            padding: 10px;
            border-radius: 4px;
        }

        /* Tabla de Notas Básica */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 5px;
            font-size: 14px;
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
        .materiales-list {
            margin: 0;
            padding-left: 20px;
            font-size: 13px;
        }

        .materiales-list li {
            margin-bottom: 6px;
        }

        .materiales-list a {
            color: #0056b3;
            text-decoration: none;
        }

        .materiales-list a:hover {
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
                <strong>Sofía Rossel Mendoza Q.</strong><br>
                <span>Código: U20221045 | Rol: Alumno</span>
            </div>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn-salir">Cerrar Sesión</a>
        </div>
    </div>

    <!-- Contenido Principal -->
    <div class="container">
        
        <h2>Ficha de Matrícula y Calificaciones</h2>
        
        <div class="profile-summary">
            <strong>Carrera:</strong> Ingeniería de Sistemas de Información | 
            <strong>Ciclo Académico:</strong> IV Ciclo | 
            <strong>Semestre:</strong> 2026-1
        </div>

        <h3>Mis Cursos Matriculados</h3>

        <!-- Curso 1 -->
        <div class="curso-box">
            <div class="curso-header">
                <span>Programación Orientada a Objetos II (POO2)</span>
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
                    <strong>Materiales:</strong>
                    <ul class="materiales-list">
                        <li><a href="#">Silabo_POO2.pdf</a></li>
                        <li><a href="#">Semana1_Servlets.ppt</a></li>
                        <li><a href="#">Proyecto_Lineamientos.pdf</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Curso 2 -->
        <div class="curso-box">
            <div class="curso-header">
                <span>Diseño de Base de Datos (BD1)</span>
                <span class="aprobado">Promedio: 12.90</span>
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
                                <td>12.0</td>
                                <td>14.0</td>
                                <td>15.0</td>
                                <td>11.0</td>
                                <td>13.0</td>
                                <td class="aprobado">12.90</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="materiales-section">
                    <strong>Materiales:</strong>
                    <ul class="materiales-list">
                        <li><a href="#">Silabo_BD1.pdf</a></li>
                        <li><a href="#">Manual_SQL_Consultas.pdf</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Curso 3 -->
        <div class="curso-box">
            <div class="curso-header">
                <span>Cálculo Multivariable (CAL2)</span>
                <span class="desaprobado">Promedio: 10.40</span>
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
                                <td>10.0</td>
                                <td>11.0</td>
                                <td>12.0</td>
                                <td>09.0</td>
                                <td>11.0</td>
                                <td class="desaprobado">10.40</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="materiales-section">
                    <strong>Materiales:</strong>
                    <ul class="materiales-list">
                        <li><a href="#">Guia_Derivadas_Parciales.pdf</a></li>
                        <li><a href="#">Guia_Integrales_Dobles.pdf</a></li>
                    </ul>
                </div>
            </div>
        </div>

    </div>

</body>
</html>
