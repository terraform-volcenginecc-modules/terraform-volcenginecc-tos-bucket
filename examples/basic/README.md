# BASIC TOS BUCKET Example

## 1. Overview

Runnable basic configuration for the TOS BUCKET module. It configures the provider from input variables and calls the published Registry module.

## 2. Usage

```shell
terraform init
terraform plan
terraform apply
terraform plan
terraform destroy
```

## 3. Examples

This directory is the basic example.

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
| `environment` | Module-defined environment. |

## 8. Outputs

| Name | Description |
|---|---|
| `bucket_name` | Module-defined bucket_name. |
| `intranet_endpoint` | Module-defined intranet_endpoint. |

## 9. Notes

- Supply credentials through supported provider configuration, never in source files.
- The final plan after apply must report no changes before the configuration is accepted.
