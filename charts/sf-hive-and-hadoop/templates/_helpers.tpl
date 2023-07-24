{{- define "hadoop.name" -}}
{{- default "hadoop" .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "hive.name" -}}
{{- default "hive" .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hadoop.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "hadoop" .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hive.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "hive" .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hive-and-hadoop.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "hive-and-hadoop.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hadoop.labels" -}}
helm.sh/chart: {{ include "hive-and-hadoop.chart" . }}
app.kubernetes.io/name: {{ include "hadoop.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hive.labels" -}}
helm.sh/chart: {{ include "hive-and-hadoop.chart" . }}
app.kubernetes.io/name: {{ include "hive.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "hive.postgresql.fullname" -}}
{{- if .Values.postgresqlOverrides.host }}
{{- printf "%s" .Values.postgresqlOverrides.host -}}
{{- else if .Values.global.postgresql.host }}
{{- printf "%s" .Values.global.postgresql.host -}}
{{- else }}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end -}}

{{- define "hive.postgresql.servicePort" -}}
{{- if .Values.postgresqlOverrides.servicePort }}
{{- printf "%v" .Values.postgresqlOverrides.servicePort -}}
{{- else }}
{{- printf "%v" .Values.global.postgresql.servicePort }}
{{- end }}
{{- end -}}

{{- define "hive.postgresql.username" -}}
{{- if .Values.postgresqlOverrides.postgresqlUsername }}
{{- printf "%s" .Values.postgresqlOverrides.postgresqlUsername -}}
{{- else }}
{{- printf "%s" .Values.global.postgresql.postgresqlUsername }}
{{- end }}
{{- end -}}

{{- define "hive.postgresql.password" -}}
{{- if .Values.postgresqlOverrides.postgresqlPassword }}
{{- printf "%s" .Values.postgresqlOverrides.postgresqlPassword -}}
{{- else }}
{{- printf "%s" .Values.global.postgresql.postgresqlPassword }}
{{- end }}
{{- end -}}

{{- define "hadoop.namenode.service" -}}
{{- printf "%s-namenode-headless" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "hadoop.datanode.service" -}}
{{- printf "%s-datanode-headless" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "hive.server.service" -}}
{{- printf "%s-hive-server" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "hive.metastore.service" -}}
{{- printf "%s-hive-metastore" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
