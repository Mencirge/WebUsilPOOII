package pe.edu.usil.poo2.model.logic;

import pe.edu.usil.poo2.model.entity.Nota;

/**
 * Interfaz para el patrón Observer.
 * Define la acción a ejecutar cuando ocurre un cambio en las calificaciones.
 */
public interface IObserverAuditoria {

    /**
     * Se gatilla de forma reactiva cuando una nota es actualizada.
     * @param nota La nota que ha sido modificada.
     * @param usuarioDocente El código o correo del docente que realiza la modificación.
     */
    void onNotaActualizada(Nota nota, String usuarioDocente);
}
