<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Usuarios - ${configuracion.nombreInstitucion}</title>
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
        
        .badge-admin { background-color: #d1ecf1; color: #0c5460; }
        .badge-docente { background-color: #fff3cd; color: #856404; }
        .badge-alumno { background-color: #d4edda; color: #155724; }
        
        .badge-activo { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .badge-bloqueado { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
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
                        <h1 class="h2 fw-bold text-dark m-0">Gestión de Cuentas de Acceso</h1>
                        <p class="text-muted m-0">Administración y control de accesos de alumnos y docentes</p>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/AdminUsuariosServlet?action=form" class="btn btn-primary fw-bold d-flex align-items-center gap-2">
                            <i class="bi bi-person-plus-fill"></i> Crear Nuevo Usuario
                        </a>
                    </div>
                </div>

                <!-- Alert Messages -->
                <c:if test="${param.success eq 'true'}">
                    <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-4 shadow-sm" role="alert">
                        <i class="bi bi-check-circle-fill fs-5"></i>
                        <div><strong>¡Éxito!</strong> El usuario ha sido registrado y preconfigurado correctamente en el sistema.</div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Users Table -->
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3 border-bottom d-flex align-items-center justify-content-between">
                        <h5 class="fw-bold text-dark m-0"><i class="bi bi-list-stars me-2 text-secondary"></i>Listado de Cuentas</h5>
                        <span class="text-muted small">Mostrando todos los registros en base de datos</span>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
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
                                        <tr>
                                            <td class="ps-4">
                                                <span class="fw-bold text-dark d-block">${u.codigoOCorreo}</span>
                                                <small class="text-muted">ID: ${u.id}</small>
                                            </td>
                                            <td>
                                                <span class="fw-semibold text-secondary d-block">${u.nombreCompleto}</span>
                                                <small class="text-muted">Cod: ${u.codigoAlumnoODocente}</small>
                                            </td>
                                            <td>
                                                <span class="badge badge-custom <c:choose><c:when test="${u.rolNombre eq 'ADMIN'}">badge-admin</c:when><c:when test="${u.rolNombre eq 'DOCENTE'}">badge-docente</c:when><c:otherwise>badge-alumno</c:otherwise></c:choose>">
                                                    ${u.rolNombre}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge <c:choose><c:when test="${u.estado eq 'ACTIVO'}">badge-activo</c:when><c:otherwise>badge-bloqueado</c:otherwise></c:choose>">
                                                    ${u.estado}
                                                </span>
                                            </td>
                                            <td class="text-center fw-bold">${u.intentosFallidos}</td>
                                            <td class="text-center pe-4">
                                                <div class="btn-group gap-1">
                                                    <button type="button" class="btn btn-outline-secondary btn-sm" title="Editar">
                                                        <i class="bi bi-pencil"></i>
                                                    </button>
                                                    <c:choose>
                                                        <c:when test="${u.estado eq 'BLOQUEADO'}">
                                                            <button type="button" class="btn btn-outline-success btn-sm" title="Desbloquear">
                                                                <i class="bi bi-unlock"></i> Desbloquear
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button type="button" class="btn btn-outline-danger btn-sm" title="Bloquear" <c:if test="${u.rolNombre eq 'ADMIN'}">disabled</c:if>>
                                                                <i class="bi bi-lock"></i>
                                                            </button>
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
                </div><!-- Fin Table Card -->

            </main>
        </div>
    </div>

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
