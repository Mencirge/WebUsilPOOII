<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Docente - ${configuracion.nombreInstitucion}</title>
    <!-- Bootstrap 5 CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    
    <!-- Estilos Dinámicos (Inyección de Marca Blanca via EL) -->
    <style>
        :root {
            --primary-color: ${configuracion.colorPrincipalHex};
        }
        
        .navbar-custom {
            background-color: var(--primary-color) !important;
        }
        
        .card-custom {
            border: none;
            border-top: 5px solid var(--primary-color);
            transition: transform 0.2s, box-shadow 0.2s;
        }
        
        .card-custom:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important;
        }
        
        .btn-custom {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: #ffffff;
        }
        
        .btn-custom:hover {
            opacity: 0.9;
            color: #ffffff;
        }
    </style>
</head>
<body class="bg-light">

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom shadow-sm py-3">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center gap-2" href="#">
                <img src="${pageContext.request.contextPath}/${configuracion.logoUrl}" alt="Logo" width="40" height="40" class="rounded bg-white p-1" onerror="this.src='https://upload.wikimedia.org/wikipedia/commons/e/ec/USIL_logo.png';">
                <span class="fw-bold">${configuracion.nombreInstitucion}</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                <div class="navbar-nav align-items-center gap-3">
                    <div class="text-white text-end d-none d-md-block">
                        <small class="d-block text-white-50">Bienvenido(a), Docente</small>
                        <span class="fw-semibold">${docente.nombreCompleto}</span>
                    </div>
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
                <div class="d-flex align-items-center justify-content-between mb-5 border-bottom pb-3">
                    <div>
                        <h2 class="text-dark fw-bold m-0">Portal del Docente</h2>
                        <p class="text-muted m-0">Seleccione una de las asignaturas a su cargo para gestionar calificaciones</p>
                    </div>
                    <span class="badge bg-secondary px-3 py-2">Ciclo Académico 2026-01</span>
                </div>

                <!-- Alert Messages -->
                <c:if test="${param.success eq 'true'}">
                    <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-4 shadow-sm" role="alert">
                        <i class="bi bi-check-circle-fill fs-5"></i>
                        <div><strong>¡Éxito!</strong> Las notas fueron procesadas y actualizadas correctamente de acuerdo a la estrategia de evaluación.</div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Cards Grid -->
                <h4 class="fw-bold mb-4 text-secondary">Asignaturas Asignadas</h4>
                
                <div class="row g-4">
                    <c:forEach var="curso" items="${cursos}">
                        <div class="col-md-6 col-lg-4">
                            <div class="card h-100 shadow-sm card-custom p-3">
                                <div class="card-body d-flex flex-column">
                                    <div class="d-flex align-items-center gap-2 mb-3">
                                        <i class="bi bi-journal-bookmark-fill text-secondary fs-3"></i>
                                        <div>
                                            <span class="badge bg-secondary-subtle text-secondary fw-bold">${curso.codigo}</span>
                                        </div>
                                    </div>
                                    <h5 class="card-title fw-bold text-dark mb-2">${curso.nombre}</h5>
                                    <p class="card-text text-muted mb-4">Créditos de asignatura: ${curso.creditos}</p>
                                    
                                    <div class="mt-auto">
                                        <a href="${pageContext.request.contextPath}/CargarAlumnosServlet?cursoId=${curso.id}" class="btn btn-custom w-100 fw-bold py-2 d-flex align-items-center justify-content-center gap-2">
                                            <i class="bi bi-pencil-square"></i> Ingresar Calificaciones
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div><!-- End Cards Grid -->
                
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 Bundle JS with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
