{{- define "gateway.fullname" -}}
{{- printf "%s" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "gateway.proxy-blocks" -}}
{{- printf "%s-proxy-blocks" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
