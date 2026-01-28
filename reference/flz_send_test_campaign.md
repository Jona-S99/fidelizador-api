# Enviar campaña de prueba

Envía una campaña de prueba a correos específicos para verificar que
cumple los requerimientos antes del envío definitivo.

## Usage

``` r
flz_send_test_campaign(
  token,
  client_slug,
  campaign_id,
  test_emails = NULL,
  test_list_id = NULL,
  test_contact = NULL,
  subject_prefix = NULL,
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

- test_emails:

  Vector de correos electrónicos para enviar la prueba

- test_list_id:

  Opcional - ID de la lista de pruebas a utilizar (tiene prioridad sobre
  test_emails)

- test_contact:

  Opcional - Correo del contacto del cual se obtendrá la información
  para las pruebas

- subject_prefix:

  Opcional - Prefijo del asunto a utilizar

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

# Enviar prueba a correos específicos
resultado <- flz_send_test_campaign(
  token = token,
  client_slug = "mi-empresa",
  campaign_id = 123,
  test_emails = c("test1@example.com", "test2@example.com")
)

# Con lista de prueba
resultado <- flz_send_test_campaign(
  token = token,
  client_slug = "mi-empresa",
  campaign_id = 123,
  test_list_id = 10
)

# Con prefijo en el asunto
resultado <- flz_send_test_campaign(
  token = token,
  client_slug = "mi-empresa",
  campaign_id = 123,
  test_emails = "test@example.com",
  subject_prefix = "[PRUEBA]"
)
} # }
```
