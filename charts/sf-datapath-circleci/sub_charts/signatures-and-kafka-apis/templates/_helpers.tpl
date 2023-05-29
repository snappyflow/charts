{{/*
Expand the name of the chart.
*/}}
{{- define "signatures-and-kafka-apis.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "signatures-and-kafka-apis.fullname" -}}
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
{{- define "signatures-and-kafka-apis.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "signatures-and-kafka-apis.labels" -}}
app.kubernetes.io/name: {{ include "signatures-and-kafka-apis.name" . }}
helm.sh/chart: {{ include "signatures-and-kafka-apis.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
release: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "signatures-and-kafka-apis.postgresql.fullname" -}}
{{- if .Values.global.postgresql.host }} 
{{- printf "%s" .Values.global.postgresql.host -}}
{{- else }}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end -}}

{{- define "signatures-and-kafka-apis.ingest-controller.fullname" -}}
{{- printf "%s-%s" .Values.global.archival.releaseName "ingest-controller" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "signatures-and-kafka-apis.sfk-interface.fullname" -}}
{{- printf "%s-%s" .Release.Name "sfk-interface" | trunc 63 | trimSuffix "-" -}}
{{- end -}}