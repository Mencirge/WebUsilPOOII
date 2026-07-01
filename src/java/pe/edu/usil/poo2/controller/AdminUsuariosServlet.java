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
 * Servlet controlador encargado de la gestión de usuarios (CRUD) y control de bloqueo/desbloqueo.
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

        } else if ("toggleStatus".equalsIgnoreCase(action)) {
            // Acción de Bloquear/Desbloquear
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                int targetId = Integer.parseInt(idStr);
                
                // Impedir autobloqueo
                if (targetId == usuario.getId()) {
                    response.sendRedirect(request.getContextPath() + "/AdminUsuariosServlet?action=list&error=No+puede+bloquearse+a+si+mismo");
                    return;
                }

                String sqlGet = "SELECT estado FROM usuarios WHERE id = ?";
                String estadoActual = "ACTIVO";
                try (Connection con = ConexionBD.getConexion();
                     PreparedStatement ps = con.prepareStatement(sqlGet)) {
                    ps.setInt(1, targetId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            estadoActual = rs.getString("estado");
                        }
                    }
                } catch (SQLException e) {
                    System.err.println("Error al consultar estado de usuario: " + e.getMessage());
                }

                String nuevoEstado = "BLOQUEADO".equalsIgnoreCase(estadoActual) ? "ACTIVO" : "BLOQUEADO";
                String sqlUpdate = "UPDATE usuarios SET estado = ?, intentos_fallidos = 0, bloqueado_hasta = NULL WHERE id = ?";
                
                try (Connection con = ConexionBD.getConexion();
                     PreparedStatement ps = con.prepareStatement(sqlUpdate)) {
                    ps.setString(1, nuevoEstado);
                    ps.setInt(2, targetId);
                    ps.executeUpdate();
                    System.out.println("[ADMIN-CRUD] Estado de usuario ID " + targetId + " cambiado a " + nuevoEstado);
                    response.sendRedirect(request.getContextPath() + "/AdminUsuariosServlet?action=list&success=Estado+de+cuenta+actualizado+a+" + nuevoEstado);
                } catch (SQLException e) {
                    System.err.println("Error al actualizar estado del usuario: " + e.getMessage());
                    response.sendRedirect(request.getContextPath() + "/AdminUsuariosServlet?action=list&error=Error+al+cambiar+estado");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/AdminUsuariosServlet?action=list&error=ID+invalido");
            }

        } else if ("form".equalsIgnoreCase(action) || "edit".equalsIgnoreCase(action)) {
            // Cargar datos para edición si corresponde
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty() && "edit".equalsIgnoreCase(action)) {
                int targetId = Integer.parseInt(idStr);
                String sqlGet = "SELECT u.id, u.codigo_o_correo, u.password, u.rol_id, r.nombre AS rol_nombre, "
                               + "COALESCE(a.nombre, d.nombre, '') AS nombre, "
                               + "COALESCE(a.apellido, d.apellido, '') AS apellido, "
                               + "COALESCE(a.codigo_alumno, d.codigo_docente, '') AS codigo_alumno_o_docente "
                               + "FROM usuarios u "
                               + "JOIN roles r ON u.rol_id = r.id "
                               + "LEFT JOIN alumnos a ON u.id = a.usuario_id "
                               + "LEFT JOIN docentes d ON u.id = d.usuario_id "
                               + "WHERE u.id = ?";
                try (Connection con = ConexionBD.getConexion();
                     PreparedStatement ps = con.prepareStatement(sqlGet)) {
                    ps.setInt(1, targetId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            Usuario u = new Usuario();
                            u.setId(rs.getInt("id"));
                            u.setCodigoOCorreo(rs.getString("codigo_o_correo"));
                            u.setPassword(rs.getString("password"));
                            u.setRolId(rs.getInt("rol_id"));
                            u.setRolNombre(rs.getString("rol_nombre"));
                            
                            request.setAttribute("userEdit", u);
                            request.setAttribute("nombre", rs.getString("nombre"));
                            request.setAttribute("apellido", rs.getString("apellido"));
                            request.setAttribute("codigo", rs.getString("codigo_alumno_o_docente"));
                        }
                    }
                } catch (SQLException e) {
                    System.err.println("Error al cargar datos de usuario para edicion: " + e.getMessage());
                }
            }
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

        // Recibir parámetros del formulario
        String idStr = request.getParameter("id"); // Solo presente en edición
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

        if (idStr != null && !idStr.trim().isEmpty()) {
            // PROCESAR EDICIÓN (UPDATE)
            int userId = Integer.parseInt(idStr);
            String updateUsuario = "UPDATE usuarios SET codigo_o_correo = ?, password = ?, rol_id = ? WHERE id = ?";
            
            try (Connection con = ConexionBD.getConexion()) {
                con.setAutoCommit(false); // Iniciar Transacción
                
                int rolId = "ALUMNO".equalsIgnoreCase(rol) ? 2 : 3;
                try (PreparedStatement psUsr = con.prepareStatement(updateUsuario)) {
                    psUsr.setString(1, correo.trim());
                    psUsr.setString(2, password.trim());
                    psUsr.setInt(3, rolId);
                    psUsr.setInt(4, userId);
                    psUsr.executeUpdate();
                }
                
                if (rolId == 2) { // ALUMNO
                    String updateAlumno = "UPDATE alumnos SET nombre = ?, apellido = ?, codigo_alumno = ? WHERE usuario_id = ?";
                    try (PreparedStatement psAlu = con.prepareStatement(updateAlumno)) {
                        psAlu.setString(1, nombre.trim());
                        psAlu.setString(2, apellido.trim());
                        psAlu.setString(3, codigo.trim());
                        psAlu.setInt(4, userId);
                        psAlu.executeUpdate();
                    }
                } else { // DOCENTE
                    String updateDocente = "UPDATE docentes SET nombre = ?, apellido = ?, codigo_docente = ? WHERE usuario_id = ?";
                    try (PreparedStatement psDoc = con.prepareStatement(updateDocente)) {
                        psDoc.setString(1, nombre.trim());
                        psDoc.setString(2, apellido.trim());
                        psDoc.setString(3, codigo.trim());
                        psDoc.setInt(4, userId);
                        psDoc.executeUpdate();
                    }
                }
                con.commit(); // Confirmar Transacción
                System.out.println("[ADMIN-CRUD] Usuario editado con éxito. ID: " + userId);
                response.sendRedirect(request.getContextPath() + "/AdminUsuariosServlet?action=list&success=Usuario+actualizado+correctamente");
            } catch (SQLException e) {
                System.err.println("Error al editar usuario en la base de datos: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/AdminUsuariosServlet?action=list&error=Error+Base+de+Datos:+" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
            }
        } else {
            // PROCESAR CREACIÓN (INSERT)
            Usuario nuevoUsuario = UsuarioFactory.crearUsuario(rol, 0, nombre, apellido, correo, password, codigo);
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
                            psAlu.setString(5, "Ingeniería de Sistemas de Información");
                            psAlu.setInt(6, 1);
                            psAlu.executeUpdate();
                        }
                    } else if ("DOCENTE".equals(nuevoUsuario.getRolNombre())) {
                        String insertDocente = "INSERT INTO docentes (usuario_id, nombre, apellido, codigo_docente, especialidad) VALUES (?, ?, ?, ?, ?)";
                        try (PreparedStatement psDoc = con.prepareStatement(insertDocente)) {
                            psDoc.setInt(1, nuevoUsuarioId);
                            psDoc.setString(2, nombre.trim());
                            psDoc.setString(3, apellido.trim());
                            psDoc.setString(4, codigo.trim());
                            psDoc.setString(5, "Programación Orientada a Objetos II");
                            psDoc.executeUpdate();
                        }
                    }
                    con.commit(); // Confirmar Transacción
                    System.out.println("[ADMIN-CRUD] Usuario Creado con éxito. ID: " + nuevoUsuarioId);
                    response.sendRedirect(request.getContextPath() + "/AdminUsuariosServlet?action=list&success=Usuario+creado+con+exito");
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
}
