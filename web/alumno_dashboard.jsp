<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Intranet Alumno - ${configuracion.nombreInstitucion}</title>
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

        /* Sidebar Accordion overrides */
        .sidebar-accordion .accordion-button {
            color: rgba(255, 255, 255, 0.85);
            padding: 0.8rem 1.5rem;
            font-weight: 500;
        }

        .sidebar-accordion .accordion-button::after {
            filter: invert(1);
        }

        .sidebar-accordion .accordion-button:not(.collapsed) {
            background-color: var(--hover-color);
            color: #ffffff;
            box-shadow: none;
        }

        .sidebar-accordion-body {
            background-color: rgba(0, 0, 0, 0.1);
            padding: 0.5rem 0;
        }

        .sidebar-accordion-link {
            display: block;
            padding: 0.5rem 2rem 0.5rem 3.5rem;
            color: rgba(255, 255, 255, 0.75);
            text-decoration: none;
            font-size: 0.85rem;
            transition: color 0.2s;
        }

        .sidebar-accordion-link:hover {
            color: #ffffff;
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
<body>

    <div class="wrapper">
        
        <!-- Sidebar -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <img src="${pageContext.request.contextPath}/imagenes/usil_logo.png" alt="Logo" class="sidebar-brand-img" onerror="this.src='https://upload.wikimedia.org/wikipedia/commons/e/ec/USIL_logo.png';">
                <h5 class="fw-bold text-white mb-1 m-0" style="font-size: 1.1rem;">${configuracion.nombreInstitucion}</h5>
                <div class="sidebar-user-fullname">${alumno.nombre} ${alumno.apellido}</div>
                <div class="sidebar-user-role">Alumno / Cod: ${alumno.codigoAlumno}</div>
            </div>
            
            <div class="sidebar-nav">
                <!-- Accordion de Cursos -->
                <div class="accordion accordion-flush sidebar-accordion" id="sidebarAccordion">
                    <div class="accordion-item bg-transparent border-0">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed bg-transparent border-0 text-white shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#collapseCursos" aria-expanded="false" aria-controls="collapseCursos">
                                <i class="bi bi-journal-bookmark-fill me-2"></i> Mis Cursos
                            </button>
                        </h2>
                        <div id="collapseCursos" class="accordion-collapse collapse" data-bs-parent="#sidebarAccordion">
                            <div class="sidebar-accordion-body">
                                <c:forEach var="nota" items="${notas}">
                                    <a href="#" class="sidebar-accordion-link" onclick="activateTab('grades-tab')">
                                        <i class="bi bi-book me-1"></i> ${nota.cursoCodigo} - ${nota.cursoNombre}
                                    </a>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tabs de navegación vinculados al Sidebar -->
                <a href="#" class="sidebar-link active" id="nav-grades" onclick="activateTab('grades-tab')">
                    <i class="bi bi-grid-3x3-gap-fill"></i> Calificaciones
                </a>
                
                <a href="#" class="sidebar-link" id="nav-profile" onclick="activateTab('profile-tab')">
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

            <!-- Contenido dinámico mediante tabs invisibles de Bootstrap -->
            <div class="tab-content" id="alumnoTabContent">
                
                <!-- Tab Calificaciones (Por Defecto) -->
                <div class="tab-pane fade show active" id="grades-pane" role="tabpanel">
                    
                    <div class="d-flex align-items-center justify-content-between mb-4 border-bottom pb-2">
                        <div>
                            <h2 class="fw-bold text-dark m-0">Calificaciones Académicas</h2>
                            <p class="text-muted m-0">Ficha oficial de notas por asignaturas registradas</p>
                        </div>
                        <span class="badge bg-secondary px-3 py-2 text-uppercase">Semestre 2026-1</span>
                    </div>

                    <!-- Ficha de Notas -->
                    <div class="card card-custom">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr class="text-uppercase text-secondary" style="font-size: 0.85rem;">
                                            <th class="ps-4">Curso</th>
                                            <th class="text-center">Créditos</th>
                                            <th class="text-center">PC1</th>
                                            <th class="text-center">PC2</th>
                                            <th class="text-center">PC3</th>
                                            <th class="text-center">EP</th>
                                            <th class="text-center">EF</th>
                                            <th class="text-center">Promedio</th>
                                            <th class="text-center pe-4">Estado</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="nota" items="${notas}">
                                            <tr>
                                                <td class="ps-4">
                                                    <span class="fw-bold text-dark d-block">${nota.cursoNombre}</span>
                                                    <small class="text-muted">Código: ${nota.cursoCodigo}</small>
                                                </td>
                                                <td class="text-center fw-semibold">${nota.creditos}</td>
                                                <td class="text-center">${nota.pc1}</td>
                                                <td class="text-center">${nota.pc2}</td>
                                                <td class="text-center">${nota.pc3}</td>
                                                <td class="text-center">${nota.examenParcial}</td>
                                                <td class="text-center">${nota.examenFinal}</td>
                                                <td class="text-center fw-bold text-primary">${nota.promedioFinal}</td>
                                                <td class="text-center pe-4">
                                                    <span class="badge ${nota.promedioFinal >= 10.5 ? 'badge-aprobado' : 'badge-desaprobado'} px-2.5 py-1.5 fw-semibold">
                                                        ${nota.promedioFinal >= 10.5 ? 'APROBADO' : 'DESAPROBADO'}
                                                    </span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                </div><!-- Fin Tab Calificaciones -->

                <!-- Tab Mi Perfil -->
                <div class="tab-pane fade" id="profile-pane" role="tabpanel">
                    
                    <div class="d-flex align-items-center justify-content-between mb-4 border-bottom pb-2">
                        <div>
                            <h2 class="fw-bold text-dark m-0">Mi Perfil Personal</h2>
                            <p class="text-muted m-0">Gestiona y actualiza tus datos de contacto</p>
                        </div>
                    </div>

                    <div class="row g-4">
                        <!-- Perfil Ficha -->
                        <div class="col-lg-4">
                            <div class="card card-custom text-center p-4">
                                <div class="mb-3 position-relative d-inline-block mx-auto">
                                    <i class="bi bi-person-circle text-secondary" style="font-size: 5rem;"></i>
                                </div>
                                <h5 class="fw-bold text-dark mb-1">${alumno.nombre} ${alumno.apellido}</h5>
                                <p class="text-muted small mb-3">${usuarioPerfil.codigoOCorreo}</p>
                                <span class="badge bg-secondary mb-4 px-3 py-1.5 text-uppercase" style="font-size: 0.75rem;">Carrera: ${alumno.carrera}</span>
                                
                                <div class="border-top pt-3 text-start">
                                    <small class="text-muted d-block mb-1"><i class="bi bi-shield-check me-1"></i> Estado Cuenta:</small>
                                    <span class="fw-semibold text-success"><i class="bi bi-patch-check-fill"></i> Activa</span>
                                </div>
                            </div>
                        </div>

                        <!-- Edición de Contacto -->
                        <div class="col-lg-8">
                            <div class="card card-custom p-4">
                                <h5 class="fw-bold text-dark mb-4 border-bottom pb-2"><i class="bi bi-pencil-square me-2 text-secondary"></i>Actualizar Datos de Contacto</h5>
                                
                                <form action="${pageContext.request.contextPath}/controller/ActualizarContactoServlet" method="POST">
                                    
                                    <div class="row g-3 mb-4">
                                        <div class="col-md-6">
                                            <label for="correo_personal" class="form-label fw-semibold text-secondary">Correo Personal:</label>
                                            <div class="input-group">
                                                <span class="input-group-text"><i class="bi bi-envelope-fill"></i></span>
                                                <input type="email" id="correo_personal" name="correo_personal" class="form-control" value="${usuarioPerfil.correoPersonal}" placeholder="ejemplo@correo.com" required>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-6">
                                            <label for="telefono" class="form-label fw-semibold text-secondary">Teléfono de Contacto:</label>
                                            <div class="input-group">
                                                <span class="input-group-text"><i class="bi bi-telephone-fill"></i></span>
                                                <input type="text" id="telefono" name="telefono" class="form-control" value="${usuarioPerfil.telefono}" placeholder="Ej: 987654321" required>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="d-flex justify-content-between align-items-center border-top pt-3">
                                        <!-- Botón de Lanzamiento de Modal de Seguridad -->
                                        <button type="button" class="btn btn-warning fw-bold text-dark" data-bs-toggle="modal" data-bs-target="#changePasswordModal">
                                            <i class="bi bi-shield-lock-fill me-1"></i> Cambiar Contraseña
                                        </button>
                                        
                                        <button type="submit" class="btn btn-primary btn-primary-custom fw-bold px-4">
                                            Guardar Cambios
                                        </button>
                                    </div>

                                </form>
                            </div>
                        </div>
                    </div>

                </div><!-- Fin Tab Perfil -->

            </div>
        </main>
    </div>

    <!-- ========================================================================= -->
    -- MODAL INTERACTIVO DE CAMBIO DE CONTRASEÑA
    <!-- ========================================================================= -->
    <div class="modal fade" id="changePasswordModal" tabindex="-1" aria-labelledby="changePasswordModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header bg-warning text-dark py-3">
                    <h5 class="modal-title fw-bold" id="changePasswordModalLabel">
                        <i class="bi bi-shield-lock-fill me-2"></i> Cambiar Contraseña de Acceso
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/CambiarPasswordServlet" method="POST">
                    <div class="modal-body p-4">
                        
                        <div class="alert alert-light border d-flex gap-2 align-items-center mb-4 py-2.5">
                            <i class="bi bi-info-circle-fill text-warning fs-4"></i>
                            <div class="small">Tu nueva contraseña debe tener un mínimo de <strong>6 caracteres</strong> por motivos de seguridad institucional.</div>
                        </div>

                        <!-- Contraseña Actual -->
                        <div class="mb-3">
                            <label for="modal_password_actual" class="form-label fw-semibold text-secondary">Contraseña Actual:</label>
                            <input type="password" id="modal_password_actual" name="password_actual" class="form-control" placeholder="Ingresa tu clave actual" required>
                        </div>

                        <!-- Nueva Contraseña -->
                        <div class="mb-3">
                            <label for="modal_nueva_password" class="form-label fw-semibold text-secondary">Nueva Contraseña:</label>
                            <input type="password" id="modal_nueva_password" name="nueva_password" class="form-control" placeholder="Mínimo 6 caracteres" minlength="6" required>
                        </div>

                        <!-- Confirmar Nueva Contraseña -->
                        <div class="mb-3">
                            <label for="modal_confirmacion" class="form-label fw-semibold text-secondary">Confirmar Nueva Contraseña:</label>
                            <input type="password" id="modal_confirmacion" name="confirmacion" class="form-control" placeholder="Repite tu nueva clave" minlength="6" required>
                        </div>

                    </div>
                    <div class="modal-footer bg-light border-top-0 py-3">
                        <button type="button" class="btn btn-outline-secondary fw-semibold" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-warning fw-bold text-dark px-4">Actualizar Clave</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Tab Activation Script -->
    <script>
        function activateTab(tabId) {
            // Desactivar todos los links del Sidebar
            document.getElementById('nav-grades').classList.remove('active');
            document.getElementById('nav-profile').classList.remove('active');

            // Ocultar todos los tab panes
            document.getElementById('grades-pane').classList.remove('show', 'active');
            document.getElementById('profile-pane').classList.remove('show', 'active');

            if (tabId === 'grades-tab') {
                document.getElementById('nav-grades').classList.add('active');
                document.getElementById('grades-pane').classList.add('show', 'active');
            } else if (tabId === 'profile-tab') {
                document.getElementById('nav-profile').classList.add('active');
                document.getElementById('profile-pane').classList.add('show', 'active');
            }
        }
    </script>
</body>
</html>
