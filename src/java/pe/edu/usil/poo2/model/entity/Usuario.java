package pe.edu.usil.poo2.model.entity;

import java.sql.Timestamp;

public class Usuario {
    private int id;
    private String codigoOCorreo;
    private String password;
    private int rolId;
    private String rolNombre; // Para simplificar acceso al nombre de rol en el filtro y servlet
    private String estado;    // "ACTIVO" o "BLOQUEADO"
    private int intentosFallidos;
    private Timestamp bloqueadoHasta;

    public Usuario() {
    }

    public Usuario(int id, String codigoOCorreo, String password, int rolId, String rolNombre, String estado, int intentosFallidos, Timestamp bloqueadoHasta) {
        this.id = id;
        this.codigoOCorreo = codigoOCorreo;
        this.password = password;
        this.rolId = rolId;
        this.rolNombre = rolNombre;
        this.estado = estado;
        this.intentosFallidos = intentosFallidos;
        this.bloqueadoHasta = bloqueadoHasta;
    }

    // Método auxiliar para saber si el usuario está bloqueado temporalmente
    public boolean isBloqueado() {
        if (bloqueadoHasta != null) {
            long currentTime = System.currentTimeMillis();
            long blockedUntil = bloqueadoHasta.getTime();
            return blockedUntil > currentTime;
        }
        return "BLOQUEADO".equalsIgnoreCase(estado);
    }

    // Método auxiliar para saber cuántos segundos le quedan al bloqueo
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
}
