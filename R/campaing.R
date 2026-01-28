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

  # Validar que category_id sea numérico
  if (!is.numeric(category_id) && !grepl("^\\d+$", as.character(category_id))) {
    stop(
      "El parámetro 'category_id' debe ser un ID numérico.\n",
      "Ejemplo: category_id = 1 (no use nombres como 'General')"
    )
  }

  # Validar que list_id sea numérico si se proporciona
  if (!is.null(list_id)) {
    if (!is.numeric(list_id) && !grepl("^\\d+$", as.character(list_id))) {
      stop("El parámetro 'list_id' debe ser un ID numérico")
    }
  }

  # Construir endpoint
  endpoint <- paste0(base_url, "/1.1/campaign/newsletter.", format)

  # Construir body con parámetros requeridos
  # Convertir valores numéricos a string para multipart/form-data
  body_params <- list(
    name = name,
    category_id = as.character(category_id),
    subject = subject,
    sender_email = sender_email,
    reply_to_name = reply_to_name,
    reply_to = reply_to
  )

  # Agregar parámetros opcionales si están presentes
  if (!is.null(list_id)) {
    body_params$list_id <- as.character(list_id)
  }
  if (!is.null(list_segment_id)) {
    body_params$list_segment_id <- as.character(list_segment_id)
  }
  if (!is.null(dynamic_sender_id)) {
    body_params$dynamic_sender_id <- as.character(dynamic_sender_id)
  }
  if (!is.null(has_google_analytics)) {
    body_params$has_google_analytics <- as.character(has_google_analytics)
  }
  if (!is.null(update_form_id)) {
    body_params$update_form_id <- as.character(update_form_id)
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
    body_params$template_id <- as.character(template_id)
  }
  if (!is.null(labels)) {
    body_params$labels <- labels
  }
  if (!is.null(calendar_id)) {
    body_params$calendar_id <- as.character(calendar_id)
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

  # Realizar petición con manejo de errores
  response <- tryCatch(
    {
      httr2::request(endpoint) |>
        httr2::req_method("POST") |>
        httr2::req_headers(
          "X-Client-Slug" = client_slug,
          "Authorization" = paste("Bearer", token$access_token)
        ) |>
        httr2::req_body_multipart(!!!body_params) |>
        httr2::req_perform()
    },
    httr2_http_400 = function(e) {
      # Intentar extraer mensaje de error del cuerpo de la respuesta
      error_msg <- "HTTP 400 Bad Request - Parámetros inválidos.\n"

      if (!is.null(e$resp)) {
        tryCatch(
          {
            body <- httr2::resp_body_json(e$resp)
            if (!is.null(body$message)) {
              error_msg <- paste0(
                error_msg,
                "Mensaje de la API: ",
                body$message,
                "\n"
              )
            }
            if (!is.null(body$errors)) {
              error_msg <- paste0(
                error_msg,
                "Errores: ",
                paste(body$errors, collapse = ", "),
                "\n"
              )
            }
          },
          error = function(e2) {
            # Si no se puede parsear el JSON, continuar
          }
        )
      }

      error_msg <- paste0(
        error_msg,
        "\nVerifique:\n",
        "  1. category_id debe ser un ID numérico (ej: 1), no un nombre\n",
        "  2. list_id debe ser numérico\n",
        "  3. sender_email debe estar registrado en Fidelizador\n",
        "  4. Todos los campos requeridos están presentes"
      )

      stop(error_msg, call. = FALSE)
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


#' Enviar campaña de prueba
#'
#' @description
#' Envía una campaña de prueba a correos específicos para verificar que cumple
#' los requerimientos antes del envío definitivo.
#'
#' @param token Token de autenticación obtenido con `flz_auth()`
#' @param client_slug Slug del cliente en Fidelizador
#' @param campaign_id ID de la campaña existente en estado borrador
#' @param test_emails Vector de correos electrónicos para enviar la prueba
#' @param test_list_id Opcional - ID de la lista de pruebas a utilizar (tiene prioridad sobre test_emails)
#' @param test_contact Opcional - Correo del contacto del cual se obtendrá la información para las pruebas
#' @param subject_prefix Opcional - Prefijo del asunto a utilizar
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
#' # Enviar prueba a correos específicos
#' resultado <- flz_send_test_campaign(
#'   token = token,
#'   client_slug = "mi-empresa",
#'   campaign_id = 123,
#'   test_emails = c("test1@example.com", "test2@example.com")
#' )
#'
#' # Con lista de prueba
#' resultado <- flz_send_test_campaign(
#'   token = token,
#'   client_slug = "mi-empresa",
#'   campaign_id = 123,
#'   test_list_id = 10
#' )
#'
#' # Con prefijo en el asunto
#' resultado <- flz_send_test_campaign(
#'   token = token,
#'   client_slug = "mi-empresa",
#'   campaign_id = 123,
#'   test_emails = "test@example.com",
#'   subject_prefix = "[PRUEBA]"
#' )
#' }
flz_send_test_campaign <- function(
  token,
  client_slug,
  campaign_id,
  test_emails = NULL,
  test_list_id = NULL,
  test_contact = NULL,
  subject_prefix = NULL,
  format = "json",
  base_url = "https://api.fidelizador.com"
) {
  # Validaciones
  if (!inherits(token, "fidelizador_token")) {
    stop("El token debe ser obtenido con flz_auth()")
  }

  if (missing(campaign_id) || is.null(campaign_id)) {
    stop("El parámetro 'campaign_id' es requerido")
  }

  if (is.null(test_emails) && is.null(test_list_id)) {
    stop("Debe proporcionar 'test_emails' o 'test_list_id'")
  }

  # Construir endpoint
  endpoint <- paste0(
    base_url,
    "/1.1/campaign/",
    campaign_id,
    "/send_test.",
    format
  )

  # Construir body de la petición
  body_params <- list()

  if (!is.null(test_emails)) {
    # Si es un vector, convertir a string separado por comas
    if (is.vector(test_emails) && length(test_emails) > 1) {
      body_params$test_emails <- paste(test_emails, collapse = ",")
    } else {
      body_params$test_emails <- as.character(test_emails)
    }
  }

  if (!is.null(test_list_id)) {
    body_params$test_list_id <- as.character(test_list_id)
  }

  if (!is.null(test_contact)) {
    body_params$test_contact <- as.character(test_contact)
  }

  if (!is.null(subject_prefix)) {
    body_params$subject_prefix <- as.character(subject_prefix)
  }

  # Realizar petición con manejo de errores
  response <- tryCatch(
    {
      httr2::request(endpoint) |>
        httr2::req_method("POST") |>
        httr2::req_headers(
          "X-Client-Slug" = client_slug,
          "Authorization" = paste("Bearer", token$access_token)
        ) |>
        httr2::req_body_multipart(!!!body_params) |>
        httr2::req_perform()
    },
    httr2_http_400 = function(e) {
      error_msg <- "HTTP 400 Bad Request - Parámetros inválidos.\n"

      if (!is.null(e$resp)) {
        tryCatch(
          {
            body <- httr2::resp_body_json(e$resp)
            if (!is.null(body$message)) {
              error_msg <- paste0(error_msg, "Mensaje: ", body$message, "\n")
            }
          },
          error = function(e2) {}
        )
      }

      error_msg <- paste0(
        error_msg,
        "\nVerifique:\n",
        "  1. campaign_id es válido y la campaña está en borrador\n",
        "  2. test_emails tienen formato válido\n",
        "  3. test_list_id existe si se proporciona"
      )

      stop(error_msg, call. = FALSE)
    },
    httr2_http_404 = function(e) {
      stop(
        "Campaña no encontrada (HTTP 404).\n",
        "Verifique que el campaign_id '",
        campaign_id,
        "' sea correcto.",
        call. = FALSE
      )
    },
    httr2_http_401 = function(e) {
      stop(
        "Error de autenticación (HTTP 401).\n",
        "Verifique:\n",
        "  1. Las credenciales tienen permisos de 'Campaña de email'\n",
        "  2. El token no ha expirado",
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

#' Programar envío de campaña
#'
#' @description
#' Comprueba si la campaña cumple los requerimientos de envío y la programa
#' para ser enviada inmediatamente o en una fecha específica.
#'
#' @param token Token de autenticación obtenido con `flz_auth()`
#' @param client_slug Slug del cliente en Fidelizador
#' @param campaign_id ID de la campaña existente en estado borrador
#' @param send_now Lógico - Si TRUE, programa la campaña para envío inmediato (por defecto: NULL)
#' @param scheduled_at Fecha y hora de envío programado. Formato: "YYYY-MM-DD HH:MM:SS" (por defecto: NULL)
#' @param timezone Opcional - Zona horaria para la programación (ej: "America/Santiago")
#' @param format Formato de respuesta: "json" o "xml" (por defecto: "json")
#' @param base_url URL base de la API (por defecto: "https://api.fidelizador.com")
#'
#' @return Objeto con la respuesta de la API
#' @export
#'
#' @details
#' Este método requiere al menos uno de los siguientes permisos:
#' - Campaña de email (Lectura y escritura)
#' - Permisos generales (Todos)
#'
#' Debe proporcionar OBLIGATORIAMENTE uno de los siguientes:
#' - `send_now = TRUE` para envío inmediato
#' - `scheduled_at` con fecha y hora específica
#'
#' @examples
#' \dontrun{
#' token <- flz_auth()
#'
#' # Envío inmediato
#' resultado <- flz_schedule_campaign(
#'   token = token,
#'   client_slug = "mi-empresa",
#'   campaign_id = 123,
#'   send_now = TRUE
#' )
#'
#' # Programar para fecha específica
#' resultado <- flz_schedule_campaign(
#'   token = token,
#'   client_slug = "mi-empresa",
#'   campaign_id = 123,
#'   scheduled_at = "2026-02-01 10:00:00",
#'   timezone = "America/Santiago"
#' )
#' }
flz_schedule_campaign <- function(
  token,
  client_slug,
  campaign_id,
  send_now = NULL,
  scheduled_at = NULL,
  timezone = NULL,
  format = "json",
  base_url = "https://api.fidelizador.com"
) {
  # Validaciones
  if (!inherits(token, "fidelizador_token")) {
    stop("El token debe ser obtenido con flz_auth()")
  }

  if (missing(campaign_id) || is.null(campaign_id)) {
    stop("El parámetro 'campaign_id' es requerido")
  }

  # Validar que se proporcione al menos uno de los parámetros requeridos
  if (is.null(send_now) && is.null(scheduled_at)) {
    stop(
      "Debe proporcionar 'send_now = TRUE' o 'scheduled_at' con una fecha.\n",
      "Ejemplo: send_now = TRUE o scheduled_at = '2026-02-01 10:00:00'"
    )
  }

  # Validar que no se proporcionen ambos
  if (!is.null(send_now) && !is.null(scheduled_at)) {
    warning(
      "Se proporcionaron 'send_now' y 'scheduled_at'. ",
      "Se usará 'send_now' y se ignorará 'scheduled_at'."
    )
  }

  # Construir endpoint
  endpoint <- paste0(
    base_url,
    "/1.1/campaign/",
    campaign_id,
    "/schedule.",
    format
  )

  # Construir body de la petición
  body_params <- list()

  if (!is.null(send_now) && isTRUE(send_now)) {
    body_params$send_now <- "true"
  } else if (!is.null(scheduled_at)) {
    # Validar formato de fecha
    if (!grepl("^\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}$", scheduled_at)) {
      stop(
        "El formato de 'scheduled_at' debe ser: 'YYYY-MM-DD HH:MM:SS'\n",
        "Ejemplo: '2026-02-01 10:00:00'"
      )
    }
    body_params$scheduled_at <- scheduled_at
  }

  if (!is.null(timezone)) {
    body_params$timezone <- as.character(timezone)
  }

  # Realizar petición con manejo de errores
  response <- tryCatch(
    {
      httr2::request(endpoint) |>
        httr2::req_method("POST") |>
        httr2::req_headers(
          "X-Client-Slug" = client_slug,
          "Authorization" = paste("Bearer", token$access_token)
        ) |>
        httr2::req_body_multipart(!!!body_params) |>
        httr2::req_perform()
    },
    httr2_http_400 = function(e) {
      error_msg <- "HTTP 400 Bad Request - Error al programar campaña.\n"

      if (!is.null(e$resp)) {
        tryCatch(
          {
            body <- httr2::resp_body_json(e$resp)
            if (!is.null(body$message)) {
              error_msg <- paste0(error_msg, "Mensaje: ", body$message, "\n")
            }
            if (!is.null(body$errors)) {
              error_msg <- paste0(
                error_msg,
                "Errores: ",
                paste(body$errors, collapse = ", "),
                "\n"
              )
            }
          },
          error = function(e2) {}
        )
      }

      error_msg <- paste0(
        error_msg,
        "\nVerifique:\n",
        "  1. La campaña está completa y lista para enviar\n",
        "  2. El formato de fecha es correcto (YYYY-MM-DD HH:MM:SS)\n",
        "  3. La zona horaria es válida si se especificó\n",
        "  4. La campaña tiene contenido y destinatarios configurados"
      )

      stop(error_msg, call. = FALSE)
    },
    httr2_http_404 = function(e) {
      stop(
        "Campaña no encontrada (HTTP 404).\n",
        "Verifique que el campaign_id '",
        campaign_id,
        "' sea correcto y la campaña exista.",
        call. = FALSE
      )
    },
    httr2_http_401 = function(e) {
      stop(
        "Error de autenticación (HTTP 401).\n",
        "Verifique:\n",
        "  1. Las credenciales tienen permisos de 'Campaña de email'\n",
        "  2. El token no ha expirado",
        call. = FALSE
      )
    },
    httr2_http_409 = function(e) {
      stop(
        "Conflicto al programar campaña (HTTP 409).\n",
        "La campaña puede que ya esté programada o en proceso de envío.",
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
