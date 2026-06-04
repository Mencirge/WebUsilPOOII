package pe.edu.usil.poo2.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionBD {
    // Valores por defecto (locales) si no se configuran variables de entorno en Render
    private static final String DEFAULT_HOST = "localhost";
    private static final String DEFAULT_PORT = "5432";
    private static final String DEFAULT_DB = "usil_poo2_db";
    private static final String DEFAULT_USER = "postgres";
    private static final String DEFAULT_PASS = "admin";

    public static Connection getConexion() throws SQLException {
        try {
            Class.forName("org.postgresql.Driver");
            
            // Obtener variables de entorno (Render las inyecta de forma segura)
            String host = System.getenv("DB_HOST") != null ? System.getenv("DB_HOST") : DEFAULT_HOST;
            String port = System.getenv("DB_PORT") != null ? System.getenv("DB_PORT") : DEFAULT_PORT;
            String dbName = System.getenv("DB_NAME") != null ? System.getenv("DB_NAME") : DEFAULT_DB;
            String user = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : DEFAULT_USER;
            String pass = System.getenv("DB_PASSWORD") != null ? System.getenv("DB_PASSWORD") : DEFAULT_PASS;
            
            // Construir URL de PostgreSQL
            String url = "jdbc:postgresql://" + host + ":" + port + "/" + dbName + "?sslmode=require";
            
            // Si es local y falla sslmode, intentar sin sslmode como fallback
            if (host.equals("localhost")) {
                url = "jdbc:postgresql://" + host + ":" + port + "/" + dbName;
            }

            return DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver de PostgreSQL no encontrado en el Classpath. Verifique que la librería esté agregada al proyecto.", e);
        }
    }
}
