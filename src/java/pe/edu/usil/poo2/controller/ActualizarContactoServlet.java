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
 * Servlet controlador encargado de gestionar la actualización de datos de contacto del usuario.
 * Redirige de vuelta a los dashboards controladores correspondientes tras completar la acción.
 */
@WebServlet(name = "ActualizarContactoServlet", urlPatterns = {"/controller/ActualizarContactoServlet"})
public class ActualizarContactoServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

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
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Sesion+no+iniciada");
            return;
        }

        String correoPersonal = request.getParameter("correo_personal");
        String telefono = request.getParameter("telefono");

        if (correoPersonal == null || correoPersonal.trim().isEmpty() || 
            telefono == null || telefono.trim().isEmpty()) {
            redirigirConError(usuario, request, response, "Todos los campos son obligatorios");
            return;
        }

        boolean exito = usuarioDAO.actualizarContacto(usuario.getId(), correoPersonal, telefono);

        if (exito) {
            // Actualizar el objeto de sesión
            usuario.setCorreoPersonal(correoPersonal.trim());
            usuario.setTelefono(telefono.trim());
            session.setAttribute("usuarioLogueado", usuario);
            session.setAttribute("usuario", usuario);
            redirigirConExito(usuario, request, response, "Datos de contacto actualizados");
        } else {
            redirigirConError(usuario, request, response, "Error al guardar los datos en la base de datos");
        }
    }

    private void redirigirConExito(Usuario usuario, HttpServletRequest request, HttpServletResponse response, String msg) 
            throws IOException {
        String rol = usuario.getRolNombre();
        String contextPath = request.getContextPath();
        String param = "?success=" + java.net.URLEncoder.encode(msg, "UTF-8");
        if ("ALUMNO".equals(rol)) {
            response.sendRedirect(contextPath + "/DashboardAlumnoServlet" + param);
        } else if ("DOCENTE".equals(rol)) {
            response.sendRedirect(contextPath + "/DashboardDocenteServlet" + param);
        } else {
            response.sendRedirect(contextPath + "/AdminDashboardServlet" + param);
        }
    }

    private void redirigirConError(Usuario usuario, HttpServletRequest request, HttpServletResponse response, String msg) 
            throws IOException {
        String rol = usuario.getRolNombre();
        String contextPath = request.getContextPath();
        String param = "?error=" + java.net.URLEncoder.encode(msg, "UTF-8");
        if ("ALUMNO".equals(rol)) {
            response.sendRedirect(contextPath + "/DashboardAlumnoServlet" + param);
        } else if ("DOCENTE".equals(rol)) {
            response.sendRedirect(contextPath + "/DashboardDocenteServlet" + param);
        } else {
            response.sendRedirect(contextPath + "/AdminDashboardServlet" + param);
        }
    }
}
