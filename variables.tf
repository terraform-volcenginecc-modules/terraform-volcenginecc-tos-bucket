variable "bucket_name" {
  type        = string
  description = "Globally unique TOS bucket name. Changing it replaces the bucket and every optional child configuration."

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name must be 3 to 63 lowercase letters, numbers, or hyphens, and start and end with a letter or number."
  }
}

variable "acl" {
  type        = string
  description = "Canned bucket ACL. Keep private unless public object access is explicitly approved."
  default     = "private"

  validation {
    condition = contains([
      "private",
      "public-read",
      "public-read-write",
      "authenticated-read",
      "bucket-owner-read",
      "bucket-owner-full-control",
      "log-delivery-write",
      "bucket-owner-entrusted",
      "default",
    ], var.acl)
    error_message = "acl must be a supported TOS canned ACL."
  }
}

variable "allow_public_write" {
  type        = bool
  description = "Explicitly permits the unsafe public-read-write ACL. Keep false unless public anonymous writes are approved."
  default     = false
}

variable "allow_public_read" {
  type        = bool
  description = "Explicitly permits the public-read or public-read-write ACL. Keep false unless anonymous reads are approved."
  default     = false
}

variable "allow_public_policy" {
  type        = bool
  description = "Explicitly permits policy_json Allow statements whose principal is *. Keep false to prevent anonymous Bucket Policy access."
  default     = false
}

variable "allow_wildcard_policy_actions" {
  type        = bool
  description = "Explicitly permits * or tos:* actions in policy_json. Keep false to require least-privilege actions."
  default     = false
}

variable "storage_class" {
  type        = string
  description = "Default storage class for new objects."
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "IA", "ARCHIVE_FR", "INTELLIGENT_TIERING", "COLD_ARCHIVE", "ARCHIVE", "DEEP_COLD_ARCHIVE"], var.storage_class)
    error_message = "storage_class must be a supported TOS storage class."
  }
}

variable "bucket_type" {
  type        = string
  description = "Bucket namespace type. Changing it replaces the bucket."
  default     = "fns"

  validation {
    condition     = contains(["fns", "hns"], var.bucket_type)
    error_message = "bucket_type must be fns or hns."
  }
}

variable "az_redundancy" {
  type        = string
  description = "Availability-zone redundancy. Changing it replaces the bucket."
  default     = "single-az"

  validation {
    condition     = contains(["single-az", "multi-az"], var.az_redundancy)
    error_message = "az_redundancy must be single-az or multi-az."
  }
}

variable "versioning_status" {
  type        = string
  description = "Object versioning status. Enabled is the default because the current Cloud Control API rejects Bucket creation with Suspended."
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "versioning_status must be Enabled or Suspended."
  }
}

variable "project_name" {
  type        = string
  description = "TOS project that owns the bucket. Changing it replaces the bucket."
  default     = "default"
}

variable "policy_json" {
  type        = string
  description = "Optional least-privilege TOS bucket policy JSON. Policy principals and IAM policies remain caller-owned."
  default     = null
  nullable    = true

  validation {
    condition     = var.policy_json == null ? true : can(jsondecode(var.policy_json))
    error_message = "policy_json must be valid JSON when set."
  }
}

variable "tags" {
  type        = map(string)
  description = "Bucket tags, represented as an explicit key/value map."
  default     = {}

  validation {
    condition     = alltrue([for key in keys(var.tags) : length(trimspace(key)) > 0])
    error_message = "Tag keys must not be empty."
  }
}

variable "lifecycle_rules" {
  type = map(object({
    id                                     = string
    prefix                                 = optional(string, "")
    status                                 = optional(string, "Enabled")
    expiration_days                        = optional(number)
    noncurrent_version_expiration_days     = optional(number)
    abort_incomplete_multipart_upload_days = optional(number)
    transitions = optional(list(object({
      days          = number
      storage_class = string
    })), [])
    noncurrent_version_transitions = optional(list(object({
      days          = number
      storage_class = string
    })), [])
  }))
  description = "Lifecycle rules keyed by stable logical names. Renaming a key changes the Terraform address while the id is sent to TOS."
  default     = {}

  validation {
    condition     = alltrue([for rule in values(var.lifecycle_rules) : length(trimspace(rule.id)) > 0 && contains(["Enabled", "Disabled"], rule.status)])
    error_message = "Each lifecycle rule requires a non-empty id and status Enabled or Disabled."
  }

  validation {
    condition = alltrue(flatten([
      for rule in values(var.lifecycle_rules) : concat(
        [for days in [rule.expiration_days, rule.noncurrent_version_expiration_days, rule.abort_incomplete_multipart_upload_days] : days == null ? true : days > 0],
        [for transition in rule.transitions : transition.days > 0 && contains(["STANDARD", "IA", "ARCHIVE_FR", "INTELLIGENT_TIERING", "COLD_ARCHIVE", "ARCHIVE", "DEEP_COLD_ARCHIVE"], transition.storage_class)],
        [for transition in rule.noncurrent_version_transitions : transition.days > 0 && contains(["STANDARD", "IA", "ARCHIVE_FR", "INTELLIGENT_TIERING", "COLD_ARCHIVE", "ARCHIVE", "DEEP_COLD_ARCHIVE"], transition.storage_class)],
      )
    ]))
    error_message = "Lifecycle day values must be positive and lifecycle transition storage classes must be supported."
  }
}

variable "cors_rules" {
  type = list(object({
    allowed_origins = set(string)
    allowed_methods = set(string)
    allowed_headers = optional(set(string), [])
    expose_headers  = optional(set(string), [])
    max_age_seconds = optional(number, 3600)
    response_vary   = optional(bool, false)
  }))
  description = "CORS rules. Every field is supplied explicitly because the Provider models rules as Optional+Computed sets."
  default     = []

  validation {
    condition = alltrue([
      for rule in var.cors_rules :
      length(rule.allowed_origins) > 0 &&
      length(rule.allowed_methods) > 0 &&
      alltrue([for method in rule.allowed_methods : contains(["GET", "PUT", "POST", "DELETE", "HEAD"], method)]) &&
      rule.max_age_seconds >= 0
    ])
    error_message = "Each CORS rule needs origins, supported HTTP methods, and a non-negative max_age_seconds."
  }
}

variable "encryption" {
  type = object({
    sse_algorithm     = string
    kms_master_key_id = optional(string)
  })
  description = "Optional default server-side encryption. Pass an existing KMS key ID when using kms; this module does not manage KMS."
  default     = null
  nullable    = true

  validation {
    condition     = var.encryption == null ? true : contains(["kms", "AES256", "SM4"], var.encryption.sse_algorithm)
    error_message = "encryption.sse_algorithm must be kms, AES256, or SM4."
  }
}

variable "website" {
  type = object({
    index_document    = string
    error_document    = optional(string)
    forbidden_sub_dir = optional(bool, false)
    redirect_all_requests_to = optional(object({
      host_name = string
      protocol  = optional(string, "https")
    }))
  })
  description = "Optional static website hosting configuration. Publishing website objects and any public-read policy remain caller-owned."
  default     = null
  nullable    = true

  validation {
    condition = var.website == null ? true : (
      length(trimspace(var.website.index_document)) > 0 &&
      (var.website.redirect_all_requests_to == null ? true : contains(["http", "https"], var.website.redirect_all_requests_to.protocol))
    )
    error_message = "website.index_document must not be empty and redirect protocol must be http or https."
  }
}

variable "realtime_log" {
  type = object({
    role              = string
    use_service_topic = bool
    tls_project_id    = optional(string)
    tls_topic_id      = optional(string)
  })
  description = "Optional TOS real-time log delivery to TLS. The IAM role and optional TLS project/topic are caller-owned."
  default     = null
  nullable    = true

  validation {
    condition     = var.realtime_log == null ? true : (length(trimspace(var.realtime_log.role)) > 0 && var.realtime_log.use_service_topic)
    error_message = "realtime_log.role must not be empty and realtime_log.use_service_topic must be true."
  }
}
