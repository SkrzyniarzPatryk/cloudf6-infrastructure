{{- define "paymentWorker.image" -}}
{{- $img := .Values.paymentWorker.deployment.image -}}
{{- printf "%s:%s" $img.repository (default "latest" $img.tag) -}}
{{- end -}}

{{- define "paymentApi.image" -}}
{{- $img := .Values.paymentApi.deployment.image -}}
{{- printf "%s:%s" $img.repository (default "latest" $img.tag) -}}
{{- end -}}