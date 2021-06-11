{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "query-controller.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "query-controller.fullname" -}}
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
{{- define "query-controller.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "query-controller.labels" -}}
app.kubernetes.io/name: {{ include "query-controller.name" . }}
helm.sh/chart: {{ include "query-controller.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "query-controller.postgresql.fullname" -}}
{{- if .Values.global.postgresql.host }} 
{{- printf "%s" .Values.global.postgresql.host -}}
{{- else }}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end -}}

{{- define "query-controller.spark-manager.fullname" -}}
{{- printf "%s-%s" .Release.Name "spark-manager" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "query-controller.log-archival.fullname" -}}
{{- printf "%s-%s" .Release.Name "log-archival" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "query-controller.dataset-controller.fullname" -}}
{{- printf "%s-%s" .Release.Name "dataset-controller" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "query-controller.ingest-controller.fullname" -}}
{{- printf "%s-%s" .Release.Name "ingest-controller" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "query-controller.spark-history-server.fullname" -}}
{{- printf "%s-%s" .Release.Name "spark-history-server" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "query-controller.cp-schema-registry.fullname" -}}
{{- printf "%s-%s" .Values.global.snappyflowDatapath.releaseName "cp-schema-registry" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "dataset-controller.service.servicePort" -}}
{{- $port := index .Values "dataset-controller" "service" "servicePort" -}}
{{- printf "%s" $port -}}
{{- end -}}

{{- define "ingest-controller.service.servicePort" -}}
{{- $port := index .Values "ingest-controller" "service" "servicePort" -}}
{{- printf "%s" $port -}}
{{- end -}}

{{- define "spark-manager.jobserver.service.servicePort" -}}
{{- $port := index .Values "spark-manager" "jobserver" "service" "servicePort" -}}
{{- printf "%s" $port -}}
{{- end -}}

{{- define "log-archival.service.servicePort" -}}
{{- $port := index .Values "log-archival" "service" "servicePort" -}}
{{- printf "%s" $port -}}
{{- end -}}

{{- define "query-controller.hive-server.username" -}}
{{- if .Values.global.hive.external.enabled }}
{{- .Values.global.hive.external.userName -}}
{{- else }}
{{- printf "root" -}}
{{- end }}
{{- end -}}

{{- define "query-controller.hive-server.host" -}}
{{- if .Values.global.hive.external.enabled }}
{{- .Values.global.hive.external.host -}}
{{- else }}
{{- printf "%s-%s" .Release.Name "hive-server" | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end -}}

{{- define "query-controller.hive-server.port" -}}
{{- if .Values.global.hive.external.enabled }}
{{- .Values.global.hive.external.port -}}
{{- else }}
{{- printf "10000" -}}
{{- end }}
{{- end -}}

{{- define "query-controller.hive-server.auth" -}}
{{- if .Values.global.hive.external.enabled }}
{{- .Values.global.hive.external.auth -}}
{{- else }}
{{- printf "NONE" -}}
{{- end }}
{{- end -}}
