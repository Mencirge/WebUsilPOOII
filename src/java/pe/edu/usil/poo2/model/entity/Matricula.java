package pe.edu.usil.poo2.model.entity;

/**
 * Entidad de dominio pura que representa la matrícula de un alumno en un curso.
 */
public class Matricula {
    private int id;
    private int alumnoId;
    private int cursoId;
    private String semestre;

    public Matricula() {
    }

    public Matricula(int id, int alumnoId, int cursoId, String semestre) {
        this.id = id;
        this.alumnoId = alumnoId;
        this.cursoId = cursoId;
        this.semestre = semestre;
    }

    // Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getAlumnoId() {
        return alumnoId;
    }

    public void setAlumnoId(int alumnoId) {
        this.alumnoId = alumnoId;
    }

    public int getCursoId() {
        return cursoId;
    }

    public void setCursoId(int cursoId) {
        this.cursoId = cursoId;
    }

    public String getSemestre() {
        return semestre;
    }

    public void setSemestre(String semestre) {
        this.semestre = semestre;
    }
}
