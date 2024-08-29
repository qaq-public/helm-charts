{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "qaq.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "qaq.fullname" -}}
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
{{- define "qaq.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "qaq.labels" -}}
helm.sh/chart: {{ include "qaq.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ include "qaq.name" . }}
{{- end -}}

{{/*
Common label selectors
*/}}
{{- define "qaq.matchLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: {{ include "qaq.name" . }}
{{- end -}}

{{- define "qaq.app.csrf.secret.name" -}}
{{- printf "%s-%s" ( include "qaq.fullname" . ) "csrf"}}
{{- end -}}

{{- define "qaq.app.ingress.secret.name" -}}
{{- printf "%s-%s" ( include "qaq.fullname" . ) "certs"}}
{{- end -}}

{{- define "qaq.app.csrf.secret.key" -}}
{{- printf "private.key" }}
{{- end -}}

{{- define "qaq.app.csrf.secret.value" -}}
{{- $secretName := (include "qaq.app.csrf.secret.name" .) -}}
{{- $secret := lookup "v1" "Secret" .Release.Namespace $secretName -}}
{{- if .Values.app.security.csrfKey -}}
private.key: {{ .Values.app.security.csrfKey | b64enc | quote }}
{{- else if and $secret (hasKey $secret "data") (hasKey $secret.data "private.key") (index $secret.data "private.key") -}}
private.key: {{ index $secret.data "private.key" }}
{{- else -}}
private.key: {{ randBytes 256 | b64enc | quote }}
{{- end -}}
{{- end -}}

{{- define "qaq.metrics-scraper.name" -}}
{{- printf "%s-%s" ( include "qaq.fullname" . ) ( .Values.metricsScraper.role )}}
{{- end -}}

{{- define "qaq.web.configMap.settings.name" -}}
{{- printf "%s-%s-%s" ( include "qaq.fullname" . ) ( .Values.web.role ) "settings" }}
{{- end -}}

{{- define "qaq.validate.mode" -}}
{{- if not (or (eq .Values.app.mode "dashboard") (eq .Values.app.mode "api")) -}}
{{- fail "value of .Values.app.mode must be one of [dashboard, api]"}}
{{- end -}}
{{- end -}}

{{- define "qaq.validate.ingressIssuerScope" -}}
{{- if not (or (eq .Values.app.ingress.issuer.scope "disabled") (eq .Values.app.ingress.issuer.scope "default") (eq .Values.app.ingress.issuer.scope "cluster")) }}
{{- fail "value of .Values.app.ingress.issuer.scope must be one of [default, cluster, disabled]"}}
{{- end -}}
{{- end -}}