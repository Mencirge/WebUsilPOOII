<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Intranet USIL</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .login-box {
            background-color: #ffffff;
            width: 360px;
            padding: 30px;
            border: 1px solid #cccccc;
            border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .logo-placeholder {
            margin-bottom: 20px;
        }

        .logo-placeholder img {
            max-width: 140px;
            height: auto;
        }

        h2 {
            color: #0c2340;
            margin-bottom: 10px;
            font-size: 22px;
        }

        p.desc {
            color: #666666;
            font-size: 14px;
            margin-bottom: 25px;
        }

        .form-group {
            text-align: left;
            margin-bottom: 15px;
        }

        label {
            display: block;
            font-size: 13px;
            font-weight: bold;
            color: #333333;
            margin-bottom: 5px;
        }

        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #cccccc;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 14px;
        }

        input:focus {
            outline: none;
            border-color: #0c2340;
        }

        .btn-login {
            background-color: #0c2340;
            color: #ffffff;
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 4px;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 10px;
        }

        .btn-login:hover {
            background-color: #16365c;
        }

        .btn-login:disabled {
            background-color: #cccccc;
            color: #666666;
            cursor: not-allowed;
        }

        /* Alertas de error y mensajes */
        .alert-error {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
            font-size: 13px;
            text-align: left;
        }

        .alert-success {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
            font-size: 13px;
            text-align: left;
        }

        .alert-block {
            background-color: #fff3cd;
            border: 1px solid #ffeeba;
            color: #856404;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
            font-size: 13px;
            font-weight: bold;
            display: none;
        }
    </style>
</head>
<body>

    <div class="login-box">
        <div class="logo-placeholder">
            <!-- Logo de la USIL con fallback de imagen -->
            <img src="${pageContext.request.contextPath}/imagenes/usil_logo.png" alt="Logo USIL" onerror="this.src='https://upload.wikimedia.org/wikipedia/commons/e/ec/USIL_logo.png';">
        </div>
        
        <h2>Sistema Académico</h2>
        <p class="desc">Ingrese su código y contraseña para continuar</p>

        <!-- Mensajes de Error de JSP -->
        <% if (request.getParameter("error") != null) { %>
            <div class="alert-error" id="error-alert">
                <strong>Error:</strong> <%= request.getParameter("error") %>
            </div>
        <% } %>

        <!-- Mensajes Informativos de JSP -->
        <% if (request.getParameter("msg") != null) { %>
            <div class="alert-success">
                <%= request.getParameter("msg") %>
            </div>
        <% } %>

        <!-- Contenedor del Temporizador de Bloqueo -->
        <div class="alert-block" id="timer-container">
            Formulario bloqueado. Espere: <span id="countdown-timer">0</span> segundos.
        </div>

        <!-- Formulario -->
        <form action="${pageContext.request.contextPath}/LoginServlet" method="POST" id="login-form">
            <div class="form-group">
                <label for="codigo_o_correo">Código de Usuario o Correo:</label>
                <input type="text" id="codigo_o_correo" name="codigo_o_correo" placeholder="ej: alumno@usil.edu.pe" required>
            </div>
            
            <div class="form-group">
                <label for="password">Contraseña:</label>
                <input type="password" id="password" name="password" placeholder="Escriba su contraseña" required>
            </div>

            <button type="submit" class="btn-login" id="btn-submit">Iniciar Sesión</button>
        </form>
    </div>

    <!-- Script de Bloqueo Temporal -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const urlParams = new URLSearchParams(window.location.search);
            const errorMsg = urlParams.get('error');
            
            if (errorMsg && (errorMsg.includes('bloqueada') || errorMsg.includes('bloqueado'))) {
                const match = errorMsg.match(/\d+/);
                if (match) {
                    let seconds = parseInt(match[0], 10);
                    
                    const inputs = document.querySelectorAll('#login-form input');
                    const submitBtn = document.getElementById('btn-submit');
                    const timerContainer = document.getElementById('timer-container');
                    const countdownEl = document.getElementById('countdown-timer');

                    // Deshabilitar campos
                    inputs.forEach(input => input.disabled = true);
                    submitBtn.disabled = true;

                    // Mostrar aviso de bloqueo
                    timerContainer.style.display = 'block';
                    countdownEl.innerText = seconds;

                    // Cuenta regresiva
                    const interval = setInterval(function() {
                        seconds--;
                        countdownEl.innerText = seconds;

                        if (seconds <= 0) {
                            clearInterval(interval);
                            // Rehabilitar campos
                            inputs.forEach(input => input.disabled = false);
                            submitBtn.disabled = false;
                            
                            // Cambiar aviso de bloqueo a éxito
                            timerContainer.style.backgroundColor = "#d4edda";
                            timerContainer.style.borderColor = "#c3e6cb";
                            timerContainer.style.color = "#155724";
                            timerContainer.innerHTML = "Bloqueo finalizado. Ya puede intentar ingresar de nuevo.";
                            
                            // Ocultar alerta de error antigua
                            const errorAlert = document.getElementById('error-alert');
                            if (errorAlert) errorAlert.style.display = 'none';
                        }
                    }, 1000);
                }
            }
        });
    </script>
</body>
</html>
