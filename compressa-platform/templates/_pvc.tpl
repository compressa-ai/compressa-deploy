{{- define "compressa-platform.pvc" }}
{{- $top := .top }}
{{- $item := .item }}
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ include "compressa-platform.fullname" $top }}-{{ $item.name }}
spec:
{{- with $item.spec.accessModes }}
  accessModes:
{{- toYaml . | nindent 4 }}
{{- end }}
{{- with $item.spec.storageClassName }}
  storageClassName: {{ . }}
{{- end }}
{{- with $item.spec.resources }}
  resources:
{{- toYaml . | nindent 4}}
{{- end }}
{{- end }}