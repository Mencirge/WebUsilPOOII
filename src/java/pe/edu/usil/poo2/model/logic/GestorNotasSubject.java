package pe.edu.usil.poo2.model.logic;

import java.util.ArrayList;
import java.util.List;
import pe.edu.usil.poo2.model.entity.Nota;

/**
 * Sujeto (Subject) del patrón Observer.
 * Publica eventos de notas a los observadores registrados tras procesar el cálculo.
 */
public class GestorNotasSubject {

    private final List<IObserverAuditoria> observadores = new ArrayList<>();

    /**
     * Agrega un nuevo observador a la lista de suscripción.
     * @param obs El observador de auditoría.
     */
    public void agregarObservador(IObserverAuditoria obs) {
        if (obs != null && !observadores.contains(obs)) {
            observadores.add(obs);
        }
    }

    /**
     * Remueve un observador de la lista de suscripción.
     * @param obs El observador de auditoría.
     */
    public void removerObservador(IObserverAuditoria obs) {
        if (obs != null) {
            observadores.remove(obs);
        }
    }

    /**
     * Notifica a todos los observadores registrados sobre la actualización.
     * @param nota La nota modificada.
     * @param usuarioDocente El docente responsable del cambio.
     */
    public void notificarObservadores(Nota nota, String usuarioDocente) {
        for (IObserverAuditoria obs : observadores) {
            obs.onNotaActualizada(nota, usuarioDocente);
        }
    }

    /**
     * Método principal que procesa la nota inyectando la estrategia de evaluación
     * seleccionada y notifica a los observadores.
     * 
     * @param nota La entidad de notas a procesar.
     * @param estrategia La estrategia de evaluación a aplicar (Strategy).
     * @param usuarioDocente El docente que realiza el cambio.
     */
    public void procesarYGuardarNota(Nota nota, IEstrategiaEvaluacion estrategia, String usuarioDocente) {
        // 1. Calcular el promedio de la nota inyectando la estrategia (Strategy)
        double nuevoPromedio = estrategia.calcularPromedio(nota);
        
        // 2. Asignar ese promedio a la nota
        nota.setPromedioFinal(nuevoPromedio);
        
        // 3. Invocar la notificación a los observadores (Observer)
        notificarObservadores(nota, usuarioDocente);
    }
}
