package pe.edu.usil.poo2.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import pe.edu.usil.poo2.model.entity.Usuario;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"*.jsp", "/controller/*"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Determinar si la solicitud es para la página de login o recursos estáticos
        boolean isLoginPage = requestURI.endsWith("login.jsp") || requestURI.endsWith(contextPath + "/") || requestURI.endsWith("index.html");
        boolean isLoginServlet = requestURI.contains("LoginServlet");
        boolean isStaticResource = requestURI.contains("/imagenes/") || requestURI.contains("/css/") || requestURI.contains("/js/");

        Usuario usuarioLogueado = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        // Si ya está logueado e intenta ingresar al login, redirigir a su respectivo Dashboard
        if (usuarioLogueado != null && (isLoginPage || isLoginServlet)) {
            redirigirADashboard(usuarioLogueado, httpRequest, httpResponse);
            return;
        }

        // Si no está logueado y es una página libre, permitir
        if (isLoginPage || isLoginServlet || isStaticResource) {
            chain.doFilter(request, response);
            return;
        }

        // Si no está logueado y trata de acceder a una página protegida, redirigir a login
        if (usuarioLogueado == null) {
            httpResponse.sendRedirect(contextPath + "/login.jsp?error=Debe+iniciar+sesion");
            return;
        }

        // --- CONTROL DE ACCESO BASADO EN ROLES (RBAC) ---
        String rol = usuarioLogueado.getRolNombre(); // "ADMIN", "DOCENTE", "ALUMNO"

        if (requestURI.contains("dashboard_alumno.jsp") && !"ALUMNO".equals(rol)) {
            redirigirADashboard(usuarioLogueado, httpRequest, httpResponse);
            return;
        }

        if (requestURI.contains("dashboard_docente.jsp") && !"DOCENTE".equals(rol)) {
            redirigirADashboard(usuarioLogueado, httpRequest, httpResponse);
            return;
        }

        if (requestURI.contains("admin_panel.jsp") && !"ADMIN".equals(rol)) {
            redirigirADashboard(usuarioLogueado, httpRequest, httpResponse);
            return;
        }

        // Si cumple con todas las validaciones
        chain.doFilter(request, response);
    }

    private void redirigirADashboard(Usuario usuario, HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String rol = usuario.getRolNombre();
        String contextPath = request.getContextPath();
        switch (rol) {
            case "ALUMNO":
                response.sendRedirect(contextPath + "/dashboard_alumno.jsp");
                break;
            case "DOCENTE":
                response.sendRedirect(contextPath + "/dashboard_docente.jsp");
                break;
            case "ADMIN":
                response.sendRedirect(contextPath + "/admin_panel.jsp");
                break;
            default:
                response.sendRedirect(contextPath + "/login.jsp?error=Rol+no+reconocido");
                break;
        }
    }

    @Override
    public void destroy() {
    }
}
