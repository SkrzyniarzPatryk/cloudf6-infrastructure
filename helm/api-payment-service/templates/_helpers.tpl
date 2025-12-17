{{- define "payment-worker.image" -}}
{{- $img := .Values.deployment.image -}}
{{- printf "%s:%s" $img.repository (default "latest" $img.tag) -}}
{{- end -}}

{{- define "payment-api.image" -}}
{{- $img := .Values.deployment.image -}}
{{- printf "%s:%s" $img.repository (default "latest" $img.tag) -}}
{{- end -}}



{{- define "mychart.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}