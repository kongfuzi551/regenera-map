package com.regeneramap.point;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Acceso a datos de {@link Point}. JpaRepository ya provee {@code findAll()}
 * para recuperar todos los puntos del mapa.
 */
@Repository
public interface PointRepository extends JpaRepository<Point, Long> {
}
