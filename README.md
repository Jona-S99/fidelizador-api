
# fidelizadorapi <img src="man/figures/fidelizador_logo_pkg.png" align="right" height="138" />

> Cliente R para la API oficial de Fidelizador

## Descripción

`fidelizadorapi` es una librería de R que reúne funciones para trabajar con la API oficial de Fidelizador, facilitando tareas de autenticación, consulta de recursos y gestión de campañas desde R.

## Instalación

Puedes instalar la versión en desarrollo desde GitHub:

```r
# Instalar pak si no lo tienes
install.packages("pak")

# Instalar fidelizador-api desde GitHub
pak::pkg_install("Jona-S99/fidelizador-api")
```

## Requisitos

- R >= 4.0.0
- httr2

## Configuración

### Obtener credenciales

1. Accede al portal de Fidelizador
2. Ve a la sección de API/Credenciales
3. Obtén tu `client_id` y `client_secret`
4. Asegúrate de tener habilitado el flujo **Client Credentials**

### Configurar credenciales

```r
library(fidelizadorapi)

# Opción 1: Guardar en variables de entorno (recomendado)
flz_set_credentials(
  client_id = "tu_client_id",
  client_secret = "tu_client_secret"
)

# Opción 2: Usar directamente en cada autenticación
token <- flz_auth(
  client_id = "tu_client_id",
  client_secret = "tu_client_secret"
)
```

## Uso básico

### Autenticación

```r
library(fidelizadorapi)

# Autenticarse (usando credenciales guardadas)
token <- flz_auth()
```

## Encontrar tu Client Slug

Tu `client_slug` se encuentra en la URL del portal de Fidelizador:

```
https://cl1.fidelizador.com/{client-slug}/dashboard/
                            ^^^^^^^^^^^^
```

## Contribuciones

Las contribuciones son bienvenidas. Por favor, abre un issue o pull request en GitHub.

## Soporte

Para reportar problemas o solicitar nuevas funcionalidades, abre un issue en el repositorio de GitHub.
