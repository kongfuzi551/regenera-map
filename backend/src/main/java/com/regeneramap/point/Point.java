package com.regeneramap.point;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.OffsetDateTime;

/**
 * Punto del mapa: PROBLEMA, PROPUESTA o INTERVENCION.
 * Mapea la tabla {@code points} de la migración V1.
 *
 * <p>La ubicación se almacena como GEOMETRY(Point, 4326) en PostGIS y se mapea
 * al tipo JTS {@link org.locationtech.jts.geom.Point} gracias a hibernate-spatial.
 */
@Entity
@Table(name = "points")
public class Point {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /** Autor del punto. Puede ser null si el usuario fue eliminado (ON DELETE SET NULL). */
    @Column(name = "user_id")
    private Long userId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private PointCategory category;

    @Column(nullable = false)
    private String title;

    @Column
    private String description;

    /** Ubicación en WGS84 (SRID 4326). getX() = longitud, getY() = latitud. */
    @Column(nullable = false)
    private org.locationtech.jts.geom.Point location;

    /** Vínculo opcional a otro punto (p. ej. una INTERVENCION que resuelve un PROBLEMA). */
    @Column(name = "linked_to")
    private Long linkedTo;

    @Column(name = "created_at", nullable = false)
    private OffsetDateTime createdAt;

    protected Point() {
        // Constructor sin argumentos requerido por JPA.
    }

    public Long getId() {
        return id;
    }

    public Long getUserId() {
        return userId;
    }

    public PointCategory getCategory() {
        return category;
    }

    public String getTitle() {
        return title;
    }

    public String getDescription() {
        return description;
    }

    public org.locationtech.jts.geom.Point getLocation() {
        return location;
    }

    public Long getLinkedTo() {
        return linkedTo;
    }

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }
}
