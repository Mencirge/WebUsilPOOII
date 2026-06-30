package pe.edu.usil.poo2.model.logic;

import pe.edu.usil.poo2.model.entity.Nota;

/**
 * Implementación de la estrategia de evaluación regular.
 * Fórmula: 30% Promedio PCs (PC1, PC2, PC3) + 30% Examen Parcial + 40% Examen Final.
 */
public class EstrategiaEvaluacionRegular implements IEstrategiaEvaluacion {

    @Override
    public double calcularPromedio(Nota nota) {
        double promedioPC = (nota.getPc1() + nota.getPc2() + nota.getPc3()) / 3.0;
        double promedioFinal = (promedioPC * 0.3) + (nota.getExamenParcial() * 0.3) + (nota.getExamenFinal() * 0.4);
        
        // Redondear a dos decimales
        return Math.round(promedioFinal * 100.0) / 100.0;
    }
}
