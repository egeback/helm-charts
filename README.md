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

### Automation

This repository uses [Renovate](https://www.whitesourcesoftware.com/free-developer-tools/renovate) to automatically keep application versions and dependencies up to date. Every update automatically increments the chart version and generates changelogs.