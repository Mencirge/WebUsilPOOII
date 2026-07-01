<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calificaciones - ${configuracion.nombreInstitucion}</title>
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

        .sidebar-accordion-link:hover, .sidebar-accordion-link.active {
            color: #ffffff;
            background-color: rgba(255, 255, 255, 0.1);
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

        .btn-save {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: #ffffff;
            font-weight: bold;
        }

        .btn-save:hover {
            opacity: 0.9;
            color: #ffffff;
        }

        .grade-input {
            width: 70px;
            padding: 5px;
            text-align: center;
            font-weight: bold;
        }

        .promedio-celda {
            font-weight: bold;
            font-size: 1.05rem;
            text-align: center;
        }

        .aprobado {
            color: #198754;
        }

        .desaprobado {
            color: #dc3545;
        }
    </style>
</head>
<body>

    <div class="wrapper">
        
        <!-- Sidebar -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <img src="${pageContext.request.contextPath}/${configuracion.logoUrl}" alt="Logo" class="sidebar-brand-img" onerror="this.src='https://upload.wikimedia.org/wikipedia/commons/e/ec/USIL_logo.png';">
                <h5 class="fw-bold text-white mb-1 m-0" style="font-size: 1.1rem;">${configuracion.nombreInstitucion}</h5>
                <div class="sidebar-user-fullname">${docente.nombreCompleto}</div>
                <div class="sidebar-user-role">Docente / Cod: ${docente.codigoAlumnoODocente}</div>
            </div>
            
            <div class="sidebar-nav">
                <!-- Accordion de Cursos -->
                <div class="accordion accordion-flush sidebar-accordion" id="sidebarAccordion">
                    <div class="accordion-item bg-transparent border-0">
                        <h2 class="accordion-header">
                            <button class="accordion-button bg-transparent border-0 text-white shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#collapseCursos" aria-expanded="true" aria-controls="collapseCursos">
                                <i class="bi bi-journal-bookmark-fill me-2"></i> Mis Clases
                            </button>
                        </h2>
                        <div id="collapseCursos" class="accordion-collapse collapse show" data-bs-parent="#sidebarAccordion">
                            <div class="sidebar-accordion-body">
                                <c:forEach var="c" items="${cursos}">
                                    <a href="${pageContext.request.contextPath}/CargarAlumnosServlet?cursoId=${c.id}" class="sidebar-accordion-link <c:if test='${c.id == curso.id}'>active</c:if>'>
                                        <i class="bi bi-pencil-square me-1"></i> ${c.codigo}
                                    </a>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>

                <a href="${pageContext.request.contextPath}/DashboardDocenteServlet" class="sidebar-link">
                    <i class="bi bi-grid-3x3-gap-fill"></i> Mis Cursos
                </a>
                
                <a href="${pageContext.request.contextPath}/DashboardDocenteServlet?tab=profile" class="sidebar-link">
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
            
            <div class="container-fluid p-0">
                
                <!-- Title Header -->
                <div class="card border-0 shadow-sm mb-4 card-custom" style="border-top: 5px solid var(--primary-color);">
                    <div class="card-body p-4 d-flex align-items-center justify-content-between flex-wrap gap-3">
                        <div>
                            <span class="badge bg-secondary mb-2">${curso.codigo}</span>
                            <h3 class="fw-bold text-dark m-0">${curso.nombre}</h3>
                            <p class="text-muted m-0">Registro y Calificación de Alumnos Matriculados</p>
                        </div>
                        <div class="bg-light p-3 rounded text-center border">
                            <small class="text-muted d-block uppercase fw-semibold">Créditos del Curso</small>
                            <span class="fs-4 fw-bold text-primary">${curso.creditos}</span>
                        </div>
                    </div>
                </div>

                <!-- Formulario de Calificaciones -->
                <form action="${pageContext.request.contextPath}/controller/GuardarNotasServlet" method="POST">
                    <!-- Mantener el id del curso en la petición -->
                    <input type="hidden" name="cursoId" value="${curso.id}">
                    
                    <div class="card border-0 shadow-sm card-custom">
                        <div class="card-header card-header-custom py-3 d-flex align-items-center justify-content-between">
                            <h5 class="fw-bold text-dark m-0"><i class="bi bi-people-fill me-2 text-secondary"></i>Acta de Calificaciones</h5>
                            <span class="text-muted small">Fórmula de Promedio Regular Ponderado Activa</span>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0" id="tabla-calificaciones">
                                    <thead class="table-light">
                                        <tr class="text-uppercase text-secondary" style="font-size: 0.85rem;">
                                            <th class="ps-4" style="width: 30%;">Estudiante</th>
                                            <th class="text-center">PC1</th>
                                            <th class="text-center">PC2</th>
                                            <th class="text-center">PC3</th>
                                            <th class="text-center">Ex. Parcial</th>
                                            <th class="text-center">Ex. Final</th>
                                            <th class="text-center pe-4" style="width: 15%;">Promedio Final</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="nota" items="${notes != null ? notes : notas}">
                                            <tr class="alumno-row" data-id="${nota.matriculaId}">
                                                <td class="ps-4">
                                                    <input type="hidden" name="matricula_ids" value="${nota.matriculaId}">
                                                    <span class="fw-bold text-dark d-block">${nota.alumnoNombre}</span>
                                                    <small class="text-muted">${nota.codigoAlumno}</small>
                                                </td>
                                                <td class="text-center">
                                                    <input type="number" name="pc1_${nota.matriculaId}" class="form-control form-control-sm grade-input pc1 mx-auto" value="${nota.pc1}" min="0" max="20" step="0.1" required>
                                                </td>
                                                <td class="text-center">
                                                    <input type="number" name="pc2_${nota.matriculaId}" class="form-control form-control-sm grade-input pc2 mx-auto" value="${nota.pc2}" min="0" max="20" step="0.1" required>
                                                </td>
                                                <td class="text-center">
                                                    <input type="number" name="pc3_${nota.matriculaId}" class="form-control form-control-sm grade-input pc3 mx-auto" value="${nota.pc3}" min="0" max="20" step="0.1" required>
                                                </td>
                                                <td class="text-center">
                                                    <input type="number" name="ep_${nota.matriculaId}" class="form-control form-control-sm grade-input ep mx-auto" value="${nota.examenParcial}" min="0" max="20" step="0.1" required>
                                                </td>
                                                <td class="text-center">
                                                    <input type="number" name="ef_${nota.matriculaId}" class="form-control form-control-sm grade-input ef mx-auto" value="${nota.examenFinal}" min="0" max="20" step="0.1" required>
                                                </td>
                                                <td class="text-center pe-4">
                                                    <div class="promedio-celda <c:choose><c:when test='${nota.promedioFinal >= 10.5}'>aprobado</c:when><c:otherwise>desaprobado</c:otherwise></c:choose>" id="prom-${nota.matriculaId}">
                                                        ${nota.promedioFinal}
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                        <!-- Footer del Card con Acciones -->
                        <div class="card-footer bg-light p-3 text-end border-top">
                            <a href="${pageContext.request.contextPath}/DashboardDocenteServlet" class="btn btn-outline-secondary fw-semibold px-4 py-2 me-2">
                                <i class="bi bi-x-circle"></i> Cancelar
                            </a>
                            <button type="submit" class="btn btn-save fw-bold px-5 py-2">
                                <i class="bi bi-cloud-check-fill me-1"></i> Guardar Acta de Notas
                            </button>
                        </div>
                    </div>
                </form>

            </div>
        </main>
    </div>

    <!-- Modal de Cambio de Contraseña -->
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
                            <div class="small">Tu nueva contraseña debe tener un mínimo de <strong>6 caracteres</strong>.</div>
                        </div>

                        <div class="mb-3">
                            <label for="modal_password_actual" class="form-label fw-semibold text-secondary">Contraseña Actual:</label>
                            <input type="password" id="modal_password_actual" name="password_actual" class="form-control" placeholder="Ingresa tu clave actual" required>
                        </div>

                        <div class="mb-3">
                            <label for="modal_nueva_password" class="form-label fw-semibold text-secondary">Nueva Contraseña:</label>
                            <input type="password" id="modal_nueva_password" name="nueva_password" class="form-control" placeholder="Mínimo 6 caracteres" minlength="6" required>
                        </div>

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

    <!-- Script de Cálculo Interactivo Local (Real-Time Average) -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const inputs = document.querySelectorAll(".grade-input");
            
            inputs.forEach(input => {
                input.addEventListener("input", function() {
                    const row = this.closest(".alumno-row");
                    const id = row.getAttribute("data-id");
                    
                    const pc1 = parseFloat(row.querySelector(".pc1").value) || 0.0;
                    const pc2 = parseFloat(row.querySelector(".pc2").value) || 0.0;
                    const pc3 = parseFloat(row.querySelector(".pc3").value) || 0.0;
                    const ep = parseFloat(row.querySelector(".ep").value) || 0.0;
                    const ef = parseFloat(row.querySelector(".ef").value) || 0.0;
                    
                    const promPC = (pc1 + pc2 + pc3) / 3.0;
                    const promedioFinal = (promPC * 0.3) + (ep * 0.3) + (ef * 0.4);
                    
                    const promedioFinalRedondeado = Math.round(promedioFinal * 100.0) / 100.0;
                    
                    const promCell = document.getElementById("prom-" + id);
                    promCell.innerText = promedioFinalRedondeado.toFixed(2);
                    
                    if (promedioFinalRedondeado < 10.5) {
                        promCell.className = "promedio-celda desaprobado";
                    } else {
                        promCell.className = "promedio-celda aprobado";
                    }
                });
            });
        });
    </script>
</body>
</html>
