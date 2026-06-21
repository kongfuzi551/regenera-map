/**
 * Configuración de entorno por defecto (desarrollo).
 * Se sustituye por environment.prod.ts en el build de producción
 * mediante fileReplacements en angular.json.
 */
export const environment = {
  production: false,
  apiUrl: 'http://localhost/api'
};
