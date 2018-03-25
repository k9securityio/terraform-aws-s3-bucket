
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| acl | (Optional) ACL to use for the bucket; defaults to 'private' | string | `private` | no |
| app | Name of the application the bucket supports | string | - | yes |
| env | Name of the environment the bucket supports | string | - | yes |
| kms_master_key_id | (Optional) KMS Customer Master Key id to encrypt objects with.  Empty string means use the default master key. | string | `` | no |
| logging_target_bucket | Bucket to use for request access logging | string | - | yes |
| logging_target_prefix | (Optional) Override the default log prefix path of log/s3/<bucket name>/ | string | `` | no |
| logical_name | Specify the 'logical' name of the bucket appropriate for the bucket's primary use case, e.g. media or orders | string | - | yes |
| org | Short id of the organization that owns the bucket | string | - | yes |
| owner | Name of the team or department that responsible for the bucket | string | - | yes |
| region | The region to instantiate the bucket in | string | - | yes |
| versioning_enabled | Enable versioning on the bucket; defaults to 'true' | string | `true` | no |
| versioning_mfa_delete | Require confirmation of deletes via multi-factor auth; defaults to 'false' | string | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| s3.arn |  |
| s3.bucket_domain_name |  |
| s3.id |  |

