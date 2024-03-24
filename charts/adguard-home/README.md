# adguard-home

![Version: 1.0.19](https://img.shields.io/badge/Version-1.0.19-informational?style=flat-square) ![AppVersion: v0.107.46](https://img.shields.io/badge/AppVersion-v0.107.46-informational?style=flat-square)

DNS proxy as ad-blocker for local network

**Homepage:** <https://github.com/egeback/helm-charts/blob/main/charts/adguard-home>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| egeback | <marky@egeback.se> |  |

## Source Code

* <https://github.com/AdguardTeam/AdGuardHome>

## Requirements

Kubernetes: `>=1.16.0-0`

| Repository | Name | Version |
|------------|------|---------|
| https://bjw-s.github.io/helm-charts | common | 3.0.4 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| configMaps.config.data."AdGuardHome.yaml" | string | `"bind_host: 0.0.0.0\nbind_port: 3000\nbeta_bind_port: 0\nusers: []\nauth_attempts: 5\nblock_auth_min: 15\nhttp_proxy: \"\"\nlanguage: \"\"\ndebug_pprof: false\nweb_session_ttl: 720\ndns:\n  bind_hosts:\n  - 0.0.0.0\n  port: 53\n  statistics_interval: 1\n  querylog_enabled: true\n  querylog_file_enabled: true\n  querylog_interval: 2160h\n  querylog_size_memory: 1000\n  anonymize_client_ip: false\n  protection_enabled: true\n  blocking_mode: default\n  blocking_ipv4: \"\"\n  blocking_ipv6: \"\"\n  blocked_response_ttl: 10\n  parental_block_host: family-block.dns.adguard.com\n  safebrowsing_block_host: standard-block.dns.adguard.com\n  ratelimit: 20\n  ratelimit_whitelist: []\n  refuse_any: true\n  upstream_dns:\n  - https://dns10.quad9.net/dns-query\n  upstream_dns_file: \"\"\n  bootstrap_dns:\n  - 9.9.9.10\n  - 149.112.112.10\n  - 2620:fe::10\n  - 2620:fe::fe:10\n  all_servers: false\n  fastest_addr: false\n  fastest_timeout: 1s\n  allowed_clients: []\n  disallowed_clients: []\n  blocked_hosts:\n  - version.bind\n  - id.server\n  - hostname.bind\n  trusted_proxies:\n  - 127.0.0.0/8\n  - ::1/128\n  cache_size: 4194304\n  cache_ttl_min: 0\n  cache_ttl_max: 0\n  cache_optimistic: false\n  bogus_nxdomain: []\n  aaaa_disabled: false\n  enable_dnssec: false\n  edns_client_subnet: false\n  max_goroutines: 300\n  ipset: []\n  filtering_enabled: true\n  filters_update_interval: 24\n  parental_enabled: false\n  safesearch_enabled: false\n  safebrowsing_enabled: false\n  safebrowsing_cache_size: 1048576\n  safesearch_cache_size: 1048576\n  parental_cache_size: 1048576\n  cache_time: 30\n  rewrites: []\n  blocked_services: []\n  upstream_timeout: 10s\n  private_networks: []\n  use_private_ptr_resolvers: true\n  local_ptr_upstreams: []\ntls:\n  enabled: false\n  server_name: \"\"\n  force_https: false\n  port_https: 443\n  port_dns_over_tls: 853\n  port_dns_over_quic: 853\n  port_dnscrypt: 0\n  dnscrypt_config_file: \"\"\n  allow_unencrypted_doh: false\n  strict_sni_check: false\n  certificate_chain: \"\"\n  private_key: \"\"\n  certificate_path: \"\"\n  private_key_path: \"\"\nfilters:\n- enabled: true\n  url: https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt\n  name: AdGuard DNS filter\n  id: 1\n- enabled: false\n  url: https://adaway.org/hosts.txt\n  name: AdAway Default Blocklist\n  id: 2\nwhitelist_filters: []\nuser_rules: []\ndhcp:\n  enabled: false\n  interface_name: \"\"\n  local_domain_name: lan\n  dhcpv4:\n    gateway_ip: \"\"\n    subnet_mask: \"\"\n    range_start: \"\"\n    range_end: \"\"\n    lease_duration: 86400\n    icmp_timeout_msec: 1000\n    options: []\n  dhcpv6:\n    range_start: \"\"\n    lease_duration: 86400\n    ra_slaac_only: false\n    ra_allow_slaac: false\nclients:\n  runtime_sources:\n    whois: true\n    arp: true\n    rdns: true\n    dhcp: true\n    hosts: true\n  persistent: []\nlog_compress: false\nlog_localtime: false\nlog_max_backups: 0\nlog_max_size: 100\nlog_max_age: 3\nlog_file: \"\"\nverbose: false\nos:\n  group: \"\"\n  user: \"\"\n  rlimit_nofile: 0\nschema_version: 14\n"` |  |
| configMaps.config.enabled | bool | `true` |  |
| controllers.main.containers.main.args | list | `["--config","/config/AdGuardHome.yaml","--work-dir","/opt/adguardhome/work","--no-check-update"]` | arguments passed to the adguard-home command line. |
| controllers.main.containers.main.env | object | See below | environment variables. |
| controllers.main.containers.main.env.TZ | string | `"UTC"` | Set the container timezone |
| controllers.main.containers.main.image.pullPolicy | string | `"IfNotPresent"` | image pull policy |
| controllers.main.containers.main.image.repository | string | `"adguard/adguardhome"` | image repository |
| controllers.main.containers.main.image.tag | string | `"{{ .Chart.AppVersion }}"` |  |
| controllers.main.initContainers.copy-configmap | object | See values.yaml | Configures an initContainer that copies the configmap to the AdGuardHome conf directory It does NOT overwrite when the file already exists. |
| controllers.main.replicas | int | `1` | Number of pods to load balance between |
| defaultPodOptions.hostNetwork | bool | `true` |  |
| ingress.main | object | See values.yaml | Enable and configure ingress settings for the chart under this key. |
| persistence | object | See values.yaml | Configure persistence settings for the chart under this key. |
| service | object | See values.yaml | Configures service settings for the chart. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)
