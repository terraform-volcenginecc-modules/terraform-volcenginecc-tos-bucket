# COMPLETE TOS BUCKET Example

## 1. Overview

Runnable complete configuration for the TOS BUCKET module. It configures the provider from input variables and calls the published Registry module.

## 2. Usage

```shell
terraform init
terraform plan
terraform apply
terraform plan
terraform destroy
```

## 3. Examples

This directory is the complete example.

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
| `terraform-volcenginecc-modules/tos-bucket/volcenginecc` | Published TOS BUCKET module. |

## 7. Inputs

| Name | Description |
|---|---|
| `bucket_name` | Module-defined bucket_name. |
| `kms_master_key_id` | Module-defined kms_master_key_id. |
| `cdn_principals` | Module-defined cdn_principals. |
| `cors_allowed_origins` | Module-defined cors_allowed_origins. |
| `tls_log_role_name` | Module-defined tls_log_role_name. |
| `tls_project_id` | Module-defined tls_project_id. |
| `tls_topic_id` | Module-defined tls_topic_id. |
| `environment` | Module-defined environment. |

## 8. Outputs

| Name | Description |
|---|---|
| `bucket_name` | Module-defined bucket_name. |
| `extranet_endpoint` | Module-defined extranet_endpoint. |
| `website_id` | Module-defined website_id. |

## 9. Notes

- Supply credentials through supported provider configuration, never in source files.
- The final plan after apply must report no changes before the configuration is accepted.
