{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "authenticator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "authenticator.fullname" -}}
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
{{- define "authenticator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "authenticator.labels" -}}
app.kubernetes.io/name: {{ include "authenticator.name" . }}
helm.sh/chart: {{ include "authenticator.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
release: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "authenticator.postgresql.fullname" -}}
{{- if .Values.global.postgresql.host }}
{{- printf "%s" .Values.global.postgresql.host -}}
{{- else }}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end -}}

{{- define "authenticator.job-server.fullname" -}}
{{- printf "%s-%s" .Release.Name "job-server" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "authenticator.log-archival.fullname" -}}
{{- printf "%s-%s" .Release.Name "log-archival" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "authenticator.dataset-controller.fullname" -}}
{{- printf "%s-%s" .Release.Name "dataset-controller" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "authenticator.spark-history-server.fullname" -}}
{{- printf "%s-%s" .Release.Name "spark-history-server" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "authenticator.cp-schema-registry.fullname" -}}
{{- printf "%s-%s" .Values.global.kafka.release.name "cp-schema-registry" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "dataset-controller.service.servicePort" -}}
{{- $port := index .Values "dataset-controller" "service" "servicePort" -}}
{{- printf "%s" $port -}}
{{- end -}}

{{- define "job-server.service.servicePort" -}}
{{- $port := index .Values "job-server" "service" "servicePort" -}}
{{- printf "%s" $port -}}
{{- end -}}

{{- define "log-archival.service.servicePort" -}}
{{- $port := index .Values "log-archival" "service" "servicePort" -}}
{{- printf "%s" $port -}}
{{- end -}}

