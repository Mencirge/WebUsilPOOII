package pe.edu.usil.poo2.model.logic;

import pe.edu.usil.poo2.model.entity.Nota;

/**
 * Interfaz para el patrón Strategy de cálculo de promedios.
 * Permite cambiar la fórmula de evaluación dinámicamente según el tipo de curso.
 */
public interface IEstrategiaEvaluacion {

    /**
     * Calcula el promedio final en base a las notas registradas.
     * @param nota La entidad Nota conteniendo las calificaciones parciales.
     * @return El promedio final calculado y redondeado.
     */
    double calcularPromedio(Nota nota);
}
