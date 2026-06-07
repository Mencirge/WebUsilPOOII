<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="pe.edu.usil.poo2.model.entity.Usuario" %>
<%@ page import="java.sql.*" %>
<%@ page import="pe.edu.usil.poo2.util.ConexionBD" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Sesion+no+iniciada");
        return;
    }

    int cursoId = 0;
    String cursoCodigo = "";
    String cursoAsignado = "Ninguno";
    String bloqueAsignado = "FC-PRE";
    String cicloAsignado = "(PRE-GRADO) 2026-01";

    try (Connection conn = ConexionBD.getConexion();
         PreparedStatement ps = conn.prepareStatement(
             "SELECT id, codigo, nombre FROM cursos WHERE nombre = (SELECT especialidad FROM docentes WHERE usuario_id = ?)")) {
        ps.setInt(1, usuario.getId());
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                cursoId = rs.getInt("id");
                cursoCodigo = rs.getString("codigo");
                cursoAsignado = rs.getString("nombre");
            }
        }
    } catch (Exception e) {
        System.err.println("Error al obtener curso asignado al docente: " + e.getMessage());
    }

    // Fallback por defecto si no coincide especialidad
    if (cursoId == 0) {
        cursoId = 5;
        cursoCodigo = "POO2";
        cursoAsignado = "Programación Orientada a Objetos II";
    }

    // Bloque correspondiente para mantener estética
    if (cursoCodigo.equals("CAL1")) {
        bloqueAsignado = "FC-PREIEM02C01";
    } else if (cursoCodigo.equals("EST1")) {
        bloqueAsignado = "FC-VIREMP03E01";
    } else if (cursoCodigo.equals("IHC")) {
        bloqueAsignado = "FC-PREISF05B01M";
    } else if (cursoCodigo.equals("MD")) {
        bloqueAsignado = "FC-PREISF02A01M";
    } else if (cursoCodigo.equals("POO2")) {
        bloqueAsignado = "FC-PREIEM04B01T";
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Docente - USIL</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            color: #333333;
        }

        /* Cabecera */
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

        .instructor-info {
            background-color: #eef2f7;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 25px;
            font-size: 15px;
        }

        .panel-busqueda {
            margin-bottom: 20px;
            padding: 12px;
            background-color: #fcfcfc;
            border: 1px solid #e0e0e0;
            border-radius: 4px;
            font-size: 14px;
        }

        /* Tabla de Calificaciones */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        table, th, td {
            border: 1px solid #cccccc;
        }

        th {
            background-color: #f2f2f2;
            color: #333333;
            font-size: 13px;
            font-weight: bold;
            padding: 10px;
            text-align: center;
        }

        td {
            padding: 10px;
            vertical-align: middle;
        }

        .txt-alumno {
            font-weight: bold;
            color: #0c2340;
        }

        .txt-codigo {
            font-size: 12px;
            color: #666666;
        }

        /* Inputs de Notas */
        .grade-input {
            width: 50px;
            padding: 5px;
            border: 1px solid #cccccc;
            border-radius: 4px;
            text-align: center;
            font-weight: bold;
        }

        .grade-input:focus {
            border-color: #0056b3;
            outline: none;
        }

        .promedio-celda {
            font-weight: bold;
            text-align: center;
            font-size: 14px;
        }

        .aprobado {
            color: green;
        }

        .desaprobado {
            color: red;
        }

        /* Botones de acción */
        .btn-group {
            text-align: right;
            margin-top: 20px;
        }

        .btn {
            padding: 10px 20px;
            font-size: 14px;
            font-weight: bold;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-left: 10px;
        }

        .btn-cancelar {
            background-color: #e0e0e0;
            color: #333333;
        }

        .btn-cancelar:hover {
            background-color: #cccccc;
        }

        .btn-guardar {
            background-color: #0c2340;
            color: #ffffff;
        }

        .btn-guardar:hover {
            background-color: #16365c;
        }

        /* Alerta de guardado */
        .alerta-exito {
            display: none;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            padding: 12px;
            border-radius: 4px;
            margin-bottom: 20px;
            font-size: 14px;
        }
    </style>
</head>
<body>

    <!-- Cabecera -->
    <div class="header">
        <h1>USIL - Portal Docente</h1>
        <div class="user-menu">
            <div class="user-details">
                <strong><%= usuario.getNombreCompleto() %></strong><br>
                <span>Código: <%= usuario.getCodigoAlumnoODocente() %> | Rol: Docente</span>
            </div>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn-salir">Cerrar Sesión</a>
        </div>
    </div>

    <!-- Contenido Principal -->
    <div class="container">
        
        <%
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            if (success != null) {
        %>
            <div style="background-color: #d4edda; border: 1px solid #c3e6cb; color: #155724; padding: 12px; border-radius: 4px; margin-bottom: 20px;">
                <strong>Éxito:</strong> <%= success %>
            </div>
        <%
            }
            if (error != null) {
        %>
            <div style="background-color: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; padding: 12px; border-radius: 4px; margin-bottom: 20px;">
                <strong>Error:</strong> <%= error %>
            </div>
        <%
            }
        %>

        <h2>Calificaciones y Actas - Período <%= cicloAsignado %></h2>
        
        <div class="instructor-info" style="position: relative; line-height: 1.6;">
            <strong>Docente:</strong> <%= usuario.getNombreCompleto() %> | 
            <strong>Facultad:</strong> Ingeniería |
            <strong>Correo:</strong> <%= usuario.getCodigoOCorreo() %><br>
            <strong>Correo Personal:</strong> <%= (usuario.getCorreoPersonal() != null && !usuario.getCorreoPersonal().isEmpty()) ? usuario.getCorreoPersonal() : "<i>No registrado</i>" %> | 
            <strong>Teléfono:</strong> <%= (usuario.getTelefono() != null && !usuario.getTelefono().isEmpty()) ? usuario.getTelefono() : "<i>No registrado</i>" %>
            <div style="margin-top: 10px;">
                <button type="button" onclick="document.getElementById('editProfileForm').style.display='block'; document.getElementById('changePasswordForm').style.display='none';" style="background-color: #0c2340; color: white; border: none; padding: 6px 10px; border-radius: 4px; cursor: pointer; font-size: 12px; font-weight: bold; margin-right: 10px;">Editar Contacto</button>
                <button type="button" onclick="document.getElementById('changePasswordForm').style.display='block'; document.getElementById('editProfileForm').style.display='none';" style="background-color: #555555; color: white; border: none; padding: 6px 10px; border-radius: 4px; cursor: pointer; font-size: 12px; font-weight: bold;">Cambiar Contraseña</button>
            </div>
        </div>

        <!-- Formulario Editar Contacto -->
        <div id="editProfileForm" style="display:none; background-color: #f9f9f9; border: 1px solid #cccccc; padding: 15px; margin-bottom: 20px; border-radius: 4px;">
            <h4 style="margin-top: 0; color: #0c2340; margin-bottom: 10px;">Editar Datos de Contacto</h4>
            <form action="${pageContext.request.contextPath}/controller/ActualizarContactoServlet" method="POST">
                <div style="margin-bottom: 10px;">
                    <label style="display: block; font-weight: bold; font-size: 13px; margin-bottom: 3px;">Correo Personal:</label>
                    <input type="email" name="correo_personal" value="<%= usuario.getCorreoPersonal() != null ? usuario.getCorreoPersonal() : "" %>" style="width: 100%; max-width: 300px; padding: 6px; border: 1px solid #cccccc; border-radius: 4px;" required>
                </div>
                <div style="margin-bottom: 10px;">
                    <label style="display: block; font-weight: bold; font-size: 13px; margin-bottom: 3px;">Teléfono Celular / Casa:</label>
                    <input type="text" name="telefono" value="<%= usuario.getTelefono() != null ? usuario.getTelefono() : "" %>" style="width: 100%; max-width: 300px; padding: 6px; border: 1px solid #cccccc; border-radius: 4px;" required>
                </div>
                <button type="submit" style="background-color: #28a745; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; font-weight: bold; font-size: 12px;">Guardar Cambios</button>
                <button type="button" onclick="document.getElementById('editProfileForm').style.display='none'" style="background-color: #6c757d; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; font-weight: bold; font-size: 12px; margin-left: 5px;">Cancelar</button>
            </form>
        </div>

        <!-- Formulario Cambiar Contraseña -->
        <div id="changePasswordForm" style="display:none; background-color: #f9f9f9; border: 1px solid #cccccc; padding: 15px; margin-bottom: 20px; border-radius: 4px;">
            <h4 style="margin-top: 0; color: #0c2340; margin-bottom: 10px;">Cambiar Contraseña de Acceso</h4>
            <form action="${pageContext.request.contextPath}/controller/CambiarPasswordServlet" method="POST">
                <div style="margin-bottom: 10px;">
                    <label style="display: block; font-weight: bold; font-size: 13px; margin-bottom: 3px;">Contraseña Actual:</label>
                    <input type="password" name="password_actual" style="width: 100%; max-width: 300px; padding: 6px; border: 1px solid #cccccc; border-radius: 4px;" required>
                </div>
                <div style="margin-bottom: 10px;">
                    <label style="display: block; font-weight: bold; font-size: 13px; margin-bottom: 3px;">Nueva Contraseña:</label>
                    <input type="password" name="password_nuevo" style="width: 100%; max-width: 300px; padding: 6px; border: 1px solid #cccccc; border-radius: 4px;" required>
                </div>
                <div style="margin-bottom: 10px;">
                    <label style="display: block; font-weight: bold; font-size: 13px; margin-bottom: 3px;">Confirmar Nueva Contraseña:</label>
                    <input type="password" name="password_nuevo_confirmar" style="width: 100%; max-width: 300px; padding: 6px; border: 1px solid #cccccc; border-radius: 4px;" required>
                </div>
                <button type="submit" style="background-color: #28a745; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; font-weight: bold; font-size: 12px;">Cambiar Contraseña</button>
                <button type="button" onclick="document.getElementById('changePasswordForm').style.display='none'" style="background-color: #6c757d; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; font-weight: bold; font-size: 12px; margin-left: 5px;">Cancelar</button>
            </form>
        </div>

        <div class="alerta-exito" id="mensaje-exito">
            <strong>Éxito:</strong> Las calificaciones para el bloque <strong><%= bloqueAsignado %></strong> se registraron temporalmente.
        </div>

        <!-- Filtro del Curso asignado -->
        <div class="panel-busqueda">
            <strong>Curso Asignado:</strong> <%= cursoAsignado %> | 
            <strong>Bloque:</strong> <%= bloqueAsignado %> |
            <strong>Semestre:</strong> 2026-01
        </div>

        <!-- Formulario de Calificaciones -->
        <form action="${pageContext.request.contextPath}/controller/GuardarNotasServlet" method="POST">
            <!-- Tabla de Alumnos -->
            <table id="tabla-notas">
                <thead>
                    <tr>
                        <th style="text-align: left;">Alumno</th>
                        <th>PC1</th>
                        <th>PC2</th>
                        <th>PC3</th>
                        <th>Ex. Parcial</th>
                        <th>Ex. Final</th>
                        <th>Prom. Final</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try (Connection conn = ConexionBD.getConexion();
                             PreparedStatement ps = conn.prepareStatement(
                                 "SELECT m.id AS matricula_id, a.codigo_alumno, a.nombre || ' ' || a.apellido AS alumno_nombre, " +
                                 "n.pc1, n.pc2, n.pc3, n.examen_parcial, n.examen_final, n.promedio_final " +
                                 "FROM matriculas m " +
                                 "JOIN alumnos a ON m.alumno_id = a.id " +
                                 "LEFT JOIN notas n ON n.matricula_id = m.id " +
                                 "WHERE m.curso_id = ? " +
                                 "ORDER BY a.apellido, a.nombre")) {
                            ps.setInt(1, cursoId);
                            try (ResultSet rs = ps.executeQuery()) {
                                boolean tieneAlumnos = false;
                                while (rs.next()) {
                                    tieneAlumnos = true;
                                    int matriculaId = rs.getInt("matricula_id");
                                    String codigoAlumno = rs.getString("codigo_alumno");
                                    String alumnoNombre = rs.getString("alumno_nombre");
                                    double pc1 = rs.getDouble("pc1");
                                    double pc2 = rs.getDouble("pc2");
                                    double pc3 = rs.getDouble("pc3");
                                    double ep = rs.getDouble("examen_parcial");
                                    double ef = rs.getDouble("examen_final");
                                    double pf = rs.getDouble("promedio_final");
                                    
                                    String classPromedio = (pf >= 11.5) ? "promedio-celda aprobado" : "promedio-celda desaprobado";
                    %>
                    <tr class="alumno-row" data-id="<%= matriculaId %>">
                        <td>
                            <input type="hidden" name="matricula_ids" value="<%= matriculaId %>">
                            <span class="txt-alumno"><%= alumnoNombre %></span><br>
                            <span class="txt-codigo"><%= codigoAlumno %></span>
                        </td>
                        <td style="text-align: center;">
                            <input type="number" name="pc1_<%= matriculaId %>" class="grade-input pc1" value="<%= String.format(java.util.Locale.US, "%.1f", pc1) %>" min="0" max="20" step="0.1">
                        </td>
                        <td style="text-align: center;">
                            <input type="number" name="pc2_<%= matriculaId %>" class="grade-input pc2" value="<%= String.format(java.util.Locale.US, "%.1f", pc2) %>" min="0" max="20" step="0.1">
                        </td>
                        <td style="text-align: center;">
                            <input type="number" name="pc3_<%= matriculaId %>" class="grade-input pc3" value="<%= String.format(java.util.Locale.US, "%.1f", pc3) %>" min="0" max="20" step="0.1">
                        </td>
                        <td style="text-align: center;">
                            <input type="number" name="ep_<%= matriculaId %>" class="grade-input ep" value="<%= String.format(java.util.Locale.US, "%.1f", ep) %>" min="0" max="20" step="0.1">
                        </td>
                        <td style="text-align: center;">
                            <input type="number" name="ef_<%= matriculaId %>" class="grade-input ef" value="<%= String.format(java.util.Locale.US, "%.1f", ef) %>" min="0" max="20" step="0.1">
                        </td>
                        <td class="<%= classPromedio %>" id="prom-<%= matriculaId %>"><%= String.format(java.util.Locale.US, "%.2f", pf) %></td>
                    </tr>
                    <%
                                }
                                if (!tieneAlumnos) {
                    %>
                    <tr>
                        <td colspan="7" style="text-align: center; color: #666666; padding: 20px;">
                            No hay alumnos matriculados en este curso.
                        </td>
                    </tr>
                    <%
                                }
                            }
                        } catch (Exception e) {
                    %>
                    <tr>
                        <td colspan="7" style="text-align: center; color: red; padding: 20px; font-weight: bold;">
                            Error al cargar alumnos: <%= e.getMessage() %>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
 
            <!-- Botones de Acción -->
            <div class="btn-group">
                <button type="button" class="btn btn-cancelar" onclick="window.location.reload();">Cancelar</button>
                <button type="submit" class="btn btn-guardar" id="btn-save">Guardar Cambios</button>
            </div>
        </form>
    </div>
 
    <!-- Script de Calculo Interactivo Local -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const inputs = document.querySelectorAll(".grade-input");
            
            // Recalcular promedio al cambiar inputs
            inputs.forEach(input => {
                input.addEventListener("input", function() {
                    const row = this.closest(".alumno-row");
                    const id = row.getAttribute("data-id");
                    
                    const pc1 = parseFloat(row.querySelector(".pc1").value) || 0;
                    const pc2 = parseFloat(row.querySelector(".pc2").value) || 0;
                    const pc3 = parseFloat(row.querySelector(".pc3").value) || 0;
                    const ep = parseFloat(row.querySelector(".ep").value) || 0;
                    const ef = parseFloat(row.querySelector(".ef").value) || 0;
                    
                    // Fórmula estándar: 
                    // Prom_PCs = (PC1+PC2+PC3)/3
                    // Prom_Final = Prom_PCs*0.3 + EP*0.3 + EF*0.4
                    const promPC = (pc1 + pc2 + pc3) / 3;
                    const finalProm = (promPC * 0.3) + (ep * 0.3) + (ef * 0.4);
                    
                    const promCell = document.getElementById("prom-" + id);
                    promCell.innerText = finalProm.toFixed(2);
                    
                    // Aplicar color según nota
                    if (finalProm < 11.5) {
                        promCell.className = "promedio-celda desaprobado";
                    } else {
                        promCell.className = "promedio-celda aprobado";
                    }
                });
            });
        });
    </script>
</body>
</html>
