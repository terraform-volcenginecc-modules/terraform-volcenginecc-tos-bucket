output "bucket_name" {
  description = "Private TOS bucket name."
  value       = module.private_bucket.bucket_name
}

output "intranet_endpoint" {
  description = "Private-network endpoint for clients in the configured region."
  value       = module.private_bucket.intranet_endpoint
}
