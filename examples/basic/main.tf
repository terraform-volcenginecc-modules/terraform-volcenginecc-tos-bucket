module "private_bucket" {
  source  = "terraform-volcenginecc-modules/tos-bucket/volcenginecc"
  version = "~> 1.0"

  bucket_name = var.bucket_name
  acl         = "private"

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Scenario    = "private-static-assets"
  }
}
