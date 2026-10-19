output "bucket_name" {
  description = "Name of the managed TOS bucket."
  value       = volcenginecc_tos_bucket.this.name
}

output "bucket_id" {
  description = "Provider ID of the managed TOS bucket."
  value       = volcenginecc_tos_bucket.this.id
}

output "location" {
  description = "Region returned by TOS for the bucket. Region is selected through the caller's provider configuration."
  value       = volcenginecc_tos_bucket.this.location
}

output "extranet_endpoint" {
  description = "Public TOS protocol endpoint returned for the bucket."
  value       = volcenginecc_tos_bucket.this.extranet_endpoint
}

output "bucket_domain_name" {
  description = "Public TOS protocol domain name returned for the bucket."
  value       = volcenginecc_tos_bucket.this.extranet_endpoint
}

output "intranet_endpoint" {
  description = "Private-network TOS protocol endpoint returned for the bucket."
  value       = volcenginecc_tos_bucket.this.intranet_endpoint
}

output "website_id" {
  description = "Provider ID of the optional static website configuration."
  value       = try(volcenginecc_tos_bucket_website.this[0].id, null)
}

output "cors_id" {
  description = "Provider ID of the optional CORS configuration."
  value       = try(volcenginecc_tos_bucket_cors.this[0].id, null)
}

output "encryption_id" {
  description = "Provider ID of the optional default encryption configuration."
  value       = try(volcenginecc_tos_bucket_encryption.this[0].id, null)
}

output "realtime_log_id" {
  description = "Provider ID of the optional TLS real-time log configuration."
  value       = try(volcenginecc_tos_bucket_realtime_log.this[0].id, null)
}
