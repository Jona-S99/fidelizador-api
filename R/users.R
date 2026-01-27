#' Obtener todos los usuarios existentes
#'
#' @param token Token de acceso obtenido con flz_auth()
#' @param client_slug Slug del cliente
#' @param username Opcional - Filtrar por nombre de usuario
#' @param only_active Opcional - Filtrar solo usuarios activos (TRUE/FALSE)
#' @param format Formato de retorno (json o xml). Por defecto: "json"
#' @param base_url URL base de la API
#'
#' @return Lista de usuarios
#' @export
flz_get_users <- function(
  token,
  client_slug,
  username = NULL,
  only_active = NULL,
  format = "json",
  base_url = "https://api.fidelizador.com"
) {
  # Construir endpoint
  endpoint <- paste0(base_url, "/1.1/user.", format)

  # Construir request
  req <- httr2::request(endpoint) |>
    httr2::req_method("GET") |>
    httr2::req_headers(
      "Authorization" = paste("Bearer", token$access_token),
      "X-Client-Slug" = client_slug
    )

  # Agregar parámetros opcionales
  params <- list()
  if (!is.null(username)) {
    params$username <- username
  }
  if (!is.null(only_active)) {
    params$only_active <- only_active
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
