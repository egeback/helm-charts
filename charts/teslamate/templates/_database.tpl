{{/*
Bundled database on the official mariadb/postgres images, rendered through
bjw-s common. "egeback.database.values" returns a values fragment that
common.yaml merges into .Values before bjw-s renders, so the database gets a
StatefulSet, a Service and (unless auth.existingSecret is set) a Secret.

Shared verbatim between the home-assistant and teslamate charts.

Usage: include "egeback.database.values" (dict "ctx" $ "engine" "mariadb")
       engine is "mariadb" or "postgresql" and selects .Values.<engine>.
*/}}

{{/* Resource name for the database StatefulSet, Service and Secret */}}
{{- define "egeback.database.name" -}}
{{- printf "%s-%s" (include "bjw-s.common.lib.chart.names.fullname" .ctx) .engine -}}
{{- end -}}

{{/* Secret holding the database passwords */}}
{{- define "egeback.database.secretName" -}}
{{- $db := get .ctx.Values .engine -}}
{{- $db.auth.existingSecret | default (include "egeback.database.name" .) -}}
{{- end -}}

{{/* TCP port for the engine */}}
{{- define "egeback.database.port" -}}
{{- ternary 3306 5432 (eq .engine "mariadb") -}}
{{- end -}}

{{- define "egeback.database.values" -}}
{{- $db := get .ctx.Values .engine -}}
{{- $isMariadb := eq .engine "mariadb" -}}
{{- $name := include "egeback.database.name" . -}}
{{- $secretName := include "egeback.database.secretName" . -}}
controllers:
  {{ .engine }}:
    type: statefulset
    forceRename: {{ $name }}
    # Not inherited from the app's defaultPodOptions (hostNetwork, uid 1000)
    pod:
      hostNetwork: false
      dnsPolicy: ClusterFirst
      securityContext:
        runAsUser: 999
        runAsGroup: 999
        runAsNonRoot: true
        fsGroup: 999
        fsGroupChangePolicy: OnRootMismatch
    statefulset:
      serviceName:
        identifier: {{ .engine }}
      volumeClaimTemplates:
        - name: data
          accessMode: {{ $db.persistence.accessMode }}
          size: {{ $db.persistence.size }}
          {{- with $db.persistence.storageClass }}
          storageClass: {{ . }}
          {{- end }}
          globalMounts:
            # postgres 18+ keeps PGDATA in a major-version subdirectory of /var/lib/postgresql
            - path: {{ ternary "/var/lib/mysql" "/var/lib/postgresql" $isMariadb }}
    containers:
      main:
        image:
          repository: {{ $db.image.repository }}
          tag: {{ $db.image.tag | quote }}
        env:
          {{- if $isMariadb }}
          MARIADB_DATABASE: {{ $db.auth.database | quote }}
          MARIADB_USER: {{ $db.auth.username | quote }}
          MARIADB_PASSWORD:
          {{- else }}
          POSTGRES_DB: {{ $db.auth.database | quote }}
          POSTGRES_USER: {{ $db.auth.username | quote }}
          POSTGRES_PASSWORD:
          {{- end }}
            valueFrom:
              secretKeyRef:
                name: {{ $secretName }}
                key: password
          {{- if $isMariadb }}
          MARIADB_ROOT_PASSWORD:
            valueFrom:
              secretKeyRef:
                name: {{ $secretName }}
                key: root-password
          {{- end }}
        probes:
          liveness:
            enabled: true
          readiness:
            enabled: true
            custom: true
            spec:
              exec:
                {{- if $isMariadb }}
                command: ["healthcheck.sh", "--connect", "--innodb_initialized"]
                {{- else }}
                command: ["pg_isready", "-h", "127.0.0.1", "-U", {{ $db.auth.username | quote }}, "-d", {{ $db.auth.database | quote }}]
                {{- end }}
              periodSeconds: 10
              timeoutSeconds: 5
              failureThreshold: 3
          startup:
            enabled: true
        {{- with $db.resources }}
        resources: {{- toYaml . | nindent 10 }}
        {{- end }}
service:
  {{ .engine }}:
    controller: {{ .engine }}
    forceRename: {{ $name }}
    ports:
      db:
        port: {{ include "egeback.database.port" . }}
{{- if not $db.auth.existingSecret }}
secrets:
  {{ .engine }}:
    forceRename: {{ $name }}
    stringData:
      password: {{ required (printf "%s.auth.password (or %s.auth.existingSecret) is required when %s.enabled=true" .engine .engine .engine) $db.auth.password | quote }}
      {{- if $isMariadb }}
      root-password: {{ required "mariadb.auth.rootPassword (or mariadb.auth.existingSecret) is required when mariadb.enabled=true" $db.auth.rootPassword | quote }}
      {{- end }}
{{- end }}
{{- end -}}

{{/* Env var reading the database user's password from the database Secret */}}
{{- define "egeback.database.passwordEnv" -}}
valueFrom:
  secretKeyRef:
    name: {{ include "egeback.database.secretName" . }}
    key: password
{{- end -}}

{{/*
Adding the database gives bjw-s a second controller and Service, which makes it
append the identifier to every name (<fullname>-main). Pin the app's own
resources to the names they would have had without the database.
Usage: include "egeback.database.keepAppNames" $
*/}}
{{- define "egeback.database.keepAppNames" -}}
{{- $fullname := include "bjw-s.common.lib.chart.names.fullname" . -}}
{{- $pinned := dict -}}
{{- range $kind := list "controllers" "service" -}}
  {{- $enabled := list -}}
  {{- range $id, $item := (get $.Values $kind | default dict) -}}
    {{- if and (kindIs "map" $item) (ternary $item.enabled true (hasKey $item "enabled")) -}}
      {{- $enabled = append $enabled $id -}}
    {{- end -}}
  {{- end -}}
  {{- if eq (len $enabled) 1 -}}
    {{- $id := first $enabled -}}
    {{- if not (get (get (get $.Values $kind) $id) "forceRename") -}}
      {{- $_ := set $pinned $kind (dict $id (dict "forceRename" $fullname)) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- toYaml $pinned -}}
{{- end -}}

{{/*
bjw-s mounts persistence items without advancedMounts into every controller,
which would put the app's volumes (e.g. a ReadWriteOnce /config claim) into the
database pod as well. Rewrite those items to the equivalent advancedMounts for
the app's own controllers. Call before the database controller is added.
Usage: include "egeback.database.scopeAppPersistence" $
*/}}
{{- define "egeback.database.scopeAppPersistence" -}}
{{- range $id, $item := ($.Values.persistence | default dict) -}}
  {{- if and (kindIs "map" $item) (ternary $item.enabled true (hasKey $item "enabled")) (not (hasKey $item "advancedMounts")) -}}
    {{- $defaultPath := ternary $item.hostPath (printf "/%s" $id) (eq "hostPath" ($item.type | default "")) -}}
    {{- $mounts := $item.globalMounts | default (list (dict "path" $defaultPath)) -}}
    {{- $advanced := dict -}}
    {{- range $ctrlId, $ctrl := ($.Values.controllers | default dict) -}}
      {{- if kindIs "map" $ctrl -}}
        {{- $containers := dict -}}
        {{- range $cId, $c := ($ctrl.containers | default dict) -}}
          {{- $_ := set $containers $cId $mounts -}}
        {{- end -}}
        {{- $_ := set $advanced $ctrlId $containers -}}
      {{- end -}}
    {{- end -}}
    {{- $_ := set $.Values.persistence $id (merge (dict "advancedMounts" $advanced) (omit $item "globalMounts")) -}}
  {{- end -}}
{{- end -}}
{{- end -}}
