# home-assistant

![Version: 4.1.2](https://img.shields.io/badge/Version-4.1.2-informational?style=flat-square) ![AppVersion: 2026.11.1](https://img.shields.io/badge/AppVersion-2026.11.1-informational?style=flat-square)

Home Assistant helm package

**Homepage:** <https://github.com/egeback/helm-charts/tree/main/charts/home-assistant>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| egeback | <marky@egeback.se> |  |

## Source Code

* <https://github.com/home-assistant/home-assistant-docker>

## Requirements

Kubernetes: `>=1.16.0-0`

| Repository | Name | Version |
|------------|------|---------|
| https://bjw-s-labs.github.io/helm-charts | common | 5.3.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| controllers.main.containers.code.enabled | bool | `false` |  |
| controllers.main.containers.code.env | object | See below | environment variables. See more environment variables in the [home-assistant documentation](https://home-assistant.org/docs). |
| controllers.main.containers.code.image.repository | string | `"causticlab/hass-configurator-docker"` | image repository |
| controllers.main.containers.code.image.tag | string | `"0.6.0"` | image tag renovate: datasource=docker depName=causticlab/hass-configurator-docker |
| controllers.main.containers.main.env | object | See below | environment variables. See more environment variables in the [home-assistant documentation](https://home-assistant.org/docs). |
| controllers.main.containers.main.env.TZ | string | `"UTC"` | Set the container timezone |
| controllers.main.containers.main.image.pullPolicy | string | `"IfNotPresent"` | image pull policy |
| controllers.main.containers.main.image.repository | string | `"ghcr.io/home-assistant/home-assistant"` | image repository |
| controllers.main.containers.main.image.tag | string | chart.appVersion | image tag |
| controllers.main.containers.main.probes | object | See values.yaml | Probes against the web UI; the startup probe allows for a slow first start |
| defaultPodOptions.automountServiceAccountToken | bool | `false` |  |
| defaultPodOptions.dnsPolicy | string | `"ClusterFirstWithHostNet"` |  |
| defaultPodOptions.hostNetwork | bool | `true` |  |
| defaultPodOptions.securityContext.fsGroup | int | `1000` |  |
| defaultPodOptions.securityContext.fsGroupChangePolicy | string | `"OnRootMismatch"` |  |
| defaultPodOptions.securityContext.runAsGroup | int | `1000` |  |
| defaultPodOptions.securityContext.runAsUser | int | `1000` |  |
| ingress.main | object | See values.yaml | Enable and configure ingress settings for the chart under this key. |
| mariadb | object | See values.yaml | Bundled MariaDB for the recorder, on the official `mariadb` image. When    enabled the chart sets `RECORDER_DB_URL` on Home Assistant; use it with    `recorder: {db_url: !env_var RECORDER_DB_URL}` in configuration.yaml. |
| mariadb.auth.existingSecret | string | `""` | Existing Secret with the keys `password` and `root-password` |
| mariadb.auth.password | string | `""` | Password for `username`; required unless `existingSecret` is set. Must be URL-safe (it is embedded in RECORDER_DB_URL). |
| mariadb.auth.rootPassword | string | `""` | Root password; required unless `existingSecret` is set |
| mariadb.enabled | bool | `false` | Deploy a MariaDB StatefulSet (mutually exclusive with `postgresql.enabled`) |
| mariadb.image.tag | string | `"12.3.3"` | Keep to a MariaDB LTS series Home Assistant supports (10.11, 11.4, 11.8, 12.3) renovate: datasource=docker depName=mariadb |
| mariadb.persistence.storageClass | string | `""` | StorageClass for the data volume ("-" for none, empty for the cluster default) |
| persistence | object | See values.yaml | Configure persistence settings for the chart under this key. |
| persistence.config | object | See values.yaml | Home Assistant's /config. While disabled the chart mounts an emptyDir    instead (configuration is lost when the pod is recreated); enable it with    a PVC or `existingClaim` for real use. |
| persistence.usb | object | See values.yaml | Configure a hostPathMount to mount a USB device in the container. |
| postgresql | object | See values.yaml | Bundled PostgreSQL for the recorder, on the official `postgres` image. When    enabled the chart sets `RECORDER_DB_URL` on Home Assistant; use it with    `recorder: {db_url: !env_var RECORDER_DB_URL}` in configuration.yaml. |
| postgresql.auth.existingSecret | string | `""` | Existing Secret with the key `password` |
| postgresql.auth.password | string | `""` | Password for `username`; required unless `existingSecret` is set. Must be URL-safe (it is embedded in RECORDER_DB_URL). |
| postgresql.enabled | bool | `false` | Deploy a PostgreSQL StatefulSet (mutually exclusive with `mariadb.enabled`) |
| postgresql.image.tag | string | `"18.6"` | Home Assistant requires PostgreSQL 15 or newer from 2027.3; major upgrades need a dump/restore renovate: datasource=docker depName=postgres |
| postgresql.persistence.storageClass | string | `""` | StorageClass for the data volume ("-" for none, empty for the cluster default) |
| service | object | See values.yaml | Configures service settings for the chart. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
