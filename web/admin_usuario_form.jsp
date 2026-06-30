<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Usuario - ${configuracion.nombreInstitucion}</title>
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
        
        .card-header-custom {
            background-color: #f8f9fa;
            border-left: 5px solid var(--primary-color);
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
                        <a href="${pageContext.request.contextPath}/AdminDashboardServlet" class="nav-link py-2 px-3 fw-semibold">
                            <i class="bi bi-speedometer2 me-2"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/AdminUsuariosServlet?action=list" class="nav-link active py-2 px-3 fw-semibold">
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
                        <h1 class="h2 fw-bold text-dark m-0">Registrar Nuevo Usuario</h1>
                        <p class="text-muted m-0">Agregar un nuevo estudiante o profesor al sistema</p>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/AdminUsuariosServlet?action=list" class="btn btn-outline-secondary fw-semibold d-flex align-items-center gap-2">
                            <i class="bi bi-arrow-left"></i> Volver al Listado
                        </a>
                    </div>
                </div>

                <!-- Alert Errors -->
                <c:if test="${not empty param.error}">
                    <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center gap-2 mb-4 shadow-sm" role="alert">
                        <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                        <div><strong>Error:</strong> ${param.error}</div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Form Card -->
                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        
                        <div class="card border-0 shadow-sm">
                            <div class="card-header card-header-custom py-3">
                                <h5 class="fw-bold text-dark m-0"><i class="bi bi-person-plus-fill me-2 text-secondary"></i>Formulario de Registro</h5>
                            </div>
                            <div class="card-body p-4">
                                
                                <form action="${pageContext.request.contextPath}/AdminUsuariosServlet" method="POST">
                                    
                                    <div class="row g-3 mb-4">
                                        <!-- Nombres -->
                                        <div class="col-md-6">
                                            <label for="nombre" class="form-label fw-semibold text-secondary">Nombres:</label>
                                            <input type="text" id="nombre" name="nombre" class="form-control" placeholder="Ej: Juan Carlos" required>
                                        </div>
                                        
                                        <!-- Apellidos -->
                                        <div class="col-md-6">
                                            <label for="apellido" class="form-label fw-semibold text-secondary">Apellidos:</label>
                                            <input type="text" id="apellido" name="apellido" class="form-control" placeholder="Ej: Pérez Silva" required>
                                        </div>

                                        <!-- Correo Institucional -->
                                        <div class="col-md-6">
                                            <label for="correo" class="form-label fw-semibold text-secondary">Correo Institucional:</label>
                                            <input type="email" id="correo" name="correo" class="form-control" placeholder="Ej: alumno@usil.edu.pe" required>
                                        </div>

                                        <!-- Contraseña inicial -->
                                        <div class="col-md-6">
                                            <label for="password" class="form-label fw-semibold text-secondary">Contraseña:</label>
                                            <input type="password" id="password" name="password" class="form-control" placeholder="Contraseña de acceso inicial" required>
                                        </div>

                                        <!-- Rol Select -->
                                        <div class="col-md-6">
                                            <label for="rol" class="form-label fw-semibold text-secondary">Rol del Sistema:</label>
                                            <select id="rol" name="rol" class="form-select" required>
                                                <option value="" disabled selected>-- Seleccione Rol --</option>
                                                <option value="ALUMNO">ALUMNO (Estudiante)</option>
                                                <option value="DOCENTE">DOCENTE (Profesor)</option>
                                            </select>
                                        </div>

                                        <!-- Código Alumno/Docente -->
                                        <div class="col-md-6">
                                            <label for="codigo" class="form-label fw-semibold text-secondary">Código del Usuario:</label>
                                            <input type="text" id="codigo" name="codigo" class="form-control" placeholder="Ej: U20261045 / D20210001" required>
                                        </div>
                                    </div>

                                    <!-- Form Buttons -->
                                    <div class="border-top pt-3 text-end">
                                        <a href="${pageContext.request.contextPath}/AdminUsuariosServlet?action=list" class="btn btn-outline-secondary fw-semibold px-4 py-2 me-2">Cancelar</a>
                                        <button type="submit" class="btn btn-primary fw-bold px-5 py-2">Registrar Usuario</button>
                                    </div>

                                </form>

                            </div>
                        </div>

                    </div>
                </div><!-- Fin Form Card -->

            </main>
        </div>
    </div>

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
