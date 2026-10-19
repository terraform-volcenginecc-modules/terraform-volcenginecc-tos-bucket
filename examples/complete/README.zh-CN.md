# COMPLETE TOS BUCKET 示例

## 1. 概述

TOS BUCKET 模块的可运行 complete 配置。它从输入变量设置 Provider，并调用已发布的 Registry 模块。

## 2. 用法

```shell
terraform init
terraform plan
terraform apply
terraform plan
terraform destroy
```

## 3. 示例

本目录即为 complete 示例。

## 4. 版本要求

| 名称 | 版本 |
|---|---|
| Terraform | `>= 1.5.7` |
| OpenTofu | `>= 1.11.8` |

## 5. Provider

| 名称 | 来源 |
|---|---|
| `volcenginecc` | `volcengine/volcenginecc` |

## 6. 资源

| 名称 | 说明 |
|---|---|
| `terraform-volcenginecc-modules/tos-bucket/volcenginecc` | 已发布的 TOS BUCKET 模块。 |

## 7. 输入

| 名称 | 说明 |
|---|---|
| `bucket_name` | 模块定义的 bucket_name。 |
| `kms_master_key_id` | 模块定义的 kms_master_key_id。 |
| `cdn_principals` | 模块定义的 cdn_principals。 |
| `cors_allowed_origins` | 模块定义的 cors_allowed_origins。 |
| `tls_log_role_name` | 模块定义的 tls_log_role_name。 |
| `tls_project_id` | 模块定义的 tls_project_id。 |
| `tls_topic_id` | 模块定义的 tls_topic_id。 |
| `environment` | 模块定义的 environment。 |

## 8. 输出

| 名称 | 说明 |
|---|---|
| `bucket_name` | 模块定义的 bucket_name。 |
| `extranet_endpoint` | 模块定义的 extranet_endpoint。 |
| `website_id` | 模块定义的 website_id。 |

## 9. 注意事项

- 请通过 Provider 支持的配置提供凭据，绝不应写入源文件。
- apply 后的最终 plan 必须报告无变更，才能接受该配置。
