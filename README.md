# Abstemia · Encuesta de degustación

Aplicación web estática, lista para publicar en GitHub Pages, con preguntas fijas basadas en el formulario interno **Abstemia — Noche de degustación de prueba**.

## Características

- Encuesta pública sin registro, optimizada para celular.
- Preguntas de comida y bebida del documento original (1 a 14).
- Todas las preguntas son opcionales; se exige al menos una respuesta.
- Administración con correo y contraseña.
- Promedios por pregunta numérica, detalle de respuestas y exportación CSV compatible con Excel.
- Persistencia y seguridad mediante Supabase y políticas RLS.

## Instalación

1. Crear un proyecto en [Supabase](https://supabase.com/).
2. Abrir **SQL Editor** y ejecutar `supabase.sql`.
3. En **Authentication > Users**, crear manualmente un usuario con correo y contraseña para el dueño.
4. En SQL Editor, ejecutar (cambiando el correo):
   ```sql
   insert into public.admin_users(user_id)
   select id from auth.users where email = 'correo-del-dueno@ejemplo.com'
   on conflict do nothing;
   ```
5. En **Authentication > Providers > Email**, deshabilitar los registros públicos si no se necesitan.
6. Copiar la **Project URL** y la clave **anon/publishable** desde Supabase a `config.js`. **Nunca** poner una clave `service_role` o `secret` en archivos públicos.
7. Subir `index.html`, `styles.css`, `app.js`, `config.js` y `supabase.sql` a un repositorio GitHub. `supabase.sql` es documentación/configuración y no se ejecuta desde el navegador.
8. En GitHub: **Settings > Pages > Deploy from a branch > main / (root)**. Esperar a que GitHub muestre la URL pública.
9. Compartir la URL con los clientes o generar un QR con esa URL. El dueño puede entrar en `URL/#admin`.

## Consideraciones

- La clave pública de Supabase es visible en el navegador; la seguridad depende de las políticas RLS del SQL.
- La tabla `admin_users` solo puede administrarse desde el SQL Editor con privilegios elevados.
- Para una noche con mucha concurrencia, agregar CAPTCHA, límites de frecuencia o un endpoint protegido contra spam; la versión básica permite múltiples envíos anónimos.
- El panel muestra hasta 5000 respuestas; para un volumen mayor implementar paginación.
- El formulario original no especifica una escala para **Sabor del aderezo (César)**: se dejó como respuesta libre, sin inventar una escala.
- La pregunta de precio se deja libre porque el documento no define moneda ni rangos.
- No se incluyeron nombres ni datos personales de clientes.
