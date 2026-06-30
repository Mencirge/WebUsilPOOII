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

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String codigoOCorreo = request.getParameter("codigo_o_correo");
        String password = request.getParameter("password");

        if (codigoOCorreo == null || codigoOCorreo.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Campos+obligatorios");
            return;
        }

        // 1. Obtener usuario de la base de datos
        Usuario usuario = usuarioDAO.obtenerPorCodigoOCorreo(codigoOCorreo.trim());

        if (usuario == null) {
            // Mensaje genérico para evitar enumeración de usuarios por seguridad
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Credenciales+incorrectas");
            return;
        }

        // 2. Verificar si está bloqueado temporalmente
        if (usuario.isBloqueado()) {
            long segundosRestantes = usuario.getSegundosRestantesBloqueo();
            if (segundosRestantes > 0) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=Usuario+bloqueado+temporalmente.+Espere+" + segundosRestantes + "+segundos");
            } else {
                // Si el tiempo de bloqueo ya expiró en tiempo de ejecución, pero su estado sigue BLOQUEADO en la base de datos,
                // permitiremos continuar. Posteriormente, si se loguea con éxito o falla de nuevo, se actualizará en DB.
                usuario.setEstado("ACTIVO");
            }
        }

        // 3. Validar la contraseña (comparación directa por simplicidad, reemplazable por hash)
        boolean esCorrecta = usuario.getPassword().equals(password);

        if (esCorrecta) {
            // Login Exitoso -> Resetear contador de intentos y guardar en sesión
            usuarioDAO.resetearIntentosFallidos(usuario.getId());
            usuario.setIntentosFallidos(0);
            usuario.setEstado("ACTIVO");
            usuario.setBloqueadoHasta(null);

            HttpSession session = request.getSession(true);
            session.setAttribute("usuario", usuario);

            // Redirección por Rol
            String rol = usuario.getRolNombre();
            switch (rol) {
                case "ALUMNO":
                    response.sendRedirect(request.getContextPath() + "/DashboardAlumnoServlet");
                    break;
                case "DOCENTE":
                    response.sendRedirect(request.getContextPath() + "/DashboardDocenteServlet");
                    break;
                case "ADMIN":
                    response.sendRedirect(request.getContextPath() + "/AdminDashboardServlet");
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/login.jsp?error=Rol+no+reconocido");
                    break;
            }
        } else {
            // Login Fallido -> Incrementar intentos
            int nuevosIntentos = usuario.getIntentosFallidos() + 1;
            usuarioDAO.registrarIntentoFallido(usuario.getId(), nuevosIntentos);

            if (nuevosIntentos >= 3) {
                // Bloquear por 5 minutos
                usuarioDAO.bloquearUsuarioTemporalmente(usuario.getId(), 5);
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=Cuenta+bloqueada+temporalmente+por+5+minutos+debido+a+3+intentos+fallidos");
            } else {
                int intentosRestantes = 3 - nuevosIntentos;
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=Credenciales+incorrectas.+Intentos+restantes:+" + intentosRestantes);
            }
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirigir GETs accidentales al login
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
