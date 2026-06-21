package com.regeneramap.point;

/**
 * Categoría de un punto del mapa. Se corresponde con la restricción CHECK
 * de la columna {@code points.category} definida en la migración V1.
 */
public enum PointCategory {
    /** Zona degradada, basura, árbol enfermo... (rojo) */
    PROBLEMA,
    /** Sugerencia de mejora (azul) */
    PROPUESTA,
    /** Acción completada por un administrador (verde) */
    INTERVENCION
}
