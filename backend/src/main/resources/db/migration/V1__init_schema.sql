-- V1__init_schema.sql
-- Esquema inicial de regenera-map.
-- Crea la extensión PostGIS y las tablas base: users, points, photos y likes.

-- Extensión PostGIS para soporte de geometrías geográficas
CREATE EXTENSION IF NOT EXISTS postgis;

-- =============================================================
-- Tabla: users
-- Usuarios autenticados vía Google OAuth2.
-- Los "Ciudadanos Consulta" no se almacenan (sin login).
-- =============================================================
CREATE TABLE users (
    id          BIGSERIAL PRIMARY KEY,
    google_id   VARCHAR(255) NOT NULL UNIQUE,
    email       VARCHAR(320) NOT NULL UNIQUE,
    nick        VARCHAR(50)  NOT NULL UNIQUE,
    avatar_url  TEXT,
    role        VARCHAR(20)  NOT NULL DEFAULT 'COLABORADOR'
                CHECK (role IN ('COLABORADOR', 'ADMIN')),
    active      BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- =============================================================
-- Tabla: points
-- Puntos del mapa: problemas, propuestas e intervenciones.
-- location usa SRID 4326 (WGS84, lat/lon estándar).
-- linked_to permite vincular una INTERVENCION a un PROBLEMA/PROPUESTA.
-- =============================================================
CREATE TABLE points (
    id          BIGSERIAL PRIMARY KEY,
    user_id     BIGINT       NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    category    VARCHAR(20)  NOT NULL
                CHECK (category IN ('PROBLEMA', 'PROPUESTA', 'INTERVENCION')),
    title       VARCHAR(150) NOT NULL,
    description TEXT,
    location    GEOMETRY(Point, 4326) NOT NULL,
    linked_to   BIGINT       REFERENCES points(id) ON DELETE SET NULL,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- Índice espacial para consultas geográficas (bounding box, cercanía)
CREATE INDEX idx_points_location ON points USING GIST (location);
-- Índices de apoyo para filtros y joins frecuentes
CREATE INDEX idx_points_category ON points (category);
CREATE INDEX idx_points_user_id  ON points (user_id);

-- =============================================================
-- Tabla: photos
-- Fotos asociadas a un punto (URLs en Supabase Storage).
-- =============================================================
CREATE TABLE photos (
    id          BIGSERIAL PRIMARY KEY,
    point_id    BIGINT      NOT NULL REFERENCES points(id) ON DELETE CASCADE,
    url         TEXT        NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_photos_point_id ON photos (point_id);

-- =============================================================
-- Tabla: likes
-- "Me gusta" de un usuario a un punto. Un usuario solo puede
-- dar un like por punto (restricción única).
-- =============================================================
CREATE TABLE likes (
    id          BIGSERIAL PRIMARY KEY,
    user_id     BIGINT      NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    point_id    BIGINT      NOT NULL REFERENCES points(id) ON DELETE CASCADE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT uq_likes_user_point UNIQUE (user_id, point_id)
);

CREATE INDEX idx_likes_point_id ON likes (point_id);
