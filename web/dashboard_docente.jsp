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
    <title>Portal Docente - USIL</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-dark: #07162c;
            --primary-blue: #0c2340;
            --accent-gold: #d1a153;
            --accent-gold-hover: #b88d44;
            --bg-color: #f1f5f9;
            --card-bg: #ffffff;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --text-white: #ffffff;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --border-color: #e2e8f0;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Outfit', sans-serif;
        }

        body {
            background-color: var(--bg-color);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Barra de Navegación Superior */
        .navbar {
            background-color: var(--primary-blue);
            color: var(--text-white);
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .navbar-brand {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .logo-img {
            height: 40px;
            width: auto;
        }

        .brand-text {
            font-size: 20px;
            font-weight: 700;
            letter-spacing: 0.5px;
            border-left: 2px solid var(--accent-gold);
            padding-left: 12px;
        }

        .navbar-profile {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .user-info {
            text-align: right;
        }

        .user-name {
            font-size: 15px;
            font-weight: 600;
        }

        .user-role {
            font-size: 12px;
            color: var(--accent-gold);
            font-weight: 500;
        }

        .avatar-img {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            border: 2px solid var(--accent-gold);
            background-color: var(--primary-dark);
            padding: 2px;
        }

        .btn-logout {
            background: rgba(239, 68, 68, 0.1);
            color: #f87171;
            border: 1px solid rgba(239, 68, 68, 0.2);
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .btn-logout:hover {
            background: #ef4444;
            color: var(--text-white);
            border-color: #ef4444;
        }

        /* Contenido Principal */
        .main-container {
            max-width: 1200px;
            width: 100%;
            margin: 40px auto;
            padding: 0 20px;
            flex-grow: 1;
        }

        /* Banner de Bienvenida */
        .welcome-banner {
            background: linear-gradient(135deg, var(--primary-blue), #1e3d59);
            color: var(--text-white);
            border-radius: 20px;
            padding: 35px;
            box-shadow: 0 4px 20px rgba(12, 35, 64, 0.15);
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }

        .welcome-banner::after {
            content: "";
            position: absolute;
            top: -50px;
            right: -50px;
            width: 200px;
            height: 200px;
            background: rgba(209, 161, 83, 0.1);
            border-radius: 50%;
        }

        .welcome-title {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .welcome-subtitle {
            color: var(--accent-gold);
            font-size: 16px;
            font-weight: 400;
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .stat-card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 24px;
            display: flex;
            align-items: center;
            gap: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.02);
        }

        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            background-color: rgba(12, 35, 64, 0.05);
            color: var(--primary-blue);
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 24px;
        }

        .stat-info {
            display: flex;
            flex-direction: column;
        }

        .stat-value {
            font-size: 22px;
            font-weight: 700;
            color: var(--primary-blue);
        }

        .stat-label {
            font-size: 13px;
            color: var(--text-muted);
            font-weight: 500;
        }

        /* Panel de Calificación */
        .grading-panel {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 18px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.02);
            overflow: hidden;
            margin-bottom: 30px;
        }

        .panel-header {
            background-color: #fafbfc;
            border-bottom: 1px solid var(--border-color);
            padding: 20px 25px;
            display: flex;
            justify-content: flex-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .panel-title {
            font-size: 18px;
            font-weight: 700;
            color: var(--primary-blue);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .selector-box {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .course-select {
            padding: 10px 16px;
            font-size: 14px;
            border-radius: 10px;
            border: 1px solid var(--border-color);
            background-color: #fff;
            color: var(--primary-blue);
            font-weight: 600;
            outline: none;
            cursor: pointer;
        }

        .course-select:focus {
            border-color: var(--accent-gold);
        }

        /* Tabla de Estudiantes */
        .table-responsive {
            overflow-x: auto;
            padding: 0;
        }

        .students-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        .students-table th {
            background-color: #f8fafc;
            color: var(--text-muted);
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 16px 20px;
            border-bottom: 2px solid var(--border-color);
        }

        .students-table td {
            padding: 16px 20px;
            border-bottom: 1px solid var(--border-color);
            font-size: 14px;
        }

        .student-profile {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .student-code {
            font-size: 12px;
            color: var(--text-muted);
            font-weight: 500;
        }

        .student-name {
            font-weight: 600;
            color: var(--primary-blue);
        }

        /* Inputs para notas */
        .grade-input {
            width: 60px;
            padding: 8px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            text-align: center;
            font-size: 14px;
            font-weight: 600;
            color: var(--primary-blue);
            outline: none;
            transition: all 0.2s ease;
        }

        .grade-input:focus {
            border-color: var(--accent-gold);
            background-color: rgba(209, 161, 83, 0.05);
            box-shadow: 0 0 0 2px rgba(209, 161, 83, 0.2);
        }

        .final-grade-cell {
            font-weight: 700;
            font-size: 15px;
            text-align: center;
            color: var(--success-color);
        }

        .final-grade-cell.failed {
            color: var(--danger-color);
        }

        .action-container {
            padding: 25px;
            display: flex;
            justify-content: flex-end;
            background-color: #fafbfc;
            border-top: 1px solid var(--border-color);
            gap: 15px;
        }

        .btn-action {
            padding: 12px 24px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn-secondary {
            background-color: #f1f5f9;
            color: var(--text-muted);
            border: 1px solid var(--border-color);
        }

        .btn-secondary:hover {
            background-color: #e2e8f0;
            color: var(--text-main);
        }

        .btn-primary {
            background: linear-gradient(90deg, var(--primary-blue), #1e3d59);
            color: var(--text-white);
            border: 1px solid var(--accent-gold);
            box-shadow: 0 4px 12px rgba(12, 35, 64, 0.15);
        }

        .btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 15px rgba(209, 161, 83, 0.3);
        }

        /* Notificación Flotante */
        .toast-notification {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background-color: #1e293b;
            color: #fff;
            padding: 15px 25px;
            border-radius: 12px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.25);
            display: flex;
            align-items: center;
            gap: 12px;
            transform: translateY(150px);
            transition: transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            z-index: 1000;
            font-size: 14px;
            font-weight: 500;
        }

        .toast-notification.show {
            transform: translateY(0);
        }
    </style>
</head>
<body>

    <!-- Navbar -->
    <header class="navbar">
        <div class="navbar-brand">
            <img src="${pageContext.request.contextPath}/imagenes/usil_logo.png" alt="USIL Logo" class="logo-img" onerror="this.src='https://upload.wikimedia.org/wikipedia/commons/e/ec/USIL_logo.png';">
            <span class="brand-text">Portal Docente</span>
        </div>
        <div class="navbar-profile">
            <div class="user-info">
                <div class="user-name">Juan Carlos Pérez Silva</div>
                <div class="user-role">Docente: D20210001</div>
            </div>
            <img src="${pageContext.request.contextPath}/imagenes/avatar_docente.png" alt="Avatar" class="avatar-img" onerror="this.src='https://cdn-icons-png.flaticon.com/512/2784/2784445.png';">
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn-logout">
                <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M10 12.5a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v2a.5.5 0 0 0 1 0v-2A1.5 1.5 0 0 0 9.5 2h-8A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-2a.5.5 0 0 0-1 0v2z"/><path fill-rule="evenodd" d="M15.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 0 0-.708.708L14.293 7.5H5.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708l3-3z"/></svg>
                Salir
            </a>
        </div>
    </header>

    <!-- Main Container -->
    <main class="main-container">
        
        <!-- Welcome Banner -->
        <section class="welcome-banner">
            <h2 class="welcome-title">Bienvenido, Prof. Pérez</h2>
            <p class="welcome-subtitle">Facultad de Ingeniería - Carrera de Ingeniería de Software</p>
        </section>

        <!-- Stats Grid -->
        <section class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">👥</div>
                <div class="stat-info">
                    <span class="stat-value">32</span>
                    <span class="stat-label">Alumnos a Cargo</span>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">📚</div>
                <div class="stat-info">
                    <span class="stat-value">2</span>
                    <span class="stat-label">Cursos Asignados</span>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">⏱️</div>
                <div class="stat-info">
                    <span class="stat-value">4 días</span>
                    <span class="stat-label">Plazo de Carga de Notas</span>
                </div>
            </div>
        </section>

        <!-- Panel de Registro de Notas -->
        <section class="grading-panel">
            <div class="panel-header" style="justify-content: space-between;">
                <h3 class="panel-title">✍️ Registro de Calificaciones</h3>
                
                <div class="selector-box">
                    <label for="course-select" style="font-size: 13px; font-weight:600; color: var(--text-muted);">Curso:</label>
                    <select id="course-select" class="course-select">
                        <option value="POO2">Programación Orientada a Objetos II (Secc. A)</option>
                        <option value="BD2">Diseño de Base de Datos (Secc. B)</option>
                    </select>
                </div>
            </div>

            <!-- Tabla de alumnos a calificar -->
            <div class="table-responsive">
                <table class="students-table">
                    <thead>
                        <tr>
                            <th style="width: 300px;">Alumno</th>
                            <th style="text-align: center;">PC1</th>
                            <th style="text-align: center;">PC2</th>
                            <th style="text-align: center;">PC3</th>
                            <th style="text-align: center;">E. Parcial</th>
                            <th style="text-align: center;">E. Final</th>
                            <th style="text-align: center;">Promedio</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Fila 1 (Sofía Rossel - Datos semilla) -->
                        <tr class="student-row" data-id="1">
                            <td>
                                <div class="student-profile">
                                    <img src="${pageContext.request.contextPath}/imagenes/avatar_alumno.png" alt="Avatar" style="width:32px; height:32px; border-radius:50%;" onerror="this.src='https://cdn-icons-png.flaticon.com/512/3135/3135810.png';">
                                    <div>
                                        <div class="student-name">Sofía Rossel Mendoza Quispe</div>
                                        <div class="student-code">U20221045</div>
                                    </div>
                                </div>
                            </td>
                            <td style="text-align: center;"><input type="number" class="grade-input pc1" value="15.00" min="0" max="20" step="0.5"></td>
                            <td style="text-align: center;"><input type="number" class="grade-input pc2" value="16.00" min="0" max="20" step="0.5"></td>
                            <td style="text-align: center;"><input type="number" class="grade-input pc3" value="14.00" min="0" max="20" step="0.5"></td>
                            <td style="text-align: center;"><input type="number" class="grade-input ep" value="15.00" min="0" max="20" step="0.5"></td>
                            <td style="text-align: center;"><input type="number" class="grade-input ef" value="17.00" min="0" max="20" step="0.5"></td>
                            <td class="final-grade-cell prom" id="prom-1">15.60</td>
                        </tr>

                        <!-- Fila 2 (Carlos Díaz) -->
                        <tr class="student-row" data-id="2">
                            <td>
                                <div class="student-profile">
                                    <img src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png" alt="Avatar" style="width:32px; height:32px; border-radius:50%;">
                                    <div>
                                        <div class="student-name">Carlos Alberto Díaz Ruiz</div>
                                        <div class="student-code">U20212034</div>
                                    </div>
                                </div>
                            </td>
                            <td style="text-align: center;"><input type="number" class="grade-input pc1" value="11.00" min="0" max="20" step="0.5"></td>
                            <td style="text-align: center;"><input type="number" class="grade-input pc2" value="10.00" min="0" max="20" step="0.5"></td>
                            <td style="text-align: center;"><input type="number" class="grade-input pc3" value="12.00" min="0" max="20" step="0.5"></td>
                            <td style="text-align: center;"><input type="number" class="grade-input ep" value="8.00" min="0" max="20" step="0.5"></td>
                            <td style="text-align: center;"><input type="number" class="grade-input ef" value="11.00" min="0" max="20" step="0.5"></td>
                            <td class="final-grade-cell prom failed" id="prom-2">10.40</td>
                        </tr>

                        <!-- Fila 3 (Maria Fe Ortiz) -->
                        <tr class="student-row" data-id="3">
                            <td>
                                <div class="student-profile">
                                    <img src="https://cdn-icons-png.flaticon.com/512/4140/4140047.png" alt="Avatar" style="width:32px; height:32px; border-radius:50%;">
                                    <div>
                                        <div class="student-name">María Fe Ortiz Ramos</div>
                                        <div class="student-code">U20231122</div>
                                    </div>
                                </div>
                            </td>
                            <td style="text-align: center;"><input type="number" class="grade-input pc1" value="17.00" min="0" max="20" step="0.5"></td>
                            <td style="text-align: center;"><input type="number" class="grade-input pc2" value="18.00" min="0" max="20" step="0.5"></td>
                            <td style="text-align: center;"><input type="number" class="grade-input pc3" value="19.00" min="0" max="20" step="0.5"></td>
                            <td style="text-align: center;"><input type="number" class="grade-input ep" value="16.00" min="0" max="20" step="0.5"></td>
                            <td style="text-align: center;"><input type="number" class="grade-input ef" value="18.00" min="0" max="20" step="0.5"></td>
                            <td class="final-grade-cell prom" id="prom-3">17.60</td>
                        </tr>

                        <!-- Fila 4 (Diego Flores) -->
                        <tr class="student-row" data-id="4">
                            <td>
                                <div class="student-profile">
                                    <img src="https://cdn-icons-png.flaticon.com/512/3135/3135768.png" alt="Avatar" style="width:32px; height:32px; border-radius:50%;">
                                    <div>
                                        <div class="student-name">Diego Armando Flores Solís</div>
                                        <div class="student-code">U20221345</div>
                                    </div>
                                </div>
                            </td>
                            <td style="text-align: center;"><input type="number" class="grade-input pc1" value="14.00" min="0" max="20" step="0.5"></td>
                            <td style="text-align: center;"><input type="number" class="grade-input pc2" value="12.00" min="0" max="20" step="0.5"></td>
                            <td style="text-align: center;"><input type="number" class="grade-input pc3" value="13.00" min="0" max="20" step="0.5"></td>
                            <td style="text-align: center;"><input type="number" class="grade-input ep" value="13.00" min="0" max="20" step="0.5"></td>
                            <td style="text-align: center;"><input type="number" class="grade-input ef" value="14.00" min="0" max="20" step="0.5"></td>
                            <td class="final-grade-cell prom" id="prom-4">13.20</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Botones de Acción -->
            <div class="action-container">
                <button type="button" class="btn-action btn-secondary" onclick="window.location.reload();">Descartar Cambios</button>
                <button type="button" class="btn-action btn-primary" id="btn-save-grades">Guardar Registro</button>
            </div>
        </section>

    </main>

    <!-- Notificación Flotante -->
    <div class="toast-notification" id="toast">
        <span>💾 Notas guardadas exitosamente en la base de datos PostgreSQL.</span>
    </div>

    <!-- Script de cálculo automático y simulación -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const inputs = document.querySelectorAll(".grade-input");
            
            // Recalcular promedio al cambiar cualquier nota
            inputs.forEach(input => {
                input.addEventListener("input", function() {
                    const row = this.closest(".student-row");
                    const id = row.getAttribute("data-id");
                    
                    const pc1 = parseFloat(row.querySelector(".pc1").value) || 0;
                    const pc2 = parseFloat(row.querySelector(".pc2").value) || 0;
                    const pc3 = parseFloat(row.querySelector(".pc3").value) || 0;
                    const ep = parseFloat(row.querySelector(".ep").value) || 0;
                    const ef = parseFloat(row.querySelector(".ef").value) || 0;
                    
                    // Fórmula estándar: 
                    // Promedio de PCs = (PC1+PC2+PC3)/3 (ejemplo simplificado)
                    // Promedio Final = (Prom_PCs * 0.3) + (EP * 0.3) + (EF * 0.4)
                    const promPC = (pc1 + pc2 + pc3) / 3;
                    const finalProm = (promPC * 0.3) + (ep * 0.3) + (ef * 0.4);
                    
                    const promCell = document.getElementById("prom-" + id);
                    promCell.innerText = finalProm.toFixed(2);
                    
                    if (finalProm < 11.5) {
                        promCell.classList.add("failed");
                    } else {
                        promCell.classList.remove("failed");
                    }
                });
            });

            // Botón de guardar simulado
            const saveBtn = document.getElementById("btn-save-grades");
            const toast = document.getElementById("toast");

            saveBtn.addEventListener("click", function() {
                // Mostrar notificación
                toast.classList.add("show");
                
                // Ocultar después de 3 segundos
                setTimeout(function() {
                    toast.classList.remove("show");
                }, 3000);
            });
        });
    </script>
</body>
</html>
