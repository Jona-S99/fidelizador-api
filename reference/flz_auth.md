# Autenticarse con la API de Fidelizador usando Client Credentials

Autenticarse con la API de Fidelizador usando Client Credentials

## Usage

``` r
flz_auth(
  client_id = NULL,
  client_secret = NULL,
  base_url = "https://api.fidelizador.com"
)
```

## Arguments

- client_id:

  Client ID obtenido del portal de Fidelizador (opcional si ya se sete
  como variable de entorno)

- client_secret:

  Client Secret obtenido del portal de Fidelizador (opcional si ya se
  sete como variable de entorno)

- base_url:

  URL base de la API (por defecto: "https://api.fidelizador.com")

## Value

Token de acceso
