{{- define "shopdashboard.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "shopdashboard.fullname" -}}
shopdashboard
{{- end }}

{{- define "shopdashboard.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "shopdashboard.labels" -}}
helm.sh/chart: {{ include "shopdashboard.chart" . }}
{{ include "shopdashboard.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "shopdashboard.selectorLabels" -}}
app.kubernetes.io/name: {{ include "shopdashboard.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "shopdashboard.image" -}}
{{- if .Values.image.registry -}}
{{- printf "%s/%s:%s" .Values.image.registry .Values.image.repository .tag -}}
{{- else -}}
{{- printf "%s:%s" .Values.image.repository .tag -}}
{{- end -}}
{{- end }}

{{- define "shopdashboard.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "shopdashboard.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
