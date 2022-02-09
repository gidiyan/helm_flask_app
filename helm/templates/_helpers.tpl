{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "luxcampus.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "luxcampus.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "luxcampus.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "luxcampus.imagePullSecret" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" .Values.imageCredentials.registry (printf "%s:%s" .Values.imageCredentials.username .Values.imageCredentials.password | b64enc) | b64enc }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "luxcampus.labels" -}}
app.kubernetes.io/component: {{ .Values.cmd.name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/name: {{ include "luxcampus.name" . }}
app.kubernetes.io/part-of: orchestrate
app.kubernetes.io/version: {{ .Values.image.tag | quote | trimPrefix "v" }}
helm.sh/chart: {{ include "luxcampus.chart" . }}
helm.sh/release-namespace: {{ .Release.Namespace }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "luxcampus.selectorLabels" -}}
app.kubernetes.io/name: {{ include "luxcampus.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "luxcampus.dbUser" -}}
{{- if .Values.postgres.flex -}}
{{- .Values.postgres.user -}}
{{- else -}}
{{- printf "%s@%s"  .Values.postgres.user .Values.postgres.shortName -}}
{{- end -}}
{{- end -}}

{{- define "adminDbUser" -}}
{{- if .Values.postgres.flex -}}
{{- "postgres" -}}
{{- else -}}
{{- printf "postgres@%s" .Values.postgres.shortName -}}
{{- end -}}
{{- end -}}

{{/*
Define serviceAccountName name
*/}}
{{- define "luxcampus.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "luxcampus.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "luxcampus.job.fullname" -}}
{{- printf "%s-job" .Release.Name | lower | trunc 63 | trimSuffix "-" -}}
{{- end -}}
