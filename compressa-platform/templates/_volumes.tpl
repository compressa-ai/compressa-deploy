{{- define "compressa-platform.volumes" }}
{{- $top := . }}
{{- range $element := .Values.common.volumes }}
- name: {{ $element.name }}
  {{- if or (eq $element.type "pvc") (eq $element.type "persistentVolumeClaim") }}
  persistentVolumeClaim:
    claimName: {{ include "compressa-platform.fullname" $top }}-{{ $element.name }}
  {{- else if eq $element.type "secret"}}
  secret:
    secretName: {{ include "compressa-platform.fullname" $top }}-{{ $element.name }}
  {{- else if or (eq $element.type "cm") (eq $element.type "configMap")}}
  configMap:
    name: {{ include "compressa-platform.fullname" $top }}-{{ $element.name }}
  {{- else }}
    {{- required "Invalid volume type! Must be one of: persistentVolumeClaim, secret"  .NonExistentKey }}
  {{- end }}
{{- end }}
{{- end }}