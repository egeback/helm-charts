{{- define "adguard-home.volumeClaimTemplates" -}}
  {{ if or (.Values.volumeClaimTemplates.config.enabled) (.Values.volumeClaimTemplates.data.enabled) }}
  controllers:
    main:
      type: statefulset
      statefulset:
        volumeClaimTemplates:
        {{ if .Values.volumeClaimTemplates.config.enabled }}
           - accessMode:  "{{ .Values.volumeClaimTemplates.config.accessMode }}"
             name: config
             size: "{{ .Values.volumeClaimTemplates.config.size }}"
             storageClass: "{{ .Values.volumeClaimTemplates.config.storageClass }}"
        {{ end }}
        {{ if .Values.volumeClaimTemplates.data.enabled }}
           - accessMode:  "{{ .Values.volumeClaimTemplates.data.accessMode }}"
             name: data
             size: "{{ .Values.volumeClaimTemplates.data.size }}"
             storageClass: "{{ .Values.volumeClaimTemplates.data.storageClass }}"
             globalMounts:
             {{- range $v := .Values.volumeClaimTemplates.data.globalMounts }}
               - path: {{ $v.path }}
             {{- end }}
        {{ end }}
  {{ end }}
  {{ if .Values.volumeClaimTemplates.config.enabled }}
  persistence:
    config:
      enabled: false
  {{ end }}
  {{ if .Values.volumeClaimTemplates.data.enabled }}
  persistence:
    data:
      enabled: false
  {{ end }}
{{- end -}}