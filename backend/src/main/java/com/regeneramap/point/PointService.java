package com.regeneramap.point;

import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Lógica de negocio de los puntos del mapa.
 */
@Service
public class PointService {

    private final PointRepository pointRepository;

    public PointService(PointRepository pointRepository) {
        this.pointRepository = pointRepository;
    }

    /** Devuelve todos los puntos del mapa como DTOs públicos. */
    @Transactional(readOnly = true)
    public List<PointResponseDto> getAllPoints() {
        return pointRepository.findAll().stream()
                .map(PointResponseDto::from)
                .toList();
    }
}
