# Diseño Técnico — regenera-map

**Versión:** 0.1  
**Fecha:** Junio 2026  
**Estado:** Borrador aprobado

---

## 1. Pila Tecnológica

### Frontend
| Tecnología | Versión | Rol |
|-----------|---------|-----|
| Angular | 21 (LTS hasta mayo 2027) | Framework principal |
| TypeScript | 5.x | Lenguaje |
| Leaflet.js | Latest | Mapa interactivo (open source) |
| Angular Google Auth | Latest | Login con Google OAuth2 |
| Nginx | Alpine | Servidor web + proxy inverso |

### Backend
| Tecnología | Versión | Rol |
|-----------|---------|-----|
| Java | 21 (LTS) | Lenguaje |
| Spring Boot | 3.x | Framework principal |
| Spring Security | 6.x | Autenticación y autorización |
| Spring Data JPA | 3.x | Acceso a base de datos |
| Flyway | Latest | Migraciones de base de datos |
| Springdoc OpenAPI | Latest | Documentación API (Swagger UI) |

### Base de Datos
| Tecnología | Versión | Rol |
|-----------|---------|-----|
| PostgreSQL | 16 | Base de datos relacional |
| PostGIS | 3.x | Extensión geoespacial |

### Almacenamiento
| Tecnología | Rol |
|-----------|-----|
| Supabase Storage | Almacenamiento de fotos (gratuito hasta 1GB) |

### Infraestructura y DevOps
| Tecnología | Rol |
|-----------|-----|
| Docker | Contenedores |
| Docker Compose | Orquestación local |
| GitHub | Repositorio de código (open source) |
| GitHub Actions | CI/CD |
| GitHub Container Registry (GHCR) | Registro de imágenes Docker (gratuito) |
| Azure Container Apps | Despliegue en producción (capa gratuita) |
| Supabase PostgreSQL | Base de datos en producción (capa gratuita) |

---

## 2. Arquitectura

### Visión General

```
┌─────────────────────────────────────────────┐
│              Docker Compose                 │
│                                             │
│  ┌──────────────────────────────────────┐   │
│  │           Nginx :80                  │   │
│  │  ┌─────────────┐  ┌───────────────┐  │   │
│  │  │ Angular 21  │  │  Proxy /api   │  │   │
│  │  │ (dist/)     │  │  → :8080      │  │   │
│  │  └─────────────┘  └───────────────┘  │   │
│  └──────────────────────────────────────┘   │
│                    │                        │
│                    ▼                        │
│  ┌──────────────────────────────────────┐   │
│  │        Spring Boot :8080             │   │
│  │  - REST API                          │   │
│  │  - Spring Security + JWT             │   │
│  │  - Google OAuth2                     │   │
│  │  - Swagger UI (/api/docs)            │   │
│  └──────────────────────────────────────┘   │
│                    │                        │
│                    ▼                        │
│  ┌──────────────────────────────────────┐   │
│  │      PostgreSQL + PostGIS :5432      │   │
│  └──────────────────────────────────────┘   │
└─────────────────────────────────────────────┘

Servicios externos:
  → Google OAuth2 (autenticación)
  → Supabase Storage (fotos)
```

### Flujo de Autenticación

```
Usuario
  → Login con Google (OAuth2)
  → Spring Boot valida token con Google
  → Genera JWT propio (role: CONSULTA | COLABORADOR | ADMIN)
  → Angular almacena JWT en memoria (no localStorage)
  → Cada request incluye JWT en header Authorization
```

### Flujo de Reporte de un Punto

```
Ciudadano Colaborador
  → Abre mapa → clic en ubicación
  → Formulario: categoría + descripción + fotos
  → Fotos → Supabase Storage → URL devuelta
  → POST /api/points → Spring Boot
  → Validación de rol y datos
  → INSERT en PostgreSQL (geometría PostGIS)
  → Punto aparece en mapa inmediatamente
```

### Pipeline CI/CD

```
Push a rama feature/
  → GitHub Actions: build + tests
  → PR a main

Merge a main
  → GitHub Actions: build + tests
  → Build imagen Docker frontend → push a GHCR
  → Build imagen Docker backend → push a GHCR
  → Deploy automático → Azure Container Apps
```

---

## 3. Estructura del Repositorio

```
regenera-map/                          # Monorepo
│
├── frontend/                          # Angular 21
│   ├── src/
│   │   ├── app/
│   │   │   ├── core/                  # Servicios singleton, guards, interceptors
│   │   │   │   ├── auth/              # Google OAuth, JWT service, auth guard
│   │   │   │   ├── services/          # HTTP services genéricos
│   │   │   │   └── interceptors/      # JWT interceptor
│   │   │   ├── shared/                # Componentes y pipes reutilizables
│   │   │   │   ├── components/        # Avatar, badge de estado, botones
│   │   │   │   └── pipes/             # Fecha, categoría, estado
│   │   │   ├── features/              # Módulos por funcionalidad
│   │   │   │   ├── map/               # Mapa principal + Leaflet
│   │   │   │   │   ├── map.component
│   │   │   │   │   ├── point-marker/
│   │   │   │   │   ├── point-detail/
│   │   │   │   │   └── point-filter/
│   │   │   │   ├── auth/              # Login, registro, perfil
│   │   │   │   │   ├── login/
│   │   │   │   │   ├── register/      # Elección de nick y avatar
│   │   │   │   │   └── profile/
│   │   │   │   ├── reports/           # Crear y editar reportes
│   │   │   │   │   ├── report-form/
│   │   │   │   │   └── my-reports/
│   │   │   │   └── admin/             # Panel de administración
│   │   │   │       ├── points/        # Validar / rechazar puntos
│   │   │   │       ├── interventions/ # Añadir intervenciones
│   │   │   │       └── users/         # Gestión de usuarios
│   │   │   └── layout/                # Header, footer, navegación
│   │   ├── assets/
│   │   │   ├── avatars/               # Avatares predefinidos
│   │   │   └── icons/                 # Iconos del mapa por categoría
│   │   └── environments/
│   │       ├── environment.ts         # Desarrollo local
│   │       └── environment.prod.ts    # Producción
│   ├── Dockerfile
│   └── nginx.conf
│
├── backend/                           # Spring Boot 3 + Java 21
│   ├── src/main/java/com/regeneramap/
│   │   ├── config/                    # Configuración global
│   │   │   ├── SecurityConfig.java    # Spring Security + JWT
│   │   │   ├── OAuth2Config.java      # Google OAuth2
│   │   │   ├── CorsConfig.java        # CORS
│   │   │   └── PostGISConfig.java     # Dialecto PostgreSQL+PostGIS
│   │   ├── domain/                    # Entidades JPA
│   │   │   ├── User.java
│   │   │   ├── Point.java             # Punto en el mapa (geometría PostGIS)
│   │   │   ├── Photo.java
│   │   │   └── Like.java
│   │   ├── repository/                # Spring Data JPA
│   │   │   ├── UserRepository.java
│   │   │   ├── PointRepository.java   # Consultas geoespaciales
│   │   │   └── LikeRepository.java
│   │   ├── service/                   # Lógica de negocio
│   │   │   ├── AuthService.java
│   │   │   ├── PointService.java
│   │   │   ├── PhotoService.java      # Upload a Supabase Storage
│   │   │   └── UserService.java
│   │   ├── controller/                # REST API
│   │   │   ├── AuthController.java
│   │   │   ├── PointController.java
│   │   │   ├── PhotoController.java
│   │   │   └── AdminController.java
│   │   ├── dto/                       # Objetos de transferencia
│   │   │   ├── request/
│   │   │   └── response/
│   │   └── exception/                 # Manejo de errores
│   │       ├── GlobalExceptionHandler.java
│   │       └── exceptions/
│   ├── src/main/resources/
│   │   ├── application.yml            # Config base
│   │   ├── application-dev.yml        # Config local
│   │   ├── application-prod.yml       # Config producción
│   │   └── db/migration/              # Scripts Flyway
│   │       ├── V1__init_schema.sql    # Esquema inicial + PostGIS
│   │       └── V2__seed_data.sql      # Datos de ejemplo (dev)
│   └── Dockerfile
│
├── docker/
│   ├── docker-compose.yml             # Entorno local completo
│   ├── docker-compose.prod.yml        # Producción
│   └── postgres/
│       └── init.sql                   # Habilitar extensión PostGIS
│
├── .github/
│   └── workflows/
│       ├── ci.yml                     # Build + tests en cada PR
│       └── cd.yml                     # Deploy a Azure en merge a main
│
├── docs/
│   ├── 01-requisitos.md               # Especificación de requisitos
│   ├── 02-diseno-tecnico.md           # Este documento
│   ├── 03-planificacion.md            # Versiones y backlog
│   └── api/                           # Documentación API REST (generada)
│
├── .gitignore
└── README.md
```

---

## 4. Modelo de Datos (Esquema Inicial)

```sql
-- Extensión geoespacial
CREATE EXTENSION IF NOT EXISTS postgis;

-- Enum de roles
CREATE TYPE user_role AS ENUM ('COLABORADOR', 'ADMIN');

-- Enum de categorías de punto
CREATE TYPE point_category AS ENUM ('PROBLEMA', 'PROPUESTA', 'INTERVENCION');

-- Usuarios
CREATE TABLE users (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    google_id   VARCHAR(255) UNIQUE NOT NULL,
    email       VARCHAR(255) UNIQUE NOT NULL,
    nick        VARCHAR(50) UNIQUE NOT NULL,
    avatar_url  VARCHAR(500),
    role        user_role NOT NULL DEFAULT 'COLABORADOR',
    active      BOOLEAN NOT NULL DEFAULT true,
    created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Puntos en el mapa
CREATE TABLE points (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id      UUID REFERENCES users(id) ON DELETE SET NULL,
    category     point_category NOT NULL,
    title        VARCHAR(255) NOT NULL,
    description  TEXT,
    location     GEOMETRY(POINT, 4326) NOT NULL,
    linked_to    UUID REFERENCES points(id) ON DELETE SET NULL,
    created_at   TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Índice espacial para consultas geoespaciales
CREATE INDEX idx_points_location ON points USING GIST(location);

-- Fotos
CREATE TABLE photos (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    point_id   UUID NOT NULL REFERENCES points(id) ON DELETE CASCADE,
    url        VARCHAR(500) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Likes
CREATE TABLE likes (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id    UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    point_id   UUID NOT NULL REFERENCES points(id) ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, point_id)
);
```

---

## 5. API REST — Endpoints Principales

| Método | Endpoint | Rol requerido | Descripción |
|--------|----------|---------------|-------------|
| GET | /api/points | Público | Listar puntos (con filtros) |
| GET | /api/points/{id} | Público | Detalle de un punto |
| POST | /api/points | COLABORADOR | Crear punto |
| PUT | /api/points/{id} | COLABORADOR (propio) / ADMIN | Editar punto |
| DELETE | /api/points/{id} | COLABORADOR (propio) / ADMIN | Eliminar punto |

| POST | /api/points/{id}/like | COLABORADOR | Dar like |
| DELETE | /api/points/{id}/like | COLABORADOR | Quitar like |
| POST | /api/photos/upload | COLABORADOR / ADMIN | Subir foto |
| GET | /api/users/me | COLABORADOR | Perfil propio |
| PUT | /api/users/me | COLABORADOR | Editar perfil propio |
| DELETE | /api/users/me | COLABORADOR | Darse de baja |
| GET | /api/admin/users | ADMIN | Listar usuarios |
| PATCH | /api/admin/users/{id}/role | ADMIN | Cambiar rol |
| PATCH | /api/admin/users/{id}/active | ADMIN | Activar/desactivar usuario |
| GET | /api/auth/google | Público | Iniciar login con Google |
| GET | /api/auth/callback | Público | Callback OAuth2 |

Documentación interactiva disponible en `/api/docs` (Swagger UI).

---

## 6. Convenciones de Desarrollo

### Ramas

```
main          → Producción (protegida, solo merge via PR)
develop       → Integración
feature/      → Nueva funcionalidad (feature/map-filters)
fix/          → Corrección de bug (fix/login-redirect)
```

### Commits

Seguimos el estándar [Conventional Commits](https://www.conventionalcommits.org):

```
feat: añadir filtro por categoría en el mapa
fix: corregir redirección tras login
chore: actualizar dependencias Angular
docs: añadir documentación de endpoints
refactor: extraer lógica de mapa a servicio
test: añadir tests del endpoint de puntos
```

Los commits que cierran issues incluyen `closes #ID` para actualizar el tablero de GitHub automáticamente.

### Pull Requests

- Todo cambio a `main` pasa por PR
- El pipeline CI debe estar en verde antes de hacer merge
- Al menos una revisión propia antes de aprobar (en un proyecto en solitario, equivale a una revisión diferida)
