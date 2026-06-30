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
import pe.edu.usil.poo2.model.entity.Alumno;
import pe.edu.usil.poo2.model.entity.Nota;
import pe.edu.usil.poo2.model.entity.Usuario;
import pe.edu.usil.poo2.model.repository.AlumnoRepository;
import pe.edu.usil.poo2.util.ConfiguracionInstitucion;

/**
 * Servlet controlador encargado de gestionar el Dashboard del Alumno.
 * Carga el perfil del alumno y sus calificaciones para transferirlos a la vista JSP.
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
            // Se asume "usuarioLogueado" según requerimiento, con "usuario" como fallback de compatibilidad
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
        
        // Robustez: si es un usuario de prueba sin registro en la tabla de alumnos, creamos datos mock
        if (alumno == null) {
            alumno = new Alumno(
                1, 
                usuario.getId(), 
                usuario.getNombreCompleto() != null ? usuario.getNombreCompleto().split(" ")[0] : "Estudiante", 
                usuario.getNombreCompleto() != null && usuario.getNombreCompleto().contains(" ") ? usuario.getNombreCompleto().substring(usuario.getNombreCompleto().indexOf(" ") + 1) : "USIL", 
                usuario.getCodigoAlumnoODocente() != null ? usuario.getCodigoAlumnoODocente() : "U20269999", 
                "Ingeniería de Sistemas de Información", 
                2
            );
        }

        // 2. Simular/instanciar lista de notas (las cuales corresponden a sus matrículas del semestre)
        List<Nota> notas = new ArrayList<>();
        notas.add(new Nota(1, 101, 15.0, 14.0, 16.0, 15.0, 14.0, 14.70, "Programación Orientada a Objetos II", "POO2", 5));
        notas.add(new Nota(2, 102, 12.0, 13.0, 15.0, 11.0, 12.0, 12.50, "Matemática Discreta", "MD", 4));
        notas.add(new Nota(3, 103, 16.0, 15.0, 14.0, 17.0, 16.0, 15.80, "Interacción Humano Computador", "IHC", 3));
        notas.add(new Nota(4, 104, 11.0, 10.0, 12.0, 11.0, 13.0, 11.70, "Cálculo de una Variable", "CAL1", 4));
        notas.add(new Nota(5, 105, 15.0, 14.0, 16.0, 15.0, 16.0, 15.30, "Estadística Descriptiva", "EST1", 4));

        // 3. Instanciar ConfiguracionInstitucion Singleton para marca blanca
        ConfiguracionInstitucion configuracion = ConfiguracionInstitucion.getInstancia();

        // 4. Pasar atributos a la solicitud (request)
        request.setAttribute("alumno", alumno);
        request.setAttribute("notas", notas);
        request.setAttribute("configuracion", configuracion);
        
        // Mantener compatibilidad con el objeto usuario de la sesión para mostrar correos
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
