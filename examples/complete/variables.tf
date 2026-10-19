variable "bucket_name" {
  type        = string
  description = "Globally unique TOS bucket name for the static website origin and archive data."
}

variable "kms_master_key_id" {
  type        = string
  description = "Existing KMS key ID used for default SSE-KMS encryption."
}

variable "cdn_principals" {
  type        = set(string)
  description = "Existing IAM principal identifiers permitted to read website origin objects."
}

variable "cors_allowed_origins" {
  type        = set(string)
  description = "Trusted browser origins permitted to read static website objects."
}

variable "tls_log_role_name" {
  type        = string
  description = "Existing IAM role that authorizes TOS to create or write TLS real-time logs."
}

variable "tls_project_id" {
  type        = string
  description = "Optional existing TLS project ID for TOS real-time logs. Omit it to use a TOS service-managed destination."
  default     = null
  nullable    = true
}

variable "tls_topic_id" {
  type        = string
  description = "Optional existing TLS topic ID for TOS real-time logs. Omit it to use a TOS service-managed destination."
  default     = null
  nullable    = true
}

variable "environment" {
  type        = string
  description = "Environment tag value."
  default     = "prod"
}
