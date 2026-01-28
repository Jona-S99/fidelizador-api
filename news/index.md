# Changelog

## fidelizadorapi (development version)

### 0.0.1: funcionalidades iniciales

#### Autenticación

- [`flz_set_credentials()`](https://Jona-S99.github.io/fidelizadorapi/reference/flz_set_credentials.md):
  Guarda las credenciales en variables de entorno
- [`flz_get_credentials()`](https://Jona-S99.github.io/fidelizadorapi/reference/flz_get_credentials.md):
  Obtiene las credenciales desde variables de entorno
- [`flz_auth()`](https://Jona-S99.github.io/fidelizadorapi/reference/flz_auth.md):
  Autenticación con la API usando Client Credentials

#### Gestión de listas

- [`flz_get_lists()`](https://Jona-S99.github.io/fidelizadorapi/reference/flz_get_lists.md):
  Obtiene todas las listas de contactos
- [`flz_create_list()`](https://Jona-S99.github.io/fidelizadorapi/reference/flz_create_list.md):
  Crea una nueva lista de contactos
- [`flz_delete_list()`](https://Jona-S99.github.io/fidelizadorapi/reference/flz_delete_list.md):
  Elimina una lista existente

#### Gestión de categorías

- [`flz_get_categories()`](https://Jona-S99.github.io/fidelizadorapi/reference/flz_get_categories.md):
  Obtiene el listado de categorías

#### Gestión de campañas

- [`flz_create_campaign_newsletter()`](https://Jona-S99.github.io/fidelizadorapi/reference/flz_create_campaign_newsletter.md):
  Crea una nueva campaña de newsletter
- [`flz_send_test_campaign()`](https://Jona-S99.github.io/fidelizadorapi/reference/flz_send_test_campaign.md):
  Envía una nueva campaña de prueba a correos específicos
- [`flz_schedule_campaign()`](https://Jona-S99.github.io/fidelizadorapi/reference/flz_schedule_campaign.md):
  Programa el envío de campaña, o la envía inmediatamente

#### Gestión de usuarios

- [`flz_get_users()`](https://Jona-S99.github.io/fidelizadorapi/reference/flz_get_users.md):
  Obtiene todos los usuarios existentes
