{{- define "adguard-home.init" -}}
  {{/* Make sure all variables are set properly */}}
  {{- include "bjw-s.common.loader.init" . }}

  {{- $_ := include "adguard-home.hardcodedValues" . | fromYaml | merge .Values -}}
  {{- $_ := include "adguard-home.volumeClaimTemplates" . | fromYaml | merge .Values -}}
  {{- $_ := include "adguard-home.affinity" . | fromYaml | merge .Values -}}
  {{- $_ := include "adguard-home.nonRoot" . | fromYaml | merge .Values -}}

{{- end -}}