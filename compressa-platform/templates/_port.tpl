{{- define "compressa-platform.service-ports" }}
ports:
{{- range $port := . }}
  - name: {{ .name }}
    port: {{ .servicePort | default .port }}
    targetPort: {{ .containerPort | default .name }}
    protocol: {{ .protocol }}
{{- end }}
{{- end }}

{{- define "compressa-platform.pod-ports" }}
ports:
{{- range $port := . }}
  - name: {{ .name }}
    containerPort: {{ .containerPort | default .port }}
    protocol: {{ .protocol }}
{{- end }}
{{- end }}