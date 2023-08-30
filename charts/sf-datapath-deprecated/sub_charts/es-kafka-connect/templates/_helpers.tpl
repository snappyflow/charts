{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "es-kafka-connect.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "es-kafka-connect.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "es-kafka-connect.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Form the Kafka URL. If Kafka is installed as part of this chart, use k8s service discovery,
else use user-provided URL
*/}}
{{- define "es-kafka-connect.kafka.bootstrapServers" -}}
{{- regexReplaceAllLiteral ":\\d+" .Values.global.kafka.bootstrapServers (printf ":%s" .Values.global.kafka.saslPort) -}}
{{- end -}}

{{/*
Create a default fully qualified schema registry name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "es-kafka-connect.cp-schema-registry.fullname" -}}
{{- $name := default "cp-schema-registry" (index .Values "cp-schema-registry" "nameOverride") -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "es-kafka-connect.cp-schema-registry.service-name" -}}
{{- if (index .Values "cp-schema-registry" "url") -}}
{{- printf "%s" (index .Values "cp-schema-registry" "url") -}}
{{- else -}}
{{- printf "http://%s:8081" (include "es-kafka-connect.cp-schema-registry.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Worker configurations that kafka-connect needs
*/}}
{{- define "es-kafka-connect.group.id" -}}
{{- printf "%s-%s-%s" .Release.Namespace .Release.Name "es-connect"  -}}
{{- end -}}

{{- define "es-kafka-connect.config.storage.topic" -}}
{{- printf "%s-%s-%s" .Release.Namespace .Release.Name "es-connect-config"  -}}
{{- end -}}

{{- define "es-kafka-connect.offset.storage.topic" -}}
{{- printf "%s-%s-%s" .Release.Namespace .Release.Name "es-connect-offset"  -}}
{{- end -}}

{{- define "es-kafka-connect.status.storage.topic" -}}
{{- printf "%s-%s-%s" .Release.Namespace .Release.Name "es-connect-status"  -}}
{{- end -}}
