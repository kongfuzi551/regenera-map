package com.regeneramap.point;

import java.time.OffsetDateTime;

/**
 * Representación pública de un punto del mapa.
 * La geometría se aplana a {@code latitude}/{@code longitude} para que el
 * frontend (Leaflet) la consuma directamente.
 */
public record PointResponseDto(
        Long id,
        PointCategory category,
        String title,
        String description,
        double latitude,
        double longitude,
        OffsetDateTime createdAt
) {

    /** Construye el DTO a partir de la entidad, extrayendo lat/lng de la geometría JTS. */
    public static PointResponseDto from(Point point) {
        org.locationtech.jts.geom.Point location = point.getLocation();
        return new PointResponseDto(
                point.getId(),
                point.getCategory(),
                point.getTitle(),
                point.getDescription(),
                location.getY(),
                location.getX(),
                point.getCreatedAt()
        );
    }
}
