{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "cp-helm-charts.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cp-helm-charts.fullname" -}}
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
{{- define "cp-helm-charts.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
To get api version for HPA
*/}}
{{- define "autoscaling.apiVersion" -}}
   {{- if .Capabilities.APIVersions.Has "autoscaling/v2" -}}
      {{- print "autoscaling/v2" -}}
   {{- else -}}
     {{- print "autoscaling/v2beta2" -}}
   {{- end -}}
{{- end -}}

{{/*
To get api version for cronJob
*/}}
{{- define "batch.apiVersion" -}}
   {{- if .Capabilities.APIVersions.Has "batch/v1" -}}
      {{- print "batch/v1" -}}
   {{- end -}}
{{- end -}}

{{/*
To get api version for Policy
*/}}
{{- define "policy.apiVersion" -}}
   {{- if .Capabilities.APIVersions.Has "policy/v1" -}}
      {{- print "policy/v1" -}}
   {{- end -}}
{{- end -}}