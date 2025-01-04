{{- define "adguard-home.nonRoot" -}}
{{ if .Values.options.runAsNonRoot.enabled }}
defaultPodOptions:
  securityContext:
      fsGroup: {{ .Values.options.runAsNonRoot.fsGroup }}
      seccompProfile:
        type: RuntimeDefault

controllers:
  main:
    initContainers:
      copy-configmap:
        securityContext:
          runAsUser: {{ .Values.options.runAsNonRoot.runAsUser }}
          allowPrivilegeEscalation: false
          privileged: false
          readOnlyRootFilesystem: false
          runAsNonRoot: true
          capabilities:
            drop:
              - ALL

    defaultContainerOptions:
      securityContext:
        allowPrivilegeEscalation: false
        privileged: false
        readOnlyRootFilesystem: false
        runAsNonRoot: true
        runAsUser: {{ .Values.options.runAsNonRoot.runAsUser }}
        capabilities:
          drop:
            - ALL
          add:
          {{- range $v := .Values.options.runAsNonRoot.neededCapabilities }}
            - {{$v}}
          {{- end -}}
{{ end }}
{{- end -}}