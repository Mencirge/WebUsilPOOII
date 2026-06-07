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

@WebServlet(name = "GuardarNotasServlet", urlPatterns = {"/controller/GuardarNotasServlet"})
public class GuardarNotasServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        // Validar sesión y rol de docente
        if (usuario == null || !"DOCENTE".equals(usuario.getRolNombre())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=No+autorizado");
            return;
        }

        String[] matriculaIds = request.getParameterValues("matricula_ids");
        if (matriculaIds == null || matriculaIds.length == 0) {
            response.sendRedirect(request.getContextPath() + "/dashboard_docente.jsp?error=No+se+encontraron+alumnos+para+guardar");
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
                    response.sendRedirect(request.getContextPath() + "/dashboard_docente.jsp?error=Las+notas+deben+estar+entre+0+y+20");
                    return;
                }

                // Calcular promedio final: 30% Promedio PCs (PC1+PC2+PC3)/3 + 30% EP + 40% EF
                double promPC = (pc1 + pc2 + pc3) / 3.0;
                double promedioFinal = (promPC * 0.3) + (ep * 0.3) + (ef * 0.4);
                double promedioFinalRedondeado = Math.round(promedioFinal * 100.0) / 100.0;

                // Actualizar en base de datos
                boolean exito = usuarioDAO.actualizarNotas(matriculaId, pc1, pc2, pc3, ep, ef, promedioFinalRedondeado);
                if (!exito) {
                    todosExitosos = false;
                }
            }

            if (todosExitosos) {
                response.sendRedirect(request.getContextPath() + "/dashboard_docente.jsp?success=Notas+actualizadas+correctamente");
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard_docente.jsp?error=Algunas+notas+no+se+pudieron+guardar");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/dashboard_docente.jsp?error=Formato+de+nota+invalido");
        }
    }
}
