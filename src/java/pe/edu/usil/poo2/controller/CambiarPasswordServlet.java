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
import pe.edu.usil.poo2.util.ConfiguracionInstitucion;

/**
 * Servlet controlador encargado de gestionar el cambio de contraseña de los usuarios autenticados.
 * Valida la coincidencia y la contraseña actual antes de actualizar en PostgreSQL.
 */
@WebServlet(name = "CambiarPasswordServlet", urlPatterns = {"/CambiarPasswordServlet"})
public class CambiarPasswordServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Usuario usuario = null;
        if (session != null) {
            usuario = (Usuario) session.getAttribute("usuarioLogueado");
            if (usuario == null) {
                usuario = (Usuario) session.getAttribute("usuario");
            }
        }

        // Validar que el usuario esté autenticado
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Debe+iniciar+sesion");
            return;
        }

        // Cargar configuración de marca blanca (Singleton)
        ConfiguracionInstitucion configuracion = ConfiguracionInstitucion.getInstancia();
        request.setAttribute("configuracion", configuracion);

        request.getRequestDispatcher("/cambiar_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuario = null;
        if (session != null) {
            usuario = (Usuario) session.getAttribute("usuarioLogueado");
            if (usuario == null) {
                usuario = (Usuario) session.getAttribute("usuario");
            }
        }

        // Validar autenticación
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Debe+iniciar+sesion");
            return;
        }

        // Recibir parámetros
        String passwordActual = request.getParameter("password_actual");
        String nuevaPassword = request.getParameter("nueva_password");
        String confirmacion = request.getParameter("confirmacion");

        // Validar campos obligatorios
        if (passwordActual == null || passwordActual.trim().isEmpty() ||
            nuevaPassword == null || nuevaPassword.trim().isEmpty() ||
            confirmacion == null || confirmacion.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/CambiarPasswordServlet?error=Todos+los+campos+son+obligatorios");
            return;
        }

        // 1. Validar que la nueva contraseña coincida con su confirmación
        if (!nuevaPassword.equals(confirmacion)) {
            response.sendRedirect(request.getContextPath() + "/CambiarPasswordServlet?error=La+nueva+contrasena+y+la+confirmacion+no+coinciden");
            return;
        }

        // 2. Validar que la contraseña actual sea la correcta
        if (!usuario.getPassword().equals(passwordActual)) {
            response.sendRedirect(request.getContextPath() + "/CambiarPasswordServlet?error=La+contrasena+actual+es+incorrecta");
            return;
        }

        // 3. Actualizar la contraseña en la base de datos PostgreSQL
        boolean exito = usuarioDAO.actualizarPassword(usuario.getId(), nuevaPassword);

        if (exito) {
            // Actualizar el objeto de usuario en la sesión actual
            usuario.setPassword(nuevaPassword);
            session.setAttribute("usuarioLogueado", usuario);
            session.setAttribute("usuario", usuario);

            System.out.println("[SEGURIDAD] Contraseña actualizada para el usuario: " + usuario.getCodigoOCorreo());

            // Redirigir al panel correspondiente con mensaje de éxito
            String rol = usuario.getRolNombre();
            String redirectUrl;
            if ("ADMIN".equalsIgnoreCase(rol)) {
                redirectUrl = "/AdminDashboardServlet?successPass=true";
            } else if ("DOCENTE".equalsIgnoreCase(rol)) {
                redirectUrl = "/DashboardDocenteServlet?successPass=true";
            } else {
                redirectUrl = "/DashboardAlumnoServlet?successPass=true";
            }
            response.sendRedirect(request.getContextPath() + redirectUrl);
        } else {
            response.sendRedirect(request.getContextPath() + "/CambiarPasswordServlet?error=Error+al+actualizar+la+contrasena+en+la+base+de+datos");
        }
    }
}
