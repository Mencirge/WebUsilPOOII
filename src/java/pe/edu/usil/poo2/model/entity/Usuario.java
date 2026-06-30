package pe.edu.usil.poo2.model.entity;

import java.sql.Timestamp;

/**
 * Entidad de dominio pura que representa a un Usuario del sistema.
 * Agrupa credenciales, estado de bloqueo, e información de contacto.
 */
public class Usuario {
    private int id;
    private String codigoOCorreo;
    private String password;
    private int rolId;
    private int intentosFallidos;
    private Timestamp bloqueadoHasta;
    private String correoPersonal;
    private String telefono;
    private String estado; // ACTIVO/BLOQUEADO

    // Campos auxiliares para la capa de presentación (manteniendo compatibilidad)
    private String rolNombre; 
    private String nombreCompleto;
    private String codigoAlumnoODocente;

    public Usuario() {
    }

    public Usuario(int id, String codigoOCorreo, String password, int rolId, String rolNombre, String estado, 
                   int intentosFallidos, Timestamp bloqueadoHasta, String nombreCompleto, String codigoAlumnoODocente) {
        this.id = id;
        this.codigoOCorreo = codigoOCorreo;
        this.password = password;
        this.rolId = rolId;
        this.rolNombre = rolNombre;
        this.estado = estado;
        this.intentosFallidos = intentosFallidos;
        this.bloqueadoHasta = bloqueadoHasta;
        this.nombreCompleto = nombreCompleto;
        this.codigoAlumnoODocente = codigoAlumnoODocente;
    }

    public Usuario(int id, String codigoOCorreo, String password, int rolId, String rolNombre, String estado, 
                   int intentosFallidos, Timestamp bloqueadoHasta, String nombreCompleto, String codigoAlumnoODocente,
                   String correoPersonal, String telefono) {
        this(id, codigoOCorreo, password, rolId, rolNombre, estado, intentosFallidos, bloqueadoHasta, nombreCompleto, codigoAlumnoODocente);
        this.correoPersonal = correoPersonal;
        this.telefono = telefono;
    }

    // Helper methods para bloqueo temporal
    public boolean isBloqueado() {
        if (bloqueadoHasta != null) {
            long currentTime = System.currentTimeMillis();
            long blockedUntil = bloqueadoHasta.getTime();
            return blockedUntil > currentTime;
        }
        return "BLOQUEADO".equalsIgnoreCase(estado);
    }

    public long getSegundosRestantesBloqueo() {
        if (bloqueadoHasta != null) {
            long diff = bloqueadoHasta.getTime() - System.currentTimeMillis();
            if (diff > 0) {
                return diff / 1000;
            }
        }
        return 0;
    }

    // Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCodigoOCorreo() {
        return codigoOCorreo;
    }

    public void setCodigoOCorreo(String codigoOCorreo) {
        this.codigoOCorreo = codigoOCorreo;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getRolId() {
        return rolId;
    }

    public void setRolId(int rolId) {
        this.rolId = rolId;
    }

    public int getIntentosFallidos() {
        return intentosFallidos;
    }

    public void setIntentosFallidos(int intentosFallidos) {
        this.intentosFallidos = intentosFallidos;
    }

    public Timestamp getBloqueadoHasta() {
        return bloqueadoHasta;
    }

    public void setBloqueadoHasta(Timestamp bloqueadoHasta) {
        this.bloqueadoHasta = bloqueadoHasta;
    }

    public String getCorreoPersonal() {
        return correoPersonal;
    }

    public void setCorreoPersonal(String correoPersonal) {
        this.correoPersonal = correoPersonal;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getRolNombre() {
        return rolNombre;
    }

    public void setRolNombre(String rolNombre) {
        this.rolNombre = rolNombre;
    }

    public String getNombreCompleto() {
        return nombreCompleto;
    }

    public void setNombreCompleto(String nombreCompleto) {
        this.nombreCompleto = nombreCompleto;
    }

    public String getCodigoAlumnoODocente() {
        return codigoAlumnoODocente;
    }

    public void setCodigoAlumnoODocente(String codigoAlumnoODocente) {
        this.codigoAlumnoODocente = codigoAlumnoODocente;
    }
}
