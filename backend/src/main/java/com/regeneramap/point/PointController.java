package com.regeneramap.point;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.List;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * API pública de puntos del mapa. El context-path {@code /api} (configurado en
 * application.yml) hace que estos endpoints cuelguen de {@code /api/points}.
 */
@RestController
@RequestMapping("/points")
@Tag(name = "Points", description = "Puntos del mapa colaborativo")
public class PointController {

    private final PointService pointService;

    public PointController(PointService pointService) {
        this.pointService = pointService;
    }

    /**
     * Lista todos los puntos del mapa. Endpoint público, no requiere autenticación.
     */
    @GetMapping
    @Operation(summary = "Listar todos los puntos del mapa")
    public List<PointResponseDto> getPoints() {
        return pointService.getAllPoints();
    }
}
