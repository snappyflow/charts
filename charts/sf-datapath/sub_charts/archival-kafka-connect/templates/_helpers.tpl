{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "archival-kafka-connect.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "archival-kafka-connect.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "archival-kafka-connect.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Form the Kafka URL. If Kafka is installed as part of this chart, use k8s service discovery,
else use user-provided URL
*/}}
{{- define "archival-kafka-connect.kafka.bootstrapServers" -}}
{{- .Values.global.kafka.bootstrapServers -}}
{{- end -}}

{{/*
Create a default fully qualified schema registry name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "archival-kafka-connect.cp-schema-registry.fullname" -}}
{{- $name := default "cp-schema-registry" (index .Values "cp-schema-registry" "nameOverride") -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "archival-kafka-connect.cp-schema-registry.service-name" -}}
{{- if (index .Values "cp-schema-registry" "url") -}}
{{- printf "%s" (index .Values "cp-schema-registry" "url") -}}
{{- else -}}
{{- printf "http://%s:8081" (include "archival-kafka-connect.cp-schema-registry.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Worker configurations that kafka-connect needs
*/}}
{{- define "s3-kafka-connect.group.id" -}}
{{- printf "%s-%s-%s" .Release.Namespace .Release.Name "s3-connect"  -}}
{{- end -}}

{{- define "s3-kafka-connect.config.storage.topic" -}}
{{- printf "%s-%s-%s" .Release.Namespace .Release.Name "s3-connect-config"  -}}
{{- end -}}

{{- define "s3-kafka-connect.offset.storage.topic" -}}
{{- printf "%s-%s-%s" .Release.Namespace .Release.Name "s3-connect-offset"  -}}
{{- end -}}

{{- define "s3-kafka-connect.status.storage.topic" -}}
{{- printf "%s-%s-%s" .Release.Namespace .Release.Name "s3-connect-status"  -}}
{{- end -}}
