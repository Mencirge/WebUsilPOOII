<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cambiar Contraseña - ${configuracion.nombreInstitucion}</title>
    <!-- Bootstrap 5 CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    
    <style>
        :root {
            --primary-color: ${configuracion.colorPrincipalHex};
        }
        
        body {
            background-color: #f4f6f9;
        }
        
        .card-custom {
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            border: none;
        }
        
        .btn-primary-custom {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            transition: all 0.2s;
        }
        
        .btn-primary-custom:hover {
            opacity: 0.9;
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .back-link {
            color: #6c757d;
            text-decoration: none;
        }
        .back-link:hover {
            color: var(--primary-color);
            text-decoration: underline;
        }
    </style>
</head>
<body class="d-flex align-items-center min-vh-100 py-5">

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                
                <!-- Logo & Brand Header -->
                <div class="text-center mb-4">
                    <img src="${pageContext.request.contextPath}/${configuracion.logoUrl}" alt="Logo" width="60" class="mb-2 rounded bg-white p-2 shadow-sm" onerror="this.src='https://upload.wikimedia.org/wikipedia/commons/e/ec/USIL_logo.png';">
                    <h4 class="fw-bold text-dark m-0">${configuracion.nombreInstitucion}</h4>
                    <p class="text-muted small">Módulo de Seguridad del Usuario</p>
                </div>

                <!-- Form Card -->
                <div class="card card-custom">
                    <div class="card-body p-4 p-md-5">
                        
                        <div class="d-flex align-items-center gap-2 mb-4 border-bottom pb-3">
                            <i class="bi bi-shield-lock-fill text-secondary fs-3"></i>
                            <h4 class="fw-bold text-dark m-0">Actualizar Contraseña</h4>
                        </div>

                        <!-- Alert Errors -->
                        <c:if test="${not empty param.error}">
                            <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center gap-2 mb-4" role="alert">
                                <i class="bi bi-exclamation-triangle-fill"></i>
                                <div>${param.error}</div>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/CambiarPasswordServlet" method="POST">
                            
                            <!-- Contraseña Actual -->
                            <div class="mb-3">
                                <label for="password_actual" class="form-label fw-semibold text-secondary">Contraseña Actual:</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-key-fill"></i></span>
                                    <input type="password" id="password_actual" name="password_actual" class="form-control" placeholder="Ingresa tu contraseña actual" required>
                                </div>
                            </div>

                            <!-- Nueva Contraseña -->
                            <div class="mb-3">
                                <label for="nueva_password" class="form-label fw-semibold text-secondary">Nueva Contraseña:</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                                    <input type="password" id="nueva_password" name="nueva_password" class="form-control" placeholder="Mínimo 6 caracteres" minlength="6" required>
                                </div>
                            </div>

                            <!-- Confirmar Nueva Contraseña -->
                            <div class="mb-4">
                                <label for="confirmacion" class="form-label fw-semibold text-secondary">Confirmar Nueva Contraseña:</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-shield-check"></i></span>
                                    <input type="password" id="confirmacion" name="confirmacion" class="form-control" placeholder="Repite tu nueva contraseña" minlength="6" required>
                                </div>
                            </div>

                            <!-- Submit Button -->
                            <button type="submit" class="btn btn-primary btn-primary-custom w-100 py-2.5 fw-bold text-white mb-3">
                                <i class="bi bi-check2-circle me-1"></i> Guardar Nueva Contraseña
                            </button>

                            <!-- Cancel/Back Link -->
                            <div class="text-center">
                                <a href="javascript:history.back()" class="back-link fw-semibold small">
                                    <i class="bi bi-arrow-left me-1"></i> Cancelar y Volver
                                </a>
                            </div>

                        </form>

                    </div>
                </div><!-- Fin Card -->

            </div>
        </div>
    </div>

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
