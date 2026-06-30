package pe.edu.usil.poo2.model.logic;

import pe.edu.usil.poo2.model.entity.Nota;

/**
 * Implementación de la estrategia de evaluación práctica (talleres, laboratorios).
 * Fórmula: Promedio de PCs = (PC1 + PC2 + PC3) / 3.
 */
public class EstrategiaEvaluacionPractica implements IEstrategiaEvaluacion {

    @Override
    public double calcularPromedio(Nota nota) {
        double promedioFinal = (nota.getPc1() + nota.getPc2() + nota.getPc3()) / 3.0;
        
        // Redondear a dos decimales
        return Math.round(promedioFinal * 100.0) / 100.0;
    }
}
