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
    <title>Panel Admin - USIL</title>
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

        /* Métricas de Resumen */
        .metrics-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 25px;
        }

        .metric-card {
            background-color: #f9f9f9;
            border: 1px solid #e0e0e0;
            border-radius: 4px;
            padding: 15px;
            text-align: center;
        }

        .metric-title {
            font-size: 12px;
            color: #666666;
            text-transform: uppercase;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .metric-value {
            font-size: 22px;
            font-weight: bold;
            color: #0c2340;
        }

        /* Tabla de Cuentas */
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
            text-align: left;
        }

        td {
            padding: 10px;
        }

        /* Estados y Roles (Etiquetas simples) */
        .badge {
            font-size: 11px;
            font-weight: bold;
            padding: 3px 8px;
            border-radius: 3px;
            text-transform: uppercase;
        }

        .badge-admin { background-color: #d1ecf1; color: #0c5460; }
        .badge-docente { background-color: #fff3cd; color: #856404; }
        .badge-alumno { background-color: #d4edda; color: #155724; }

        .badge-activo { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .badge-bloqueado { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        /* Botón de Desbloqueo */
        .btn-desbloquear {
            background-color: #28a745;
            color: #ffffff;
            border: none;
            padding: 5px 10px;
            border-radius: 3px;
            font-size: 12px;
            font-weight: bold;
            cursor: pointer;
        }

        .btn-desbloquear:hover {
            background-color: #218838;
        }

        .btn-desbloquear:disabled {
            background-color: #cccccc;
            color: #666666;
            cursor: not-allowed;
        }

        /* Notificación */
        .alerta-desbloqueo {
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
        <h1>USIL - Portal de Administración</h1>
        <div class="user-menu">
            <div class="user-details">
                <strong>Administrador TI</strong><br>
                <span>Código: AD001 | Rol: Admin</span>
            </div>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn-salir">Cerrar Sesión</a>
        </div>
    </div>

    <!-- Contenido Principal -->
    <div class="container">
        
        <h2>Panel Administrativo de Seguridad</h2>

        <div class="alerta-desbloqueo" id="alerta-exito">
            <strong>Éxito:</strong> La cuenta se ha desbloqueado. Los intentos fallidos fueron reseteados a 0.
        </div>

        <!-- Tarjetas de métricas -->
        <div class="metrics-container">
            <div class="metric-card">
                <div class="metric-title">Usuarios Registrados</div>
                <div class="metric-value">3</div>
            </div>
            <div class="metric-card">
                <div class="metric-title">Esquema de Roles</div>
                <div class="metric-value">3 Roles</div>
            </div>
            <div class="metric-card">
                <div class="metric-title">Cuentas Bloqueadas</div>
                <div class="metric-value" id="cant-bloqueados">1</div>
            </div>
        </div>

        <h3>Listado de Cuentas de Acceso</h3>

        <!-- Tabla -->
        <table>
            <thead>
                <tr>
                    <th>Código o Correo</th>
                    <th>Rol del Sistema</th>
                    <th>Estado de Cuenta</th>
                    <th style="text-align: center;">Intentos Fallidos</th>
                    <th>Último Bloqueo</th>
                    <th style="text-align: center;">Acciones</th>
                </tr>
            </thead>
            <tbody>
                <!-- Fila Admin -->
                <tr>
                    <td><strong>admin@usil.edu.pe</strong></td>
                    <td><span class="badge badge-admin">ADMIN</span></td>
                    <td><span class="badge badge-activo">Activo</span></td>
                    <td style="text-align: center;">0</td>
                    <td>--</td>
                    <td style="text-align: center;">--</td>
                </tr>

                <!-- Fila Docente -->
                <tr>
                    <td><strong>docente@usil.edu.pe</strong></td>
                    <td><span class="badge badge-docente">DOCENTE</span></td>
                    <td><span class="badge badge-activo">Activo</span></td>
                    <td style="text-align: center;">0</td>
                    <td>--</td>
                    <td style="text-align: center;">--</td>
                </tr>

                <!-- Fila Alumno -->
                <tr>
                    <td><strong>alumno@usil.edu.pe</strong></td>
                    <td><span class="badge badge-alumno">ALUMNO</span></td>
                    <td><span class="badge badge-activo">Activo</span></td>
                    <td style="text-align: center;">0</td>
                    <td>--</td>
                    <td style="text-align: center;">--</td>
                </tr>

                <!-- Fila Usuario Bloqueado de Prueba -->
                <tr id="fila-bloqueado">
                    <td><strong>bloqueado_test@usil.edu.pe</strong></td>
                    <td><span class="badge badge-alumno">ALUMNO</span></td>
                    <td><span class="badge badge-bloqueado" id="estado-usuario">Bloqueado</span></td>
                    <td style="text-align: center;" id="cant-intentos">3</td>
                    <td id="hora-bloqueo">Hace 2 minutos</td>
                    <td style="text-align: center;">
                        <button type="button" class="btn-desbloquear" id="btn-unlock">Desbloquear</button>
                    </td>
                </tr>
            </tbody>
        </table>

    </div>

    <!-- Script de Simulación de Desbloqueo -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const unlockBtn = document.getElementById("btn-unlock");
            const alertaExito = document.getElementById("alerta-exito");

            if (unlockBtn) {
                unlockBtn.addEventListener("click", function() {
                    // Cambiar estados visuales de la fila
                    document.getElementById("estado-usuario").className = "badge badge-activo";
                    document.getElementById("estado-usuario").innerText = "Activo";
                    document.getElementById("cant-intentos").innerText = "0";
                    document.getElementById("hora-bloqueo").innerText = "--";
                    document.getElementById("cant-bloqueados").innerText = "0";
                    
                    // Deshabilitar el botón
                    unlockBtn.disabled = true;
                    unlockBtn.innerText = "Desbloqueado";
                    unlockBtn.style.backgroundColor = "#cccccc";
                    unlockBtn.style.color = "#666666";
                    unlockBtn.style.cursor = "not-allowed";

                    // Mostrar alerta de éxito
                    alertaExito.style.display = "block";
                    window.scrollTo({ top: 0, behavior: 'smooth' });

                    setTimeout(function() {
                        alertaExito.style.display = "none";
                    }, 3000);
                });
            }
        });
    </script>
</body>
</html>
