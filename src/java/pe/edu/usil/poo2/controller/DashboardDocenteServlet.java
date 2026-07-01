package pe.edu.usil.poo2.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import pe.edu.usil.poo2.model.entity.Curso;
import pe.edu.usil.poo2.model.entity.Usuario;
import pe.edu.usil.poo2.util.ConexionBD;
import pe.edu.usil.poo2.util.ConfiguracionInstitucion;

/**
 * Servlet controlador encargado de gestionar el Dashboard del Docente.
 * Carga los cursos asignados al docente desde la BD utilizando JDBC.
 */
@WebServlet(name = "DashboardDocenteServlet", urlPatterns = {"/DashboardDocenteServlet"})
public class DashboardDocenteServlet extends HttpServlet {

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

        // Si no hay sesión válida, redirigir al login
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Sesion+no+iniciada");
            return;
        }

        // Obtener cursos del docente conectando a PostgreSQL
        List<Curso> cursos = new ArrayList<>();
        String sql = "SELECT c.id, c.codigo, c.nombre, c.creditos "
                   + "FROM cursos c "
                   + "JOIN docentes d ON c.nombre = d.especialidad "
                   + "WHERE d.usuario_id = ?";

        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, usuario.getId());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    cursos.add(new Curso(
                        rs.getInt("id"),
                        rs.getString("codigo"),
                        rs.getString("nombre"),
                        rs.getInt("creditos")
                    ));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al cargar cursos reales del docente: " + e.getMessage());
        }

        // Obtener configuración de marca blanca (Singleton)
        ConfiguracionInstitucion configuracion = ConfiguracionInstitucion.getInstancia();

        // Pasar atributos al request
        request.setAttribute("cursos", cursos);
        request.setAttribute("configuracion", configuracion);
        request.setAttribute("docente", usuario);

        // Redireccionar hacia la vista docente_dashboard.jsp
        request.getRequestDispatcher("/docente_dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
