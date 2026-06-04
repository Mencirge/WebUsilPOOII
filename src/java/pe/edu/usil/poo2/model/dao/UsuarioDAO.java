package pe.edu.usil.poo2.model.dao;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import pe.edu.usil.poo2.model.entity.Usuario;

public class UsuarioDAO {
    // Lista de usuarios en memoria para simulación local sin necesidad de base de datos
    private static final List<Usuario> usuarios = new ArrayList<>();

    static {
        // Inicializar usuarios semilla en memoria
        // Roles: 1 = ADMIN, 2 = DOCENTE, 3 = ALUMNO
        usuarios.add(new Usuario(1, "admin@usil.edu.pe", "123456", 1, "ADMIN", "ACTIVO", 0, null));
        usuarios.add(new Usuario(2, "docente@usil.edu.pe", "123456", 2, "DOCENTE", "ACTIVO", 0, null));
        usuarios.add(new Usuario(3, "alumno@usil.edu.pe", "123456", 3, "ALUMNO", "ACTIVO", 0, null));
        // Usuario pre-bloqueado para pruebas del panel de administración
        usuarios.add(new Usuario(4, "bloqueado_test@usil.edu.pe", "123456", 3, "ALUMNO", "BLOQUEADO", 3, 
                new Timestamp(System.currentTimeMillis() + 300 * 1000))); // Bloqueado por 5 minutos
    }

    public Usuario obtenerPorCodigoOCorreo(String codigoOCorreo) {
        if (codigoOCorreo == null) return null;
        for (Usuario u : usuarios) {
            if (u.getCodigoOCorreo().equalsIgnoreCase(codigoOCorreo.trim())) {
                return u; 
            }
        }
        return null;
    }

    public void registrarIntentoFallido(int usuarioId, int intentos) {
        for (Usuario u : usuarios) {
            if (u.getId() == usuarioId) {
                u.setIntentosFallidos(intentos);
                break;
            }
        }
    }

    public void bloquearUsuarioTemporalmente(int usuarioId, int minutos) {
        for (Usuario u : usuarios) {
            if (u.getId() == usuarioId) {
                u.setEstado("BLOQUEADO");
                // Calcular timestamp futuro para el desbloqueo
                u.setBloqueadoHasta(new Timestamp(System.currentTimeMillis() + ((long) minutos * 60 * 1000)));
                break;
            }
        }
    }

    public void resetearIntentosFallidos(int usuarioId) {
        for (Usuario u : usuarios) {
            if (u.getId() == usuarioId) {
                u.setIntentosFallidos(0);
                u.setEstado("ACTIVO");
                u.setBloqueadoHasta(null);
                break;
            }
        }
    }
}
