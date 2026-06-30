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
import pe.edu.usil.poo2.model.entity.Usuario;
import pe.edu.usil.poo2.model.logic.UsuarioFactory;
import pe.edu.usil.poo2.util.ConexionBD;
import pe.edu.usil.poo2.util.ConfiguracionInstitucion;

/**
 * Servlet controlador encargado de la gestión de usuarios (CRUD).
 * Utiliza el patrón Factory para la creación de instancias de usuario.
 */
@WebServlet(name = "AdminUsuariosServlet", urlPatterns = {"/AdminUsuariosServlet"})
public class AdminUsuariosServlet extends HttpServlet {

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

        // Validar rol de administrador
        if (usuario == null || !"ADMIN".equals(usuario.getRolNombre())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Acceso+denegado");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        ConfiguracionInstitucion configuracion = ConfiguracionInstitucion.getInstancia();
        request.setAttribute("configuracion", configuracion);

        if ("list".equalsIgnoreCase(action)) {
            List<Usuario> usuarios = new ArrayList<>();
            
            // Cargar todos los usuarios desde la base de datos PostgreSQL
            String sql = "SELECT u.id, u.codigo_o_correo, u.password, u.rol_id, r.nombre AS rol_nombre, "
                       + "u.estado, u.intentos_fallidos, u.bloqueado_hasta, "
                       + "COALESCE(a.nombre || ' ' || a.apellido, d.nombre || ' ' || d.apellido, 'Administrador') AS nombre_completo, "
                       + "COALESCE(a.codigo_alumno, d.codigo_docente, 'AD001') AS codigo_alumno_o_docente, "
                       + "u.correo_personal, u.telefono "
                       + "FROM usuarios u "
                       + "JOIN roles r ON u.rol_id = r.id "
                       + "LEFT JOIN alumnos a ON u.id = a.usuario_id "
                       + "LEFT JOIN docentes d ON u.id = d.usuario_id "
                       + "ORDER BY u.id DESC";

            try (Connection con = ConexionBD.getConexion();
                 PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Usuario u = new Usuario(
                        rs.getInt("id"),
                        rs.getString("codigo_o_correo"),
                        rs.getString("password"),
                        rs.getInt("rol_id"),
                        rs.getString("rol_nombre"),
                        rs.getString("estado"),
                        rs.getInt("intentos_fallidos"),
                        rs.getTimestamp("bloqueado_hasta"),
                        rs.getString("nombre_completo"),
                        rs.getString("codigo_alumno_o_docente"),
                        rs.getString("correo_personal"),
                        rs.getString("telefono")
                    );
                    usuarios.add(u);
                }

            } catch (SQLException e) {
                System.err.println("Error al cargar usuarios para el admin: " + e.getMessage());
            }

            request.setAttribute("usuarios", usuarios);
            request.getRequestDispatcher("/admin_usuarios.jsp").forward(request, response);

        } else if ("form".equalsIgnoreCase(action)) {
            // Redirige al formulario de creación
            request.getRequestDispatcher("/admin_usuario_form.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuarioAdmin = null;
        if (session != null) {
            usuarioAdmin = (Usuario) session.getAttribute("usuarioLogueado");
            if (usuarioAdmin == null) {
                usuarioAdmin = (Usuario) session.getAttribute("usuario");
            }
        }

        // Validar rol de administrador
        if (usuarioAdmin == null || !"ADMIN".equals(usuarioAdmin.getRolNombre())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Acceso+denegado");
            return;
        }

        // Recibir parámetros del formulario de creación
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String correo = request.getParameter("correo");
        String password = request.getParameter("password");
        String rol = request.getParameter("rol"); // ALUMNO o DOCENTE
        String codigo = request.getParameter("codigo");

        if (nombre == null || apellido == null || correo == null || password == null || rol == null || codigo == null) {
            response.sendRedirect(request.getContextPath() + "/AdminUsuariosServlet?action=form&error=Campos+obligatorios");
            return;
        }

        // 1. Usar el UsuarioFactory (Patrón Factory) para instanciar el Usuario
        Usuario nuevoUsuario = UsuarioFactory.crearUsuario(rol, 0, nombre, apellido, correo, password, codigo);

        // 2. Persistencia real en la BD PostgreSQL mediante Transacciones JDBC directas
        String insertUsuario = "INSERT INTO usuarios (codigo_o_correo, password, rol_id, estado) VALUES (?, ?, ?, ?) RETURNING id";
        
        try (Connection con = ConexionBD.getConexion()) {
            con.setAutoCommit(false); // Iniciar Transacción

            int nuevoUsuarioId = 0;
            try (PreparedStatement psUsr = con.prepareStatement(insertUsuario)) {
                psUsr.setString(1, nuevoUsuario.getCodigoOCorreo());
                psUsr.setString(2, nuevoUsuario.getPassword());
                psUsr.setInt(3, nuevoUsuario.getRolId());
                psUsr.setString(4, nuevoUsuario.getEstado());
                
                try (ResultSet rs = psUsr.executeQuery()) {
                    if (rs.next()) {
                        nuevoUsuarioId = rs.getInt(1);
                    }
                }
            }

            if (nuevoUsuarioId > 0) {
                if ("ALUMNO".equals(nuevoUsuario.getRolNombre())) {
                    String insertAlumno = "INSERT INTO alumnos (usuario_id, nombre, apellido, codigo_alumno, carrera, ciclo) VALUES (?, ?, ?, ?, ?, ?)";
                    try (PreparedStatement psAlu = con.prepareStatement(insertAlumno)) {
                        psAlu.setInt(1, nuevoUsuarioId);
                        psAlu.setString(2, nombre.trim());
                        psAlu.setString(3, apellido.trim());
                        psAlu.setString(4, codigo.trim());
                        psAlu.setString(5, "Ingeniería de Sistemas de Información"); // Carrera por defecto
                        psAlu.setInt(6, 1); // Ciclo inicial por defecto
                        psAlu.executeUpdate();
                    }
                } else if ("DOCENTE".equals(nuevoUsuario.getRolNombre())) {
                    String insertDocente = "INSERT INTO docentes (usuario_id, nombre, apellido, codigo_docente, especialidad) VALUES (?, ?, ?, ?, ?)";
                    try (PreparedStatement psDoc = con.prepareStatement(insertDocente)) {
                        psDoc.setInt(1, nuevoUsuarioId);
                        psDoc.setString(2, nombre.trim());
                        psDoc.setString(3, apellido.trim());
                        psDoc.setString(4, codigo.trim());
                        psDoc.setString(5, "Programación Orientada a Objetos II"); // Especialidad por defecto
                        psDoc.executeUpdate();
                    }
                }
                con.commit(); // Confirmar Transacción
                System.out.println("[ADMIN-CRUD] Usuario Creado con éxito via Factory. ID: " + nuevoUsuarioId);
                response.sendRedirect(request.getContextPath() + "/AdminUsuariosServlet?action=list&success=true");
            } else {
                con.rollback();
                response.sendRedirect(request.getContextPath() + "/AdminUsuariosServlet?action=form&error=Error+al+guardar+usuario");
            }

        } catch (SQLException e) {
            System.err.println("Error al insertar usuario en la base de datos: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/AdminUsuariosServlet?action=form&error=Error+Base+de+Datos:+" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }
}
