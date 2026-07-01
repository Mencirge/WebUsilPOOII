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
import pe.edu.usil.poo2.model.entity.Alumno;
import pe.edu.usil.poo2.model.entity.Nota;
import pe.edu.usil.poo2.model.entity.Usuario;
import pe.edu.usil.poo2.model.repository.AlumnoRepository;
import pe.edu.usil.poo2.util.ConexionBD;
import pe.edu.usil.poo2.util.ConfiguracionInstitucion;

/**
 * Servlet controlador encargado de gestionar el Dashboard del Alumno.
 * Carga el perfil del alumno y sus calificaciones reales de la BD para transferirlos a la vista JSP.
 */
@WebServlet(name = "DashboardAlumnoServlet", urlPatterns = {"/DashboardAlumnoServlet"})
public class DashboardAlumnoServlet extends HttpServlet {

    private final AlumnoRepository alumnoRepository = new AlumnoRepository();

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

        // 1. Obtener los datos del alumno de la base de datos usando el repositorio
        Alumno alumno = alumnoRepository.obtenerPorUsuarioId(usuario.getId());
        
        if (alumno == null) {
            // Robustez: si es un usuario sin registro en la tabla de alumnos, creamos datos mock de contingencia
            alumno = new Alumno(
                1, 
                usuario.getId(), 
                usuario.getNombreCompleto() != null ? usuario.getNombreCompleto().split(" ")[0] : "Estudiante", 
                usuario.getNombreCompleto() != null && usuario.getNombreCompleto().contains(" ") ? usuario.getNombreCompleto().substring(usuario.getNombreCompleto().indexOf(" ") + 1) : "USIL", 
                usuario.getCodigoAlumnoODocente() != null ? usuario.getCodigoAlumnoODocente() : "U20269999", 
                "Ingeniería de Sistemas de Información", 
                1
            );
        }

        // 2. Obtener calificaciones reales del alumno conectando a PostgreSQL
        List<Nota> notas = new ArrayList<>();
        String sql = "SELECT n.id AS nota_id, m.id AS matricula_id, c.nombre AS curso_nombre, c.codigo AS curso_codigo, c.creditos, "
                   + "COALESCE(n.pc1, 0.00) AS pc1, COALESCE(n.pc2, 0.00) AS pc2, COALESCE(n.pc3, 0.00) AS pc3, "
                   + "COALESCE(n.examen_parcial, 0.00) AS examen_parcial, COALESCE(n.examen_final, 0.00) AS examen_final, "
                   + "COALESCE(n.promedio_final, 0.00) AS promedio_final "
                   + "FROM matriculas m "
                   + "JOIN cursos c ON m.curso_id = c.id "
                   + "LEFT JOIN notas n ON n.matricula_id = m.id "
                   + "WHERE m.alumno_id = ?";

        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, alumno.getId());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    notas.add(new Nota(
                        rs.getInt("nota_id"),
                        rs.getInt("matricula_id"),
                        rs.getDouble("pc1"),
                        rs.getDouble("pc2"),
                        rs.getDouble("pc3"),
                        rs.getDouble("examen_parcial"),
                        rs.getDouble("examen_final"),
                        rs.getDouble("promedio_final"),
                        rs.getString("curso_nombre"),
                        rs.getString("curso_codigo"),
                        rs.getInt("creditos")
                    ));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al cargar notas reales del alumno: " + e.getMessage());
        }

        // 3. Instanciar ConfiguracionInstitucion Singleton para marca blanca
        ConfiguracionInstitucion configuracion = ConfiguracionInstitucion.getInstancia();

        // 4. Pasar atributos a la solicitud (request)
        request.setAttribute("alumno", alumno);
        request.setAttribute("notas", notas);
        request.setAttribute("configuracion", configuracion);
        request.setAttribute("usuarioPerfil", usuario);

        // 5. Redireccionar hacia la vista alumno_dashboard.jsp
        request.getRequestDispatcher("/alumno_dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
