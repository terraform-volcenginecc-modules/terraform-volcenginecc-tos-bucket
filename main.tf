locals {
  bucket_policy_statements = var.policy_json == null ? [] : try(
    [for statement in jsondecode(var.policy_json).Statement : statement],
    [jsondecode(var.policy_json).Statement],
  )

  policy_has_public_principal = anytrue([
    for statement in local.bucket_policy_statements : (
      try(statement.Principal == "*", false) ||
      try(contains(tolist(statement.Principal), "*"), false) ||
      try(statement.Principal.AWS == "*", false) ||
      try(contains(tolist(statement.Principal.AWS), "*"), false)
    )
  ])

  policy_has_wildcard_action = anytrue([
    for statement in local.bucket_policy_statements : (
      try(statement.Action == "*", false) ||
      try(statement.Action == "tos:*", false) ||
      try(contains(tolist(statement.Action), "*"), false) ||
      try(contains(tolist(statement.Action), "tos:*"), false)
    )
  ])

  lifecycle_uses_noncurrent_versions = anytrue([
    for rule in values(var.lifecycle_rules) : (
      rule.noncurrent_version_expiration_days != null ||
      length(rule.noncurrent_version_transitions) > 0
    )
  ])
}

resource "volcenginecc_tos_bucket" "this" {
  name                  = var.bucket_name
  storage_class         = var.storage_class
  bucket_type           = var.bucket_type
  az_redundancy         = var.az_redundancy
  enable_version_status = var.versioning_status
  project_name          = var.project_name
  policy                = var.policy_json

  acl_grant = var.acl == "private" ? null : {
    acl                = var.acl
    grant_full_control = null
    grant_read         = null
    grant_read_acp     = null
    grant_write        = null
    grant_write_acp    = null
  }

  lifecycle_config = length(var.lifecycle_rules) == 0 ? null : [
    for rule in values(var.lifecycle_rules) : {
      lifecycle_rule_id = rule.id
      prefix            = rule.prefix
      status            = rule.status
      expiration = rule.expiration_days == null ? null : {
        date = null
        days = rule.expiration_days
      }
      no_current_version_expiration = rule.noncurrent_version_expiration_days == null ? null : {
        non_current_date = null
        non_current_days = rule.noncurrent_version_expiration_days
      }
      abort_in_complete_multipart_upload = rule.abort_incomplete_multipart_upload_days == null ? null : {
        days_after_initiation = rule.abort_incomplete_multipart_upload_days
      }
      transitions = [
        for transition in rule.transitions : {
          date          = null
          days          = transition.days
          storage_class = transition.storage_class
        }
      ]
      non_current_version_transitions = [
        for transition in rule.noncurrent_version_transitions : {
          non_current_date = null
          non_current_days = transition.days
          storage_class    = transition.storage_class
        }
      ]
      filter = null
      tags   = []
    }
  ]

  tags = [
    for key, value in var.tags : {
      key   = key
      value = value
    }
  ]

  lifecycle {
    precondition {
      condition     = var.acl != "public-read" || var.allow_public_read
      error_message = "acl public-read requires allow_public_read to be true."
    }

    precondition {
      condition     = var.acl != "public-read-write" || (var.allow_public_read && var.allow_public_write)
      error_message = "acl public-read-write requires both allow_public_read and allow_public_write to be true."
    }

    precondition {
      condition     = var.allow_public_policy || !local.policy_has_public_principal
      error_message = "policy_json cannot grant an Allow statement to a public principal unless allow_public_policy is true."
    }

    precondition {
      condition     = var.allow_wildcard_policy_actions || !local.policy_has_wildcard_action
      error_message = "policy_json cannot use * or tos:* actions unless allow_wildcard_policy_actions is true."
    }

    precondition {
      condition     = !local.lifecycle_uses_noncurrent_versions || var.versioning_status == "Enabled"
      error_message = "versioning_status must be Enabled when lifecycle_rules configure noncurrent-version expiration or transitions."
    }
  }
}

resource "volcenginecc_tos_bucket_cors" "this" {
  count = length(var.cors_rules) == 0 ? 0 : 1

  bucket_name = volcenginecc_tos_bucket.this.name
  cors_rules = [
    for rule in var.cors_rules : {
      allowed_headers = rule.allowed_headers
      allowed_methods = rule.allowed_methods
      allowed_origins = rule.allowed_origins
      expose_headers  = rule.expose_headers
      max_age_seconds = rule.max_age_seconds
      response_vary   = rule.response_vary
    }
  ]
}

resource "volcenginecc_tos_bucket_encryption" "this" {
  count = var.encryption == null ? 0 : 1

  name              = volcenginecc_tos_bucket.this.name
  sse_algorithm     = var.encryption.sse_algorithm
  kms_master_key_id = var.encryption.kms_master_key_id

  lifecycle {
    precondition {
      condition     = var.encryption.sse_algorithm != "kms" ? true : try(length(trimspace(var.encryption.kms_master_key_id)) > 0, false)
      error_message = "encryption.kms_master_key_id must be set when encryption.sse_algorithm is kms."
    }

    precondition {
      condition     = var.encryption.sse_algorithm == "kms" || var.encryption.kms_master_key_id == null
      error_message = "encryption.kms_master_key_id can only be set when encryption.sse_algorithm is kms."
    }
  }
}

resource "volcenginecc_tos_bucket_website" "this" {
  count = var.website == null ? 0 : 1

  bucket = volcenginecc_tos_bucket.this.name
  index_document = {
    suffix            = var.website.index_document
    forbidden_sub_dir = var.website.forbidden_sub_dir
  }
  error_document = var.website.error_document == null ? null : {
    key = var.website.error_document
  }
  redirect_all_requests_to = var.website.redirect_all_requests_to == null ? null : {
    host_name = var.website.redirect_all_requests_to.host_name
    protocol  = var.website.redirect_all_requests_to.protocol
  }
  routing_rules = null

  lifecycle {
    precondition {
      condition     = var.website.redirect_all_requests_to == null ? true : var.website.error_document == null
      error_message = "website.error_document cannot be used with website.redirect_all_requests_to."
    }
  }
}

resource "volcenginecc_tos_bucket_realtime_log" "this" {
  count = var.realtime_log == null ? 0 : 1

  bucket_name = volcenginecc_tos_bucket.this.name
  real_time_log = merge(
    {
      role              = var.realtime_log.role
      use_service_topic = var.realtime_log.use_service_topic
    },
    var.realtime_log.tls_project_id == null ? {} : { tls_project_id = var.realtime_log.tls_project_id },
    var.realtime_log.tls_topic_id == null ? {} : { tls_topic_id = var.realtime_log.tls_topic_id },
  )
}
