#' Guardar credenciales en variables de entorno
#'
#' @param client_id Client ID
#' @param client_secret Client Secret
#'
#' @export
flz_set_credentials <- function(client_id, client_secret) {
  Sys.setenv(
    FIDELIZADOR_CLIENT_ID = client_id,
    FIDELIZADOR_CLIENT_SECRET = client_secret
  )
  message("Credenciales guardadas en la sesión actual")
}

#' Obtener credenciales desde variables de entorno
#'
#' @return Lista con client_id y client_secret
#' @export
flz_get_credentials <- function() {
  client_id <- Sys.getenv("FIDELIZADOR_CLIENT_ID")
  client_secret <- Sys.getenv("FIDELIZADOR_CLIENT_SECRET")

  if (client_id == "" || client_secret == "") {
    stop(
      "Credenciales no encontradas.\nUse flz_set_credentials() para establecerlas como variables de entorno.",
    )
  }

  list(
    client_id = client_id,
    client_secret = client_secret
  )
}


#' Autenticarse con la API de Fidelizador usando Client Credentials
#'
#' @param client_id Client ID obtenido del portal de Fidelizador (opcional si ya se seteó como variable de entorno)
#' @param client_secret Client Secret obtenido del portal de Fidelizador (opcional si ya se seteó como variable de entorno)
#' @param base_url URL base de la API (por defecto: "https://api.fidelizador.com")
#'
#' @return Token de acceso
#' @export
flz_auth <- function(
  client_id = NULL,
  client_secret = NULL,
  base_url = "https://api.fidelizador.com"
) {
  # 1. Ccredenciales
  # Si no se proporcionan, obtenerlas del entorno
  if (is.null(client_id) || is.null(client_secret)) {
    creds <- flz_get_credentials()
    client_id <- creds$client_id
    client_secret <- creds$client_secret
  }

  # 2. Endpoint de autenticación
  endpoint <- paste0(base_url, "/oauth/v2/token")

  # 3. Realizar la solicitud de token
  response <- httr2::request(endpoint) |>
    httr2::req_method("POST") |>
    httr2::req_headers(
      "Content-Type" = "application/x-www-form-urlencoded"
    ) |>
    httr2::req_body_form(
      grant_type = "client_credentials",
      client_id = client_id,
      client_secret = client_secret
    ) |>
    httr2::req_perform()

  token_data <- response |> httr2::resp_body_json()

  structure(
    list(
      access_token = token_data$access_token,
      token_type = token_data$token_type %||% "Bearer",
      expires_in = token_data$expires_in,
      created_at = Sys.time()
    ),
    class = "fidelizador_token"
  )
}
