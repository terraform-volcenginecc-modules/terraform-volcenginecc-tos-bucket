output "bucket_name" {
  description = "Static website origin bucket name."
  value       = module.website_origin.bucket_name
}

output "extranet_endpoint" {
  description = "Public TOS protocol endpoint returned for the website origin bucket."
  value       = module.website_origin.extranet_endpoint
}

output "website_id" {
  description = "Provider ID of the static website configuration."
  value       = module.website_origin.website_id
}
