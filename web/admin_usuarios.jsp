<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Usuarios - ${configuracion.nombreInstitucion}</title>
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

        .badge-admin { background-color: #d1ecf1; color: #0c5460; }
        .badge-docente { background-color: #fff3cd; color: #856404; }
        .badge-alumno { background-color: #d4edda; color: #155724; }
        
        .badge-activo { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .badge-bloqueado { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        .btn-filter-custom {
            border-color: var(--primary-color);
            color: var(--primary-color);
        }

        .btn-filter-custom.active, .btn-filter-custom:hover {
            background-color: var(--primary-color) !important;
            border-color: var(--primary-color) !important;
            color: #ffffff !important;
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
                    <h1 class="h2 fw-bold text-dark m-0">Gestión de Cuentas de Acceso</h1>
                    <p class="text-muted m-0">Administración y control de accesos de alumnos y docentes</p>
                </div>
            </div>

            <!-- Alert Messages -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-4 shadow-sm" role="alert">
                    <i class="bi bi-check-circle-fill fs-5"></i>
                    <div>${param.success}</div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center gap-2 mb-4 shadow-sm" role="alert">
                    <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                    <div>${param.error}</div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Filtros e Interacción UI (Filtro por Rol en el Cliente) -->
            <div class="mb-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
                <div class="btn-group" role="group" aria-label="Filtro de Roles">
                    <button type="button" class="btn btn-outline-primary btn-filter-custom active filter-btn" data-role="TODOS">
                        <i class="bi bi-people-fill me-1"></i> Todos
                    </button>
                    <button type="button" class="btn btn-outline-primary btn-filter-custom filter-btn" data-role="ADMIN">
                        <i class="bi bi-shield-lock-fill me-1"></i> Admins
                    </button>
                    <button type="button" class="btn btn-outline-primary btn-filter-custom filter-btn" data-role="DOCENTE">
                        <i class="bi bi-person-video3 me-1"></i> Docentes
                    </button>
                    <button type="button" class="btn btn-outline-primary btn-filter-custom filter-btn" data-role="ALUMNO">
                        <i class="bi bi-mortarboard me-1"></i> Alumnos
                    </button>
                </div>
                
                <a href="${pageContext.request.contextPath}/AdminUsuariosServlet?action=form" class="btn btn-primary fw-bold d-flex align-items-center gap-2" style="background-color: var(--primary-color); border-color: var(--primary-color);">
                    <i class="bi bi-person-plus-fill"></i> Crear Nuevo Usuario
                </a>
            </div>

            <!-- Tabla de Usuarios -->
            <div class="card border-0 shadow-sm card-custom">
                <div class="card-header bg-white py-3 border-bottom d-flex align-items-center justify-content-between">
                    <h5 class="fw-bold text-dark m-0"><i class="bi bi-list-stars me-2 text-secondary"></i>Listado de Cuentas</h5>
                    <span class="text-muted small">Mostrando registros de base de datos</span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr class="text-uppercase text-secondary" style="font-size: 0.85rem;">
                                    <th class="ps-4">Código o Correo</th>
                                    <th>Nombre Completo</th>
                                    <th>Rol del Sistema</th>
                                    <th>Estado de Cuenta</th>
                                    <th class="text-center">Intentos Fallidos</th>
                                    <th class="text-center pe-4">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="u" items="${usuarios}">
                                    <tr class="user-row" data-role="${u.rolNombre}">
                                        <td class="ps-4">
                                            <span class="fw-bold text-dark d-block">${u.codigoOCorreo}</span>
                                            <small class="text-muted">ID: ${u.id}</small>
                                        </td>
                                        <td>
                                            <span class="fw-semibold text-secondary d-block">${u.nombreCompleto}</span>
                                            <small class="text-muted">Cod: ${u.codigoAlumnoODocente}</small>
                                        </td>
                                        <td>
                                            <span class="badge <c:choose><c:when test="${u.rolNombre eq 'ADMIN'}">badge-admin</c:when><c:when test="${u.rolNombre eq 'DOCENTE'}">badge-docente</c:when><c:otherwise>badge-alumno</c:otherwise></c:choose> px-2 py-1.5 fw-semibold">
                                                ${u.rolNombre}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge <c:choose><c:when test="${u.estado eq 'ACTIVO'}">badge-activo</c:when><c:otherwise>badge-bloqueado</c:otherwise></c:choose> px-2 py-1.5 fw-semibold">
                                                ${u.estado}
                                            </span>
                                        </td>
                                        <td class="text-center fw-bold">${u.intentosFallidos}</td>
                                        <td class="text-center pe-4">
                                            <div class="btn-group gap-1">
                                                <!-- Botón Editar -->
                                                <a href="${pageContext.request.contextPath}/AdminUsuariosServlet?action=edit&id=${u.id}" class="btn btn-outline-secondary btn-sm" title="Editar">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                
                                                <!-- Botón Bloquear / Desbloquear -->
                                                <c:choose>
                                                    <c:when test="${u.estado eq 'BLOQUEADO'}">
                                                        <a href="${pageContext.request.contextPath}/AdminUsuariosServlet?action=toggleStatus&id=${u.id}" class="btn btn-outline-success btn-sm d-flex align-items-center gap-1" title="Desbloquear">
                                                            <i class="bi bi-unlock"></i> Desbloquear
                                                        </a>
                                                    </c:when>
                                                        <c:otherwise>
                                                            <a href="${pageContext.request.contextPath}/AdminUsuariosServlet?action=toggleStatus&id=${u.id}" 
                                                               class="btn btn-outline-danger btn-sm ${u.rolNombre eq 'ADMIN' ? 'disabled' : ''}" 
                                                               title="Bloquear" 
                                                               style="${u.rolNombre eq 'ADMIN' ? 'pointer-events: none; opacity: 0.5;' : ''}">
                                                                <i class="bi bi-lock"></i> Bloquear
                                                            </a>
                                                        </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </main>
    </div>

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Script de Filtro Client-Side -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const buttons = document.querySelectorAll(".filter-btn");
            const rows = document.querySelectorAll(".user-row");

            buttons.forEach(btn => {
                btn.addEventListener("click", function() {
                    buttons.forEach(b => b.classList.remove("active"));
                    this.classList.add("active");

                    const selectedRole = this.getAttribute("data-role");

                    rows.forEach(row => {
                        const role = row.getAttribute("data-role");
                        if (selectedRole === "TODOS" || role === selectedRole) {
                            row.style.display = "";
                        } else {
                            row.style.display = "none";
                        }
                    });
                });
            });
        });
    </script>
</body>
</html>
