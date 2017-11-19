
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| acl |  | string | `private` | no |
| app |  | string | - | yes |
| env |  | string | - | yes |
| logging_target_bucket | Bucket to use for request access logging | string | - | yes |
| logging_target_prefix | (Optional) Override the default log prefix path of log/s3/<bucket name>/ | string | `` | no |
| logical_name |  | string | - | yes |
| org |  | string | - | yes |
| owner |  | string | - | yes |
| region |  | string | - | yes |
| versioning_enabled |  | string | `true` | no |
| versioning_mfa_delete |  | string | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| s3.arn |  |
| s3.bucket_domain_name |  |
| s3.id |  |

