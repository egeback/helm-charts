
{{- define "adguard-home.affinity" -}}
{{ if .Values.options.setAffinity }}
defaultPodOptions:
    affinity:
      podAffinity: {}
      podAntiAffinity:
        preferredDuringSchedulingIgnoredDuringExecution:
          - podAffinityTerm:
              labelSelector:
                matchExpressions:
                  - key: app.kubernetes.io/name
                    operator: In
                    values:
                      - "{{ .Release.Name }}"
              topologyKey: kubernetes.io/hostname
            weight: 100
{{ end }}
{{- end -}}