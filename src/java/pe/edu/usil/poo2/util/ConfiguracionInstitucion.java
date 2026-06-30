package pe.edu.usil.poo2.util;

/**
 * Clase Singleton para el manejo de la configuración institucional (White-Label).
 * Permite personalizar la apariencia y datos de la institución educativa.
 */
public class ConfiguracionInstitucion {

    private static ConfiguracionInstitucion instancia;

    private String nombreInstitucion;
    private String colorPrincipalHex;
    private String logoUrl;

    // Constructor privado para evitar instanciación externa (estricto Singleton)
    private ConfiguracionInstitucion() {
        // Inicialización con valores por defecto
        this.nombreInstitucion = "Colegio San Ignacio";
        this.colorPrincipalHex = "#0d6efd";
        this.logoUrl = "assets/img/logo_default.png";
    }

    // Método de inicialización perezosa (Lazy Initialization)
    public static synchronized ConfiguracionInstitucion getInstancia() {
        if (instancia == null) {
            instancia = new ConfiguracionInstitucion();
        }
        return instancia;
    }

    // Getters y Setters
    public String getNombreInstitucion() {
        return nombreInstitucion;
    }

    public void setNombreInstitucion(String nombreInstitucion) {
        this.nombreInstitucion = nombreInstitucion;
    }

    public String getColorPrincipalHex() {
        return colorPrincipalHex;
    }

    public void setColorPrincipalHex(String colorPrincipalHex) {
        this.colorPrincipalHex = colorPrincipalHex;
    }

    public String getLogoUrl() {
        return logoUrl;
    }

    public void setLogoUrl(String logoUrl) {
        this.logoUrl = logoUrl;
    }
}
