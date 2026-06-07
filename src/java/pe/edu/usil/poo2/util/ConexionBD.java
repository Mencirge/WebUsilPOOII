package pe.edu.usil.poo2.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionBD {
    // Valores de Supabase por defecto para pruebas locales
    private static final String DEFAULT_HOST = "aws-1-us-west-2.pooler.supabase.com";
    private static final String DEFAULT_PORT = "6543";
    private static final String DEFAULT_DB = "postgres";
    private static final String DEFAULT_USER = "postgres.ttuoechkyixozbtiiuev";
    private static final String DEFAULT_PASS = "bFkRVaBxpKO6Chm1"; // <-- Escribe aquí tu contraseña de Supabase

    public static Connection getConexion() throws SQLException {
        try {
            Class.forName("org.postgresql.Driver");
            
            // Obtener variables de entorno (Render las inyecta de forma segura en producción)
            String host = System.getenv("DB_HOST") != null ? System.getenv("DB_HOST") : DEFAULT_HOST;
            String port = System.getenv("DB_PORT") != null ? System.getenv("DB_PORT") : DEFAULT_PORT;
            String dbName = System.getenv("DB_NAME") != null ? System.getenv("DB_NAME") : DEFAULT_DB;
            String user = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : DEFAULT_USER;
            String pass = System.getenv("DB_PASSWORD") != null ? System.getenv("DB_PASSWORD") : DEFAULT_PASS;
            
            // Construir URL de PostgreSQL para Supabase
            String url = "jdbc:postgresql://" + host + ":" + port + "/" + dbName + "?sslmode=require";
            
            // Si es local y falla sslmode, intentar sin sslmode (solo para localhost)
            if (host.equals("localhost")) {
                url = "jdbc:postgresql://" + host + ":" + port + "/" + dbName;
            }

            return DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver de PostgreSQL no encontrado en el Classpath. Verifique que la librería esté agregada al proyecto.", e);
        }
    }
}
