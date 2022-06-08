{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "dataset-controller.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "dataset-controller.fullname" -}}
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

{{- define "dataset-controller.ingest-controller.fullname" -}}
{{- printf "%s-%s" .Release.Name "ingest-controller" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "dataset-controller.log-archival.fullname" -}}
{{- printf "%s-%s" .Release.Name "log-archival" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "dataset-controller.service.servicePort" -}}
{{- printf "%s-%s" .Values.service.servicePort -}}
{{- end -}}

{{- define "ingest-controller.service.servicePort" -}}
{{- $port := index .Values "ingest-controller" "service" "servicePort" -}}
{{- printf "%s" $port -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "dataset-controller.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "dataset-controller.labels" -}}
app.kubernetes.io/name: {{ include "dataset-controller.name" . }}
helm.sh/chart: {{ include "dataset-controller.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "dataset-controller.postgresql.fullname" -}}
{{- if .Values.global.postgresql.host }} 
{{- printf "%s" .Values.global.postgresql.host -}}
{{- else }}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end -}}

{{- define "dataset-controller.spark-history-server.fullname" -}}
{{- printf "%s-%s" .Release.Name "spark-history-server" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "dataset-controller.raw-query-exec-controller.fullname" -}}
{{- printf "%s-%s" .Release.Name "raw-query-exec-controller" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
