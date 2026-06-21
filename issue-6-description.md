# Issue #6: Componente Mapa con Leaflet

## 📋 Descripción

Implementar el componente principal del mapa interactivo usando **Leaflet.js** en Angular. Este es el corazón visual de la plataforma que permite:
- Ver todos los puntos colaborativos clasificados por tipo (Problema/Propuesta/Intervención)
- Filtrar puntos por categoría
- Hacer clic en puntos para ver detalles
- Hacer clic en el mapa para crear nuevos puntos
- Mostrar la ubicación del usuario actual (si se otorga permiso)

---

## 🎯 Objetivos

- Integrar Leaflet.js en el proyecto Angular 21
- Crear componente principal `MapComponent`
- Cargar y visualizar puntos desde la API REST
- Mostrar marcadores con iconos diferenciados por tipo
- Implementar interactividad: clic en puntos y en el mapa
- Crear componentes secundarios: PointMarker, PointDetail, PointFilter
- Implementar servicios para consultas geoespaciales
- Responsividad y accesibilidad

---

## 📐 Arquitectura

### Estructura de carpetas a crear

```
frontend/src/app/
├── features/
│   └── map/
│       ├── map.component.ts
│       ├── map.component.html
│       ├── map.component.scss
│       ├── map.component.spec.ts
│       ├── point-marker/
│       │   ├── point-marker.component.ts
│       │   ├── point-marker.component.html
│       │   └── point-marker.component.scss
│       ├── point-detail/
│       │   ├── point-detail.component.ts
│       │   ├── point-detail.component.html
│       │   └── point-detail.component.scss
│       ├── point-filter/
│       │   ├── point-filter.component.ts
│       │   ├── point-filter.component.html
│       │   └── point-filter.component.scss
│       ├── map.module.ts
│       └── services/
│           ├── map.service.ts
│           └── point.service.ts
```

### Servicios necesarios

1. **PointService** → Gestiona llamadas a la API `/api/points`
2. **MapService** → Lógica de Leaflet (inicializar, agregar capas, eventos)
3. Reutilizar **AuthService** existente para permisos

---

## 📦 Dependencias a instalar

```bash
npm install leaflet @types/leaflet leaflet-default-icon-compatibility
npm install --save-dev @angular/common @angular/core
```

En `angular.json`, agregar los estilos de Leaflet:
```json
"styles": [
  "node_modules/leaflet/dist/leaflet.css",
  "src/styles.scss"
]
```

---

## 🔧 Pasos de Implementación

### PASO 1: Crear el módulo Map
- [ ] Crear `frontend/src/app/features/map/map.module.ts`
- [ ] Importar módulos necesarios: CommonModule, HttpClientModule, ReactiveFormsModule
- [ ] Declarar los 4 componentes (map, point-marker, point-detail, point-filter)
- [ ] Exportar MapComponent para su uso en AppModule

### PASO 2: Crear PointService
- [ ] Crear `frontend/src/app/features/map/services/point.service.ts`
- [ ] Implementar métodos:
  - `getPoints(filters?: {category?: string, bounds?: LatLngBounds})`: Obtener puntos con filtros
  - `getPointById(id: string)`: Obtener detalle de un punto
  - `createPoint(data: CreatePointDTO)`: Crear nuevo punto (requiere COLABORADOR)
  - `updatePoint(id: string, data: UpdatePointDTO)`: Editar punto
  - `deletePoint(id: string)`: Borrar punto
  - `likePoint(id: string)`: Dar like
  - `unlikePoint(id: string)`: Quitar like
- [ ] Usar interceptores JWT existentes para autenticación

### PASO 3: Crear MapService
- [ ] Crear `frontend/src/app/features/map/services/map.service.ts`
- [ ] Implementar métodos:
  - `initMap(container: HTMLElement, initialLat: number, initialLng: number, zoom: number)`: Inicializar Leaflet
  - `addMarkerLayer(points: Point[])`: Agregar capa de marcadores
  - `addMarker(point: Point)`: Agregar un marcador individual
  - `removeMarker(id: string)`: Eliminar marcador
  - `updateMarker(point: Point)`: Actualizar marcador (posición, icono, popup)
  - `fitBounds(bounds: LatLngBounds)`: Ajustar vista al área
  - `getMapBounds()`: Obtener límites actuales del mapa
  - `onMapClick(callback)`: Manejar clic en el mapa
  - `onMarkerClick(id: string, callback)`: Manejar clic en marcador
  - Métodos privados para crear iconos según tipo de punto

### PASO 4: MapComponent (Contenedor principal)
- [ ] Crear `frontend/src/app/features/map/map.component.ts`
- [ ] Propiedades:
  - `points: Point[]` → Lista de puntos cargados
  - `filteredPoints: Point[]` → Puntos después de aplicar filtros
  - `selectedPoint: Point | null` → Punto seleccionado
  - `isCreatingPoint: boolean` → Estado de creación
  - `userLocation: {lat: number, lng: number} | null` → Ubicación del usuario
  - `selectedFilters: {category?: string}` → Filtros activos
  - `isLoading: boolean` → Indicador de carga
- [ ] En `ngOnInit()`:
  - Inicializar mapa centrado en Alcobendas (40.5333° N, -3.6500° W, zoom 14)
  - Cargar puntos desde API
  - Mostrar ubicación del usuario (con permiso)
  - Suscribirse a cambios de filtros
- [ ] Métodos:
  - `loadPoints()`: Consultar `/api/points` con filtros
  - `onMapClick(lat: number, lng: number)`: Evento al hacer clic en el mapa → abrir formulario
  - `onMarkerClick(pointId: string)`: Mostrar `PointDetailComponent`
  - `onFilterChange(filters)`: Actualizar filtros y recargar puntos
  - `onPointCreated(point: Point)`: Agregar nuevo punto al mapa
  - `onPointUpdated(point: Point)`: Actualizar punto existente
  - `onPointDeleted(pointId: string)`: Eliminar punto del mapa
  - `handleError(error)`: Mostrar notificación de error
- [ ] Template HTML:
  - `<div #mapContainer class="map-container"></div>`
  - `<app-point-filter (filterChange)="onFilterChange($event)"></app-point-filter>`
  - `<app-point-detail [point]="selectedPoint" *ngIf="selectedPoint"></app-point-detail>`
  - `<app-report-form *ngIf="isCreatingPoint" [lat]="..." [lng]="..."></app-report-form>`
  - Indicador de carga y manejo de errores
- [ ] Estilos SCSS:
  - `.map-container`: Ocupar 100% del viewport, posición relative
  - Responsive: altura ajustada para dejar espacio a header/footer
  - Animaciones suaves de transiciones

### PASO 5: PointMarkerComponent
- [ ] Crear `frontend/src/app/features/map/point-marker/point-marker.component.ts`
- [ ] Recibir `@Input() point: Point`
- [ ] Emitir eventos:
  - `@Output() clicked: EventEmitter<Point>`
  - `@Output() likeClicked: EventEmitter<Point>`
- [ ] Mostrar mini-popup con:
  - Icono del tipo de punto
  - Título
  - Contador de likes
  - Botón para ver detalles
- [ ] Estilos: Popup compacto con sombra y transiciones

### PASO 6: PointDetailComponent
- [ ] Crear `frontend/src/app/features/map/point-detail/point-detail.component.ts`
- [ ] Recibir `@Input() point: Point`
- [ ] Emitir eventos:
  - `@Output() closed: EventEmitter<void>`
  - `@Output() edited: EventEmitter<Point>`
  - `@Output() deleted: EventEmitter<string>`
- [ ] Mostrar panel lateral (o modal) con:
  - **Encabezado**: Título, categoría (color), fecha
  - **Contenido**: Descripción completa
  - **Fotos**: Galería de imágenes
  - **Autor**: Nick + avatar
  - **Likes**: Contador + botón de like (si autenticado)
  - **Acciones**: Botones de editar/eliminar (si es propietario o admin)
  - **Estado**: Indicador de validación (si es admin)
- [ ] Comportamiento:
  - Permitir editar si `currentUser.id === point.userId || currentUser.role === ADMIN`
  - Permitir eliminar si `currentUser.id === point.userId || currentUser.role === ADMIN`
  - Mostrar botón validar/rechazar solo si `currentUser.role === ADMIN`
- [ ] Estilos: Panel responsivo, ancho ~40% en desktop, full en mobile

### PASO 7: PointFilterComponent
- [ ] Crear `frontend/src/app/features/map/point-filter/point-filter.component.ts`
- [ ] Emitir `@Output() filterChange: EventEmitter<FilterOptions>`
- [ ] Mostrar filtros:
  - Selector de categoría (Todos / Problema / Propuesta / Intervención)
  - (Futuro) Rango de fechas, búsqueda de texto, radio de distancia
- [ ] Comportamiento:
  - Actualizar filtros en tiempo real
  - Guardar preferencias en localStorage
  - Mostrar badge con número de puntos activos
- [ ] Estilos: Barra flotante o integrada en header

### PASO 8: DTOs e Interfaces
- [ ] Crear `frontend/src/app/features/map/models/`
  - `Point.interface.ts`: Interfaz del modelo Point
  - `CreatePointDTO.ts`: DTO para crear punto
  - `UpdatePointDTO.ts`: DTO para actualizar punto
  - `FilterOptions.ts`: Opciones de filtro

### PASO 9: Tests
- [ ] `map.component.spec.ts`: Tests de carga, filtrado, eventos
- [ ] `point.service.spec.ts`: Tests de llamadas HTTP
- [ ] `map.service.spec.ts`: Tests de inicialización de Leaflet

### PASO 10: Integración
- [ ] Agregar MapComponent al routing principal
  - `app/app-routing.module.ts`: Ruta `/map` o ruta por defecto
- [ ] Importar MapModule en AppModule
- [ ] Verificar que funciona con el backend (mock si es necesario)
- [ ] Documentar en README cómo levantar el entorno local

---

## 🎨 Iconografía de Puntos

| Tipo | Color | Icono | Hex |
|------|-------|-------|-----|
| Problema | Rojo | ! en círculo | #DC2626 |
| Propuesta | Azul | Bombilla | #2563EB |
| Intervención | Verde | Checkmark | #16A34A |

Usar iconos SVG personalizados o Font Awesome dentro de Leaflet divIcon.

---

## 🧪 Criterios de Aceptación

- [ ] El mapa carga y se centra en Alcobendas correctamente
- [ ] Los puntos de la API se muestran con iconos diferenciados
- [ ] Al hacer clic en un punto, se abre el detalle (sin errores)
- [ ] Los filtros funcionan y actualizan el mapa sin recargar toda la página
- [ ] Al hacer clic en el mapa se abre el formulario de creación (si está autenticado)
- [ ] La ubicación del usuario se muestra correctamente (si se da permiso)
- [ ] No hay errores en consola (excepto logs informativos)
- [ ] El mapa es responsivo en mobile, tablet y desktop
- [ ] Los tests pasan (cobertura mínima 70%)
- [ ] La documentación de componentes está completa (JSDoc)

---

## 📚 Referencias

- **Leaflet docs**: https://leafletjs.com
- **Requisitos funcionales**: `docs/01-requisitos.md`
- **Diseño técnico**: `docs/02-diseno-tecnico.md`

---

## 📝 Notas

- **Geolocalización**: Usar `navigator.geolocation.getCurrentPosition()` con manejo de errores
- **Performance**: Virtualizar marcadores si hay >1000 puntos (usar Leaflet.markercluster o similar)
- **Accesibilidad**: Asegurar que el mapa sea navegable por teclado (Leaflet lo soporta nativamente)
- **SEO**: Los puntos deben ser indexables (hacer que MapComponent no sea CSR-only si es posible)
- **Validación**: Todos los inputs deben validarse antes de enviar a la API

---

## 🚀 Prioridad

**ALTA** - Este es un componente crítico del MVP. Bloquea otras tareas de frontend.

**Estimación:** 40-48 horas (incluye tests y documentación)
