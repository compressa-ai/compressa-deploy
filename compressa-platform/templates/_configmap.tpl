{{- define "compressa-platform.configmap" }}
{{- $top := .top }}
{{- $item := .item }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "compressa-platform.fullname" $top }}-{{ $item.name }}
data:
{{- toYaml $item.data | nindent 2 }}
{{- end }}