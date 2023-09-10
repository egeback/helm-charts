# teslamate

![Version: 1.0.3](https://img.shields.io/badge/Version-1.0.3-informational?style=flat-square) ![AppVersion: 1.27.2](https://img.shields.io/badge/AppVersion-1.27.2-informational?style=flat-square)

A self-hosted data logger for your Tesla 🚘

**This chart is not maintained by the upstream project and any issues with the chart should be raised [here](https://github.com/egeback/helm-charts/issues/new/choose)**

## Source Code

* <https://github.com/adriankumpf/teslamate>
* <https://github.com/egeback/helm-charts/blob/main/charts/teslamate>

## Requirements

## Dependencies

| Repository | Name | Version |
|------------|------|---------|
| https://bjw-s.github.io/helm-charts | common | 1.5.1 |
| https://charts.bitnami.com/bitnami | postgresql | 12.2.7 |

## TL;DR

```console
helm repo add egeback https://github.com/egeback/helm-charts
helm repo update
helm install teslamate egeback/teslamate
```

## Installing the Chart

To install the chart with the release name `teslamate`

```console
helm install teslamate egeback/teslamate
```

## Uninstalling the Chart

To uninstall the `teslamate` deployment

```console
helm uninstall teslamate
```

The command removes all the Kubernetes components associated with the chart **including persistent volumes** and deletes the release.

## Configuration

Read through the [values.yaml](./values.yaml) file. It has several commented out suggested values.
Other values may be used from the [values.yaml](https://github.com/bjw-s/helm-charts/blob/main/charts/library/common/values.yaml).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

```console
helm install teslamate \
  --set env.TZ="America/New York" \
    egeback/teslamate
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart.

```console
helm install teslamate egeback/teslamate -f values.yaml
```

## Custom configuration

N/A

## Values

**Important**: When deploying an application Helm chart you can add more values from our common library chart [here](https://github.com/bjw-s/helm-charts/tree/main/charts/library/common)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| env | object | See below | environment variables. See [teslamate docs](https://docs.teslamate.org/docs/configuration/environment_variables) for more details. |
| env.DATABASE_HOST | string | `"{{ include \"bjw-s.common.lib.chart.names.fullname\" .}}-postgresql"` | Postgres database hostname |
| env.DATABASE_NAME | string | `"{{ .Values.postgresql.auth.database }}"` | Postgres database password |
| env.DATABASE_PASS | string | `"{{ .Values.postgresql.auth.password }}"` | Postgres database password |
| env.DATABASE_USER | string | `"{{ \"Values.postgresql.auth.username\" | default \"postgres\" }}"` | Postgres database user name |
| env.DISABLE_MQTT | string | `"false"` | Disables the MQTT feature if `true` |
| env.ENCRYPTION_KEY | string | `"MySuperSecretEncryptionKey"` | Teslamate encryption key |
| env.MQTT_HOST | string | `""` | MQTT server host |
| env.MQTT_PORT | int | `1883` | MQTT server port |
| env.TZ | string | `"UTC"` | Set the container timezone |
| image.pullPolicy | string | `"IfNotPresent"` | image pull policy |
| image.repository | string | `"teslamate/teslamate"` | image repository |
| image.tag | string | chart.appVersion | image tag |
| ingress.main | object | See values.yaml | Enable and configure ingress settings for the chart under this key. |
| persistence | object | See values.yaml | Configure persistence settings for the chart under this key. |
| postgresql | object | See values.yaml | Enable and configure postgresql database subchart under this key.    For more options see [postgresql chart documentation](https://github.com/bitnami/charts/tree/master/bitnami/postgresql) |
| service | object | See values.yaml | Configures service settings for the chart. |

## Changelog

### Version 1.0.3

### Older versions

A historical overview of changes can be found on [ArtifactHUB](https://artifacthub.io/packages/helm/egeback/teslamate?modal=changelog)

## Support
- Open an [issue](https://github.com/egeback/helm-charts/issues/new/choose)

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)