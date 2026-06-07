package config;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    // Estos datos coinciden con tu base de datos en Supabase (Pooler)
    private String url = "jdbc:postgresql://aws-1-us-west-2.pooler.supabase.com:6543/postgres?sslmode=require";
    private String user = "postgres.ttuoechkyixozbtiiuev";
    private String pass = "bFkRVaBxpKO6Chm1";
    private Connection con;

    public Connection getConnection() {
        try {
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection(url, user, pass);
            System.out.println("Conexión exitosa a Supabase!");
        } catch (Exception e) {
            System.err.println("Error de conexión: " + e.getMessage());
        }
        return con;
    }
}