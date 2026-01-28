# Obtener todas las listas del sistema

Obtiene todas las listas de contactos del sistema en Fidelizador.

## Usage

``` r
flz_get_lists(
  token,
  client_slug,
  format = "json",
  base_url = "https://api.fidelizador.com"
)
```

## Arguments

- token:

  Token de autenticación obtenido con
  [`flz_auth()`](https://Jona-S99.github.io/fidelizadorapi/reference/flz_auth.md)

- client_slug:

  Slug del cliente de Fidelizador.

- format:

  Formato de respuesta: "json" o "xml" (por defecto "json")

- base_url:

  URL base de la API (por defecto: "https://api.fidelizador.com")

## Value

Objeto con la respuesta de la API conteniendo todas las listas

## Examples

``` r
if (FALSE) { # \dontrun{
token <- flz_auth()

# Obtener todas las listas
listas <- flz_get_lists(
  token = token,
  client_slug = "mi-empresa"
)
} # }
```
