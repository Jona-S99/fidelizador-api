# Obtener todos los usuarios existentes

Obtener todos los usuarios existentes

## Usage

``` r
flz_get_users(
  token,
  client_slug,
  username = NULL,
  only_active = NULL,
  format = "json",
  base_url = "https://api.fidelizador.com"
)
```

## Arguments

- token:

  Token de acceso obtenido con flz_auth()

- client_slug:

  Slug del cliente

- username:

  Opcional - Filtrar por nombre de usuario

- only_active:

  Opcional - Filtrar solo usuarios activos (TRUE/FALSE)

- format:

  Formato de retorno (json o xml). Por defecto: "json"

- base_url:

  URL base de la API

## Value

Lista de usuarios
