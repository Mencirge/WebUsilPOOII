package pe.edu.usil.poo2.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import pe.edu.usil.poo2.model.entity.Usuario;
import pe.edu.usil.poo2.util.ConexionBD;

public class UsuarioDAO {

    public Usuario obtenerPorCodigoOCorreo(String codigoOCorreo) {
        if (codigoOCorreo == null || codigoOCorreo.trim().isEmpty()) {
            return null;
        }
        String sql = "SELECT u.id, u.codigo_o_correo, u.password, u.rol_id, r.nombre AS rol_nombre, "
                   + "u.estado, u.intentos_fallidos, u.bloqueado_hasta, "
                   + "COALESCE(a.nombre || ' ' || a.apellido, d.nombre || ' ' || d.apellido, 'Administrador') AS nombre_completo, "
                   + "COALESCE(a.codigo_alumno, d.codigo_docente, 'AD001') AS codigo_alumno_o_docente, "
                   + "u.correo_personal, u.telefono "
                   + "FROM usuarios u "
                   + "JOIN roles r ON u.rol_id = r.id "
                   + "LEFT JOIN alumnos a ON u.id = a.usuario_id "
                   + "LEFT JOIN docentes d ON u.id = d.usuario_id "
                   + "WHERE u.codigo_o_correo = ? OR a.codigo_alumno = ? OR d.codigo_docente = ?";
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            String val = codigoOCorreo.trim();
            ps.setString(1, val);
            ps.setString(2, val);
            ps.setString(3, val);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Usuario(
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
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener usuario de la BD: " + e.getMessage());
        }
        return null;
    }

    public void registrarIntentoFallido(int usuarioId, int intentos) {
        String sql = "UPDATE usuarios SET intentos_fallidos = ? WHERE id = ?";
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, intentos);
            ps.setInt(2, usuarioId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error al registrar intento fallido en la BD: " + e.getMessage());
        }
    }

    public void bloquearUsuarioTemporalmente(int usuarioId, int minutos) {
        String sql = "UPDATE usuarios SET estado = 'BLOQUEADO', bloqueado_hasta = ? WHERE id = ?";
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            Timestamp bloqueadoHasta = new Timestamp(System.currentTimeMillis() + ((long) minutos * 60 * 1000));
            ps.setTimestamp(1, bloqueadoHasta);
            ps.setInt(2, usuarioId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error al bloquear usuario en la BD: " + e.getMessage());
        }
    }

    public void resetearIntentosFallidos(int usuarioId) {
        String sql = "UPDATE usuarios SET intentos_fallidos = 0, estado = 'ACTIVO', bloqueado_hasta = NULL WHERE id = ?";
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error al resetear intentos fallidos en la BD: " + e.getMessage());
        }
    }

    public boolean actualizarContacto(int usuarioId, String correoPersonal, String telefono) {
        String sql = "UPDATE usuarios SET correo_personal = ?, telefono = ? WHERE id = ?";
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, correoPersonal != null ? correoPersonal.trim() : null);
            ps.setString(2, telefono != null ? telefono.trim() : null);
            ps.setInt(3, usuarioId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar contacto en la BD: " + e.getMessage());
            return false;
        }
    }

    public boolean cambiarPassword(int usuarioId, String nuevoPassword) {
        String sql = "UPDATE usuarios SET password = ? WHERE id = ?";
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nuevoPassword);
            ps.setInt(2, usuarioId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al cambiar contraseña en la BD: " + e.getMessage());
            return false;
        }
    }
}
