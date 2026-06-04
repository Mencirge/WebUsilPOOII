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
    <title>Portal Alumno - USIL</title>
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

        /* Tarjetas de Resumen */
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
            transition: transform 0.2s ease;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 15px rgba(0,0,0,0.05);
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

        /* Sección de Cursos */
        .section-title {
            font-size: 22px;
            font-weight: 700;
            color: var(--primary-blue);
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
            border-left: 4px solid var(--accent-gold);
            padding-left: 10px;
        }

        .courses-container {
            display: flex;
            flex-direction: column;
            gap: 30px;
        }

        .course-card {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 18px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.02);
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .course-card:hover {
            box-shadow: 0 10px 25px rgba(0,0,0,0.06);
            border-color: rgba(209, 161, 83, 0.4);
        }

        .course-header {
            background-color: #fafbfc;
            border-bottom: 1px solid var(--border-color);
            padding: 20px 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }

        .course-title-block {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .course-icon-wrapper {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            overflow: hidden;
            border: 2px solid var(--border-color);
            background-color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .course-icon {
            width: 32px;
            height: 32px;
            object-fit: contain;
        }

        .course-name {
            font-size: 18px;
            font-weight: 600;
            color: var(--primary-blue);
        }

        .course-code {
            font-size: 13px;
            color: var(--text-muted);
            font-weight: 500;
            background-color: #f1f5f9;
            padding: 3px 8px;
            border-radius: 6px;
            margin-left: 10px;
        }

        .course-stats {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .badge-promedio {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .badge-aprobado {
            background-color: rgba(16, 185, 129, 0.1);
            color: var(--success-color);
            border: 1px solid rgba(16, 185, 129, 0.2);
        }

        .badge-desaprobado {
            background-color: rgba(239, 68, 68, 0.1);
            color: var(--danger-color);
            border: 1px solid rgba(239, 68, 68, 0.2);
        }

        /* Cuerpo de la tarjeta del curso */
        .course-body {
            padding: 25px;
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
        }

        @media (max-width: 768px) {
            .course-body {
                grid-template-columns: 1fr;
            }
        }

        /* Tabla de Notas */
        .grades-table-wrapper {
            overflow-x: auto;
        }

        .grades-table {
            width: 100%;
            border-collapse: collapse;
            text-align: center;
        }

        .grades-table th {
            background-color: #f8fafc;
            color: var(--text-muted);
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 12px 10px;
            border-bottom: 2px solid var(--border-color);
        }

        .grades-table td {
            padding: 16px 10px;
            border-bottom: 1px solid var(--border-color);
            font-size: 15px;
            font-weight: 500;
        }

        .grade-highlight {
            font-weight: 700;
            color: var(--primary-blue);
        }

        /* Sección de Materiales */
        .materials-block {
            background-color: #fafbfc;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 20px;
        }

        .materials-title {
            font-size: 14px;
            font-weight: 600;
            color: var(--primary-blue);
            margin-bottom: 15px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 8px;
        }

        .materials-list {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .material-item {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 13px;
        }

        .material-link {
            color: var(--primary-blue);
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s ease;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 200px;
            display: inline-block;
        }

        .material-link:hover {
            color: var(--accent-gold);
        }

        .file-icon {
            color: var(--accent-gold);
            font-size: 16px;
        }
    </style>
</head>
<body>

    <!-- Navbar -->
    <header class="navbar">
        <div class="navbar-brand">
            <img src="${pageContext.request.contextPath}/imagenes/usil_logo.png" alt="USIL Logo" class="logo-img" onerror="this.src='https://upload.wikimedia.org/wikipedia/commons/e/ec/USIL_logo.png';">
            <span class="brand-text">Portal Académico</span>
        </div>
        <div class="navbar-profile">
            <div class="user-info">
                <div class="user-name">Sofía Rossel Mendoza Q.</div>
                <div class="user-role">Alumno: U20221045</div>
            </div>
            <img src="${pageContext.request.contextPath}/imagenes/avatar_alumno.png" alt="Avatar" class="avatar-img" onerror="this.src='https://cdn-icons-png.flaticon.com/512/3135/3135810.png';">
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
            <h2 class="welcome-title">¡Hola de nuevo, Sofía!</h2>
            <p class="welcome-subtitle">Facultad de Ingeniería - Ingeniería de Sistemas de Información</p>
        </section>

        <!-- Stats Grid -->
        <section class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">🎓</div>
                <div class="stat-info">
                    <span class="stat-value">IV Ciclo</span>
                    <span class="stat-label">Semestre Actual</span>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">📚</div>
                <div class="stat-info">
                    <span class="stat-value">3</span>
                    <span class="stat-label">Cursos Matriculados</span>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">📈</div>
                <div class="stat-info">
                    <span class="stat-value">13.0 / 20</span>
                    <span class="stat-label">Promedio General Ponderado</span>
                </div>
            </div>
        </section>

        <h3 class="section-title">Mis Calificaciones y Recursos</h3>

        <!-- Lista de Cursos -->
        <section class="courses-container">
            
            <!-- Curso 1 -->
            <article class="course-card">
                <div class="course-header">
                    <div class="course-title-block">
                        <div class="course-icon-wrapper">
                            <img src="${pageContext.request.contextPath}/imagenes/icon_curso_prog.png" alt="Prog Icon" class="course-icon" onerror="this.src='https://cdn-icons-png.flaticon.com/512/2010/2010990.png';">
                        </div>
                        <span class="course-name">Programación Orientada a Objetos II <span class="course-code">POO2</span></span>
                    </div>
                    <div class="course-stats">
                        <span class="badge-promedio badge-aprobado">Promedio: 15.60 (Aprobado)</span>
                    </div>
                </div>
                <div class="course-body">
                    <div class="grades-table-wrapper">
                        <table class="grades-table">
                            <thead>
                                <tr>
                                    <th>PC1</th>
                                    <th>PC2</th>
                                    <th>PC3</th>
                                    <th>E. Parcial</th>
                                    <th>E. Final</th>
                                    <th class="grade-highlight">Prom. Final</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>15.00</td>
                                    <td>16.00</td>
                                    <td>14.00</td>
                                    <td>15.00</td>
                                    <td>17.00</td>
                                    <td class="grade-highlight" style="color: var(--success-color)">15.60</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="materials-block">
                        <h4 class="materials-title">Materiales del Curso</h4>
                        <ul class="materials-list">
                            <li class="material-item">
                                <span class="file-icon">📄</span>
                                <a href="#" class="material-link" title="Sílabo del Curso">Sílabo POO II.pdf</a>
                            </li>
                            <li class="material-item">
                                <span class="file-icon">📊</span>
                                <a href="#" class="material-link" title="Semana 1 - Arquitectura de Web Apps">Semana 1 - Servlets y MVC.pptx</a>
                            </li>
                            <li class="material-item">
                                <span class="file-icon">📁</span>
                                <a href="#" class="material-link" title="Plantilla Base del Proyecto Final">Plantilla_NetBeans_POO2.zip</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </article>

            <!-- Curso 2 -->
            <article class="course-card">
                <div class="course-header">
                    <div class="course-title-block">
                        <div class="course-icon-wrapper">
                            <img src="${pageContext.request.contextPath}/imagenes/icon_curso_db.png" alt="DB Icon" class="course-icon" onerror="this.src='https://cdn-icons-png.flaticon.com/512/2906/2906274.png';">
                        </div>
                        <span class="course-name">Diseño de Base de Datos <span class="course-code">BD1</span></span>
                    </div>
                    <div class="course-stats">
                        <span class="badge-promedio badge-aprobado">Promedio: 12.90 (Aprobado)</span>
                    </div>
                </div>
                <div class="course-body">
                    <div class="grades-table-wrapper">
                        <table class="grades-table">
                            <thead>
                                <tr>
                                    <th>PC1</th>
                                    <th>PC2</th>
                                    <th>PC3</th>
                                    <th>E. Parcial</th>
                                    <th>E. Final</th>
                                    <th class="grade-highlight">Prom. Final</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>12.00</td>
                                    <td>14.00</td>
                                    <td>15.00</td>
                                    <td>11.00</td>
                                    <td>13.00</td>
                                    <td class="grade-highlight" style="color: var(--success-color)">12.90</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="materials-block">
                        <h4 class="materials-title">Materiales del Curso</h4>
                        <ul class="materials-list">
                            <li class="material-item">
                                <span class="file-icon">📄</span>
                                <a href="#" class="material-link" title="Sílabo Base de Datos">Sílabo BD1.pdf</a>
                            </li>
                            <li class="material-item">
                                <span class="file-icon">📝</span>
                                <a href="#" class="material-link" title="Guía de Laboratorio SQL">Guía de Laboratorio SQL.pdf</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </article>

            <!-- Curso 3 -->
            <article class="course-card">
                <div class="course-header">
                    <div class="course-title-block">
                        <div class="course-icon-wrapper">
                            <img src="${pageContext.request.contextPath}/imagenes/icon_curso_math.png" alt="Math Icon" class="course-icon" onerror="this.src='https://cdn-icons-png.flaticon.com/512/3771/3771275.png';">
                        </div>
                        <span class="course-name">Cálculo Multivariable <span class="course-code">CAL2</span></span>
                    </div>
                    <div class="course-stats">
                        <span class="badge-promedio badge-desaprobado" style="color: var(--warning-color); background: rgba(245, 158, 11, 0.1); border-color: rgba(245, 158, 11, 0.2);">Promedio: 10.40 (En riesgo)</span>
                    </div>
                </div>
                <div class="course-body">
                    <div class="grades-table-wrapper">
                        <table class="grades-table">
                            <thead>
                                <tr>
                                    <th>PC1</th>
                                    <th>PC2</th>
                                    <th>PC3</th>
                                    <th>E. Parcial</th>
                                    <th>E. Final</th>
                                    <th class="grade-highlight">Prom. Final</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>10.00</td>
                                    <td>11.00</td>
                                    <td>12.00</td>
                                    <td>09.00</td>
                                    <td>11.00</td>
                                    <td class="grade-highlight" style="color: var(--warning-color)">10.40</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="materials-block">
                        <h4 class="materials-title">Materiales del Curso</h4>
                        <ul class="materials-list">
                            <li class="material-item">
                                <span class="file-icon">📄</span>
                                <a href="#" class="material-link" title="Límites y Derivadas Parciales">Guía Derivadas Parciales.pdf</a>
                            </li>
                            <li class="material-item">
                                <span class="file-icon">📊</span>
                                <a href="#" class="material-link" title="Integrales Dobles y Triples">Semana 10 - Integrales Múltiples.pdf</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </article>

        </section>

    </main>

</body>
</html>
