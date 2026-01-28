# Borrar una lista de contactos

Elimina una lista de contactos existente en Fidelizador.

## Usage

``` r
flz_delete_list(
  token,
  client_slug,
  list_id,
  method = NULL,
  format = "json",
  base_url = "https://api.fidelizador.com"
)
```

## Arguments

- token:

  Token de autenticaci obtenido con
  [`flz_auth()`](https://Jona-S99.github.io/fidelizadorapi/reference/flz_auth.md)

- client_slug:

  Slug del cliente en Fidelizador

- list_id:

  ID de la lista a eliminar

- method:

  M de eliminaci (opcional) Tipo de eliminaci a utilizar. 1: solo borra
  lista 2: borra los contactos que est solo asociados a esta lista, 3:
  borra todos los contactos de la lista. Por defecto es la opci 1.

- format:

  Formato de respuesta: "json" o "xml" (por defecto: "json")

- base_url:

  URL base de la API (por defecto: "https://api.fidelizador.com")

## Value

Objeto con la respuesta de la API

## Details

Este m puede devolver los siguientes c de respuesta:

- 200: Lista eliminada exitosamente

- 409: Ya existe un proceso de eliminaci en curso

## Examples

``` r
if (FALSE) { # \dontrun{
token <- flz_auth()

# Borrar una lista
resultado <- flz_delete_list(
  token = token,
  client_slug = "mi-empresa",
  list_id = 123
)
} # }
```
