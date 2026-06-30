package pe.edu.usil.poo2.model.logic;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import pe.edu.usil.poo2.model.entity.Nota;

/**
 * Observador concreto encargado del logging y auditoría de seguridad del sistema.
 * Registra en consola las modificaciones de notas realizadas por los docentes.
 */
public class RegistroAuditoriaObserver implements IObserverAuditoria {

    @Override
    public void onNotaActualizada(Nota nota, String usuarioDocente) {
        LocalDateTime ahora = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
        
        System.out.println("[AUDITORIA] - " + ahora.format(formatter) 
                + " | El docente '" + usuarioDocente 
                + "' actualizó la nota de la matrícula ID: " + nota.getMatriculaId() 
                + " (Registro Nota ID: " + nota.getId() + "). "
                + "PC1: " + nota.getPc1() + " | PC2: " + nota.getPc2() + " | PC3: " + nota.getPc3()
                + " | EP: " + nota.getExamenParcial() + " | EF: " + nota.getExamenFinal()
                + " | Promedio Final Calculado: " + nota.getPromedioFinal());
    }
}
