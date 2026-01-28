# Programar envío de campaña

Comprueba si la campaña cumple los requerimientos de envío y la programa
para ser enviada inmediatamente o en una fecha específica.

## Usage

``` r
flz_schedule_campaign(
  token,
  client_slug,
  campaign_id,
  send_now = NULL,
  scheduled_at = NULL,
  timezone = NULL,
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

- campaign_id:

  ID de la campaña existente en estado borrador

- send_now:

  Lógico - Si TRUE, programa la campaña para envío inmediato (por
  defecto: NULL)

- scheduled_at:

  Fecha y hora de envío programado. Formato: "YYYY-MM-DD HH:MM:SS" (por
  defecto: NULL)

- timezone:

  Opcional - Zona horaria para la programación (ej: "America/Santiago")

- format:

  Formato de respuesta: "json" o "xml" (por defecto: "json")

- base_url:

  URL base de la API (por defecto: "https://api.fidelizador.com")

## Value

Objeto con la respuesta de la API

## Details

Este método requiere al menos uno de los siguientes permisos:

- Campaña de email (Lectura y escritura)

- Permisos generales (Todos)

Debe proporcionar OBLIGATORIAMENTE uno de los siguientes:

- `send_now = TRUE` para envío inmediato

- `scheduled_at` con fecha y hora específica

## Examples

``` r
if (FALSE) { # \dontrun{
token <- flz_auth()

# Envío inmediato
resultado <- flz_schedule_campaign(
  token = token,
  client_slug = "mi-empresa",
  campaign_id = 123,
  send_now = TRUE
)

# Programar para fecha específica
resultado <- flz_schedule_campaign(
  token = token,
  client_slug = "mi-empresa",
  campaign_id = 123,
  scheduled_at = "2026-02-01 10:00:00",
  timezone = "America/Santiago"
)
} # }
```
