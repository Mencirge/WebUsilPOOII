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
 * Servlet controlador encargado de gestionar el cambio de contraseña de los usuarios.
 * Valida contraseñas y redirige con parámetros de error/éxito a los dashboards correspondientes.
 */
@WebServlet(name = "CambiarPasswordServlet", urlPatterns = {"/CambiarPasswordServlet"})
public class CambiarPasswordServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Redirigir GETs accidentales de vuelta a su dashboard
        HttpSession session = request.getSession(false);
        Usuario usuario = null;
        if (session != null) {
            usuario = (Usuario) session.getAttribute("usuarioLogueado");
            if (usuario == null) {
                usuario = (Usuario) session.getAttribute("usuario");
            }
        }

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        redirigirADashboard(usuario, request, response, null, null);
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

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Debe+iniciar+sesion");
            return;
        }

        String passwordActual = request.getParameter("password_actual");
        String nuevaPassword = request.getParameter("nueva_password");
        String confirmacion = request.getParameter("confirmacion");

        if (passwordActual == null || passwordActual.trim().isEmpty() ||
            nuevaPassword == null || nuevaPassword.trim().isEmpty() ||
            confirmacion == null || confirmacion.trim().isEmpty()) {
            redirigirADashboard(usuario, request, response, null, "Todos los campos son obligatorios");
            return;
        }

        if (!nuevaPassword.equals(confirmacion)) {
            redirigirADashboard(usuario, request, response, null, "La nueva contraseña y la confirmación no coinciden");
            return;
        }

        if (!usuario.getPassword().equals(passwordActual)) {
            redirigirADashboard(usuario, request, response, null, "La contraseña actual es incorrecta");
            return;
        }

        boolean exito = usuarioDAO.actualizarPassword(usuario.getId(), nuevaPassword);

        if (exito) {
            usuario.setPassword(nuevaPassword);
            session.setAttribute("usuarioLogueado", usuario);
            session.setAttribute("usuario", usuario);
            System.out.println("[SEGURIDAD] Contraseña actualizada para: " + usuario.getCodigoOCorreo());
            redirigirADashboard(usuario, request, response, "Contraseña actualizada correctamente", null);
        } else {
            redirigirADashboard(usuario, request, response, null, "Error al actualizar la contraseña en la base de datos");
        }
    }

    private void redirigirADashboard(Usuario usuario, HttpServletRequest request, HttpServletResponse response, String successMsg, String errorMsg) 
            throws IOException {
        String rol = usuario.getRolNombre();
        String contextPath = request.getContextPath();
        
        StringBuilder param = new StringBuilder();
        if (successMsg != null) {
            param.append("?success=").append(java.net.URLEncoder.encode(successMsg, "UTF-8"));
        } else if (errorMsg != null) {
            param.append("?error=").append(java.net.URLEncoder.encode(errorMsg, "UTF-8"));
        }
        
        String servletPath;
        if ("ADMIN".equalsIgnoreCase(rol)) {
            servletPath = "/AdminDashboardServlet";
        } else if ("DOCENTE".equalsIgnoreCase(rol)) {
            servletPath = "/DashboardDocenteServlet";
        } else {
            servletPath = "/DashboardAlumnoServlet";
        }
        
        response.sendRedirect(contextPath + servletPath + param.toString());
    }
}
