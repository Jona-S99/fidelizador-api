#' Crear una nueva lista de contactos
#'
#' @description
#' Crea una nueva lista de contactos en Fidelizador.
#'
#' @param token Token de autenticaci\u00f3n obtenido con `flz_auth()`
#' @param client_slug Slug del cliente en Fidelizador
#' @param name Nombre de la lista
#' @param fields Vector con los slugs de campos personalizados (opcional). DEBEN SER EN MAY\u00daSCULAS.
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


#' Obtener todas las listas de contactos
#'
#' @param token Token de acceso obtenido con flz_auth()
#' @param client_slug Slug del cliente
#' @param name Opcional - Filtrar listas por nombre
#' @param page Opcional - N\u00famero de p\u00e1gina
#' @param items Opcional - Cantidad de resultados por p\u00e1gina (1-100)
#' @param format Formato de retorno (json o xml). Por defecto: "json"
#' @param base_url URL base de la API
#'
#' @return Lista de contactos
#' @export
flz_get_lists <- function(
  token,
  client_slug,
  name = NULL,
  page = NULL,
  items = NULL,
  format = "json",
  base_url = "https://api.fidelizador.com"
) {
  # Validar items si se proporciona
  if (!is.null(items) && (items < 1 || items > 100)) {
    stop("El par\u00e1metro 'items' debe estar entre 1 y 100")
  }

  # Construir endpoint
  endpoint <- paste0(base_url, "/1.1/list.", format)

  # Construir request
  req <- httr2::request(endpoint) |>
    httr2::req_method("GET") |>
    httr2::req_headers(
      "X-Client-Slug" = client_slug,
      "Authorization" = paste("Bearer", token$access_token)
    )

  # Agregar par\u00e1metros opcionales
  params <- list()
  if (!is.null(name)) {
    params$name <- name
  }
  if (!is.null(page)) {
    params$page <- page
  }
  if (!is.null(items)) {
    params$items <- items
  }

  if (length(params) > 0) {
    req <- req |> httr2::req_url_query(!!!params)
  }

  # Realizar petici\u00f3n
  response <- req |> httr2::req_perform()

  if (format == "json") {
    response |> httr2::resp_body_json()
  } else {
    response |> httr2::resp_body_string()
  }
}

#' Importar contactos a una lista desde un archivo
#'
#' @description
#' Crea una nueva importaci\u00f3n de contactos desde un archivo CSV, TXT u otro formato
#' compatible hacia una lista existente en Fidelizador.
#'
#' @param token Token de autenticaci\u00f3n obtenido con `flz_auth()`
#' @param client_slug Slug del cliente en Fidelizador
#' @param list_id ID de la lista donde se importar\u00e1n los contactos
#' @param file_path Ruta al archivo a importar
#' @param field_mapping Lista nombrada que mapea campos a n\u00fameros de columna.
#'   Los nombres deben ser los tags de campos (ej: "EMAIL", "FIRSTNAME") y
#'   los valores los n\u00fameros de columna (empezando en 0)
#' @param sync Sincronizar la lista (0 o 1). Por defecto: NULL
#' @param ignore_first_line Omitir primera l\u00ednea del archivo/cabecera (0 o 1). Por defecto: NULL
#' @param auto_unique_code Generar autom\u00e1ticamente c\u00f3digo identificador (0 o 1). Por defecto: NULL
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
#' # Mapeo de campos: nombre del campo == n\u00famero de columna
#' campos <- list(
#'   EMAIL = 0,
#'   FIRSTNAME = 1,
#'   LASTNAME = 2,
#'   COMPANY = 3
#' )
#'
#' # Importar contactos
#' resultado <- flz_import_list(
#'   token = token,
#'   client_slug = "mi-empresa",
#'   list_id = 123,
#'   file_path = "contactos.csv",
#'   field_mapping = campos,
#'   ignore_first_line = 1
#' )
#' }
flz_import_list <- function(
  token,
  client_slug,
  list_id,
  file_path,
  field_mapping,
  sync = NULL,
  ignore_first_line = NULL,
  auto_unique_code = NULL,
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

  if (missing(file_path) || is.null(file_path)) {
    stop("El par\u00e1metro 'file_path' es requerido")
  }

  if (!file.exists(file_path)) {
    stop("El archivo especificado no existe: ", file_path)
  }

  if (
    missing(field_mapping) ||
      is.null(field_mapping) ||
      length(field_mapping) == 0
  ) {
    stop(
      "El par\u00e1metro 'field_mapping' es requerido y debe contener al menos un campo"
    )
  }

  # Construir endpoint
  endpoint <- paste0(base_url, "/1.0/list/", list_id, "/import.", format)

  # Construir body con el archivo
  body_params <- list(
    file = curl::form_file(file_path)
  )

  # Agregar mapeo de campos
  # Cada campo debe enviarse como fields[TAG-CAMPO] = n\u00famero_columna
  for (field_name in names(field_mapping)) {
    param_name <- paste0("fields[", field_name, "]")
    body_params[[param_name]] <- as.character(field_mapping[[field_name]])
  }

  # Agregar par\u00e1metros opcionales
  if (!is.null(sync)) {
    body_params$sync <- as.character(sync)
  }
  if (!is.null(ignore_first_line)) {
    body_params$ignorefirstline <- as.character(ignore_first_line)
  }
  if (!is.null(auto_unique_code)) {
    body_params$autouniquecode <- as.character(auto_unique_code)
  }

  # Realizar petici\u00f3n
  response <- httr2::request(endpoint) |>
    httr2::req_method("POST") |>
    httr2::req_headers(
      "X-Client-Slug" = client_slug,
      "Authorization" = paste("Bearer", token$access_token)
    ) |>
    httr2::req_body_multipart(!!!body_params) |>
    httr2::req_perform()

  # Procesar respuesta
  if (format == "json") {
    result <- response |> httr2::resp_body_json()
  } else {
    result <- response |> httr2::resp_body_string()
  }

  result
}
