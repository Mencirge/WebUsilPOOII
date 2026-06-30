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
import java.util.ArrayList;
import java.util.List;
import pe.edu.usil.poo2.model.entity.Curso;
import pe.edu.usil.poo2.model.entity.Nota;
import pe.edu.usil.poo2.model.entity.Usuario;
import pe.edu.usil.poo2.util.ConexionBD;
import pe.edu.usil.poo2.util.ConfiguracionInstitucion;

/**
 * Servlet encargado de cargar la lista de alumnos matriculados y sus notas para un curso específico.
 * Sirve como puente de datos antes de mostrar el formulario de registro de notas.
 */
@WebServlet(name = "CargarAlumnosServlet", urlPatterns = {"/CargarAlumnosServlet"})
public class CargarAlumnosServlet extends HttpServlet {

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

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Sesion+no+iniciada");
            return;
        }

        String cursoIdStr = request.getParameter("cursoId");
        if (cursoIdStr == null || cursoIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/DashboardDocenteServlet?error=Parametros+incorrectos");
            return;
        }

        int cursoId = Integer.parseInt(cursoIdStr);
        Curso curso = null;
        List<Nota> notas = new ArrayList<>();

        // 1. Obtener detalles del curso de la BD
        String sqlCurso = "SELECT id, codigo, nombre, creditos FROM cursos WHERE id = ?";
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sqlCurso)) {
            ps.setInt(1, cursoId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    curso = new Curso(
                        rs.getInt("id"),
                        rs.getString("codigo"),
                        rs.getString("nombre"),
                        rs.getInt("creditos")
                    );
                }
            }
        } catch (Exception e) {
            System.err.println("Error al cargar curso en CargarAlumnosServlet: " + e.getMessage());
        }

        if (curso == null) {
            response.sendRedirect(request.getContextPath() + "/DashboardDocenteServlet?error=Curso+no+encontrado");
            return;
        }

        // 2. Cargar los alumnos y sus notas desde la BD
        String sqlAlumnos = "SELECT m.id AS matricula_id, a.codigo_alumno, a.nombre || ' ' || a.apellido AS alumno_nombre, "
                          + "COALESCE(n.id, 0) AS nota_id, COALESCE(n.pc1, 0.0) AS pc1, COALESCE(n.pc2, 0.0) AS pc2, "
                          + "COALESCE(n.pc3, 0.0) AS pc3, COALESCE(n.examen_parcial, 0.0) AS ep, "
                          + "COALESCE(n.examen_final, 0.0) AS ef, COALESCE(n.promedio_final, 0.0) AS pf "
                          + "FROM matriculas m "
                          + "JOIN alumnos a ON m.alumno_id = a.id "
                          + "LEFT JOIN notas n ON n.matricula_id = m.id "
                          + "WHERE m.curso_id = ? "
                          + "ORDER BY a.apellido, a.nombre";
        
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sqlAlumnos)) {
            ps.setInt(1, cursoId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Nota nota = new Nota(
                        rs.getInt("nota_id"),
                        rs.getInt("matricula_id"),
                        rs.getDouble("pc1"),
                        rs.getDouble("pc2"),
                        rs.getDouble("pc3"),
                        rs.getDouble("ep"),
                        rs.getDouble("ef"),
                        rs.getDouble("pf"),
                        rs.getString("alumno_nombre"),
                        rs.getString("codigo_alumno")
                    );
                    notas.add(nota);
                }
            }
        } catch (Exception e) {
            System.err.println("Error al cargar alumnos matriculados en CargarAlumnosServlet: " + e.getMessage());
        }

        // 3. Pasar atributos al request
        request.setAttribute("curso", curso);
        request.setAttribute("notas", notas);
        request.setAttribute("configuracion", ConfiguracionInstitucion.getInstancia());

        // 4. Redireccionar hacia docente_notas_form.jsp
        request.getRequestDispatcher("/docente_notas_form.jsp").forward(request, response);
    }
}
