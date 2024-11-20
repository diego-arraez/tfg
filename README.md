### v.0.1 (PEC2) - ${\textsf{\color{lightgreen}Compilable}}$
- Primera versión con menus y estructura

### v.0.2
- Apartado de login/registro
- Colores de la app (Assets)

### v.0.3
- Se completa la funcionalidad de login/registro.
- Añadido JSON para el login (llamada a la base de datos).
- Estructura de la base de datos creada
- Modificaciones de diseño

### v.0.4
- Carpetas reorganizadas para mejor estructura.
- Añadido icono.
- Vista de login modificada con nuevo icono.
- Primera versión de RankingView
- Primera versión de CuentaView

### v.0.5
- Primera versión de Mercado (ChartView) con los recursos del usuario y el valor actual.
- Actualizada vista de RankingView para mostrar los valores actuales y tiempo para actualizarse.
- Cronjob para actualización de valores (cron-job.org).
- Más propuestas de iconos.
- Excel de posibles premios a implementar.

### v.0.6 - ${\textsf{\color{lightgreen}Compilable}}$
- Añadido gráfico de valores en ChartView.
- Corregidos errores en AjustesView, CuentaView y ChartView para poder compilar correctamente.
- Añadidos ComprasView y VentasView (historial) sin contenido.

### v.0.7 - ${\textsf{\color{lightgreen}Compilable}}$
- Añadida funcionalidad de notificaciones en AjustesView (aviso 15 minutos antes del cierre mercado).
- Posibilidad de mostrar/ocultar recursos en el chart (ChartView).
- Posibilidad de ocultar el Chart desde AjustesView.
- Nuevo icono definitivo, adaptado al modo oscuro y tintado de iOS18.
- Cronjob (php) actualizado para evitar llenar la base de datos, borrando valores anteriores a 7 días.
