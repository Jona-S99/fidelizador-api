# Importar contactos a una lista

Crea una nueva importación de contactos desde un archivo a una lista
existente en Fidelizador.

## Usage

``` r
flz_import_contacts(
  token,
  client_slug,
  list_id,
  file,
  fields,
  sync = NULL,
  ignorefirstline = NULL,
  autouniquecode = NULL,
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

- list_id:

  ID de la lista donde se importarán los contactos

- file:

  Ruta al archivo a importar

- fields:

  Lista nombrada donde los nombres son los tags de campos (en
  MAYÚSCULAS) y los valores son los números de columna. Ejemplo:
  `list(EMAIL = 1, FIRSTNAME = 2)`

- sync:

  Indica si se debe sincronizar la lista. Valores: 0 o 1 (por defecto
  NULL)

- ignorefirstline:

  Indica si se debe omitir la primera línea (cabecera). Valores: 0 o 1
  (por defecto NULL)

- autouniquecode:

  Indica si debe generar automáticamente el Código Identificador.
  Valores: 0 o 1 (por defecto NULL)

- format:

  Formato de respuesta: "json" o "xml" (por defecto "json")

- base_url:

  URL base de la API (por defecto: "https://api.fidelizador.com")

## Value

Objeto con la respuesta de la API

## Examples

``` r
if (FALSE) { # \dontrun{
token <- flz_auth()

# Importar contactos con campos básicos
resultado <- flz_import_contacts(
  token = token,
  client_slug = "mi-empresa",
  list_id = 123,
  file = "contactos.csv",
  fields = list(EMAIL = 1, FIRSTNAME = 2, LASTNAME = 3)
)

# Importar con opciones adicionales
resultado <- flz_import_contacts(
  token = token,
  client_slug = "mi-empresa",
  list_id = 123,
  file = "contactos.csv",
  fields = list(EMAIL = 1, FIRSTNAME = 2),
  sync = 1,
  ignorefirstline = 1,
  autouniquecode = 1
)
} # }
```
