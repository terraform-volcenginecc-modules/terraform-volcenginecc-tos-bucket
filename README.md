# terraform-volcenginecc-tos-bucket

## 1. Overview

Terraform module for managing Volcengine TOS BUCKET resources with the `volcenginecc` provider. The caller owns provider authentication, region configuration, and external resources passed by ID.

## 2. Usage

```hcl
module "tos_bucket" {
  source  = "terraform-volcenginecc-modules/tos-bucket/volcenginecc"
  version = "~> 1.0"

  # Set the required module inputs for your environment.
}
```

## 3. Examples

- `basic`: independently runnable basic configuration.
- `complete`: independently runnable complete configuration.

## 4. Requirements

| Name | Version |
|---|---|
| Terraform | `>= 1.5.7` |
| OpenTofu | `>= 1.11.8` |

## 5. Providers

| Name | Source |
|---|---|
| `volcenginecc` | `volcengine/volcenginecc` |

## 6. Resources

| Name | Description |
|---|---|
| `volcenginecc_tos_bucket` | Module-defined volcenginecc_tos_bucket. |
| `volcenginecc_tos_bucket_cors` | Module-defined volcenginecc_tos_bucket_cors. |
| `volcenginecc_tos_bucket_encryption` | Module-defined volcenginecc_tos_bucket_encryption. |
| `volcenginecc_tos_bucket_website` | Module-defined volcenginecc_tos_bucket_website. |
| `volcenginecc_tos_bucket_realtime_log` | Module-defined volcenginecc_tos_bucket_realtime_log. |

## 7. Inputs

| Name | Description |
|---|---|
| `bucket_name` | Module-defined bucket_name. |
| `acl` | Module-defined acl. |
| `allow_public_write` | Module-defined allow_public_write. |
| `allow_public_read` | Module-defined allow_public_read. |
| `allow_public_policy` | Module-defined allow_public_policy. |
| `allow_wildcard_policy_actions` | Module-defined allow_wildcard_policy_actions. |
| `storage_class` | Module-defined storage_class. |
| `bucket_type` | Module-defined bucket_type. |
| `az_redundancy` | Module-defined az_redundancy. |
| `versioning_status` | Module-defined versioning_status. |
| `project_name` | Module-defined project_name. |
| `policy_json` | Module-defined policy_json. |
| `tags` | Module-defined tags. |
| `lifecycle_rules` | Module-defined lifecycle_rules. |
| `cors_rules` | Module-defined cors_rules. |
| `encryption` | Module-defined encryption. |
| `website` | Module-defined website. |
| `realtime_log` | Module-defined realtime_log. |

## 8. Outputs

| Name | Description |
|---|---|
| `bucket_name` | Module-defined bucket_name. |
| `bucket_id` | Module-defined bucket_id. |
| `location` | Module-defined location. |
| `extranet_endpoint` | Module-defined extranet_endpoint. |
| `bucket_domain_name` | Module-defined bucket_domain_name. |
| `intranet_endpoint` | Module-defined intranet_endpoint. |
| `website_id` | Module-defined website_id. |
| `cors_id` | Module-defined cors_id. |
| `encryption_id` | Module-defined encryption_id. |
| `realtime_log_id` | Module-defined realtime_log_id. |

## 9. Notes

- Configure credentials using supported provider mechanisms; do not put access keys in module files.
- Review replacement behavior and provider constraints before applying changes.
- Run `terraform plan` after apply and confirm that the second plan has no changes.
