<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:choose><c:when test="${not empty userEdit}">Editar Usuario</c:when><c:otherwise>Crear Usuario</c:otherwise></c:choose> - ${configuracion.nombreInstitucion}</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    
    <style>
        :root {
            --primary-color: ${configuracion.colorPrincipalHex};
            --hover-color: rgba(255, 255, 255, 0.15);
        }
        
        body {
            background-color: #f8f9fa;
            overflow-x: hidden;
        }

        .wrapper {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar Styling */
        .sidebar {
            width: 280px;
            background-color: var(--primary-color);
            color: #ffffff;
            flex-shrink: 0;
            display: flex;
            flex-direction: column;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
            transition: all 0.3s;
        }

        .sidebar-header {
            padding: 2rem 1.5rem 1rem 1.5rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.15);
            text-align: center;
        }

        .sidebar-brand-img {
            width: 70px;
            height: 70px;
            object-fit: contain;
            border-radius: 50%;
            background-color: #ffffff;
            padding: 5px;
            margin-bottom: 1rem;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }

        .sidebar-user-fullname {
            font-size: 0.95rem;
            font-weight: 600;
            margin-top: 0.5rem;
            color: #ffffff;
        }

        .sidebar-user-role {
            font-size: 0.75rem;
            color: rgba(255, 255, 255, 0.7);
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .sidebar-nav {
            padding: 1.5rem 0;
            flex-grow: 1;
        }

        .sidebar-link {
            display: flex;
            align-items: center;
            padding: 0.8rem 1.5rem;
            color: rgba(255, 255, 255, 0.85);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s;
            border-left: 4px solid transparent;
        }

        .sidebar-link i {
            font-size: 1.2rem;
            margin-right: 0.8rem;
        }

        .sidebar-link:hover, .sidebar-link.active {
            color: #ffffff;
            background-color: var(--hover-color);
            border-left-color: #ffffff;
        }

        .sidebar-footer {
            padding: 1.5rem;
            border-top: 1px solid rgba(255, 255, 255, 0.15);
        }

        /* Main Content */
        .main-content {
            flex-grow: 1;
            padding: 2.5rem;
            overflow-y: auto;
        }

        .card-custom {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        .card-header-custom {
            background-color: #f8f9fa;
            border-left: 5px solid var(--primary-color);
        }
    </style>
</head>
<body>

    <div class="wrapper">
        
        <!-- Sidebar -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <img src="${pageContext.request.contextPath}/imagenes/usil_logo.png" alt="Logo" class="sidebar-brand-img" onerror="this.src='https://upload.wikimedia.org/wikipedia/commons/e/ec/USIL_logo.png';">
                <h5 class="fw-bold text-white mb-1 m-0" style="font-size: 1.1rem;">${configuracion.nombreInstitucion}</h5>
                <div class="sidebar-user-fullname">Administrador</div>
                <div class="sidebar-user-role">Soporte Técnico / USIL</div>
            </div>
            
            <div class="sidebar-nav">
                <a href="${pageContext.request.contextPath}/AdminDashboardServlet" class="sidebar-link">
                    <i class="bi bi-speedometer2"></i> Dashboard
                </a>
                
                <a href="${pageContext.request.contextPath}/AdminUsuariosServlet?action=list" class="sidebar-link active">
                    <i class="bi bi-people-fill"></i> Gestionar Usuarios
                </a>
                
                <a href="${pageContext.request.contextPath}/AdminDashboardServlet?tab=profile" class="sidebar-link">
                    <i class="bi bi-person-fill-gear"></i> Mi Perfil
                </a>
            </div>
            
            <div class="sidebar-footer">
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-outline-light btn-sm w-100 fw-semibold">
                    <i class="bi bi-box-arrow-right"></i> Cerrar Sesión
                </a>
            </div>
        </nav>

        <!-- Main Content Area -->
        <main class="main-content">
            
            <!-- Navbar Superior -->
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-4 border-bottom">
                <div>
                    <h1 class="h2 fw-bold text-dark m-0">
                        <c:choose>
                            <c:when test="${not empty userEdit}">Modificar Cuenta de Usuario</c:when>
                            <c:otherwise>Registrar Nuevo Usuario</c:otherwise>
                        </c:choose>
                    </h1>
                    <p class="text-muted m-0">Administración de datos y credenciales de acceso</p>
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
                <div class="col-lg-10">
                    
                    <div class="card border-0 shadow-sm card-custom">
                        <div class="card-header card-header-custom py-3">
                            <h5 class="fw-bold text-dark m-0">
                                <i class="bi bi-person-fill-gear me-2 text-secondary"></i>Datos del Formulario
                            </h5>
                        </div>
                        <div class="card-body p-4">
                            
                            <form action="${pageContext.request.contextPath}/AdminUsuariosServlet" method="POST">
                                
                                <!-- ID oculto si es modo edición -->
                                <c:if test="${not empty userEdit}">
                                    <input type="hidden" name="id" value="${userEdit.id}">
                                </c:if>
                                
                                <div class="row g-3 mb-4">
                                    <!-- Nombres -->
                                    <div class="col-md-6">
                                        <label for="nombre" class="form-label fw-semibold text-secondary">Nombres:</label>
                                        <input type="text" id="nombre" name="nombre" class="form-control" value="${nombre}" placeholder="Ej: Juan Carlos" required>
                                    </div>
                                    
                                    <!-- Apellidos -->
                                    <div class="col-md-6">
                                        <label for="apellido" class="form-label fw-semibold text-secondary">Apellidos:</label>
                                        <input type="text" id="apellido" name="apellido" class="form-control" value="${apellido}" placeholder="Ej: Pérez Silva" required>
                                    </div>

                                    <!-- Correo Institucional -->
                                    <div class="col-md-6">
                                        <label for="correo" class="form-label fw-semibold text-secondary">Correo Institucional (Acceso):</label>
                                        <input type="email" id="correo" name="correo" class="form-control" value="${userEdit.codigoOCorreo}" placeholder="Ej: alumno@usil.edu.pe" required>
                                    </div>

                                    <!-- Contraseña -->
                                    <div class="col-md-6">
                                        <label for="password" class="form-label fw-semibold text-secondary">Contraseña:</label>
                                        <input type="password" id="password" name="password" class="form-control" value="${userEdit.password}" placeholder="Clave de acceso" required>
                                    </div>

                                    <!-- Rol Select -->
                                    <div class="col-md-6">
                                        <label for="rol" class="form-label fw-semibold text-secondary">Rol del Sistema:</label>
                                        <select id="rol" name="rol" class="form-select" required>
                                            <option value="" disabled <c:if test="${empty userEdit}">selected</c:if>>-- Seleccione Rol --</option>
                                            <option value="ALUMNO" <c:if test="${userEdit.rolNombre eq 'ALUMNO'}">selected</c:if>>ALUMNO (Estudiante)</option>
                                            <option value="DOCENTE" <c:if test="${userEdit.rolNombre eq 'DOCENTE'}">selected</c:if>>DOCENTE (Profesor)</option>
                                        </select>
                                    </div>

                                    <!-- Código Alumno/Docente -->
                                    <div class="col-md-6">
                                        <label for="codigo" class="form-label fw-semibold text-secondary">Código del Usuario:</label>
                                        <input type="text" id="codigo" name="codigo" class="form-control" value="${codigo}" placeholder="Ej: U20261045 / D20210001" required>
                                    </div>
                                </div>

                                <!-- Form Buttons -->
                                <div class="border-top pt-3 text-end">
                                    <a href="${pageContext.request.contextPath}/AdminUsuariosServlet?action=list" class="btn btn-outline-secondary fw-semibold px-4 py-2 me-2">Cancelar</a>
                                    <button type="submit" class="btn btn-primary fw-bold px-5 py-2" style="background-color: var(--primary-color); border-color: var(--primary-color);">
                                        <c:choose>
                                            <c:when test="${not empty userEdit}">Guardar Cambios</c:when>
                                            <c:otherwise>Registrar Usuario</c:otherwise>
                                        </c:choose>
                                    </button>
                                </div>

                            </form>

                        </div>
                    </div>

                </div>
            </div>

        </main>
    </div>

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
