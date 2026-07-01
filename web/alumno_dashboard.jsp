<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Intranet - ${configuracion.nombreInstitucion}</title>
    <!-- Bootstrap 5 CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    
    <!-- Estilos Dinámicos (Inyección de Marca Blanca via EL) -->
    <style>
        :root {
            --primary-color: ${configuracion.colorPrincipalHex};
            --hover-color: #1251bc;
        }
        
        .navbar-custom {
            background-color: var(--primary-color) !important;
        }
        
        .nav-link-custom {
            color: #ffffff !important;
        }
        
        .nav-link-custom:hover {
            opacity: 0.9;
        }
        
        .nav-tabs .nav-link.active {
            border-bottom: 3px solid var(--primary-color) !important;
            color: var(--primary-color) !important;
            font-weight: bold;
        }
        
        .nav-tabs .nav-link {
            color: #6c757d;
        }
        
        .card-header-custom {
            background-color: #f8f9fa;
            border-left: 5px solid var(--primary-color);
        }
        
        .badge-aprobado {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .badge-desaprobado {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body class="bg-light">

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom shadow-sm py-3">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center gap-2" href="#">
                <!-- Logo dinámico con fallback local en caso no exista la URL de marca blanca -->
                <img src="${pageContext.request.contextPath}/${configuracion.logoUrl}" alt="Logo" width="40" height="40" class="rounded bg-white p-1" onerror="this.src='https://upload.wikimedia.org/wikipedia/commons/e/ec/USIL_logo.png';">
                <span class="fw-bold">${configuracion.nombreInstitucion}</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                <div class="navbar-nav align-items-center gap-3">
                    <div class="text-white text-end d-none d-md-block">
                        <small class="d-block text-white-50">Bienvenido(a), Estudiante</small>
                        <span class="fw-semibold">${alumno.nombre} ${alumno.apellido}</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/CambiarPasswordServlet" class="btn btn-outline-light btn-sm d-flex align-items-center gap-1 me-2">
                        <i class="bi bi-key-fill"></i> Cambiar Clave
                    </a>
                    <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-outline-light btn-sm d-flex align-items-center gap-1">
                        <i class="bi bi-box-arrow-right"></i> Salir
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container my-5">
        <div class="row">
            <div class="col-12">
                
                <!-- Page Title -->
                <div class="d-flex align-items-center justify-content-between mb-4 border-bottom pb-3">
                    <div>
                        <h2 class="text-dark fw-bold m-0">Portal del Estudiante</h2>
                        <p class="text-muted m-0">Acceso a su información académica y calificaciones</p>
                    </div>
                    <span class="badge bg-secondary px-3 py-2 fs-7">Semestre 2026-01</span>
                </div>

                <!-- Navigation Tabs (Bootstrap 5) -->
                <ul class="nav nav-tabs mb-4" id="alumnoTab" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active py-3 px-4" id="perfil-tab" data-bs-toggle="tab" data-bs-target="#perfil" type="button" role="tab" aria-controls="perfil" aria-selected="true">
                            <i class="bi bi-person-circle me-2"></i>Mi Perfil
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link py-3 px-4" id="notas-tab" data-bs-toggle="tab" data-bs-target="#notas" type="button" role="tab" aria-controls="notas" aria-selected="false">
                            <i class="bi bi-file-earmark-spreadsheet me-2"></i>Mis Calificaciones
                        </button>
                    </li>
                </ul>

                <!-- Tab Content -->
                <div class="tab-content" id="alumnoTabContent">
                    
                    <!-- TAB 1: MI PERFIL -->
                    <div class="tab-pane fade show active" id="perfil" role="tablist" aria-labelledby="perfil-tab">
                        <div class="row g-4">
                            <!-- Datos Personales -->
                            <div class="col-md-4">
                                <div class="card border-0 shadow-sm text-center p-4">
                                    <div class="mb-3">
                                        <i class="bi bi-person-bounding-box text-secondary" style="font-size: 6rem;"></i>
                                    </div>
                                    <h4 class="fw-bold mb-1">${alumno.nombre} ${alumno.apellido}</h4>
                                    <p class="text-muted mb-3">${alumno.codigoAlumno}</p>
                                    <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-2 rounded-pill">ESTUDIANTE ACTIVO</span>
                                </div>
                            </div>
                            
                            <!-- Detalle Académico -->
                            <div class="col-md-8">
                                <div class="card border-0 shadow-sm h-100">
                                    <div class="card-header card-header-custom py-3">
                                        <h5 class="fw-bold text-dark m-0">Ficha Informativa del Alumno</h5>
                                    </div>
                                    <div class="card-body p-4">
                                        <div class="row g-3">
                                            <div class="col-sm-6">
                                                <small class="text-muted d-block">Carrera Profesional</small>
                                                <span class="fs-5 fw-semibold text-dark">${alumno.carrera}</span>
                                            </div>
                                            <div class="col-sm-6">
                                                <small class="text-muted d-block">Ciclo de Estudios</small>
                                                <span class="fs-5 fw-semibold text-dark">${alumno.ciclo}° Ciclo</span>
                                            </div>
                                            <div class="col-sm-6 border-top pt-3">
                                                <small class="text-muted d-block">Correo Académico</small>
                                                <span class="fw-semibold text-dark">${usuarioPerfil.codigoOCorreo}</span>
                                            </div>
                                                <div class="col-sm-6 border-top pt-3">
                                                    <small class="text-muted d-block">Correo Personal</small>
                                                    <span class="fw-semibold text-dark">
                                                        <c:choose>
                                                            <c:when test="${not empty usuarioPerfil.correoPersonal}">
                                                                ${usuarioPerfil.correoPersonal}
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted"><i>No registrado</i></span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </div>
                                            <div class="col-sm-6 border-top pt-3">
                                                <small class="text-muted d-block">Teléfono / Celular</small>
                                                <span class="fw-semibold text-dark">
                                                    <c:choose>
                                                        <c:when test="${not empty usuarioPerfil.telefono}">
                                                            ${usuarioPerfil.telefono}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted"><i>No registrado</i></span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- TAB 2: CALIFICACIONES -->
                    <div class="tab-pane fade" id="notas" role="tabpanel" aria-labelledby="notas-tab">
                        <div class="card border-0 shadow-sm">
                            <div class="card-header card-header-custom py-3">
                                <h5 class="fw-bold text-dark m-0">Calificaciones Obtenidas</h5>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th class="ps-4" style="width: 35%;">Curso / Asignatura</th>
                                                <th class="text-center">Créditos</th>
                                                <th class="text-center">PC1</th>
                                                <th class="text-center">PC2</th>
                                                <th class="text-center">PC3</th>
                                                <th class="text-center">Ex. Parcial</th>
                                                <th class="text-center">Ex. Final</th>
                                                <th class="text-center pe-4" style="width: 15%;">Promedio Final</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <!-- Iteración Dinámica con JSTL Core -->
                                            <c:forEach var="nota" items="${notas}">
                                                <tr>
                                                    <td class="ps-4">
                                                        <span class="fw-bold text-dark d-block">${nota.cursoNombre}</span>
                                                        <small class="text-muted">${nota.cursoCodigo}</small>
                                                    </td>
                                                    <td class="text-center fw-semibold">${nota.creditos}</td>
                                                    <td class="text-center">${nota.pc1}</td>
                                                    <td class="text-center">${nota.pc2}</td>
                                                    <td class="text-center">${nota.pc3}</td>
                                                    <td class="text-center">${nota.examenParcial}</td>
                                                    <td class="text-center">${nota.examenFinal}</td>
                                                    <td class="text-center pe-4">
                                                        <c:choose>
                                                            <c:when test="${nota.promedioFinal >= 11.5}">
                                                                <span class="badge badge-aprobado px-3 py-2 rounded fw-bold fs-6">
                                                                    ${nota.promedioFinal}
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge-desaprobado px-3 py-2 rounded fw-bold fs-6">
                                                                    ${nota.promedioFinal}
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                </div><!-- End Tab Content -->
                
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 Bundle JS with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
