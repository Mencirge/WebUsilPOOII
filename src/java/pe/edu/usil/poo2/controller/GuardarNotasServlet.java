package pe.edu.usil.poo2.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import pe.edu.usil.poo2.model.dao.UsuarioDAO;
import pe.edu.usil.poo2.model.entity.Nota;
import pe.edu.usil.poo2.model.entity.Usuario;
import pe.edu.usil.poo2.model.logic.EstrategiaEvaluacionRegular;
import pe.edu.usil.poo2.model.logic.GestorNotasSubject;
import pe.edu.usil.poo2.model.logic.IEstrategiaEvaluacion;
import pe.edu.usil.poo2.model.logic.RegistroAuditoriaObserver;

/**
 * Servlet controlador encargado de procesar el guardado de notas.
 * Aplica los patrones Strategy (cálculo) y Observer (auditoría/registro) antes de persistir en BD.
 */
@WebServlet(name = "GuardarNotasServlet", urlPatterns = {"/controller/GuardarNotasServlet"})
public class GuardarNotasServlet extends HttpServlet {

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

        // Validar sesión y rol de docente
        if (usuario == null || !"DOCENTE".equals(usuario.getRolNombre())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=No+autorizado");
            return;
        }

        // Obtener parámetros del formulario (procesamiento por fila de alumno)
        String[] matriculaIds = request.getParameterValues("matricula_ids");
        if (matriculaIds == null || matriculaIds.length == 0) {
            response.sendRedirect(request.getContextPath() + "/DashboardDocenteServlet?error=No+se+encontraron+alumnos");
            return;
        }

        boolean todosExitosos = true;

        try {
            for (String mIdStr : matriculaIds) {
                int matriculaId = Integer.parseInt(mIdStr);

                // Obtener parámetros de notas para esta matrícula
                String pc1Str = request.getParameter("pc1_" + matriculaId);
                String pc2Str = request.getParameter("pc2_" + matriculaId);
                String pc3Str = request.getParameter("pc3_" + matriculaId);
                String epStr = request.getParameter("ep_" + matriculaId);
                String efStr = request.getParameter("ef_" + matriculaId);

                double pc1 = (pc1Str != null && !pc1Str.trim().isEmpty()) ? Double.parseDouble(pc1Str) : 0.0;
                double pc2 = (pc2Str != null && !pc2Str.trim().isEmpty()) ? Double.parseDouble(pc2Str) : 0.0;
                double pc3 = (pc3Str != null && !pc3Str.trim().isEmpty()) ? Double.parseDouble(pc3Str) : 0.0;
                double ep = (epStr != null && !epStr.trim().isEmpty()) ? Double.parseDouble(epStr) : 0.0;
                double ef = (efStr != null && !efStr.trim().isEmpty()) ? Double.parseDouble(efStr) : 0.0;

                // Validar rango de notas (0 a 20)
                if (pc1 < 0 || pc1 > 20 || pc2 < 0 || pc2 > 20 || pc3 < 0 || pc3 > 20 || ep < 0 || ep > 20 || ef < 0 || ef > 20) {
                    response.sendRedirect(request.getContextPath() + "/DashboardDocenteServlet?error=Notas+deben+estar+entre+0+y+20");
                    return;
                }

                // INTEGRACIÓN DE PATRONES DE DISEÑO (FASE 3)
                
                // 1. Instanciar la entidad Nota con los valores recibidos
                Nota nota = new Nota();
                nota.setMatriculaId(matriculaId);
                nota.setPc1(pc1);
                nota.setPc2(pc2);
                nota.setPc3(pc3);
                nota.setExamenParcial(ep);
                nota.setExamenFinal(ef);

                // 2. Instanciar EstrategiaEvaluacionRegular (Strategy)
                IEstrategiaEvaluacion estrategia = new EstrategiaEvaluacionRegular();

                // 3. Instanciar GestorNotasSubject (Sujeto) y añadirle un RegistroAuditoriaObserver (Observer)
                GestorNotasSubject gestor = new GestorNotasSubject();
                gestor.agregarObservador(new RegistroAuditoriaObserver());

                // 4. Procesar promedio y notificar observadores reactivos en consola
                gestor.procesarYGuardarNota(nota, estrategia, usuario.getCodigoOCorreo());

                // 5. Persistencia real en PostgreSQL (Supabase)
                boolean exitoBD = usuarioDAO.actualizarNotas(
                    nota.getMatriculaId(),
                    nota.getPc1(),
                    nota.getPc2(),
                    nota.getPc3(),
                    nota.getExamenParcial(),
                    nota.getExamenFinal(),
                    nota.getPromedioFinal()
                );
                
                if (!exitoBD) {
                    todosExitosos = false;
                }
            }

            if (todosExitosos) {
                // Redirige de vuelta al dashboard del docente indicando éxito
                response.sendRedirect(request.getContextPath() + "/DashboardDocenteServlet?success=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/DashboardDocenteServlet?error=Error+al+guardar+algunas+notas");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/DashboardDocenteServlet?error=Formato+de+nota+invalido");
        }
    }
}
