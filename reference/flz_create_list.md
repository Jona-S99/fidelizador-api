# Crear una nueva lista de contactos

Crea una nueva lista de contactos en Fidelizador.

## Usage

``` r
flz_create_list(
  token,
  client_slug,
  name,
  fields = NULL,
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

  Nombre de la lista

- fields:

  Vector con los slugs de campos personalizados (opcional). DEBEN SER EN
  MAYÚSCULAS.

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

# Crear lista simple
lista <- flz_create_list(
  token = token,
  client_slug = "mi-empresa",
  name = "Clientes Premium"
)

# Crear lista con campos personalizados
lista <- flz_create_list(
  token = token,
  client_slug = "mi-empresa",
  name = "Newsletter Suscriptores",
  fields = c("FIRSTNAME", "LASTNAME", "COMPANY")
)
} # }
```
