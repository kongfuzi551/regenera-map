# Especificación de Requisitos — regenera-map

**Versión:** 0.1  
**Fecha:** Junio 2026  
**Estado:** Borrador aprobado

---

## 1. Visión del Producto

Plataforma web con mapa colaborativo para que ciudadanos y organizaciones regeneradoras documenten problemas medioambientales, propongan intervenciones y registren acciones realizadas en zonas urbanas.

El MVP inicial se centra en Alcobendas y San Sebastián de los Reyes, impulsado por el grupo vecinal **AlcoSanse por la Regeneración**, inspirado en el movimiento Hope! y La Oleada por la Regeneración. La plataforma está diseñada para escalar a otras ciudades y organizaciones en versiones futuras.

---

## 2. Actores / Roles

| Rol | Acceso | Descripción |
|-----|--------|-------------|
| 👁️ Ciudadano Consulta | Sin login | Solo lectura del mapa y fichas de puntos |
| 👤 Ciudadano Colaborador | Login con Google | Reporta puntos y da likes. Rol base al registrarse |
| ⚙️ Administrador | Login con Google + asignación manual | Valida, rechaza puntos y registra intervenciones. Varias personas de confianza (3-4) |

### Flujo de alta de Administrador

```
Usuario se registra como Ciudadano Colaborador
  → Administrador principal le promueve a Administrador
    → Nuevo Administrador puede ejercer todas las funciones de gestión
```

### Decisión de diseño

El campo `role` en la tabla de usuarios tiene tres valores posibles: `CONSULTA`, `COLABORADOR`, `ADMIN`. No existe rol intermedio en esta versión. El rol MOR (Miembro de Organización Regeneradora) se introduce en v2.0.0.

---

## 3. Tipos de Puntos en el Mapa

| Tipo | Color | Quién puede añadir | Descripción |
|------|-------|--------------------|-------------|
| 🔴 Problema | Rojo | Ciudadano Colaborador | Zona degradada, basura acumulada, árbol enfermo, solar abandonado |
| 🔵 Propuesta | Azul | Ciudadano Colaborador | Sugerencia de intervención o mejora medioambiental |
| 🟢 Intervención realizada | Verde | Administrador | Acción completada y documentada |

---

## 4. Historias de Usuario

### 👁️ Ciudadano Consulta

**Ver el mapa**
- Como ciudadano consulta, quiero ver un mapa público sin necesidad de registrarme, para explorar el estado de mi zona libremente.
- Como ciudadano consulta, quiero ver todos los puntos en el mapa clasificados por tipo (problema / propuesta / intervención realizada), para entender de un vistazo qué está pasando.
- Como ciudadano consulta, quiero filtrar el mapa por tipo de punto, para ver solo lo que me interesa.
- Como ciudadano consulta, quiero hacer clic en un punto y ver su ficha completa (fotos, descripción, categoría, fecha, estado), para entender qué ocurre en ese lugar.

**Descubribilidad**
- Como ciudadano consulta, quiero que el mapa sea compartible mediante un enlace directo, para poder enviarlo por WhatsApp o redes sociales.

---

### 👤 Ciudadano Colaborador

**Autenticación y perfil**
- Como ciudadano colaborador, quiero hacer login con Google, para acceder sin crear una cuenta nueva.
- Como ciudadano colaborador, quiero elegir un nick único durante el registro, para mantener mi anonimato público preservando mi identidad real en el sistema.
- Como ciudadano colaborador, quiero elegir un avatar de una selección predefinida o usar mi foto de Google por defecto, para personalizar mi perfil.
- Como ciudadano colaborador, quiero cerrar sesión, para proteger mi privacidad en dispositivos compartidos.
- Como ciudadano colaborador, quiero darme de baja de la plataforma, para dejar de participar cuando quiera. Mis aportaciones permanecerán asociadas a "Usuario anónimo".

**Reportar un punto**
- Como ciudadano colaborador, quiero añadir un punto en el mapa desde mi ubicación actual, para reportar algo fácilmente sin teclear una dirección.
- Como ciudadano colaborador, quiero poder ajustar manualmente la ubicación del punto en el mapa, para corregirla si el GPS no es preciso.
- Como ciudadano colaborador, quiero elegir la categoría del punto (problema / propuesta), para clasificarlo correctamente.
- Como ciudadano colaborador, quiero añadir una descripción libre, para dar contexto a mi reporte.
- Como ciudadano colaborador, quiero subir una o varias fotos, para dar evidencia visual.

**Gestionar mis reportes**
- Como ciudadano colaborador, quiero ver un listado de los puntos que he reportado, para hacer seguimiento de su estado.
- Como ciudadano colaborador, quiero editar un reporte mío, para corregirlo si me he equivocado.
- Como ciudadano colaborador, quiero eliminar un reporte mío, para retirarlo si ya no es relevante.

**Interacción**
- Como ciudadano colaborador, quiero dar like a un punto del mapa, para apoyar que se priorice esa intervención o propuesta.

---

### ⚙️ Administrador

**Autenticación y perfil**
- Como administrador, quiero hacer login con Google, para acceder con mi cuenta habitual.
- Como administrador, quiero elegir un nick único durante el registro, para mantener mi anonimato público.
- Como administrador, quiero elegir un avatar de una selección predefinida o usar mi foto de Google por defecto, para personalizar mi perfil.
- Como administrador, quiero cerrar sesión, para proteger mi privacidad en dispositivos compartidos.

**Gestión de puntos**
- Como administrador, quiero validar un punto reportado por un ciudadano colaborador, para darle credibilidad y visibilidad reforzada en el mapa.
- Como administrador, quiero rechazar un punto reportado, para eliminar contenido inapropiado o erróneo, notificando al ciudadano el motivo.
- Como administrador, quiero editar la descripción o categoría de un punto, para corregir errores o completar información.

- Como administrador, quiero eliminar cualquier punto del mapa, para actuar ante contenido inapropiado grave.

**Intervenciones realizadas**
- Como administrador, quiero añadir un punto de tipo "intervención realizada" en el mapa, para documentar acciones completadas.
- Como administrador, quiero subir fotos de una intervención, para mostrar el impacto visual real.
- Como administrador, quiero añadir una descripción de la intervención (fecha, participantes, especies plantadas, etc.), para dejar registro detallado de la acción.
- Como administrador, quiero vincular una intervención realizada a un punto previo de problema o propuesta, para cerrar el ciclo y mostrar que fue atendido.

**Gestión de usuarios**
- Como administrador, quiero ver el listado completo de usuarios registrados con su rol, para supervisar la plataforma.
- Como administrador, quiero promover un ciudadano colaborador a administrador, para ampliar el equipo de gestión.
- Como administrador, quiero revocar el rol de administrador a un usuario, para gestionar bajas o cambios en el equipo.
- Como administrador, quiero desactivar la cuenta de un usuario, para actuar ante comportamientos abusivos.

---

## 5. Decisiones de Diseño

| Decisión | Motivo |
|----------|--------|
| Moderación reactiva en v0.x | Gratificación inmediata al reportar. Revisable si hay problemas de abuso |
| Login social (Google) obligatorio para colaborar | Reduce trolls sin fricción excesiva |
| Nick único público + email privado | Anonimato público con trazabilidad interna |
| Avatar predefinido o foto de Google por defecto | Evita fotos inapropiadas sin necesitar moderación |
| Baja anonimiza aportaciones | Respeto a la privacidad preservando integridad del mapa |
| Contador de actividad oculto en v0.x | Evita sensación de abandono con poca actividad inicial |
| Varios administradores (3-4) | Evita cuello de botella en validación e intervenciones |
| Sin rol MOR en v1.0.0 | Simplifica el MVP; el administrador asume esas funciones temporalmente |
