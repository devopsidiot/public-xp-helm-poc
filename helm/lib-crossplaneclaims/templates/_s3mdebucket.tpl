{{/*
Defines a claim to create an S3 bucket using devopsidiot.com XDRs.
*/}}
{{- define "lib-crossplaneclaims.s3doibucket" }}

{{- $defaultTags := (include "aws.tags" . | fromYaml) }}
{{- range .Values.s3_buckets }}
{{- $userTags := .tags | default (dict) }}
{{- $mergedTags := merge $defaultTags $userTags }}
---
apiVersion: devopsidiot.com/v1alpha1
kind: Storage
metadata:
  name: {{ .name }}
spec:
  bucketName: {{ .name }}
  {{- if not (eq (kindOf .versioning) "invalid") }}
  versioning: {{ .versioning }}
  {{- end }}
  {{- if not (eq (kindOf .defaultControlPolicy) "invalid") }}
  defaultControlPolicy: {{ .defaultControlPolicy }}
  {{- end }}
  {{- if not (eq (kindOf .defaultServerSideEncryption) "invalid") }}
  defaultServerSideEncryption: {{ .defaultServerSideEncryption }}
  {{- end }}
  {{- if .bucketPolicy }}
  bucketPolicy: {{ .bucketPolicy | toJson }}
  {{- end }}
  {{- if .bucketReplicationConfiguration }}
  bucketReplicationConfiguration: {{ .bucketReplicationConfiguration | toYaml | nindent 4 }}
  {{- end }}
  {{- if .region }}
  region: {{ .region }}
  {{- end }}
  {{- if .serviceAccount }}
  serviceAccount: {{ .serviceAccount }}
  {{- end }}
  {{- if .awsAccounts }}
  awsAccounts: {{ .awsAccounts | toYaml | nindent 4 }}
  {{- end }}
  {{- if .vpcEndPoint }}
  vpcEndPoint: {{ .vpcEndPoint }}
  {{- end }}
  {{- if .notifications }}
  notifications: {{ .notifications | toYaml | nindent 4 }}
  {{- end }}
  {{- if .lifecycleRules }}
  lifecycleRules: {{ .lifecycleRules | toYaml | nindent 4 }}
  {{- end }}
  tags:
    {{- range $key, $value := $mergedTags -}}
    {{ $key | nindent 4 }}: {{ $value | quote }}
    {{- end }}
{{- end }}
{{ end }}
