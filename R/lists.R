#' Obtener todas las listas del sistema
#'
#' @description
#' Obtiene todas las listas de contactos del sistema en Fidelizador.
#'
#' @param token Token de autenticación obtenido con `flz_auth()`
#' @param client_slug Slug del cliente de Fidelizador.
#' @param format Formato de respuesta: "json" o "xml" (por defecto "json")
#' @param base_url URL base de la API (por defecto: "https://api.fidelizador.com")
#'
#' @return Objeto con la respuesta de la API conteniendo todas las listas
#' @export
#'
#' @examples
#' \dontrun{
#' token <- flz_auth()
#'
#' # Obtener todas las listas
#' listas <- flz_get_lists(
#'   token = token,
#'   client_slug = "mi-empresa"
#' )
#' }
flz_get_lists <- function(
  token,
  client_slug,
  format = "json",
  base_url = "https://api.fidelizador.com"
) {
  # Validaciones
  if (!inherits(token, "fidelizador_token")) {
    stop("El token debe ser obtenido con flz_auth()")
  }

  if (missing(client_slug) || is.null(client_slug) || client_slug == "") {
    stop("El parámetro 'client_slug' es requerido")
  }

  # Construir endpoint
  endpoint <- paste0(base_url, "/1.0/list.", format)

  # Realizar petición
  response <- httr2::request(endpoint) |>
    httr2::req_method("GET") |>
    httr2::req_headers(
      "X-Client-Slug" = client_slug,
      "Authorization" = paste("Bearer", token$access_token)
    ) |>
    httr2::req_perform()

  # Procesar respuesta
  if (format == "json") {
    result <- response |> httr2::resp_body_json()
  } else {
    result <- response |> httr2::resp_body_string()
  }

  result
}

#' Crear una nueva lista de contactos
#'
#' @description
#' Crea una nueva lista de contactos en Fidelizador.
#'
#' @param token Token de autenticación obtenido con `flz_auth()`
#' @param client_slug Slug del cliente en Fidelizador
#' @param name Nombre de la lista
#' @param fields Vector con los slugs de campos personalizados (opcional). DEBEN SER EN MAYÚSCULAS.
#' @param format Formato de respuesta: "json" o "xml" (por defecto: "json")
#' @param base_url URL base de la API (por defecto: "https://api.fidelizador.com")
#'
#' @return Objeto con la respuesta de la API
#' @export
#'
#' @examples
#' \dontrun{
#' token <- flz_auth()
#'
#' # Crear lista simple
#' lista <- flz_create_list(
#'   token = token,
#'   client_slug = "mi-empresa",
#'   name = "Clientes Premium"
#' )
#'
#' # Crear lista con campos personalizados
#' lista <- flz_create_list(
#'   token = token,
#'   client_slug = "mi-empresa",
#'   name = "Newsletter Suscriptores",
#'   fields = c("FIRSTNAME", "LASTNAME", "COMPANY")
#' )
#' }
flz_create_list <- function(
  token,
  client_slug,
  name,
  fields = NULL,
  format = "json",
  base_url = "https://api.fidelizador.com"
) {
  # Validaciones
  if (!inherits(token, "fidelizador_token")) {
    stop("El token debe ser obtenido con flz_auth()")
  }

  if (missing(name) || is.null(name) || name == "") {
    stop("El par\u00e1metro 'name' es requerido")
  }

  # Construir endpoint
  endpoint <- paste0(base_url, "/1.0/list.", format)

  # Construir body
  body_params <- list(name = name)

  # Agregar campos personalizados si existen
  if (!is.null(fields) && length(fields) > 0) {
    # Agregar cada campo como fields[]
    for (field in fields) {
      body_params <- c(body_params, list("fields[]" = field))
    }
  }

  # Realizar petici\u00f3n
  response <- httr2::request(endpoint) |>
    httr2::req_method("POST") |>
    httr2::req_headers(
      "X-Client-Slug" = client_slug,
      "Authorization" = paste("Bearer", token$access_token)
    ) |>
    httr2::req_body_form(!!!body_params) |>
    httr2::req_perform()

  # Procesar respuesta
  if (format == "json") {
    result <- response |> httr2::resp_body_json()
  } else {
    result <- response |> httr2::resp_body_string()
  }

  result
}

#' Borrar una lista de contactos
#'
#' @description
#' Elimina una lista de contactos existente en Fidelizador.
#'
#' @param token Token de autenticaci\u00f3n obtenido con `flz_auth()`
#' @param client_slug Slug del cliente en Fidelizador
#' @param list_id ID de la lista a eliminar
#' @param method M\u00e9todo de eliminaci\u00f3n (opcional)
#'     Tipo de eliminaci\u00f3n a utilizar. 1: solo borra lista
#'     2: borra los contactos que est\u00e1n solo asociados a esta lista, 3: borra todos los contactos de la lista. Por defecto es la opci\u00f3n 1.
#' @param format Formato de respuesta: "json" o "xml" (por defecto: "json")
#' @param base_url URL base de la API (por defecto: "https://api.fidelizador.com")
#'
#' @return Objeto con la respuesta de la API
#' @export
#'
#' @details
#' Este m\u00e9todo puede devolver los siguientes c\u00f3digos de respuesta:
#' - 200: Lista eliminada exitosamente
#' - 409: Ya existe un proceso de eliminaci\u00f3n en curso
#'
#' @examples
#' \dontrun{
#' token <- flz_auth()
#'
#' # Borrar una lista
#' resultado <- flz_delete_list(
#'   token = token,
#'   client_slug = "mi-empresa",
#'   list_id = 123
#' )
#' }
flz_delete_list <- function(
  token,
  client_slug,
  list_id,
  method = NULL,
  format = "json",
  base_url = "https://api.fidelizador.com"
) {
  # Validaciones
  if (!inherits(token, "fidelizador_token")) {
    stop("El token debe ser obtenido con flz_auth()")
  }

  if (missing(list_id) || is.null(list_id)) {
    stop("El par\u00e1metro 'list_id' es requerido")
  }

  # Construir endpoint
  endpoint <- paste0(base_url, "/1.0/list/", list_id, ".", format)

  # Construir request
  req <- httr2::request(endpoint) |>
    httr2::req_method("DELETE") |>
    httr2::req_headers(
      "Content-Type" = "application/json; charset=UTF-8",
      "X-Client-Slug" = client_slug,
      "Authorization" = paste("Bearer", token$access_token)
    )

  # Agregar m\u00e9todo si se especifica
  if (!is.null(method)) {
    req <- req |> httr2::req_url_query(method = method)
  }

  # Realizar petici\u00f3n con manejo de errores espec\u00edfico
  response <- tryCatch(
    {
      req |> httr2::req_perform()
    },
    httr2_http_409 = function(e) {
      stop(
        "Ya existe un proceso de eliminaci\u00f3n en curso para esta lista (HTTP 409)",
        call. = FALSE
      )
    }
  )

  # Procesar respuesta
  if (format == "json") {
    result <- response |> httr2::resp_body_json()
  } else {
    result <- response |> httr2::resp_body_string()
  }

  result
}


#' Importar contactos a una lista
#'
#' @description
#' Crea una nueva importación de contactos desde un archivo a una lista existente en Fidelizador.
#'
#' @param token Token de autenticación obtenido con `flz_auth()`
#' @param client_slug Slug del cliente en Fidelizador
#' @param list_id ID de la lista donde se importarán los contactos
#' @param file Ruta al archivo a importar
#' @param fields Lista nombrada donde los nombres son los tags de campos (en MAYÚSCULAS)
#'   y los valores son los números de columna. Ejemplo: `list(EMAIL = 1, FIRSTNAME = 2)`
#' @param sync Indica si se debe sincronizar la lista. Valores: 0 o 1 (por defecto NULL)
#' @param ignorefirstline Indica si se debe omitir la primera línea (cabecera).
#'   Valores: 0 o 1 (por defecto NULL)
#' @param autouniquecode Indica si debe generar automáticamente el Código Identificador.
#'   Valores: 0 o 1 (por defecto NULL)
#' @param format Formato de respuesta: "json" o "xml" (por defecto "json")
#' @param base_url URL base de la API (por defecto: "https://api.fidelizador.com")
#'
#' @return Objeto con la respuesta de la API
#' @export
#'
#' @examples
#' \dontrun{
#' token <- flz_auth()
#'
#' # Importar contactos con campos básicos
#' resultado <- flz_import_contacts(
#'   token = token,
#'   client_slug = "mi-empresa",
#'   list_id = 123,
#'   file = "contactos.csv",
#'   fields = list(EMAIL = 1, FIRSTNAME = 2, LASTNAME = 3)
#' )
#'
#' # Importar con opciones adicionales
#' resultado <- flz_import_contacts(
#'   token = token,
#'   client_slug = "mi-empresa",
#'   list_id = 123,
#'   file = "contactos.csv",
#'   fields = list(EMAIL = 1, FIRSTNAME = 2),
#'   sync = 1,
#'   ignorefirstline = 1,
#'   autouniquecode = 1
#' )
#' }
flz_import_contacts <- function(
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
) {
  # Validaciones
  if (!inherits(token, "fidelizador_token")) {
    stop("El token debe ser obtenido con flz_auth()")
  }

  if (missing(list_id) || is.null(list_id)) {
    stop("El parámetro 'list_id' es requerido")
  }

  if (missing(file) || is.null(file) || file == "") {
    stop("El parámetro 'file' es requerido")
  }

  if (!file.exists(file)) {
    stop("El archivo especificado no existe: ", file)
  }

  if (missing(fields) || is.null(fields) || length(fields) == 0) {
    stop("El parámetro 'fields' es requerido y debe contener al menos un campo")
  }

  # Construir endpoint
  endpoint <- paste0(base_url, "/1.0/list/", list_id, "/import.", format)

  # Construir body con multipart
  body_parts <- list(
    file = curl::form_file(file)
  )

  # Agregar campos con nomenclatura fields[TAG-CAMPO]
  for (field_name in names(fields)) {
    param_name <- paste0("fields[", field_name, "]")
    body_parts[[param_name]] <- as.character(fields[[field_name]])
  }

  # Agregar parámetros opcionales si existen
  if (!is.null(sync)) {
    body_parts[["sync"]] <- as.character(sync)
  }

  if (!is.null(ignorefirstline)) {
    body_parts[["ignorefirstline"]] <- as.character(ignorefirstline)
  }

  if (!is.null(autouniquecode)) {
    body_parts[["autouniquecode"]] <- as.character(autouniquecode)
  }

  # Realizar petición
  response <- httr2::request(endpoint) |>
    httr2::req_method("POST") |>
    httr2::req_headers(
      "X-Client-Slug" = client_slug,
      "Authorization" = paste("Bearer", token$access_token)
    ) |>
    httr2::req_body_multipart(!!!body_parts) |>
    httr2::req_perform()

  # Procesar respuesta
  if (format == "json") {
    result <- response |> httr2::resp_body_json()
  } else {
    result <- response |> httr2::resp_body_string()
  }

  result
}
