## Emulador para Final release 1.0: 
- https://appetize.io/app/b_rug4opuulqbsanumxjv5uifvem
- https://appetize.io/app/b_7fejk2swstipubzjltp4q2wpg4
- https://appetize.io/app/b_keporob6bwsujarnpnqyk7qbiy
- https://appetize.io/app/b_6dmxld4t7pltz5egszvlqaqngi

### Changelog:
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

### v.0.8 - ${\textsf{\color{lightgreen}Compilable}}$
- Modificada la funcion de login/registro para que el password se guarde encriptado.
- Base de datos modificada para aumentar la columna users_password de la tabla users a varchar(100).
- Cambiado el nombre de Premios.swift a PremiosView.swift para que coincida con el nombre de la estructura.
- En ChartView se han implementado los botones de Compra y Venta (con la funcionalidad de que se oculten si el mercado está cerrado).

### v.0.9 - ${\textsf{\color{lightgreen}Compilable}}$
- Finalizada funcionalidad de ChartView (implementada lógica de compra y venta).
- Creado CompraView y VentaView con estructura básica (pendiente la funcionalidad de comprar/vender)

### v.0.10 - ${\textsf{\color{lightgreen}Compilable}}$
- Funcionalidad de Compra/Venta implementada.
- Funcionalidad del historial de Compra y Venta implementadas.
- ChartView: se añade la comprobación de recursos antes de mostrar los que puede vender (como ya se hacía con los coins en la compra)

### v.0.11 - ${\textsf{\color{lightgreen}Compilable} - {\color{red}CANDIDATE}}$
- Vista de Premios finalizada con Premios disponibles, canjeados y por conseguir.
- JSON con el listado de premios a partir del Excel.
- Añadida la opcion de "arrastrar para refrescar" en el ChartView.

### v.0.12 (PEC3) - ${\textsf{\color{lightgreen}Compilable} - {\color{red}CANDIDATE}}$
- Actualizado cronjob para que calcule segun transacciones de usuarios.
- Correcciones en el json de premios que no consultaba la columna correcta.
- Nueva tabla "mina" añadida en la estructura de la base de datos.
- Si el usuario es nuevo, se le redirige a "Premios" en vez de a "Ranking" una vez logueado.
- Creado color "BnW" para la correcta representación de las fuentes en modo oscuro, eliminado el color "filas" por duplicidad y modificada la transparencia de "verdePastel".
- Añadidos mensajes de información para usuarios nuevos.
- Añadido mensaje de información del juego en la ventana de login/registro,
- Cambiado "Nombre de usuario" por "Nombre de empresa ficticia" en ventana de login/registro.

### v.1.0 (PEC4 - PEC5)  ${\textsf{\color{lightgreen}Compilable} - {\color{red}FINAL}}$
- Se crea la funcionalidad de las ofertas de minas encontradas.
- Se adapta el ranking para mostrar el aviso de las minas.
- Se cambia a version formal 1.0 y se cambia el OS minimo a 18.0 para el emulador: https://appetize.io/app/b_rug4opuulqbsanumxjv5uifvem
