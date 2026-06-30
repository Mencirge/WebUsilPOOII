package pe.edu.usil.poo2.model.repository;

import java.util.List;

/**
 * Interfaz genérica para aplicar el patrón Repository sobre las entidades de dominio.
 * Define las operaciones CRUD (Crear, Leer, Actualizar, Eliminar) estándar.
 * 
 * @param <T> Representa el tipo de la entidad de dominio.
 */
public interface IRepository<T> {

    /**
     * Inserta una nueva entidad en la base de datos.
     * @param entidad La entidad a crear.
     * @return true si la inserción fue exitosa, false en caso contrario.
     */
    boolean crear(T entidad);

    /**
     * Recupera todos los registros de la entidad desde la base de datos.
     * @return Una lista conteniendo todas las entidades encontradas.
     */
    List<T> leerTodos();

    /**
     * Busca una entidad específica a partir de su identificador único.
     * @param id El identificador único de la entidad.
     * @return La entidad correspondiente al ID, o null si no se encuentra.
     */
    T leerPorId(int id);

    /**
     * Actualiza los atributos de una entidad existente en la base de datos.
     * @param entidad La entidad con los datos modificados.
     * @return true si la actualización fue exitosa, false en caso contrario.
     */
    boolean actualizar(T entidad);

    /**
     * Elimina un registro de la base de datos a partir de su ID.
     * @param id El identificador único del registro a eliminar.
     * @return true si la eliminación fue exitosa, false en caso contrario.
     */
    boolean eliminar(int id);
}
