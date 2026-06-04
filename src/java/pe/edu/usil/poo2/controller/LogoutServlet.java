package pe.edu.usil.poo2.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/LogoutServlet"})
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        procesarLogout(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        procesarLogout(request, response);
    }

    private void procesarLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // Obtener sesión actual sin crear una nueva
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // Destruir la sesión
        }
        // Redirigir al login con un mensaje de éxito
        response.sendRedirect(request.getContextPath() + "/login.jsp?msg=Sesion+cerrada+correctamente");
    }
}
