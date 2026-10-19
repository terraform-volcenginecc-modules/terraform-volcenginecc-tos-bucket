variable "bucket_name" {
  type        = string
  description = "Globally unique name for the private static-resource bucket."
}

variable "environment" {
  type        = string
  description = "Environment tag value."
  default     = "dev"
}
