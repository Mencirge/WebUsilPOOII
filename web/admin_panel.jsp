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
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
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

        /* Tablas */
        .admin-panel-card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 18px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.02);
            overflow: hidden;
            margin-bottom: 30px;
        }

        .card-header {
            background-color: #fafbfc;
            border-bottom: 1px solid var(--border-color);
            padding: 20px 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-title {
            font-size: 18px;
            font-weight: 700;
            color: var(--primary-blue);
        }

        .table-responsive {
            overflow-x: auto;
        }

        .admin-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        .admin-table th {
            background-color: #f8fafc;
            color: var(--text-muted);
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 16px 20px;
            border-bottom: 2px solid var(--border-color);
        }

        .admin-table td {
            padding: 16px 20px;
            border-bottom: 1px solid var(--border-color);
            font-size: 14px;
        }

        /* Badges de Estado y Rol */
        .badge {
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .badge-admin { background-color: #e0f2fe; color: #0284c7; }
        .badge-docente { background-color: #fef3c7; color: #d97706; }
        .badge-alumno { background-color: #dcfce7; color: #16a34a; }

        .badge-activo { background-color: rgba(16, 185, 129, 0.1); color: var(--success-color); border: 1px solid rgba(16, 185, 129, 0.2); }
        .badge-bloqueado { background-color: rgba(239, 68, 68, 0.1); color: var(--danger-color); border: 1px solid rgba(239, 68, 68, 0.2); }

        /* Botones del Admin */
        .btn-action-small {
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            border: 1px solid var(--border-color);
            background-color: #fff;
            transition: all 0.2s ease;
        }

        .btn-unlock {
            background-color: rgba(16, 185, 129, 0.1);
            color: var(--success-color);
            border-color: rgba(16, 185, 129, 0.2);
        }

        .btn-unlock:hover {
            background-color: var(--success-color);
            color: #fff;
        }

        .btn-edit {
            color: var(--primary-blue);
        }

        .btn-edit:hover {
            background-color: var(--primary-blue);
            color: #fff;
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
            <span class="brand-text">Portal Administrador</span>
        </div>
        <div class="navbar-profile">
            <div class="user-info">
                <div class="user-name">Administrador TI</div>
                <div class="user-role">Soporte Técnico</div>
            </div>
            <img src="${pageContext.request.contextPath}/imagenes/avatar_admin.png" alt="Avatar" class="avatar-img" onerror="this.src='https://cdn-icons-png.flaticon.com/512/2206/2206368.png';">
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
            <h2 class="welcome-title">Panel de Control General</h2>
            <p class="welcome-subtitle">Gestión de Usuarios, Control de Acceso y Seguridad RBAC</p>
        </section>

        <!-- Stats Grid -->
        <section class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">👤</div>
                <div class="stat-info">
                    <span class="stat-value">3</span>
                    <span class="stat-label">Usuarios Semilla Activos</span>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">🛡️</div>
                <div class="stat-info">
                    <span class="stat-value">3 Roles</span>
                    <span class="stat-label">Esquema de Roles</span>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">⚠️</div>
                <div class="stat-info">
                    <span class="stat-value" id="blocked-count-val">1</span>
                    <span class="stat-label">Cuentas Bloqueadas (Test)</span>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">⚙️</div>
                <div class="stat-info">
                    <span class="stat-value">Tomcat 10</span>
                    <span class="stat-label">Servidor en Render</span>
                </div>
            </div>
        </section>

        <!-- Panel de Gestión de Usuarios -->
        <section class="admin-panel-card">
            <div class="card-header">
                <h3 class="card-title">👥 Listado de Cuentas de Acceso</h3>
            </div>

            <div class="table-responsive">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Código/Correo</th>
                            <th>Rol</th>
                            <th>Estado</th>
                            <th style="text-align: center;">Intentos Fallidos</th>
                            <th>Último Bloqueo</th>
                            <th style="text-align: center;">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Fila 1 -->
                        <tr>
                            <td><strong>admin@usil.edu.pe</strong></td>
                            <td><span class="badge badge-admin">ADMIN</span></td>
                            <td><span class="badge badge-activo">Activo</span></td>
                            <td style="text-align: center;">0</td>
                            <td>--</td>
                            <td style="text-align: center;">
                                <button type="button" class="btn-action-small btn-edit" onclick="alert('Funcionalidad de edición básica en construcción.');">Editar</button>
                            </td>
                        </tr>
                        
                        <!-- Fila 2 -->
                        <tr>
                            <td><strong>docente@usil.edu.pe</strong></td>
                            <td><span class="badge badge-docente">DOCENTE</span></td>
                            <td><span class="badge badge-activo">Activo</span></td>
                            <td style="text-align: center;">0</td>
                            <td>--</td>
                            <td style="text-align: center;">
                                <button type="button" class="btn-action-small btn-edit" onclick="alert('Funcionalidad de edición básica en construcción.');">Editar</button>
                            </td>
                        </tr>

                        <!-- Fila 3 -->
                        <tr>
                            <td><strong>alumno@usil.edu.pe</strong></td>
                            <td><span class="badge badge-alumno">ALUMNO</span></td>
                            <td><span class="badge badge-activo">Activo</span></td>
                            <td style="text-align: center;">0</td>
                            <td>--</td>
                            <td style="text-align: center;">
                                <button type="button" class="btn-action-small btn-edit" onclick="alert('Funcionalidad de edición básica en construcción.');">Editar</button>
                            </td>
                        </tr>

                        <!-- Fila 4 (Test de bloqueo) -->
                        <tr id="blocked-user-row">
                            <td><strong>bloqueado_test@usil.edu.pe</strong></td>
                            <td><span class="badge badge-alumno">ALUMNO</span></td>
                            <td><span class="badge badge-bloqueado" id="blocked-status-badge">Bloqueado</span></td>
                            <td style="text-align: center;" id="failed-attempts-val">3</td>
                            <td id="lock-time-val">Hace 2 minutos</td>
                            <td style="text-align: center;">
                                <button type="button" class="btn-action-small btn-unlock" id="btn-unlock-test">Desbloquear</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </section>

    </main>

    <!-- Notificación Flotante -->
    <div class="toast-notification" id="toast-admin">
        <span>🔓 Cuenta de usuario desbloqueada con éxito. Intentos reseteados a 0.</span>
    </div>

    <!-- Script de Simulación de Desbloqueo -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const unlockBtn = document.getElementById("btn-unlock-test");
            const toast = document.getElementById("toast-admin");

            if (unlockBtn) {
                unlockBtn.addEventListener("click", function() {
                    // Simular cambios en la interfaz
                    document.getElementById("blocked-status-badge").className = "badge badge-activo";
                    document.getElementById("blocked-status-badge").innerText = "Activo";
                    document.getElementById("failed-attempts-val").innerText = "0";
                    document.getElementById("lock-time-val").innerText = "--";
                    document.getElementById("blocked-count-val").innerText = "0";
                    
                    // Deshabilitar botón
                    unlockBtn.disabled = true;
                    unlockBtn.innerText = "Desbloqueado";
                    unlockBtn.className = "btn-action-small";
                    
                    // Mostrar notificación
                    toast.classList.add("show");
                    setTimeout(function() {
                        toast.classList.remove("show");
                    }, 3000);
                });
            }
        });
    </script>
</body>
</html>
