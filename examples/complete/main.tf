locals {
  bucket_trn = "trn:tos:::${var.bucket_name}"
}

module "website_origin" {
  source  = "terraform-volcenginecc-modules/tos-bucket/volcenginecc"
  version = "~> 1.0"

  bucket_name       = var.bucket_name
  acl               = "private"
  az_redundancy     = "single-az"
  versioning_status = "Enabled"

  policy_json = jsonencode({
    Version = "1.0"
    Statement = [
      {
        Sid       = "AllowCdnOriginRead"
        Effect    = "Allow"
        Principal = var.cdn_principals
        Action    = "tos:GetObject"
        Resource  = "${local.bucket_trn}/*"
      },
    ]
  })

  encryption = {
    sse_algorithm     = "kms"
    kms_master_key_id = var.kms_master_key_id
  }

  cors_rules = [
    {
      allowed_origins = var.cors_allowed_origins
      allowed_methods = ["GET", "HEAD"]
      allowed_headers = ["*"]
      expose_headers  = ["x-tos-request-id", "x-tos-version-id"]
      max_age_seconds = 3600
      response_vary   = true
    },
  ]

  website = {
    index_document    = "index.html"
    error_document    = "error.html"
    forbidden_sub_dir = false
  }

  realtime_log = merge(
    {
      role              = var.tls_log_role_name
      use_service_topic = true
    },
    var.tls_project_id == null ? {} : { tls_project_id = var.tls_project_id },
    var.tls_topic_id == null ? {} : { tls_topic_id = var.tls_topic_id },
  )

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Scenario    = "static-site-versioned-archive"
  }
}
