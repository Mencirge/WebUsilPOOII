package pe.edu.usil.poo2.model.entity;

import java.sql.Timestamp;

public class Usuario {
    private int id;
    private String codigoOCorreo;
    private String password;
    private int rolId;
    private String rolNombre; 
    private String estado;    
    private int intentosFallidos;
    private Timestamp bloqueadoHasta;
    
    // Nuevos campos para mostrar datos dinámicos de alumnos y docentes
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

    public String getRolNombre() {
        return rolNombre;
    }

    public void setRolNombre(String rolNombre) {
        this.rolNombre = rolNombre;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
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
