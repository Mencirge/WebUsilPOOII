package pe.edu.usil.poo2.model.logic;

import pe.edu.usil.poo2.model.entity.Usuario;

/**
 * Fábrica (Factory Pattern) para instanciar y configurar objetos Usuario
 * según su rol institucional (ALUMNO o DOCENTE).
 */
public class UsuarioFactory {

    /**
     * Crea y pre-configura un objeto Usuario según el rol especificado.
     * 
     * @param tipoRol El rol del usuario ("ALUMNO" o "DOCENTE").
     * @param id El identificador único del usuario.
     * @param nombre El nombre del usuario.
     * @param apellido El apellido del usuario.
     * @param correo El correo electrónico institucional.
     * @param password La contraseña de acceso.
     * @param codigo El código de alumno o docente.
     * @return Un objeto Usuario configurado con sus atributos correspondientes.
     */
    public static Usuario crearUsuario(String tipoRol, int id, String nombre, String apellido, 
                                       String correo, String password, String codigo) {
        
        Usuario usuario = new Usuario();
        usuario.setId(id);
        usuario.setCodigoOCorreo(correo != null ? correo.trim() : "");
        usuario.setPassword(password);
        usuario.setEstado("ACTIVO");
        usuario.setIntentosFallidos(0);
        usuario.setBloqueadoHasta(null);
        usuario.setNombreCompleto((nombre != null ? nombre.trim() : "") + " " + (apellido != null ? apellido.trim() : ""));
        usuario.setCodigoAlumnoODocente(codigo != null ? codigo.trim() : "");
        
        // Configurar ID de Rol y Nombre de Rol correspondiente
        if ("ALUMNO".equalsIgnoreCase(tipoRol)) {
            usuario.setRolId(3);
            usuario.setRolNombre("ALUMNO");
        } else if ("DOCENTE".equalsIgnoreCase(tipoRol)) {
            usuario.setRolId(2);
            usuario.setRolNombre("DOCENTE");
        } else if ("ADMIN".equalsIgnoreCase(tipoRol)) {
            usuario.setRolId(1);
            usuario.setRolNombre("ADMIN");
        } else {
            // Rol por defecto: ALUMNO
            usuario.setRolId(3);
            usuario.setRolNombre("ALUMNO");
        }
        
        return usuario;
    }
}
