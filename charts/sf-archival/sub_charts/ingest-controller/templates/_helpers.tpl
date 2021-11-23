{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "ingest-controller.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ingest-controller.fullname" -}}
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
{{- define "ingest-controller.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "ingest-controller.labels" -}}
app.kubernetes.io/name: {{ include "ingest-controller.name" . }}
helm.sh/chart: {{ include "ingest-controller.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "ingest-controller.postgresql.fullname" -}}
{{- if .Values.global.postgresql.host }} 
{{- printf "%s" .Values.global.postgresql.host -}}
{{- else }}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end -}}

{{- define "ingest-controller.spark-manager.fullname" -}}
{{- printf "%s-%s" .Release.Name "spark-manager" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ingest-controller.log-archival.fullname" -}}
{{- printf "%s-%s" .Release.Name "log-archival" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ingest-controller.dataset-controller.fullname" -}}
{{- printf "%s-%s" .Release.Name "dataset-controller" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ingest-controller.query-controller.fullname" -}}
{{- printf "%s-%s" .Release.Name "query-controller" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ingest-controller.signatures-and-kafka-apis.ingest-controller.fullname" -}}
{{- printf "%s-%s" .Values.global.snappyflowDatapath.releaseName "signatures-and-kafka-apis.ingest-controller" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ingest-controller.spark-history-server.fullname" -}}
{{- printf "%s-%s" .Release.Name "spark-history-server" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ingest-controller.schemaRegistry.fullname" -}}
{{- printf "%s-%s" .Values.global.snappyflowDatapath.releaseName "cp-schema-registry" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ingest-controller.kafkaRest.fullname" -}}
{{- printf "%s-%s" .Values.global.snappyflowDatapath.releaseName "cp-kafka-rest" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ingest-controller.archivalKafkaConnect.fullname" -}}
{{- printf "%s-%s" .Values.global.snappyflowDatapath.releaseName "s3-kafka-connect" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ingest-controller.minio-svc.fullname" -}}
{{- if .Values.global.secrets.gcs.enable }}
{{- printf "%s-%s:%s" .Values.global.snappyflowDatapath.releaseName "minio" "9000" | trunc 63 | trimSuffix "-" -}}
{{- else }}
{{- printf "%s" "s3.amazonaws.com"}}
{{- end }}
{{- end -}}

{{- define "ingest-controller.hive-server.username" -}}
{{- if .Values.global.hive.external.enabled }}
{{- .Values.global.hive.external.userName -}}
{{- else }}
{{- printf "root" -}}
{{- end }}
{{- end -}}

{{- define "ingest-controller.hive-server.host" -}}
{{- if .Values.global.hive.external.enabled }}
{{- .Values.global.hive.external.host -}}
{{- else }}
{{- printf "%s-%s" .Release.Name "hive-server" | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end -}}

{{- define "ingest-controller.hive-server.port" -}}
{{- if .Values.global.hive.external.enabled }}
{{- .Values.global.hive.external.port -}}
{{- else }}
{{- printf "10000" -}}
{{- end }}
{{- end -}}

{{- define "ingest-controller.hive-server.auth" -}}
{{- if .Values.global.hive.external.enabled }}
{{- .Values.global.hive.external.auth -}}
{{- else }}
{{- printf "NONE" -}}
{{- end }}
{{- end -}}
