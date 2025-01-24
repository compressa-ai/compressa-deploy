{{/*
    Yeah, I know that doing this is not considered a good practice
    And I'm aware that subcharts were designed to do this instead
    But dragging subcharts would make the whole thing even more complex
    And it is already too complex IMO, so I'd rather leave it as is.

    Specifically, the problem lies in the fact that Compressa Platform uses
    several "worker" pods, and their number varies across configurations.
    They all share the same container image and parameters, yet they are not
    replicas, because they are used to host different workloads.
    Again, I know that this is not a way it is supposed to work, and that 
    the proper solution is probably to have one "controller" deployment, and
    have it start the workloads as pods using kubernetes API.

    Moreover, there are some other pods, such as rerank service, that also
    benefit from reusing this template, albeit having their own values.
    And then, there are some containers that could use simpler templates,
    but unified approach seems to me more beneficial than having some parts
    follow best practices while others already don't.

    If you came to this file because you haven't found a way to make desired
    changes in values file, or worse, you did, but everything just blew up -
    well, sorry. I've tried to make this template universal enough for any
    practical needs, but apparently it's now up to you to do it better.
*/}}
{{- define "compressa-platform.deployment" }}
{{- $top := .top }}
{{- $spec := .spec }}
{{- $extras := .extras }}
{{- $name := .name }}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "compressa-platform.fullname" $top }}-{{ $name }}
  labels:
    {{- include "compressa-platform.labels" $top | nindent 4 }}
    app.kubernetes.io/instance: {{ $top.Release.Name }}-{{ $name }}
spec:
  replicas: {{ $spec.replicaCount }}
  selector:
    matchLabels:
      {{- include "compressa-platform.selectorLabels" $top | nindent 6 }}
      app.kubernetes.io/instance: {{ $top.Release.Name }}-{{ $name }}
  template:
    metadata:
      {{- with $spec.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
      {{- end }}

      labels:
        {{- include "compressa-platform.labels" $top | nindent 8 }}
        {{- with $spec.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}

        {{- with $extras.extraPodLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
        app.kubernetes.io/instance: {{ $top.Release.Name }}-{{ $name }}
    
    spec:
      {{- with $top.Values.common.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}

      {{- with $spec.podSecurityContext }}
      securityContext:
        {{- toYaml . | nindent 8 }}
      {{- end }}

      {{- with $spec.runtimeClassName }}
      runtimeClassName: {{ . }}
      {{- end }}

      containers:
        - name: {{ $top.Chart.Name }}-{{ $name }}
          {{- with $spec.securityContext }}
          securityContext:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          image: "{{ $spec.image.repository }}:{{ $spec.image.tag | default $top.Chart.AppVersion }}"
          imagePullPolicy: {{ $spec.image.pullPolicy }}

          
          {{- if $extras.command }}
          command:
            {{- toYaml $extras.command | nindent 12 }}
          {{- else if $spec.command }}
          command:
            {{- toYaml $spec.command | nindent 12 }}
          {{- end }}

          {{- if $extras.args }}
          args:
            {{- toYaml $extras.args | nindent 12 }}
          {{- else if $spec.args }}
          args:
            {{- toYaml $spec.args | nindent 12 }}
          {{- end }}

          {{- with $spec.service.ports }}
          {{- include "compressa-platform.pod-ports" $spec.service.ports  | nindent 10 }}
          {{- end }}

          {{- with $spec.livenessProbe }}
          livenessProbe:
            {{- toYaml . | nindent 12 }}
          {{- end }}

          {{- with $spec.readinessProbe }}
          readinessProbe:
            {{- toYaml . | nindent 12 }}
          {{- end }}

          {{- with $spec.startupProbe }}
          startupProbe:
            {{- toYaml . | nindent 12 }}
          {{- end }}

          {{- if $extras.resources }}
          {{- with $extras.resources }}
          resources:
              {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- else if $spec.resources }}
            {{- with $spec.resources }}
          resources:
              {{- toYaml . | nindent 12 }}
            {{- end }}
          {{- end }}

          {{- if or $spec.env $extras.env }}
          env:
            {{- include "compressa-platform.env-vars" (merge ($spec.env | default dict) ($extras.env | default dict)) | nindent 12 }}
          {{- end }}

          {{- if or $spec.envFrom $extras.extraEnvFrom }}
          envFrom:
          {{- if $spec.envFrom }}
          {{- include "compressa-platform.env-from" (dict "top" $top "spec" $spec.envFrom) | nindent 12 }}
          {{- end }}
          {{- if $extras.extraEnvFrom }}
          {{- include "compressa-platform.env-from" (dict "top" $top "spec" $extras.extraEnvFrom) | nindent 12 }}
          {{- end }}
          {{- end }}

          {{- if or $spec.volumeMounts $extras.extraVolumeMounts }}
          volumeMounts:
            {{- toYaml (concat ( $spec.volumeMounts | default list) ($extras.extraVolumeMounts | default list)) | nindent 12 }}
          {{- end }}

      {{- with $top.Values.common.volumes }}
      volumes:
        {{- include "compressa-platform.volumes" $top | nindent 8 }}
      {{- end }}

      {{- with $spec.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $spec.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $spec.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
{{- end }}