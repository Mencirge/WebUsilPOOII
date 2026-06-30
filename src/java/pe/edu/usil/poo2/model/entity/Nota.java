package pe.edu.usil.poo2.model.entity;

/**
 * Entidad de dominio pura que representa las notas de una matrícula particular.
 */
public class Nota {
    private int id;
    private int matriculaId;
    private double pc1;
    private double pc2;
    private double pc3;
    private double examenParcial;
    private double examenFinal;
    private double promedioFinal;

    // Campos auxiliares para la capa de presentación (JSTL)
    private String cursoNombre;
    private String cursoCodigo;
    private int creditos;
    private String alumnoNombre;
    private String codigoAlumno;

    public Nota() {
    }

    public Nota(int id, int matriculaId, double pc1, double pc2, double pc3, double examenParcial, double examenFinal, double promedioFinal) {
        this.id = id;
        this.matriculaId = matriculaId;
        this.pc1 = pc1;
        this.pc2 = pc2;
        this.pc3 = pc3;
        this.examenParcial = examenParcial;
        this.examenFinal = examenFinal;
        this.promedioFinal = promedioFinal;
    }

    public Nota(int id, int matriculaId, double pc1, double pc2, double pc3, double examenParcial, double examenFinal, double promedioFinal,
                String cursoNombre, String cursoCodigo, int creditos) {
        this(id, matriculaId, pc1, pc2, pc3, examenParcial, examenFinal, promedioFinal);
        this.cursoNombre = cursoNombre;
        this.cursoCodigo = cursoCodigo;
        this.creditos = creditos;
    }

    public Nota(int id, int matriculaId, double pc1, double pc2, double pc3, double examenParcial, double examenFinal, double promedioFinal,
                String alumnoNombre, String codigoAlumno) {
        this(id, matriculaId, pc1, pc2, pc3, examenParcial, examenFinal, promedioFinal);
        this.alumnoNombre = alumnoNombre;
        this.codigoAlumno = codigoAlumno;
    }

    // Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getMatriculaId() {
        return matriculaId;
    }

    public void setMatriculaId(int matriculaId) {
        this.matriculaId = matriculaId;
    }

    public double getPc1() {
        return pc1;
    }

    public void setPc1(double pc1) {
        this.pc1 = pc1;
    }

    public double getPc2() {
        return pc2;
    }

    public void setPc2(double pc2) {
        this.pc2 = pc2;
    }

    public double getPc3() {
        return pc3;
    }

    public void setPc3(double pc3) {
        this.pc3 = pc3;
    }

    public double getExamenParcial() {
        return examenParcial;
    }

    public void setExamenParcial(double examenParcial) {
        this.examenParcial = examenParcial;
    }

    public double getExamenFinal() {
        return examenFinal;
    }

    public void setExamenFinal(double examenFinal) {
        this.examenFinal = examenFinal;
    }

    public double getPromedioFinal() {
        return promedioFinal;
    }

    public void setPromedioFinal(double promedioFinal) {
        this.promedioFinal = promedioFinal;
    }

    public String getCursoNombre() {
        return cursoNombre;
    }

    public void setCursoNombre(String cursoNombre) {
        this.cursoNombre = cursoNombre;
    }

    public String getCursoCodigo() {
        return cursoCodigo;
    }

    public void setCursoCodigo(String cursoCodigo) {
        this.cursoCodigo = cursoCodigo;
    }

    public int getCreditos() {
        return creditos;
    }

    public void setCreditos(int creditos) {
        this.creditos = creditos;
    }

    public String getAlumnoNombre() {
        return alumnoNombre;
    }

    public void setAlumnoNombre(String alumnoNombre) {
        this.alumnoNombre = alumnoNombre;
    }

    public String getCodigoAlumno() {
        return codigoAlumno;
    }

    public void setCodigoAlumno(String codigoAlumno) {
        this.codigoAlumno = codigoAlumno;
    }
}
