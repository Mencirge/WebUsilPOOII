<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calificaciones - ${configuracion.nombreInstitucion}</title>
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
        
        .card-header-custom {
            background-color: #f8f9fa;
            border-left: 5px solid var(--primary-color);
        }
        
        .btn-save {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: #ffffff;
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
<body class="bg-light">

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom shadow-sm py-3">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/DashboardDocenteServlet">
                <img src="${pageContext.request.contextPath}/${configuracion.logoUrl}" alt="Logo" width="40" height="40" class="rounded bg-white p-1" onerror="this.src='https://upload.wikimedia.org/wikipedia/commons/e/ec/USIL_logo.png';">
                <span class="fw-bold">${configuracion.nombreInstitucion}</span>
            </a>
            <div class="collapse navbar-collapse justify-content-end">
                <a href="${pageContext.request.contextPath}/DashboardDocenteServlet" class="btn btn-outline-light btn-sm d-flex align-items-center gap-1">
                    <i class="bi bi-arrow-left"></i> Volver a Mis Cursos
                </a>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container my-5">
        <div class="row">
            <div class="col-12">
                
                <!-- Title Header -->
                <div class="card border-0 shadow-sm mb-4">
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

                <!-- Formulario -->
                <form action="${pageContext.request.contextPath}/controller/GuardarNotasServlet" method="POST">
                    
                    <div class="card border-0 shadow-sm">
                        <div class="card-header card-header-custom py-3 d-flex align-items-center justify-content-between">
                            <h5 class="fw-bold text-dark m-0"><i class="bi bi-people-fill me-2 text-secondary"></i>Acta de Calificaciones</h5>
                            <span class="text-muted small">Fórmula de Promedio Regular Ponderado Activa</span>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0" id="tabla-calificaciones">
                                    <thead class="table-light">
                                        <tr>
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
                                        <c:forEach var="nota" items="${notas}">
                                            <tr class="alumno-row" data-id="${nota.matriculaId}">
                                                <td class="ps-4">
                                                    <!-- Pasar ID de matricula -->
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
                                                    <div class="promedio-celda <c:choose><c:when test="${nota.promedioFinal >= 11.5}">aprobado</c:when><c:otherwise>desaprobado</c:otherwise></c:choose>" id="prom-${nota.matriculaId}">
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
                        <div class="card-footer bg-light p-3 text-end">
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
        </div>
    </div>

    <!-- Bootstrap 5 Bundle JS with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Script de Cálculo Interactivo Local (Real-Time Average) -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const inputs = document.querySelectorAll(".grade-input");
            
            inputs.forEach(input => {
                input.addEventListener("input", function() {
                    const row = this.closest(".alumno-row");
                    const id = row.getAttribute("data-id");
                    
                    // Leer notas individuales o asumir 0.0 si están en blanco
                    const pc1 = parseFloat(row.querySelector(".pc1").value) || 0.0;
                    const pc2 = parseFloat(row.querySelector(".pc2").value) || 0.0;
                    const pc3 = parseFloat(row.querySelector(".pc3").value) || 0.0;
                    const ep = parseFloat(row.querySelector(".ep").value) || 0.0;
                    const ef = parseFloat(row.querySelector(".ef").value) || 0.0;
                    
                    // Cálculo local del promedio de PCs y Promedio Final (Estrategia Regular)
                    const promPC = (pc1 + pc2 + pc3) / 3.0;
                    const promedioFinal = (promPC * 0.3) + (ep * 0.3) + (ef * 0.4);
                    
                    // Redondear a dos decimales
                    const promedioFinalRedondeado = Math.round(promedioFinal * 100.0) / 100.0;
                    
                    const promCell = document.getElementById("prom-" + id);
                    promCell.innerText = promedioFinalRedondeado.toFixed(2);
                    
                    // Aplicar clases de color según aprobación
                    if (promedioFinalRedondeado < 11.5) {
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
