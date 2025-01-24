{{- define "compressa-platform.secret" }}
{{- $top := .top }}
{{- $item := .item }}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "compressa-platform.fullname" $top }}-{{ $item.name }}
stringData:
{{- toYaml $item.data | nindent 2 }}
{{- end }}