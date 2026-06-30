        <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Administración - ${configuracion.nombreInstitucion}</title>
    <!-- Bootstrap 5 CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    
    <style>
        :root {
            --primary-color: ${configuracion.colorPrincipalHex};
        }
        
        .sidebar {
            min-height: 100vh;
            background-color: var(--primary-color);
            color: #ffffff;
        }
        
        .sidebar a {
            color: rgba(255, 255, 255, 0.85);
            text-decoration: none;
            transition: all 0.2s;
        }
        
        .sidebar a:hover, .sidebar a.active {
            color: #ffffff;
            background-color: rgba(255, 255, 255, 0.15);
            border-radius: 4px;
        }
        
        .navbar-custom {
            border-bottom: 1px solid #dee2e6;
        }
    </style>
</head>
<body class="bg-light">

    <div class="container-fluid">
        <div class="row">
            
            <!-- Sidebar (Menú Lateral) -->
            <nav class="col-md-3 col-lg-2 d-md-block sidebar collapse p-3 shadow">
                <div class="d-flex align-items-center gap-2 mb-4 pb-3 border-bottom border-white-50">
                    <img src="${pageContext.request.contextPath}/${configuracion.logoUrl}" alt="Logo" width="35" height="35" class="rounded bg-white p-1" onerror="this.src='https://upload.wikimedia.org/wikipedia/commons/e/ec/USIL_logo.png';">
                    <span class="fs-5 fw-bold text-white">${configuracion.nombreInstitucion}</span>
                </div>
                <ul class="nav flex-column gap-2">
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/AdminDashboardServlet" class="nav-link active py-2 px-3 fw-semibold">
                            <i class="bi bi-speedometer2 me-2"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/AdminUsuariosServlet?action=list" class="nav-link py-2 px-3 fw-semibold">
                            <i class="bi bi-people-fill me-2"></i> Gestionar Usuarios
                        </a>
                    </li>
                </ul>
                <div class="mt-5 pt-5 border-top border-white-50 text-center">
                    <small class="text-white-50 d-block mb-2">Rol: Administrador</small>
                    <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-sm btn-outline-light w-100 fw-bold">
                        <i class="bi bi-box-arrow-right"></i> Salir
                    </a>
                </div>
            </nav>

            <!-- Main Content Area -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
                
                <!-- Navbar Superior -->
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-4 border-bottom navbar-custom">
                    <div>
                        <h1 class="h2 fw-bold text-dark m-0">Panel Administrativo de Seguridad</h1>
                        <p class="text-muted m-0">Bienvenido al centro de control del sistema académico</p>
                    </div>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <span class="badge bg-secondary p-2">Marca Blanca: Activa</span>
                    </div>
                </div>

                <!-- Métricas en Tarjetas (Bootstrap 5 Cards) -->
                <div class="row g-4 mb-5">
                    
                    <!-- Tarjeta Total Usuarios -->
                    <div class="col-md-6 col-lg-3">
                        <div class="card border-0 shadow-sm h-100">
                            <div class="card-body p-4 text-center">
                                <div class="d-inline-flex p-3 bg-primary-subtle text-primary rounded-circle mb-3">
                                    <i class="bi bi-people fs-3"></i>
                                </div>
                                <h6 class="text-muted text-uppercase fw-semibold mb-2">Usuarios Totales</h6>
                                <h2 class="fw-bold text-dark m-0">${totalUsuarios}</h2>
                            </div>
                        </div>
                    </div>

                    <!-- Tarjeta Alumnos -->
                    <div class="col-md-6 col-lg-3">
                        <div class="card border-0 shadow-sm h-100">
                            <div class="card-body p-4 text-center">
                                <div class="d-inline-flex p-3 bg-success-subtle text-success rounded-circle mb-3">
                                    <i class="bi bi-mortarboard fs-3"></i>
                                </div>
                                <h6 class="text-muted text-uppercase fw-semibold mb-2">Total Alumnos</h6>
                                <h2 class="fw-bold text-dark m-0">${totalAlumnos}</h2>
                            </div>
                        </div>
                    </div>

                    <!-- Tarjeta Docentes -->
                    <div class="col-md-6 col-lg-3">
                        <div class="card border-0 shadow-sm h-100">
                            <div class="card-body p-4 text-center">
                                <div class="d-inline-flex p-3 bg-info-subtle text-info rounded-circle mb-3">
                                    <i class="bi bi-person-video3 fs-3"></i>
                                </div>
                                <h6 class="text-muted text-uppercase fw-semibold mb-2">Total Docentes</h6>
                                <h2 class="fw-bold text-dark m-0">${totalDocentes}</h2>
                            </div>
                        </div>
                    </div>

                    <!-- Tarjeta Bloqueados -->
                    <div class="col-md-6 col-lg-3">
                        <div class="card border-0 shadow-sm h-100">
                            <div class="card-body p-4 text-center">
                                <div class="d-inline-flex p-3 bg-danger-subtle text-danger rounded-circle mb-3">
                                    <i class="bi bi-shield-lock-fill fs-3"></i>
                                </div>
                                <h6 class="text-muted text-uppercase fw-semibold mb-2">Cuentas Bloqueadas</h6>
                                <h2 class="fw-bold text-dark m-0">${totalBloqueados}</h2>
                            </div>
                        </div>
                    </div>

                </div><!-- Fin Tarjetas -->

                <!-- Quick actions section -->
                <div class="row">
                    <div class="col-12">
                        <div class="card border-0 shadow-sm p-4">
                            <h5 class="fw-bold text-dark mb-3"><i class="bi bi-gear-fill me-2 text-secondary"></i>Acciones Administrativas Rápidas</h5>
                            <div class="d-flex flex-wrap gap-3">
                                <a href="${pageContext.request.contextPath}/AdminUsuariosServlet?action=form" class="btn btn-primary fw-semibold d-flex align-items-center gap-2">
                                    <i class="bi bi-person-plus-fill"></i> Crear Nuevo Usuario
                                </a>
                                <a href="${pageContext.request.contextPath}/AdminUsuariosServlet?action=list" class="btn btn-outline-secondary fw-semibold d-flex align-items-center gap-2">
                                    <i class="bi bi-list-task"></i> Ver Listado de Cuentas
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

            </main>
        </div>
    </div>

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
