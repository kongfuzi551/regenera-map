-- V2__seed_data.sql
-- Datos de ejemplo para el MVP en Alcobendas y San Sebastián de los Reyes.
-- Incluye dos usuarios semilla y 6 puntos (2 PROBLEMA, 2 PROPUESTA, 2 INTERVENCION).
-- Coordenadas en SRID 4326 (WGS84). ST_MakePoint recibe (longitud, latitud).

-- =============================================================
-- Usuarios semilla
-- =============================================================
INSERT INTO users (google_id, email, nick, avatar_url, role, active) VALUES
    ('seed-admin-001',  'admin@regenera.local',  'EquipoRegenera', NULL, 'ADMIN',       TRUE),
    ('seed-vecino-001', 'vecino@regenera.local',  'VecinaAlcoSanse', NULL, 'COLABORADOR', TRUE);

-- =============================================================
-- Puntos (ids 1..6 por BIGSERIAL en orden de inserción)
-- =============================================================

-- --- PROBLEMA (rojo) -----------------------------------------

-- 1) Alcobendas — Parque de Andalucía
INSERT INTO points (user_id, category, title, description, location) VALUES (
    (SELECT id FROM users WHERE nick = 'VecinaAlcoSanse'),
    'PROBLEMA',
    'Basura acumulada en el Parque de Andalucía',
    'Desde hace semanas se acumulan bolsas de basura y restos de poda junto a la zona de juegos infantiles del Parque de Andalucía. Atrae insectos y genera mal olor, especialmente con el calor.',
    ST_SetSRID(ST_MakePoint(-3.63858, 40.54430), 4326)
);

-- 2) San Sebastián de los Reyes — Avenida de España
INSERT INTO points (user_id, category, title, description, location) VALUES (
    (SELECT id FROM users WHERE nick = 'VecinaAlcoSanse'),
    'PROBLEMA',
    'Árbol enfermo con riesgo de caída en la Avenida de España',
    'Un plátano de sombra de la mediana de la Avenida de España presenta el tronco hueco y ramas secas. Con viento fuerte pierde ramas sobre la acera, suponiendo un peligro para los peatones.',
    ST_SetSRID(ST_MakePoint(-3.62680, 40.54820), 4326)
);

-- --- PROPUESTA (azul) ----------------------------------------

-- 3) Alcobendas — Paseo de la Chopera
INSERT INTO points (user_id, category, title, description, location) VALUES (
    (SELECT id FROM users WHERE nick = 'VecinaAlcoSanse'),
    'PROPUESTA',
    'Carril bici que conecte el Paseo de la Chopera con el centro',
    'Propuesta de un carril bici segregado a lo largo del Paseo de la Chopera para unir la zona residencial con el centro de Alcobendas y fomentar la movilidad sostenible.',
    ST_SetSRID(ST_MakePoint(-3.64200, 40.53980), 4326)
);

-- 4) San Sebastián de los Reyes — Plaza de la Constitución
INSERT INTO points (user_id, category, title, description, location) VALUES (
    (SELECT id FROM users WHERE nick = 'VecinaAlcoSanse'),
    'PROPUESTA',
    'Más sombra y arbolado en la Plaza de la Constitución',
    'La Plaza de la Constitución carece de sombra en verano. Se propone plantar arbolado de hoja caduca y colocar pérgolas vegetales para hacerla más habitable durante los meses de calor.',
    ST_SetSRID(ST_MakePoint(-3.62560, 40.54750), 4326)
);

-- --- INTERVENCION (verde) ------------------------------------

-- 5) Alcobendas — Parque de Cataluña (vinculada al problema 1)
INSERT INTO points (user_id, category, title, description, location, linked_to) VALUES (
    (SELECT id FROM users WHERE nick = 'EquipoRegenera'),
    'INTERVENCION',
    'Limpieza y reforestación del Parque de Cataluña',
    'Jornada de limpieza completada por el equipo municipal: retirada de residuos, poda de seguridad y plantación de 30 nuevos arbustos autóctonos en el Parque de Cataluña.',
    ST_SetSRID(ST_MakePoint(-3.64470, 40.53960), 4326),
    (SELECT id FROM points WHERE title = 'Basura acumulada en el Parque de Andalucía')
);

-- 6) San Sebastián de los Reyes — Parque de la Marina (vinculada al problema 2)
INSERT INTO points (user_id, category, title, description, location, linked_to) VALUES (
    (SELECT id FROM users WHERE nick = 'EquipoRegenera'),
    'INTERVENCION',
    'Renovación del mobiliario urbano en el Parque de la Marina',
    'Instalación de nuevos bancos, papeleras y fuentes de agua potable en el Parque de la Marina, además de la sustitución del árbol enfermo retirado por un ejemplar joven sano.',
    ST_SetSRID(ST_MakePoint(-3.62850, 40.55280), 4326),
    (SELECT id FROM points WHERE title = 'Árbol enfermo con riesgo de caída en la Avenida de España')
);
