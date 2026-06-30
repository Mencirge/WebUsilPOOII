package pe.edu.usil.poo2.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import pe.edu.usil.poo2.model.entity.Curso;
import pe.edu.usil.poo2.model.entity.Usuario;
import pe.edu.usil.poo2.util.ConfiguracionInstitucion;

/**
 * Servlet controlador encargado de gestionar el Dashboard del Docente.
 * Carga los cursos asignados y los transfiere a la vista JSP de selección.
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

        // 1. Simular la lista de cursos asignados al docente utilizando la entidad Curso
        List<Curso> cursos = new ArrayList<>();
        cursos.add(new Curso(5, "POO2", "Programación Orientada a Objetos II", 5));
        cursos.add(new Curso(2, "EST1", "Estadística Descriptiva e Inferencia Estadística", 4));
        cursos.add(new Curso(3, "IHC", "Interacción Humano Computador", 3));

        // 2. Obtener configuración de marca blanca (Singleton)
        ConfiguracionInstitucion configuracion = ConfiguracionInstitucion.getInstancia();

        // 3. Pasar atributos al request
        request.setAttribute("cursos", cursos);
        request.setAttribute("configuracion", configuracion);
        request.setAttribute("docente", usuario);

        // 4. Redireccionar hacia la vista docente_dashboard.jsp
        request.getRequestDispatcher("/docente_dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
