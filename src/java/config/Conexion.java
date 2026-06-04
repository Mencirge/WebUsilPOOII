package config;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    // Estos datos deben coincidir con tu base de datos en Render
    private String url = "jdbc:postgresql://dpg-d8gcronlk1mc73eoetg0-a.ohio-postgres.render.com:5432/bd_universidad_poo2?sslmode=require";
    private String user = "bd_universidad_poo2_user";
    private String pass = "D9uNBVOi0OlAMwecUzQhf6RjFbWDQ13F";
    private Connection con;

    public Connection getConnection() {
        try {
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection(url, user, pass);
            System.out.println("Conexión exitosa a Render!");
        } catch (Exception e) {
            System.err.println("Error de conexión: " + e.getMessage());
        }
        return con;
    }
}