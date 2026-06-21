/**
 * Configuración de entorno de producción.
 * En producción el frontend se sirve tras nginx, que enruta /api → backend.
 */
export const environment = {
  production: true,
  apiUrl: '/api'
};
