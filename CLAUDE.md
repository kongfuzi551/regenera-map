# regenera-map

Plataforma web de mapeo colaborativo para regeneración urbana. MVP inicial en Alcobendas y San Sebastián de los Reyes (Madrid).

## Stack
- Frontend: Angular 21 + Leaflet.js (mapa) → Nginx
- Backend: Spring Boot 3.5.3 + Java 21 → REST API en /api
- BD: PostgreSQL 16 + PostGIS
- Auth: Google OAuth2 + JWT
- Fotos: Supabase Storage
- Deploy: Docker Compose → Azure Container Apps
- CI/CD: GitHub Actions → GHCR

## Estructura
Monorepo: frontend/ | backend/ (com.regeneramap) | docker/ | docs/ | .github/workflows/

## Roles
- Ciudadano Consulta: sin login, solo lectura
- Ciudadano Colaborador: login Google, reporta puntos y da likes
- Administrador: modera, valida, añade intervenciones (3-4 personas)

## Tipos de punto en el mapa
- PROBLEMA (rojo): zona degradada, basura, árbol enfermo
- PROPUESTA (azul): sugerencia de mejora
- INTERVENCION (verde): acción completada por administrador

## Modelo de datos clave
```sql
users: id, google_id, email, nick (único), avatar_url, role (COLABORADOR|ADMIN), active
points: id, user_id, category (PROBLEMA|PROPUESTA|INTERVENCION), title, description, location (GEOMETRY PostGIS), linked_to
photos: id, point_id, url
likes: id, user_id, point_id (unique)
```

## Convenciones
- Ramas: feature/* y fix/* → develop → main (protegida)
- Commits: Conventional Commits (feat/fix/chore/docs) + closes #ID
- PR siempre contra develop, nunca contra main
- Una tarea por PR

## Versiones
- v0.1.0: infraestructura + mapa público con seed data
- v0.2.0: ciudadano consulta
- v0.3.0: ciudadano colaborador + auth
- v0.4.0: administrador
- v1.0.0: lanzamiento con AlcoSanse

## Docs detallados
- docs/01-requisitos.md
- docs/02-diseno-tecnico.md
- docs/03-planificacion.md
