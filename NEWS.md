# fidelizadorapi (development version)

## 0.0.1: funcionalidades iniciales

### Autenticación
* `flz_set_credentials()`: Guarda las credenciales en variables de entorno
* `flz_get_credentials()`: Obtiene las credenciales desde variables de entorno
* `flz_auth()`: Autenticación con la API usando Client Credentials

### Gestión de listas
* `flz_get_lists()`: Obtiene todas las listas de contactos
* `flz_create_list()`: Crea una nueva lista de contactos
* `flz_delete_list()`: Elimina una lista existente

### Gestión de categorías
* `flz_get_categories()`: Obtiene el listado de categorías

### Gestión de campañas
* `flz_create_campaign_newsletter()`: Crea una nueva campaña de newsletter
* `flz_send_test_campaign()`: Envía una nueva campaña de prueba a correos específicos
* `flz_schedule_campaign()`: Programa el envío de campaña, o la envía inmediatamente

### Gestión de usuarios
* `flz_get_users()`: Obtiene todos los usuarios existentes


