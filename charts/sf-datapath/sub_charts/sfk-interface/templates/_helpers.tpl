{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "sfk-interface.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sfk-interface.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "sfk-interface.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "sfk-interface.labels" -}}
helm.sh/chart: {{ include "sfk-interface.chart" . }}
release: {{ .Release.Name }}
{{ include "sfk-interface.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "sfk-interface.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sfk-interface.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "sfk-interface.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "sfk-interface.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "sfk-interface.postgresql.fullname" -}}
{{- if .Values.global.postgresql.host }} 
{{- printf "%s" .Values.global.postgresql.host -}}
{{- else }}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end -}}

{{- define "sfk-interface.authenticator.fullname" -}}
{{- printf "%s-%s" .Release.Name "authenticator" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "sfk-interface.kafkaRest.fullname" -}}
{{- printf "%s-%s" .Release.Name "cp-kafka-rest" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "sfk-interface.apmConnect.fullname" -}}
{{- printf "%s-%s" .Release.Name "es-kafka-connect" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "sfk-interface.signatures-and-kafka-apis.fullname" -}}
{{- printf "%s-%s" .Release.Name "signatures-and-kafka-apis" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
