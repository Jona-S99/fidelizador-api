# Obtener listado de categorías

Obtiene un listado de todas las categorías en Fidelizador.

## Usage

``` r
flz_get_categories(
  token,
  client_slug,
  name = NULL,
  page = NULL,
  items = NULL,
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

  Opcional - Filtrar categorías por nombre

- page:

  Opcional - Número de página (si hay paginación)

- items:

  Opcional - Cantidad de resultados por página (1-100)

- format:

  Formato de respuesta: "json" o "xml" (por defecto: "json")

- base_url:

  URL base de la API (por defecto: "https://api.fidelizador.com")

## Value

Objeto con la respuesta de la API conteniendo las categorías

## Examples

``` r
if (FALSE) { # \dontrun{
token <- flz_auth()

# Obtener todas las categorías
categorias <- flz_get_categories(
  token = token,
  client_slug = "mi-empresa"
)

# Filtrar por nombre
categorias <- flz_get_categories(
  token = token,
  client_slug = "mi-empresa",
  name = "Newsletter"
)

# Con paginación
categorias <- flz_get_categories(
  token = token,
  client_slug = "mi-empresa",
  page = 1,
  items = 50
)
} # }
```
