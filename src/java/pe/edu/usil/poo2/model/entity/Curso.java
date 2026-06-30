package pe.edu.usil.poo2.model.entity;

/**
 * Entidad de dominio pura que representa a un Curso académico.
 */
public class Curso {
    private int id;
    private String codigo;
    private String nombre;
    private int creditos;

    public Curso() {
    }

    public Curso(int id, String codigo, String nombre, int creditos) {
        this.id = id;
        this.codigo = codigo;
        this.nombre = nombre;
        this.creditos = creditos;
    }

    // Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public int getCreditos() {
        return creditos;
    }

    public void setCreditos(int creditos) {
        this.creditos = creditos;
    }
}
