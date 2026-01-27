#' Crear una nueva campaña de newsletter
#'
#' @description
#' Crea una nueva campaña de newsletter en Fidelizador y la deja en estado borrador.
#'
#' @param token Token de autenticación obtenido con `flz_auth()`
#' @param client_slug Slug del cliente en Fidelizador
#' @param name Nombre de la campaña
#' @param category_id ID de la categoría
#' @param subject Asunto del correo
#' @param sender_email Email del remitente (debe estar registrado)
#' @param reply_to_name Nombre para "Responder a"
#' @param reply_to Email para "Responder a"
#' @param list_id ID de la lista de contactos (opcional si se usa list_segment_id)
#' @param list_segment_id ID del segmento (opcional si se usa list_id)
#' @param dynamic_sender_id ID del remitente dinámico (opcional)
#' @param has_google_analytics Activar tracking de Google Analytics (opcional)
#' @param update_form_id ID del formulario de actualización (opcional)
#' @param twitter_username Usuario de Twitter (opcional)
#' @param twitter_message Mensaje de Twitter (opcional)
#' @param content Contenido HTML de la campaña (opcional)
#' @param template_id ID del template (opcional, tiene prioridad sobre content)
#' @param labels Vector de etiquetas (opcional)
#' @param calendar_id ID del calendario para programación (opcional)
#' @param attachments Vector de archivos para adjuntar (opcional)
#' @param permissions Vector de emails para permisos (opcional)
#' @param group_ids Vector de IDs de grupos para permisos (opcional)
#' @param documents Vector de IDs de documentos (opcional)
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
#' campaign <- flz_create_campaign(
#'   token = token,
#'   client_slug = "mi-empresa",
#'   name = "Newsletter Enero 2026",
#'   category_id = 1,
#'   subject = "¡Novedades de Enero!",
#'   sender_email = "contacto@miempresa.com",
#'   reply_to_name = "Equipo Marketing",
#'   reply_to = "marketing@miempresa.com",
#'   list_id = 123,
#'   content = "<h1>Hola!</h1><p>Contenido de la campaña</p>"
#' )
#' }
flz_create_campaign_newsletter <- function(
  token,
  client_slug,
  name,
  category_id,
  subject,
  sender_email,
  reply_to_name,
  reply_to,
  list_id = NULL,
  list_segment_id = NULL,
  dynamic_sender_id = NULL,
  has_google_analytics = NULL,
  update_form_id = NULL,
  twitter_username = NULL,
  twitter_message = NULL,
  content = NULL,
  template_id = NULL,
  labels = NULL,
  calendar_id = NULL,
  attachments = NULL,
  permissions = NULL,
  group_ids = NULL,
  documents = NULL,
  format = "json",
  base_url = "https://api.fidelizador.com"
) {
  # Validaciones
  if (!inherits(token, "fidelizador_token")) {
    stop("El token debe ser obtenido con flz_auth()")
  }

  if (is.null(list_id) && is.null(list_segment_id)) {
    stop("Debe proporcionar list_id o list_segment_id")
  }

  # Construir endpoint
  endpoint <- paste0(base_url, "/1.1/campaign/newsletter.", format)

  # Construir body con parámetros requeridos
  body_params <- list(
    name = name,
    category_id = category_id,
    subject = subject,
    sender_email = sender_email,
    reply_to_name = reply_to_name,
    reply_to = reply_to
  )

  # Agregar parámetros opcionales si están presentes
  if (!is.null(list_id)) {
    body_params$list_id <- list_id
  }
  if (!is.null(list_segment_id)) {
    body_params$list_segment_id <- list_segment_id
  }
  if (!is.null(dynamic_sender_id)) {
    body_params$dynamic_sender_id <- dynamic_sender_id
  }
  if (!is.null(has_google_analytics)) {
    body_params$has_google_analytics <- has_google_analytics
  }
  if (!is.null(update_form_id)) {
    body_params$update_form_id <- update_form_id
  }
  if (!is.null(twitter_username)) {
    body_params$twitter_username <- twitter_username
  }
  if (!is.null(twitter_message)) {
    body_params$twitter_message <- twitter_message
  }
  if (!is.null(content)) {
    body_params$content <- content
  }
  if (!is.null(template_id)) {
    body_params$template_id <- template_id
  }
  if (!is.null(labels)) {
    body_params$labels <- labels
  }
  if (!is.null(calendar_id)) {
    body_params$calendar_id <- calendar_id
  }
  if (!is.null(attachments)) {
    body_params$attachments <- attachments
  }
  if (!is.null(permissions)) {
    body_params$permissions <- permissions
  }
  if (!is.null(group_ids)) {
    body_params$group_ids <- group_ids
  }
  if (!is.null(documents)) {
    body_params$documents <- documents
  }

  # Realizar petición
  response <- httr2::request(endpoint) |>
    httr2::req_method("POST") |>
    httr2::req_headers(
      "X-Client-Slug" = client_slug,
      "Authorization" = paste(token$token_type, token$access_token)
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
