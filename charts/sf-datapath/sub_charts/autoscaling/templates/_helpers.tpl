{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "autoscaling.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "autoscaling.fullname" -}}
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
{{- define "autoscaling.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "autoscaling.labels" -}}
app.kubernetes.io/name: {{ include "autoscaling.name" . }}
helm.sh/chart: {{ include "autoscaling.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "autoscaling.maxReplicas" -}}
{{- $extra := 0 -}}
{{- $GBPerPod := 100 -}}
{{- if ne (mod .Values.global.clusterQuotaGBperDay $GBPerPod) 0 -}}
{{- $extra = (sub $GBPerPod (mod .Values.global.clusterQuotaGBperDay $GBPerPod)) -}}
{{- end -}}
{{- add 2 (div (add .Values.global.clusterQuotaGBperDay $extra) $GBPerPod) -}}
{{- end -}}

{{- define "autoscaling.archivalConnectAutoscaling.fullname" -}}
{{- printf "%s-%s" .Release.Name "s3-kafka-connect" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "autoscaling.archivalConnectAutoscaling.maxReplicas" -}}
{{- .Values.archivalConnectAutoscaling.maxReplicasOverride | default (include "autoscaling.maxReplicas" .) -}}
{{- end -}}

{{- define "autoscaling.apmConnectAutoscaling.fullname" -}}
{{- printf "%s-%s" .Release.Name "es-kafka-connect" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "autoscaling.apmConnectAutoscaling.maxReplicas" -}}
{{- .Values.apmConnectAutoscaling.maxReplicasOverride | default (include "autoscaling.maxReplicas" .) -}}
{{- end -}}

{{- define "autoscaling.restKafkaAutoscaling.fullname" -}}
{{- printf "%s-%s" .Release.Name "cp-kafka-rest" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "autoscaling.minioAutoscaling.fullname" -}}
{{- printf "%s-%s" .Release.Name "minio" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "autoscaling.minioAutoscaling.maxReplicas" -}}
{{- .Values.minioAutoscaling.maxReplicasOverride | default (include "autoscaling.maxReplicas" .) -}}
{{- end -}}
