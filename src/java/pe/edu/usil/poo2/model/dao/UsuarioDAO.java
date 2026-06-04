package pe.edu.usil.poo2.model.dao;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import pe.edu.usil.poo2.model.entity.Usuario;

public class UsuarioDAO {
    // Lista de usuarios en memoria para simulación local sin necesidad de base de datos
    private static final List<Usuario> usuarios = new ArrayList<>();

    static {
        // Roles: 1 = ADMIN, 2 = DOCENTE, 3 = ALUMNO
        
        // ADMINISTRADOR
        usuarios.add(new Usuario(1, "admin@usil.edu.pe", "123456", 1, "ADMIN", "ACTIVO", 0, null, 
                "Administrador de Soporte TI", "AD001"));
        
        // DOCENTES EXISTENTES Y NUEVOS
        usuarios.add(new Usuario(2, "docente@usil.edu.pe", "123456", 2, "DOCENTE", "ACTIVO", 0, null, 
                "Juan Carlos Pérez Silva", "D20210001"));
        usuarios.add(new Usuario(5, "carlos.bravo@usil.pe", "123456", 2, "DOCENTE", "ACTIVO", 0, null, 
                "BRAVO QUISPE, CARLOS JUAN", "D20220101"));
        usuarios.add(new Usuario(6, "tania.torresa@usil.pe", "123456", 2, "DOCENTE", "ACTIVO", 0, null, 
                "TORRES APONTE, TANIA", "D20230202"));
        usuarios.add(new Usuario(7, "luis.salazarma@epg.usil.pe", "123456", 2, "DOCENTE", "ACTIVO", 0, null, 
                "SALAZAR MARIÑOS, LUIS ALBERTO", "D20210303"));
        usuarios.add(new Usuario(8, "marisel.beteta@epg.usil.pe", "123456", 2, "DOCENTE", "ACTIVO", 0, null, 
                "BETETA SALAS, MARISEL ROCIO", "D20240404"));
        usuarios.add(new Usuario(9, "hector.delgadoe@usil.pe", "123456", 2, "DOCENTE", "ACTIVO", 0, null, 
                "DELGADO ENRIQUEZ, HECTOR ODIN", "D20200505"));

        // ALUMNOS EXISTENTES Y NUEVOS
        usuarios.add(new Usuario(3, "alumno@usil.edu.pe", "123456", 3, "ALUMNO", "ACTIVO", 0, null, 
                "Sofía Rossel Mendoza Quispe", "U20221045"));
        usuarios.add(new Usuario(10, "guillermo.hoyos@usil.pe", "mEMO231546789.", 3, "ALUMNO", "ACTIVO", 0, null, 
                "Guillermo Hoyos Palomares", "U20231546"));
        usuarios.add(new Usuario(11, "javier.costa@usil.pe", "123456", 3, "ALUMNO", "ACTIVO", 0, null, 
                "Javier Enrique Costa Saravia", "U20212058"));
        
        // Usuario pre-bloqueado para pruebas
        usuarios.add(new Usuario(4, "bloqueado_test@usil.edu.pe", "123456", 3, "ALUMNO", "BLOQUEADO", 3, 
                new Timestamp(System.currentTimeMillis() + 300 * 1000), "Usuario de Prueba Bloqueado", "U20249999"));
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
