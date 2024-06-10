# teslamate

![Version: 1.0.22](https://img.shields.io/badge/Version-1.0.22-informational?style=flat-square) ![AppVersion: 1.29.1](https://img.shields.io/badge/AppVersion-1.29.1-informational?style=flat-square)

A self-hosted data logger for your Tesla 🚘

**Homepage:** <https://github.com/egeback/helm-charts/blob/main/charts/teslamate>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| egeback | <marky@egeback.se> |  |

## Source Code

* <https://github.com/adriankumpf/teslamate>
* <https://github.com/egeback/helm-charts/blob/main/charts/teslamate>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://bjw-s.github.io/helm-charts | common | 3.0.4 |
| https://charts.bitnami.com/bitnami | postgresql | 12.12.10 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| controllers.main.containers.main.image.env | object | See below | environment variables. See [teslamate docs](https://docs.teslamate.org/docs/configuration/environment_variables) for more details. |
| controllers.main.containers.main.image.env.DATABASE_HOST | string | `"{{ include \"bjw-s.common.lib.chart.names.fullname\" .}}-postgresql"` | Postgres database hostname |
| controllers.main.containers.main.image.env.DATABASE_NAME | string | `"{{ .Values.postgresql.auth.database }}"` | Postgres database password |
| controllers.main.containers.main.image.env.DATABASE_PASS | string | `"{{ .Values.postgresql.auth.password }}"` | Postgres database password |
| controllers.main.containers.main.image.env.DATABASE_USER | string | `"{{ \"Values.postgresql.auth.username\" | default \"postgres\" }}"` | Postgres database user name |
| controllers.main.containers.main.image.env.DISABLE_MQTT | string | `"false"` | Disables the MQTT feature if `true` |
| controllers.main.containers.main.image.env.ENCRYPTION_KEY | string | `"MySuperSecretEncryptionKey"` | Teslamate encryption key |
| controllers.main.containers.main.image.env.MQTT_HOST | string | `"mosquitto"` | MQTT server host |
| controllers.main.containers.main.image.env.MQTT_PORT | int | `1883` | MQTT server port |
| controllers.main.containers.main.image.env.TZ | string | `"UTC"` | Set the container timezone |
| controllers.main.containers.main.image.pullPolicy | string | `"IfNotPresent"` | image pull policy |
| controllers.main.containers.main.image.repository | string | `"teslamate/teslamate"` | image repository |
| controllers.main.containers.main.image.tag | string | chart.appVersion | image tag |
| controllers.main.containers.teslamate-abrp.enabled | bool | `false` |  |
| controllers.main.containers.teslamate-abrp.env.CAR_MODEL | string | `"tesla:my:19:bt37:awd"` |  |
| controllers.main.containers.teslamate-abrp.env.CAR_NUMBER | int | `2` |  |
| controllers.main.containers.teslamate-abrp.env.MQTT_PASSWORD | string | `"{{ .Values.controllers.main.containers.main.env.MQTT_PASSWORD }}"` |  |
| controllers.main.containers.teslamate-abrp.env.MQTT_PORT | string | `"{{ .Values.controllers.main.containers.main.env.MQTT_PORT }}"` |  |
| controllers.main.containers.teslamate-abrp.env.MQTT_SERVER | string | `"{{ .Values.controllers.main.containers.main.env.MQTT_HOST }}"` |  |
| controllers.main.containers.teslamate-abrp.env.MQTT_USERNAME | string | `"{{ .Values.controllers.main.containers.main.env.MQTT_USERNAME }}"` |  |
| controllers.main.containers.teslamate-abrp.env.USER_TOKEN | string | `"y0ur-4p1-k3y"` |  |
| controllers.main.containers.teslamate-abrp.image.repository | string | `"fetzu/teslamate-abrp"` |  |
| controllers.main.containers.teslamate-abrp.image.tag | string | `"3.0.0"` |  |
| controllers.main.containers.teslamateagile.enabled | bool | `false` |  |
| controllers.main.containers.teslamateagile.env.DATABASE_HOST | string | `"{{ .Values.controllers.main.containers.main.env.DATABASE_HOST }}"` |  |
| controllers.main.containers.teslamateagile.env.DATABASE_NAME | string | `"{{ .Values.postgresql.auth.database }}"` |  |
| controllers.main.containers.teslamateagile.env.DATABASE_PASS | string | `"{{ .Values.postgresql.auth.postgresPassword }}"` |  |
| controllers.main.containers.teslamateagile.env.DATABASE_USER | string | `"{{ .Values.postgresql.auth.username }}"` |  |
| controllers.main.containers.teslamateagile.env.TZ | string | `"{{ .Values.controllers.main.containers.main.env.TZ }}"` |  |
| controllers.main.containers.teslamateagile.env.TeslaMate__EnergyProvider | string | `"Tibber"` |  |
| controllers.main.containers.teslamateagile.env.TeslaMate__FeePerKilowattHour | int | `0` |  |
| controllers.main.containers.teslamateagile.env.TeslaMate__GeofenceId | int | `1` |  |
| controllers.main.containers.teslamateagile.env.TeslaMate__UpdateIntervalSeconds | int | `300` |  |
| controllers.main.containers.teslamateagile.env.Tibber__AccessToken | string | `"MyAccessToken"` |  |
| controllers.main.containers.teslamateagile.image.repository | string | `"mattjeanes/teslamateagile"` |  |
| controllers.main.containers.teslamateagile.image.tag | string | `"v1.14.0"` |  |
| controllers.main.containers.teslamateapi.enabled | bool | `false` |  |
| controllers.main.containers.teslamateapi.env.DATABASE_HOST | string | `"{{ .Values.controllers.main.containers.main.DATABASE_HOST }}"` |  |
| controllers.main.containers.teslamateapi.env.DATABASE_NAME | string | `"{{ .Values.postgresql.auth.database }}"` |  |
| controllers.main.containers.teslamateapi.env.DATABASE_PASS | string | `"{{ .Values.postgresql.auth.postgresPassword }}"` |  |
| controllers.main.containers.teslamateapi.env.DATABASE_USER | string | `"{{ .Values.postgresql.auth.username }}"` |  |
| controllers.main.containers.teslamateapi.env.ENCRYPTION_KEY | string | `"{{ .Values.controllers.main.containers.main.env.ENCRYPTION_KEY }}"` |  |
| controllers.main.containers.teslamateapi.env.MQTT_HOST | string | `"{{ .Values.controllers.main.containers.main.MQTT_HOST }}"` |  |
| controllers.main.containers.teslamateapi.env.TZ | string | `"{{ .Values.controllers.main.containers.main.env.TZ }}"` | MQTT password MQTT_PASSWORD: |
| controllers.main.containers.teslamateapi.image.repository | string | `"tobiasehlert/teslamateapi"` |  |
| controllers.main.containers.teslamateapi.image.tag | string | `"1.17.2"` |  |
| controllers.main.containers.teslamateapi.name | string | `"teslamateapi"` |  |
| ingress.main | object | See values.yaml | Enable and configure ingress settings for the chart under this key. |
| ingress.teslamate-api.enabled | bool | `false` |  |
| ingress.teslamate-api.hosts[0].host | string | `"teslamate-api.example.com"` |  |
| ingress.teslamate-api.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.teslamate-api.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| ingress.teslamate-api.hosts[0].paths[0].service.identifier | string | `"teslamate-api"` |  |
| ingress.teslamate-api.hosts[0].paths[0].service.name | string | `"teslamate-api"` |  |
| ingress.teslamate-api.hosts[0].paths[0].service.port | int | `8080` |  |
| persistence | object | See values.yaml | Configure persistence settings for the chart under this key. |
| postgresql | object | See values.yaml | Enable and configure postgresql database subchart under this key.    For more options see [postgresql chart documentation](https://github.com/bitnami/charts/tree/master/bitnami/postgresql) |
| service | object | See values.yaml | Configures service settings for the chart. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)
