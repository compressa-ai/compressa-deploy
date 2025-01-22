{{- define "compressa-platform.ingress-paths" }}
{{- $spec := .spec }}
{{- $top := .top }}
{{- $name := .name }}
{{- if $spec.enabled }}
{{- range $path := $spec.ingress.paths }}
- path: {{ $path.path }}
  {{- if $path.pathType }}
  pathType: {{ $path.pathType }}
  {{- else }}
  pathType: Prefix
  {{- end }}
  backend:
    service:
      name: {{ include "compressa-platform.fullname" $top }}-{{ $name }}
      port: 
        name: {{ $path.port }}
{{- end }}
{{- end }}
{{- end }}