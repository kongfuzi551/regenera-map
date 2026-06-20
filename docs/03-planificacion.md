# Planificación — regenera-map

**Versión:** 0.2  
**Fecha:** Junio 2026  
**Estado:** Borrador aprobado

---

## 1. Principios de Planificación

- Versionado semántico estándar: `vMAJOR.MINOR.PATCH`
- Cada versión debe ser funcional, desplegable y demostrable de forma independiente
- El despliegue en Azure Container Apps se activa desde la primera versión
- CI/CD operativo desde el primer commit

---

## 2. Hoja de Ruta

### v0.1.0 — Esqueleto del Proyecto
**Objetivo:** Infraestructura base funcionando de extremo a extremo.
**Historias de usuario:** Ninguna. Versión puramente técnica.

- Monorepo `regenera-map` creado en GitHub (open source)
- Estructura de carpetas frontend (Angular 21) y backend (Spring Boot 3)
- Docker Compose local con Angular + Spring Boot + PostgreSQL/PostGIS
- Mapa público visible con marcadores de ejemplo mínimos
- Sin autenticación todavía
- CI/CD operativo: GitHub Actions → GHCR → Azure Container Apps
- Swagger UI disponible en `/api/docs`
- Flyway configurado con migración inicial

---

### v0.2.0 — Ciudadano Consulta
**Objetivo:** Cualquier vecino puede explorar el mapa sin registrarse.
**Historias de usuario asignadas:**

- Ver mapa público sin registrarse
- Ver puntos clasificados por tipo (🔴 Problema / 🔵 Propuesta / 🟢 Intervención)
- Filtrar el mapa por tipo de punto
- Ver ficha completa de un punto (fotos, descripción, categoría, fecha)
- Compartir mapa por enlace directo (WhatsApp, redes sociales)
- **Seed data con puntos de ejemplo reales en Alcobendas y SSR** (varios de cada categoría, con ubicaciones, fotos y descripciones realistas)

---

### v0.3.0 — Ciudadano Colaborador
**Objetivo:** Vecinos registrados pueden reportar problemas y propuestas.
**Historias de usuario asignadas:**

- Login con Google OAuth2
- Registro con nick único y avatar predefinido o foto de Google
- Cerrar sesión
- Darse de baja (aportaciones quedan como "Usuario anónimo")
- Reportar punto desde ubicación actual
- Ajustar ubicación manualmente en el mapa
- Elegir categoría: Problema o Propuesta
- Añadir descripción libre y fotos
- Ver listado de mis reportes
- Editar reporte propio
- Eliminar reporte propio
- Dar like a un punto del mapa

---

### v0.4.0 — Administrador
**Objetivo:** Administradores moderan el mapa y registran intervenciones.
**Historias de usuario asignadas:**

- Validar o rechazar puntos reportados (con notificación al ciudadano)
- Editar descripción o categoría de cualquier punto
- Eliminar cualquier punto
- Añadir intervención realizada en el mapa
- Subir fotos de la intervención
- Añadir descripción detallada (fecha, participantes, especies plantadas, etc.)
- Vincular intervención a punto previo de problema o propuesta
- Ver listado de usuarios registrados con su rol
- Promover ciudadano colaborador a administrador
- Revocar rol de administrador
- Desactivar cuenta de un usuario

---

### v1.0.0 — Lanzamiento con AlcoSanse
**Objetivo:** Versión estable para uso real con el grupo vecinal.
**Historias de usuario:** Ninguna nueva. Estabilización y lanzamiento.

- Dominio propio configurado
- Pruebas reales con AlcoSanse por la Regeneración
- Resolución de bugs detectados en pruebas
- Optimización de rendimiento y UX móvil
- Presentación a concejerías de medio ambiente de Alcobendas y SSR
- README completo y documentación de despliegue

---

### v2.0.0 — Rol MOR y Organizaciones
**Objetivo:** Escalar el modelo a múltiples organizaciones regeneradoras.

- Nuevo rol: MOR (Miembro de Organización Regeneradora)
- Nuevo rol: Coordinador MOR
- Entidad Organización con perfil público (nombre, descripción, zona, logo)
- Flujo de alta de organización gestionado por Administrador de Plataforma
- Coordinador MOR gestiona sus propios miembros
- Miembro MOR puede validar puntos y añadir intervenciones en su zona
- Escalado a otras ciudades y grupos de La Oleada por la Regeneración

---

## 3. Backlog Futuro

Funcionalidades identificadas y descartadas del roadmap actual. Se priorizarán en función del feedback de usuarios reales.

### Funcionalidad

| Funcionalidad | Descripción | Prioridad estimada |
|--------------|-------------|-------------------|
| Antes / Después | Comparativa visual de fotos de un punto antes y después de la intervención | Alta |
| Mensajes privados | Comunicación entre Administrador/MOR y ciudadano colaborador para solicitar aclaraciones o más fotos | Media |
| Contador de actividad | Resumen público de puntos reportados e intervenciones realizadas. Mostrar solo cuando haya masa crítica | Media |
| Administrador Municipal | Rol para técnicos de ayuntamiento que puedan marcar puntos como "en gestión" o "resuelto por ayuntamiento" | Alta |
| Moderación proactiva | Aprobación de reportes antes de publicarse en el mapa. Alternativa a la moderación reactiva actual | Baja |
| Comentarios en puntos | Conversación pública en la ficha de un punto | Baja (riesgo de trolls) |
| Avatar personalizado | Subida de foto propia como avatar de perfil (requiere moderación) | Baja |
| Notificaciones push | Alertas cuando un reporte cambia de estado | Media |
| Exportación de datos | Exportar puntos del mapa en formato GeoJSON o CSV para uso externo | Media |
| App móvil nativa | Versión iOS/Android para mejorar la experiencia de reporte en campo | Alta (largo plazo) |

### Escalado

| Elemento | Descripción |
|----------|-------------|
| Multi-ciudad | Soporte para organizaciones en cualquier ciudad de España |
| Integración con La Oleada | Posible federación con otros grupos del movimiento Hope! |
| API pública | Endpoints abiertos para que terceros (ayuntamientos, investigadores) consuman datos del mapa |

---

## 4. Gestión del Proyecto en GitHub

### Estructura

```
GitHub Project → "regenera-map"
  │
  ├── Milestone v0.1.0
  ├── Milestone v0.2.0
  ├── Milestone v0.3.0
  ├── Milestone v0.4.0
  ├── Milestone v1.0.0
  └── Milestone v2.0.0
```

### Etiquetas de Issues

| Etiqueta | Uso |
|----------|-----|
| `role:consulta` | Historia del Ciudadano Consulta |
| `role:colaborador` | Historia del Ciudadano Colaborador |
| `role:admin` | Historia del Administrador |
| `type:auth` | Autenticación y perfil |
| `type:map` | Mapa y puntos |
| `type:reports` | Reportes ciudadanos |
| `type:admin-panel` | Panel de administración |
| `type:infra` | Infraestructura y DevOps |
| `type:bug` | Error a corregir |
| `backlog` | Fuera del roadmap actual |
