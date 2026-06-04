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
            padding: 10px;
            background-color: #fcfcfc;
            border: 1px solid #e0e0e0;
            border-radius: 4px;
        }

        .panel-busqueda label {
            font-weight: bold;
            margin-right: 10px;
        }

        .panel-busqueda select {
            padding: 6px;
            border-radius: 4px;
            border: 1px solid #cccccc;
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
                <strong>Juan Carlos Pérez Silva</strong><br>
                <span>Código: D20210001 | Rol: Docente</span>
            </div>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn-salir">Cerrar Sesión</a>
        </div>
    </div>

    <!-- Contenido Principal -->
    <div class="container">
        
        <h2>Registro de Calificaciones de Alumnos</h2>
        
        <div class="instructor-info">
            <strong>Facultad:</strong> Ingeniería | 
            <strong>Especialidad:</strong> Ingeniería de Software |
            <strong>Semestre:</strong> 2026-1
        </div>

        <div class="alerta-exito" id="mensaje-exito">
            <strong>Éxito:</strong> Las calificaciones se guardaron localmente en el servidor.
        </div>

        <!-- Filtro del Curso -->
        <div class="panel-busqueda">
            <label for="curso-select">Seleccione Curso:</label>
            <select id="curso-select">
                <option value="POO2">Programación Orientada a Objetos II (POO2 - Secc. A)</option>
                <option value="BD1">Diseño de Base de Datos (BD1 - Secc. B)</option>
            </select>
        </div>

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
                <!-- Fila Alumno 1 -->
                <tr class="alumno-row" data-id="1">
                    <td>
                        <span class="txt-alumno">Sofía Rossel Mendoza Quispe</span><br>
                        <span class="txt-codigo">U20221045</span>
                    </td>
                    <td style="text-align: center;"><input type="number" class="grade-input pc1" value="15.0" min="0" max="20" step="0.5"></td>
                    <td style="text-align: center;"><input type="number" class="grade-input pc2" value="16.0" min="0" max="20" step="0.5"></td>
                    <td style="text-align: center;"><input type="number" class="grade-input pc3" value="14.0" min="0" max="20" step="0.5"></td>
                    <td style="text-align: center;"><input type="number" class="grade-input ep" value="15.0" min="0" max="20" step="0.5"></td>
                    <td style="text-align: center;"><input type="number" class="grade-input ef" value="17.0" min="0" max="20" step="0.5"></td>
                    <td class="promedio-celda aprobado" id="prom-1">15.60</td>
                </tr>

                <!-- Fila Alumno 2 -->
                <tr class="alumno-row" data-id="2">
                    <td>
                        <span class="txt-alumno">Carlos Alberto Díaz Ruiz</span><br>
                        <span class="txt-codigo">U20212034</span>
                    </td>
                    <td style="text-align: center;"><input type="number" class="grade-input pc1" value="11.0" min="0" max="20" step="0.5"></td>
                    <td style="text-align: center;"><input type="number" class="grade-input pc2" value="10.0" min="0" max="20" step="0.5"></td>
                    <td style="text-align: center;"><input type="number" class="grade-input pc3" value="12.0" min="0" max="20" step="0.5"></td>
                    <td style="text-align: center;"><input type="number" class="grade-input ep" value="8.0" min="0" max="20" step="0.5"></td>
                    <td style="text-align: center;"><input type="number" class="grade-input ef" value="11.0" min="0" max="20" step="0.5"></td>
                    <td class="promedio-celda desaprobado" id="prom-2">10.40</td>
                </tr>

                <!-- Fila Alumno 3 -->
                <tr class="alumno-row" data-id="3">
                    <td>
                        <span class="txt-alumno">María Fe Ortiz Ramos</span><br>
                        <span class="txt-codigo">U20231122</span>
                    </td>
                    <td style="text-align: center;"><input type="number" class="grade-input pc1" value="17.0" min="0" max="20" step="0.5"></td>
                    <td style="text-align: center;"><input type="number" class="grade-input pc2" value="18.0" min="0" max="20" step="0.5"></td>
                    <td style="text-align: center;"><input type="number" class="grade-input pc3" value="19.0" min="0" max="20" step="0.5"></td>
                    <td style="text-align: center;"><input type="number" class="grade-input ep" value="16.0" min="0" max="20" step="0.5"></td>
                    <td style="text-align: center;"><input type="number" class="grade-input ef" value="18.0" min="0" max="20" step="0.5"></td>
                    <td class="promedio-celda aprobado" id="prom-3">17.60</td>
                </tr>

                <!-- Fila Alumno 4 -->
                <tr class="alumno-row" data-id="4">
                    <td>
                        <span class="txt-alumno">Diego Armando Flores Solís</span><br>
                        <span class="txt-codigo">U20221345</span>
                    </td>
                    <td style="text-align: center;"><input type="number" class="grade-input pc1" value="14.0" min="0" max="20" step="0.5"></td>
                    <td style="text-align: center;"><input type="number" class="grade-input pc2" value="12.0" min="0" max="20" step="0.5"></td>
                    <td style="text-align: center;"><input type="number" class="grade-input pc3" value="13.0" min="0" max="20" step="0.5"></td>
                    <td style="text-align: center;"><input type="number" class="grade-input ep" value="13.0" min="0" max="20" step="0.5"></td>
                    <td style="text-align: center;"><input type="number" class="grade-input ef" value="14.0" min="0" max="20" step="0.5"></td>
                    <td class="promedio-celda aprobado" id="prom-4">13.20</td>
                </tr>
            </tbody>
        </table>

        <!-- Botones de Acción -->
        <div class="btn-group">
            <button type="button" class="btn btn-cancelar" onclick="window.location.reload();">Cancelar</button>
            <button type="button" class="btn btn-guardar" id="btn-save">Guardar Cambios</button>
        </div>

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

            // Acción del botón guardar
            const saveBtn = document.getElementById("btn-save");
            const mensajeExito = document.getElementById("mensaje-exito");

            saveBtn.addEventListener("click", function() {
                mensajeExito.style.display = "block";
                window.scrollTo({ top: 0, behavior: 'smooth' });
                
                setTimeout(function() {
                    mensajeExito.style.display = "none";
                }, 3000);
            });
        });
    </script>
</body>
</html>
