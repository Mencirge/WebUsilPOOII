package pe.edu.usil.poo2.model.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import pe.edu.usil.poo2.model.entity.Alumno;
import pe.edu.usil.poo2.util.ConexionBD;

/**
 * Implementación concreta del Repositorio para la entidad Alumno.
 * Gestiona el ciclo de vida de los registros de la tabla 'alumnos' en PostgreSQL.
 */
public class AlumnoRepository implements IRepository<Alumno> {

    @Override
    public boolean crear(Alumno alumno) {
        String sql = "INSERT INTO alumnos (usuario_id, nombre, apellido, codigo_alumno, carrera, ciclo) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, alumno.getUsuarioId());
            ps.setString(2, alumno.getNombre());
            ps.setString(3, alumno.getApellido());
            ps.setString(4, alumno.getCodigoAlumno());
            ps.setString(5, alumno.getCarrera());
            ps.setInt(6, alumno.getCiclo());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al insertar alumno: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Alumno> leerTodos() {
        List<Alumno> lista = new ArrayList<>();
        String sql = "SELECT id, usuario_id, nombre, apellido, codigo_alumno, carrera, ciclo FROM alumnos ORDER BY apellido, nombre";
        
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Alumno alumno = new Alumno(
                    rs.getInt("id"),
                    rs.getInt("usuario_id"),
                    rs.getString("nombre"),
                    rs.getString("apellido"),
                    rs.getString("codigo_alumno"),
                    rs.getString("carrera"),
                    rs.getInt("ciclo")
                );
                lista.add(alumno);
            }
            
        } catch (SQLException e) {
            System.err.println("Error al leer listado de alumnos: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    @Override
    public Alumno leerPorId(int id) {
        String sql = "SELECT id, usuario_id, nombre, apellido, codigo_alumno, carrera, ciclo FROM alumnos WHERE id = ?";
        
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Alumno(
                        rs.getInt("id"),
                        rs.getInt("usuario_id"),
                        rs.getString("nombre"),
                        rs.getString("apellido"),
                        rs.getString("codigo_alumno"),
                        rs.getString("carrera"),
                        rs.getInt("ciclo")
                    );
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al leer alumno por ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean actualizar(Alumno alumno) {
        String sql = "UPDATE alumnos SET usuario_id = ?, nombre = ?, apellido = ?, codigo_alumno = ?, carrera = ?, ciclo = ? WHERE id = ?";
        
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, alumno.getUsuarioId());
            ps.setString(2, alumno.getNombre());
            ps.setString(3, alumno.getApellido());
            ps.setString(4, alumno.getCodigoAlumno());
            ps.setString(5, alumno.getCarrera());
            ps.setInt(6, alumno.getCiclo());
            ps.setInt(7, alumno.getId());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al actualizar datos del alumno: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean eliminar(int id) {
        String sql = "DELETE FROM alumnos WHERE id = ?";
        
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al eliminar alumno: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Recupera un alumno a partir de su ID de usuario vinculado.
     * @param usuarioId El ID de usuario.
     * @return El Alumno encontrado, o null si no se encuentra.
     */
    public Alumno obtenerPorUsuarioId(int usuarioId) {
        String sql = "SELECT id, usuario_id, nombre, apellido, codigo_alumno, carrera, ciclo FROM alumnos WHERE usuario_id = ?";
        
        try (Connection con = ConexionBD.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, usuarioId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Alumno(
                        rs.getInt("id"),
                        rs.getInt("usuario_id"),
                        rs.getString("nombre"),
                        rs.getString("apellido"),
                        rs.getString("codigo_alumno"),
                        rs.getString("carrera"),
                        rs.getInt("ciclo")
                    );
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener alumno por usuario_id: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}
