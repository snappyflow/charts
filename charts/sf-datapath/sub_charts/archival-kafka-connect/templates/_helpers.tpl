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
Worker configurations that kafka-connect needs. This is using "s3" instead of "archival" as "archival" was introduced in between and we didn't want to change consumer-groups
*/}}
{{- define "archival-kafka-connect.group.id" -}}
{{- if .Values.global.secrets.aws.enable }}
{{- printf "%s-%s-%s" .Release.Namespace .Release.Name "s3-connect"  -}}
{{- else if .Values.global.secrets.gcs.enable }}
{{- printf "%s-%s-%s" .Release.Namespace .Release.Name "gcs-connect"  -}}
{{- else }}
{{- printf "%s-%s-%s" .Release.Namespace .Release.Name "wasb-connect"  -}}
{{- end }}
{{- end -}}

{{- define "archival-kafka-connect.config.storage.topic" -}}
{{- if .Values.global.secrets.aws.enable }}
{{- printf "%s-%s-%s" .Release.Namespace .Release.Name "s3-connect-config"  -}}
{{- else if .Values.global.secrets.gcs.enable }}
{{- printf "%s-%s-%s" .Release.Namespace .Release.Name "gcs-connect-config"  -}}
{{- else }}
{{- printf "%s-%s-%s" .Release.Namespace .Release.Name "wasb-connect-config"  -}}
{{- end }}
{{- end -}}

{{- define "archival-kafka-connect.offset.storage.topic" -}}
{{- if .Values.global.secrets.aws.enable }}
{{- printf "%s-%s-%s" .Release.Namespace .Release.Name "s3-connect-offset"  -}}
{{- else if .Values.global.secrets.gcs.enable }}
{{- printf "%s-%s-%s" .Release.Namespace .Release.Name "gcs-connect-offset"  -}}
{{- else }}
{{- printf "%s-%s-%s" .Release.Namespace .Release.Name "wasb-connect-offset"  -}}
{{- end }}
{{- end -}}

{{- define "archival-kafka-connect.status.storage.topic" -}}
{{- if .Values.global.secrets.aws.enable }}
{{- printf "%s-%s-%s" .Release.Namespace .Release.Name "s3-connect-status"  -}}
{{- else if .Values.global.secrets.gcs.enable }}
{{- printf "%s-%s-%s" .Release.Namespace .Release.Name "gcs-connect-status"  -}}
{{- else }}
{{- printf "%s-%s-%s" .Release.Namespace .Release.Name "wasb-connect-status"  -}}
{{- end }}
{{- end -}}
