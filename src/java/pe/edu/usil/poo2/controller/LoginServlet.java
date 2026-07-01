package pe.edu.usil.poo2.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import pe.edu.usil.poo2.model.dao.UsuarioDAO;
import pe.edu.usil.poo2.model.entity.Usuario;

/**
 * Servlet controlador encargado de gestionar el inicio de sesión de usuarios (Login).
 * Valida credenciales e implementa políticas de bloqueo temporal tras intentos fallidos.
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Aceptar parámetros de correo/código indistintamente
        String correo = request.getParameter("correo");
        if (correo == null || correo.trim().isEmpty()) {
            correo = request.getParameter("codigo_o_correo");
        }
        String password = request.getParameter("password");

        if (correo == null || correo.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Campos+obligatorios");
            return;
        }

        correo = correo.trim();

        // 1. Obtener los datos del usuario para verificar su estado de bloqueo primero
        Usuario usuarioPre = usuarioDAO.obtenerPorCodigoOCorreo(correo);

        if (usuarioPre == null) {
            // Usuario no encontrado
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Credenciales+incorrectas");
            return;
        }

        // 2. Verificar si la cuenta está BLOQUEADA
        if ("BLOQUEADO".equalsIgnoreCase(usuarioPre.getEstado())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Su+cuenta+ha+sido+BLOQUEADA.+Contacte+con+el+administrador.");
            return;
        }

        // 3. Validar credenciales
        Usuario usuarioValido = usuarioDAO.validarLogin(correo, password);

        if (usuarioValido != null) {
            // LOGIN CORRECTO -> Resetear intentos fallidos
            usuarioDAO.resetearIntentos(usuarioValido.getId());
            
            // Iniciar sesión y guardar el usuario bajo "usuarioLogueado" y "usuario" para compatibilidad
            HttpSession session = request.getSession(true);
            session.setAttribute("usuarioLogueado", usuarioValido);
            session.setAttribute("usuario", usuarioValido);

            // Redirigir según el rol del usuario
            String rol = usuarioValido.getRolNombre();
            if ("ADMIN".equalsIgnoreCase(rol)) {
                response.sendRedirect(request.getContextPath() + "/AdminDashboardServlet");
            } else if ("DOCENTE".equalsIgnoreCase(rol)) {
                response.sendRedirect(request.getContextPath() + "/DashboardDocenteServlet");
            } else if ("ALUMNO".equalsIgnoreCase(rol)) {
                response.sendRedirect(request.getContextPath() + "/DashboardAlumnoServlet");
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=Rol+no+soportado");
            }
        } else {
            // LOGIN INCORRECTO -> Registrar intento fallido
            usuarioDAO.registrarIntentoFallido(correo);
            
            // Cargar de nuevo para mostrar los intentos restantes actualizados
            Usuario usuarioPost = usuarioDAO.obtenerPorCodigoOCorreo(correo);
            if (usuarioPost != null && "BLOQUEADO".equalsIgnoreCase(usuarioPost.getEstado())) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=Cuenta+bloqueada+por+alcanzar+el+limite+de+3+intentos+fallidos.");
            } else {
                int intentosRestantes = 3 - (usuarioPost != null ? usuarioPost.getIntentosFallidos() : 1);
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=Credenciales+incorrectas.+Intentos+restantes:+" + intentosRestantes);
            }
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
