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

@WebServlet(name = "CambiarPasswordServlet", urlPatterns = {"/controller/CambiarPasswordServlet"})
public class CambiarPasswordServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Sesion+no+iniciada");
            return;
        }

        String passwordActual = request.getParameter("password_actual");
        String passwordNuevo = request.getParameter("password_nuevo");
        String passwordNuevoConfirmar = request.getParameter("password_nuevo_confirmar");

        if (passwordActual == null || passwordActual.trim().isEmpty() || 
            passwordNuevo == null || passwordNuevo.trim().isEmpty() || 
            passwordNuevoConfirmar == null || passwordNuevoConfirmar.trim().isEmpty()) {
            redirigirConError(usuario, request, response, "Todos los campos son obligatorios");
            return;
        }

        // Validar contraseña actual (comparación directa)
        if (!usuario.getPassword().equals(passwordActual)) {
            redirigirConError(usuario, request, response, "La contraseña actual es incorrecta");
            return;
        }

        // Validar que las contraseñas nuevas coincidan
        if (!passwordNuevo.equals(passwordNuevoConfirmar)) {
            redirigirConError(usuario, request, response, "Las nuevas contraseñas no coinciden");
            return;
        }

        // Cambiar la contraseña en la base de datos
        boolean exito = usuarioDAO.cambiarPassword(usuario.getId(), passwordNuevo);

        if (exito) {
            // Actualizar contraseña en el objeto de sesión
            usuario.setPassword(passwordNuevo);
            session.setAttribute("usuario", usuario);
            redirigirConExito(usuario, request, response, "Contraseña cambiada con éxito");
        } else {
            redirigirConError(usuario, request, response, "Error al cambiar la contraseña en la base de datos");
        }
    }

    private void redirigirConExito(Usuario usuario, HttpServletRequest request, HttpServletResponse response, String msg) 
            throws IOException {
        String rol = usuario.getRolNombre();
        String contextPath = request.getContextPath();
        String param = "?success=" + java.net.URLEncoder.encode(msg, "UTF-8");
        if ("ALUMNO".equals(rol)) {
            response.sendRedirect(contextPath + "/dashboard_alumno.jsp" + param);
        } else if ("DOCENTE".equals(rol)) {
            response.sendRedirect(contextPath + "/dashboard_docente.jsp" + param);
        } else {
            response.sendRedirect(contextPath + "/admin_panel.jsp" + param);
        }
    }

    private void redirigirConError(Usuario usuario, HttpServletRequest request, HttpServletResponse response, String msg) 
            throws IOException {
        String rol = usuario.getRolNombre();
        String contextPath = request.getContextPath();
        String param = "?error=" + java.net.URLEncoder.encode(msg, "UTF-8");
        if ("ALUMNO".equals(rol)) {
            response.sendRedirect(contextPath + "/dashboard_alumno.jsp" + param);
        } else if ("DOCENTE".equals(rol)) {
            response.sendRedirect(contextPath + "/dashboard_docente.jsp" + param);
        } else {
            response.sendRedirect(contextPath + "/admin_panel.jsp" + param);
        }
    }
}
