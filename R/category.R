#' Obtener listado de categorías
#'
#' @description
#' Obtiene un listado de todas las categorías en Fidelizador.
#'
#' @param token Token de autenticación obtenido con `flz_auth()`
#' @param client_slug Slug del cliente en Fidelizador
#' @param name Opcional - Filtrar categorías por nombre
#' @param page Opcional - Número de página (si hay paginación)
#' @param items Opcional - Cantidad de resultados por página (1-100)
#' @param format Formato de respuesta: "json" o "xml" (por defecto: "json")
#' @param base_url URL base de la API (por defecto: "https://api.fidelizador.com")
#'
#' @return Objeto con la respuesta de la API conteniendo las categorías
#' @export
#'
#' @examples
#' \dontrun{
#' token <- flz_auth()
#'
#' # Obtener todas las categorías
#' categorias <- flz_get_categories(
#'   token = token,
#'   client_slug = "mi-empresa"
#' )
#'
#' # Filtrar por nombre
#' categorias <- flz_get_categories(
#'   token = token,
#'   client_slug = "mi-empresa",
#'   name = "Newsletter"
#' )
#'
#' # Con paginación
#' categorias <- flz_get_categories(
#'   token = token,
#'   client_slug = "mi-empresa",
#'   page = 1,
#'   items = 50
#' )
#' }
flz_get_categories <- function(
  token,
  client_slug,
  name = NULL,
  page = NULL,
  items = NULL,
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

  # Validar items si se proporciona
  if (!is.null(items)) {
    if (!is.numeric(items) || items < 1 || items > 100) {
      stop("El parámetro 'items' debe ser un número entre 1 y 100")
    }
  }

  # Construir endpoint
  endpoint <- paste0(base_url, "/1.1/category.", format)

  # Construir request base
  req <- httr2::request(endpoint) |>
    httr2::req_method("GET") |>
    httr2::req_headers(
      "X-Client-Slug" = client_slug,
      "Authorization" = paste("Bearer", token$access_token)
    )

  # Agregar parámetros query opcionales
  query_params <- list()

  if (!is.null(name)) {
    query_params$name <- name
  }
  if (!is.null(page)) {
    query_params$page <- page
  }
  if (!is.null(items)) {
    query_params$items <- items
  }

  if (length(query_params) > 0) {
    req <- req |> httr2::req_url_query(!!!query_params)
  }

  # Realizar petición con manejo de errores
  response <- tryCatch(
    {
      req |> httr2::req_perform()
    },
    httr2_http_401 = function(e) {
      stop(
        "Error de autenticación (HTTP 401).\n",
        "Verifique:\n",
        "  1. Las credenciales tienen permisos de 'Categorías (Lectura)'\n",
        "  2. El client_slug '",
        client_slug,
        "' es correcto\n",
        "  3. El token no ha expirado",
        call. = FALSE
      )
    },
    httr2_http_400 = function(e) {
      stop(
        "Error en los parámetros (HTTP 400).\n",
        "Verifique que los parámetros sean válidos:\n",
        "  - items debe estar entre 1 y 100\n",
        "  - page debe ser un número positivo",
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
