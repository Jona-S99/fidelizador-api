#' Obtener todas las listas de contactos
#'
#' @param token Token de acceso obtenido con flz_auth()
#' @param client_slug Slug del cliente
#' @param name Opcional - Filtrar listas por nombre
#' @param page Opcional - Número de página
#' @param items Opcional - Cantidad de resultados por página (1-100)
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
    stop("El parámetro 'items' debe estar entre 1 y 100")
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

  # Agregar parámetros opcionales
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

  # Realizar petición
  response <- req |> httr2::req_perform()

  # Retornar datos según formato
  if (format == "json") {
    response |> httr2::resp_body_json()
  } else {
    response |> httr2::resp_body_string()
  }
}
