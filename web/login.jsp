<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Acceso - Plataforma USIL</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-color: #0c2340; /* Azul USIL */
            --accent-color: #d1a153;  /* Dorado USIL */
            --bg-gradient-start: #0f2027;
            --bg-gradient-mid: #203a43;
            --bg-gradient-end: #2c5364;
            --card-bg: rgba(255, 255, 255, 0.08);
            --card-border: rgba(255, 255, 255, 0.12);
            --text-color: #ffffff;
            --text-muted: #cbd5e1;
            --danger-color: #f87171;
            --success-color: #4ade80;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Outfit', sans-serif;
        }

        body {
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, var(--bg-gradient-start), var(--bg-gradient-mid), var(--bg-gradient-end));
            background-size: cover;
            overflow: hidden;
            position: relative;
        }

        /* Efectos de fondo flotantes */
        body::before, body::after {
            content: "";
            position: absolute;
            width: 300px;
            height: 300px;
            border-radius: 50%;
            filter: blur(100px);
            z-index: 0;
            opacity: 0.4;
        }

        body::before {
            background-color: var(--primary-color);
            top: 15%;
            left: 20%;
        }

        body::after {
            background-color: var(--accent-color);
            bottom: 15%;
            right: 20%;
        }

        .login-container {
            position: relative;
            z-index: 10;
            width: 100%;
            max-width: 420px;
            padding: 20px;
        }

        .login-card {
            background: var(--card-bg);
            border: 1px solid var(--card-border);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border-radius: 24px;
            padding: 40px 30px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.3);
            text-align: center;
            transform: translateY(0);
            transition: all 0.3s ease;
        }

        .login-card:hover {
            box-shadow: 0 12px 40px 0 rgba(0, 0, 0, 0.4);
            border-color: rgba(255, 255, 255, 0.2);
        }

        .logo-img {
            max-width: 180px;
            height: auto;
            margin-bottom: 25px;
            filter: drop-shadow(0px 4px 6px rgba(0,0,0,0.2));
        }

        .login-title {
            color: var(--text-color);
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 8px;
            letter-spacing: 0.5px;
        }

        .login-subtitle {
            color: var(--text-muted);
            font-size: 14px;
            margin-bottom: 30px;
            font-weight: 300;
        }

        /* Formularios */
        .form-group {
            text-align: left;
            margin-bottom: 20px;
            position: relative;
        }

        .form-label {
            display: block;
            color: var(--text-muted);
            font-size: 13px;
            font-weight: 500;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .form-input {
            width: 100%;
            padding: 14px 16px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            color: var(--text-color);
            font-size: 15px;
            outline: none;
            transition: all 0.2s ease;
        }

        .form-input:focus {
            background: rgba(255, 255, 255, 0.1);
            border-color: var(--accent-color);
            box-shadow: 0 0 0 3px rgba(209, 161, 83, 0.2);
        }

        .form-input::placeholder {
            color: rgba(255, 255, 255, 0.4);
        }

        .btn-submit {
            width: 100%;
            padding: 14px;
            background: linear-gradient(90deg, var(--primary-color), #1a3a60);
            border: 1px solid var(--accent-color);
            border-radius: 12px;
            color: var(--text-color);
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(12, 35, 64, 0.4);
            margin-top: 10px;
        }

        .btn-submit:hover:not(:disabled) {
            background: linear-gradient(90deg, #1a3a60, var(--primary-color));
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(209, 161, 83, 0.3);
        }

        .btn-submit:active:not(:disabled) {
            transform: translateY(0);
        }

        .btn-submit:disabled {
            background: rgba(255, 255, 255, 0.08);
            border-color: rgba(255, 255, 255, 0.1);
            color: rgba(255, 255, 255, 0.3);
            cursor: not-allowed;
            box-shadow: none;
        }

        /* Notificaciones / Mensajes */
        .alert {
            border-radius: 12px;
            padding: 12px 15px;
            margin-bottom: 20px;
            font-size: 14px;
            text-align: left;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: fadeIn 0.4s ease;
        }

        .alert-danger {
            background: rgba(248, 113, 113, 0.15);
            border: 1px solid rgba(248, 113, 113, 0.3);
            color: var(--danger-color);
        }

        .alert-success {
            background: rgba(74, 222, 128, 0.15);
            border: 1px solid rgba(74, 222, 128, 0.3);
            color: var(--success-color);
        }

        /* Temporizador */
        .timer-box {
            display: none;
            background: rgba(209, 161, 83, 0.15);
            border: 1px solid rgba(209, 161, 83, 0.3);
            color: var(--accent-color);
            border-radius: 12px;
            padding: 12px;
            margin-bottom: 20px;
            font-size: 14px;
            font-weight: 500;
            animation: pulse 2.0s infinite ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.02); }
            100% { transform: scale(1); }
        }
    </style>
</head>
<body>

    <div class="login-container">
        <div class="login-card">
            <!-- Logotipo de la USIL -->
            <img src="${pageContext.request.contextPath}/imagenes/usil_logo.png" alt="Logo USIL" class="logo-img" onerror="this.src='https://upload.wikimedia.org/wikipedia/commons/e/ec/USIL_logo.png';">
            
            <h1 class="login-title">Plataforma Web</h1>
            <p class="login-subtitle">Ingresa tus credenciales universitarias</p>

            <!-- Mensajes de Alerta -->
            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-danger" id="error-alert">
                    <svg width="20" height="20" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd"></path></svg>
                    <span><%= request.getParameter("error") %></span>
                </div>
            <% } %>

            <% if (request.getParameter("msg") != null) { %>
                <div class="alert alert-success">
                    <svg width="20" height="20" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path></svg>
                    <span><%= request.getParameter("msg") %></span>
                </div>
            <% } %>

            <!-- Temporizador de Bloqueo Visual -->
            <div class="timer-box" id="timer-container">
                La cuenta está bloqueada. Reintentar en: <span id="countdown-timer">0</span> segundos.
            </div>

            <!-- Formulario de Login -->
            <form action="${pageContext.request.contextPath}/LoginServlet" method="POST" id="login-form">
                <div class="form-group">
                    <label for="codigo_o_correo" class="form-label">Código o Correo</label>
                    <input type="text" id="codigo_o_correo" name="codigo_o_correo" class="form-input" placeholder="ej: alumno@usil.edu.pe o U2022..." required>
                </div>
                
                <div class="form-group">
                    <label for="password" class="form-label">Contraseña</label>
                    <input type="password" id="password" name="password" class="form-input" placeholder="••••••••" required>
                </div>

                <button type="submit" class="btn-submit" id="btn-submit">Iniciar Sesión</button>
            </form>
        </div>
    </div>

    <!-- Script de Bloqueo Dinámico -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const urlParams = new URLSearchParams(window.location.search);
            const errorMsg = urlParams.get('error');
            
            if (errorMsg && (errorMsg.includes('bloqueada') || errorMsg.includes('bloqueado'))) {
                // Intentar extraer el número de segundos usando regex
                const match = errorMsg.match(/\d+/);
                if (match) {
                    let seconds = parseInt(match[0], 10);
                    
                    const inputs = document.querySelectorAll('#login-form input');
                    const submitBtn = document.getElementById('btn-submit');
                    const timerContainer = document.getElementById('timer-container');
                    const countdownEl = document.getElementById('countdown-timer');

                    // Deshabilitar campos de inmediato
                    inputs.forEach(input => input.disabled = true);
                    submitBtn.disabled = true;

                    // Mostrar temporizador
                    timerContainer.style.display = 'block';
                    countdownEl.innerText = seconds;

                    // Intervalo de cuenta regresiva
                    const interval = setInterval(function() {
                        seconds--;
                        countdownEl.innerText = seconds;

                        if (seconds <= 0) {
                            clearInterval(interval);
                            // Rehabilitar campos
                            inputs.forEach(input => input.disabled = false);
                            submitBtn.disabled = false;
                            
                            // Reemplazar mensaje por un aviso de listo
                            timerContainer.className = "alert alert-success";
                            timerContainer.innerHTML = `
                                <svg width="20" height="20" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path></svg>
                                <span>Bloqueo temporal finalizado. Ya puede intentar ingresar de nuevo.</span>
                            `;
                            
                            // Ocultar alerta de error previa
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
