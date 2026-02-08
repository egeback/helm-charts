# home-assistant

![Version: 2.0.3](https://img.shields.io/badge/Version-2.0.3-informational?style=flat-square) ![AppVersion: 2026.2.1](https://img.shields.io/badge/AppVersion-2026.2.1-informational?style=flat-square)

Home Assistant helm package

**This chart is not maintained by the upstream project and any issues with the chart should be raised [here](https://github.com/egeback/helm-charts/issues/new/choose)**

## Source Code

* <https://github.com/home-assistant/home-assistant-docker>

## Requirements

Kubernetes: `>=1.16.0-0`

## Dependencies

| Repository | Name | Version |
|------------|------|---------|
| https://bjw-s-labs.github.io/helm-charts | common | 4.6.2 |
| https://charts.bitnami.com/bitnami | influxdb | 7.1.20 |
| https://charts.bitnami.com/bitnami | mariadb | 24.0.4 |
| https://charts.bitnami.com/bitnami | postgresql | 18.2.4 |

## TL;DR

```console
helm repo add egeback https://github.com/egeback/helm-charts
helm repo update
helm install home-assistant egeback/home-assistant
```

## Installing the Chart

To install the chart with the release name `home-assistant`

```console
helm install home-assistant egeback/home-assistant
```

## Uninstalling the Chart

To uninstall the `home-assistant` deployment

```console
helm uninstall home-assistant
```

The command removes all the Kubernetes components associated with the chart **including persistent volumes** and deletes the release.

## Configuration

Read through the [values.yaml](./values.yaml) file. It has several commented out suggested values.
Other values may be used from the [values.yaml](https://github.com/bjw-s/helm-charts/blob/main/charts/library/common/values.yaml).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

```console
helm install home-assistant \
  --set env.TZ="America/New York" \
    egeback/home-assistant
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart.

```console
helm install home-assistant egeback/home-assistant -f values.yaml
```

## Custom configuration

N/A

## Values

**Important**: When deploying an application Helm chart you can add more values from our common library chart [here](https://github.com/bjw-s/helm-charts/tree/main/charts/library/common)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| configMaps.passwd.data.passwd | string | `"fake-user:x:1000:1000:workaround for home-assistant/core/issues/132336::\n"` |  |
| configMaps.passwd.enabled | bool | `true` |  |
| controllers.main.containers.code.enabled | bool | `false` |  |
| controllers.main.containers.code.env | object | See below | environment variables. See more environment variables in the [home-assistant documentation](https://home-assistant.org/docs). |
| controllers.main.containers.code.image.repository | string | `"causticlab/hass-configurator-docker"` | image repository |
| controllers.main.containers.code.image.tag | string | `"0.5.2"` | image tag |
| controllers.main.containers.main.env | object | See below | environment variables. See more environment variables in the [home-assistant documentation](https://home-assistant.org/docs). |
| controllers.main.containers.main.env.TZ | string | `"UTC"` | Set the container timezone |
| controllers.main.containers.main.image.pullPolicy | string | `"IfNotPresent"` | image pull policy |
| controllers.main.containers.main.image.repository | string | `"ghcr.io/home-assistant/home-assistant"` | image repository |
| controllers.main.containers.main.image.tag | string | chart.appVersion | image tag |
| defaultPodOptions.automountServiceAccountToken | bool | `false` |  |
| defaultPodOptions.dnsPolicy | string | `"ClusterFirstWithHostNet"` |  |
| defaultPodOptions.hostNetwork | bool | `true` |  |
| defaultPodOptions.podSecurityContext.fsGroup | int | `1000` |  |
| defaultPodOptions.securityContext.fsGroup | int | `1000` |  |
| defaultPodOptions.securityContext.fsGroupChangePolicy | string | `"OnRootMismatch"` |  |
| defaultPodOptions.securityContext.runAsGroup | int | `1000` |  |
| defaultPodOptions.securityContext.runAsUser | int | `1000` |  |
| influxdb | object | See values.yaml | Enable and configure influxdb database subchart under this key.    For more options see [influxdb chart documentation](https://github.com/bitnami/charts/tree/master/bitnami/influxdb) |
| ingress.main | object | See values.yaml | Enable and configure ingress settings for the chart under this key. |
| mariadb | object | See values.yaml | Enable and configure mariadb database subchart under this key.    For more options see [mariadb chart documentation](https://github.com/bitnami/charts/tree/master/bitnami/mariadb) |
| metrics.enabled | bool | See values.yaml | Enable and configure a Prometheus serviceMonitor for the chart under this key. |
| metrics.prometheusRule | object | See values.yaml | Enable and configure Prometheus Rules for the chart under this key. |
| metrics.prometheusRule.rules | list | See prometheusrules.yaml | Configure additionial rules for the chart under this key. |
| metrics.serviceMonitor.interval | string | `"1m"` |  |
| metrics.serviceMonitor.labels | object | `{}` |  |
| metrics.serviceMonitor.scrapeTimeout | string | `"30s"` |  |
| persistence | object | See values.yaml | Configure persistence settings for the chart under this key. |
| persistence.usb | object | See values.yaml | Configure a hostPathMount to mount a USB device in the container. |
| postgresql | object | See values.yaml | Enable and configure postgresql database subchart under this key.    For more options see [postgresql chart documentation](https://github.com/bitnami/charts/tree/master/bitnami/postgresql) |
| securityContext | object | `{"privileged":null}` | When hostNetwork is true set dnsPolicy to ClusterFirstWithHostNet dnsPolicy: ClusterFirstWithHostNet |
| securityContext.privileged | bool | `nil` | Privileged securityContext may be required if USB devics are accessed directly through the host machine |
| service | object | See values.yaml | Configures service settings for the chart. |

## Changelog

### Version 2.0.3

### Older versions

A historical overview of changes can be found on [ArtifactHUB](https://artifacthub.io/packages/helm/egeback/home-assistant?modal=changelog)

## Support
- Open an [issue](https://github.com/egeback/helm-charts/issues/new/choose)

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
