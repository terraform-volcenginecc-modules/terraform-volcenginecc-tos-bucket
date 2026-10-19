# terraform-volcenginecc-tos-bucket

## 1. 概述

基于 `volcenginecc` Provider 管理火山引擎 TOS BUCKET 资源的 Terraform 模块。调用方负责 Provider 凭据、地域配置，以及通过 ID 传入的外部资源。

## 2. 用法

```hcl
module "tos_bucket" {
  source  = "terraform-volcenginecc-modules/tos-bucket/volcenginecc"
  version = "~> 1.0"

  # 请设置适用于当前环境的必填模块输入。
}
```

## 3. 示例

- `basic`：可独立运行的 basic 配置。
- `complete`：可独立运行的 complete 配置。

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
| `volcenginecc_tos_bucket` | 模块定义的 volcenginecc_tos_bucket。 |
| `volcenginecc_tos_bucket_cors` | 模块定义的 volcenginecc_tos_bucket_cors。 |
| `volcenginecc_tos_bucket_encryption` | 模块定义的 volcenginecc_tos_bucket_encryption。 |
| `volcenginecc_tos_bucket_website` | 模块定义的 volcenginecc_tos_bucket_website。 |
| `volcenginecc_tos_bucket_realtime_log` | 模块定义的 volcenginecc_tos_bucket_realtime_log。 |

## 7. 输入

| 名称 | 说明 |
|---|---|
| `bucket_name` | 模块定义的 bucket_name。 |
| `acl` | 模块定义的 acl。 |
| `allow_public_write` | 模块定义的 allow_public_write。 |
| `allow_public_read` | 模块定义的 allow_public_read。 |
| `allow_public_policy` | 模块定义的 allow_public_policy。 |
| `allow_wildcard_policy_actions` | 模块定义的 allow_wildcard_policy_actions。 |
| `storage_class` | 模块定义的 storage_class。 |
| `bucket_type` | 模块定义的 bucket_type。 |
| `az_redundancy` | 模块定义的 az_redundancy。 |
| `versioning_status` | 模块定义的 versioning_status。 |
| `project_name` | 模块定义的 project_name。 |
| `policy_json` | 模块定义的 policy_json。 |
| `tags` | 模块定义的 tags。 |
| `lifecycle_rules` | 模块定义的 lifecycle_rules。 |
| `cors_rules` | 模块定义的 cors_rules。 |
| `encryption` | 模块定义的 encryption。 |
| `website` | 模块定义的 website。 |
| `realtime_log` | 模块定义的 realtime_log。 |

## 8. 输出

| 名称 | 说明 |
|---|---|
| `bucket_name` | 模块定义的 bucket_name。 |
| `bucket_id` | 模块定义的 bucket_id。 |
| `location` | 模块定义的 location。 |
| `extranet_endpoint` | 模块定义的 extranet_endpoint。 |
| `bucket_domain_name` | 模块定义的 bucket_domain_name。 |
| `intranet_endpoint` | 模块定义的 intranet_endpoint。 |
| `website_id` | 模块定义的 website_id。 |
| `cors_id` | 模块定义的 cors_id。 |
| `encryption_id` | 模块定义的 encryption_id。 |
| `realtime_log_id` | 模块定义的 realtime_log_id。 |

## 9. 注意事项

- 请通过 Provider 支持的方式配置凭据，不要将访问密钥写入模块文件。
- 执行变更前请审阅替换行为及 Provider 限制。
- apply 后请再次执行 `terraform plan`，并确认第二次 plan 无变更。
