{{/*
    Please see the comment in _deployment.tpl prior to pointing out that it is bad practice
*/}}
{{- define "compressa-platform.service" }}
{{- $top := .top }}
{{- $spec := .spec }}
{{- $extras := .extras }}
{{- $name := .name }}
---
apiVersion: v1
kind: Service
metadata:
  name: {{ include "compressa-platform.fullname" $top }}-{{ $name }}
  labels:
    {{- include "compressa-platform.labels" $top | nindent 4 }}
spec:
  type: {{ $spec.service.type }}
  {{- with $spec.service.ports }}
  {{- include "compressa-platform.service-ports" . | nindent 2}}
  {{- end }}
  selector:
    {{- include "compressa-platform.selectorLabels" $top | nindent 4 }}
    app.kubernetes.io/instance: {{ $top.Release.Name }}-{{ $name }}
{{- end }}