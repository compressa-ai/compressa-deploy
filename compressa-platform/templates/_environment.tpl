{{- define "compressa-platform.env-vars" }}
{{- range $key, $value := . }}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end }}
{{- end }}

{{- define "compressa-platform.env-from" }}
{{- $top := .top }}
{{- $spec := .spec }}
{{- range $item := .spec }}
{{- if or (eq .type "configMap") (eq .type "cm") }}
- configMapRef:
    name: {{ include "compressa-platform.fullname" $top }}-{{ .name }}
{{- else if or (eq .type "configMapExternal") (eq .type "cm-external") }}
- configMapRef:
    name: {{ .name }}
{{- else if eq .type "secret" }}
- secretRef:
    name: {{ include "compressa-platform.fullname" $top }}-{{ .name }}
{{- else if eq .type "secret-external" }}
- secretRef:
    name: {{ .name | quote }}
{{- end }}
{{- end }}
{{- end }}