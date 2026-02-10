## Usage

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

```console
helm repo add egeback https://charts.egeback.se
helm repo update
```

### Charts overview

A complete list of charts and their documentation can be found on [ArtifactHUB](https://artifacthub.io/packages/search?repo=egeback).

| Chart | Description |
| --- | --- |
| [adguard-home](charts/adguard-home) | DNS proxy as ad-blocker for local network |
| [cert-manager-cpanel-dns-webhook](charts/cert-manager-cpanel-dns-webhook) | cPanel DNS webhook for cert-manager |
| [esphome](charts/esphome) | ESP Home helm package |
| [heimdall](charts/heimdall) | Heimdall Application Dashboard |
| [home-assistant](charts/home-assistant) | Home Assistant helm package |
| [node-red](charts/node-red) | Node-RED helm package |
| [teslamate](charts/teslamate) | A self-hosted data logger for your Tesla |
| [unifi](charts/unifi) | Ubiquiti Network's Unifi Controller |
| [uptime-kuma](charts/uptime-kuma) | Uptime Kuma helm package |

### Automation

This repository uses [Renovate](https://www.whitesourcesoftware.com/free-developer-tools/renovate) to automatically keep application versions and dependencies up to date. Every update automatically increments the chart version and generates changelogs.