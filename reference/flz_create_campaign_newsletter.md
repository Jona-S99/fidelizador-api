# Crear una nueva campaña de newsletter

Crea una nueva campaña de newsletter en Fidelizador y la deja en estado
borrador.

## Usage

``` r
flz_create_campaign_newsletter(
  token,
  client_slug,
  name,
  category_id,
  subject,
  sender_email,
  reply_to_name,
  reply_to,
  list_id = NULL,
  list_segment_id = NULL,
  dynamic_sender_id = NULL,
  has_google_analytics = NULL,
  update_form_id = NULL,
  twitter_username = NULL,
  twitter_message = NULL,
  content = NULL,
  template_id = NULL,
  labels = NULL,
  calendar_id = NULL,
  attachments = NULL,
  permissions = NULL,
  group_ids = NULL,
  documents = NULL,
  format = "json",
  base_url = "https://api.fidelizador.com"
)
```

## Arguments

- token:

  Token de autenticación obtenido con
  [`flz_auth()`](https://Jona-S99.github.io/fidelizadorapi/reference/flz_auth.md)

- client_slug:

  Slug del cliente en Fidelizador

- name:

  Nombre de la campaña

- category_id:

  ID de la categoría

- subject:

  Asunto del correo

- sender_email:

  Email del remitente (debe estar registrado)

- reply_to_name:

  Nombre para "Responder a"

- reply_to:

  Email para "Responder a"

- list_id:

  ID de la lista de contactos (opcional si se usa list_segment_id)

- list_segment_id:

  ID del segmento (opcional si se usa list_id)

- dynamic_sender_id:

  ID del remitente dinámico (opcional)

- has_google_analytics:

  Activar tracking de Google Analytics (opcional)

- update_form_id:

  ID del formulario de actualización (opcional)

- twitter_username:

  Usuario de Twitter (opcional)

- twitter_message:

  Mensaje de Twitter (opcional)

- content:

  Contenido HTML de la campaña (opcional)

- template_id:

  ID del template (opcional, tiene prioridad sobre content)

- labels:

  Vector de etiquetas (opcional)

- calendar_id:

  ID del calendario para programación (opcional)

- attachments:

  Vector de archivos para adjuntar (opcional)

- permissions:

  Vector de emails para permisos (opcional)

- group_ids:

  Vector de IDs de grupos para permisos (opcional)

- documents:

  Vector de IDs de documentos (opcional)

- format:

  Formato de respuesta: "json" o "xml" (por defecto: "json")

- base_url:

  URL base de la API (por defecto: "https://api.fidelizador.com")

## Value

Objeto con la respuesta de la API

## Examples

``` r
if (FALSE) { # \dontrun{
token <- flz_auth()

campaign <- flz_create_campaign(
  token = token,
  client_slug = "mi-empresa",
  name = "Newsletter Enero 2026",
  category_id = 1,
  subject = "¡Novedades de Enero!",
  sender_email = "contacto@miempresa.com",
  reply_to_name = "Equipo Marketing",
  reply_to = "marketing@miempresa.com",
  list_id = 123,
  content = "<h1>Hola!</h1><p>Contenido de la campaña</p>"
)
} # }
```
