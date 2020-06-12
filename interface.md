
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| acl | (Optional) ACL to use for the bucket; defaults to 'private' | string | `private` | no |
| additional_tags | A map of additional tags to merge with the module's standard tags and apply to the bucket. | map | `<map>` | no |
| allow_administer_resource_arns | The list of fully-qualified AWS IAM ARNs authorized to administer this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-* | list | `<list>` | no |
| allow_administer_resource_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | string | `ArnEquals` | no |
| allow_delete_data_arns | The list of fully-qualified AWS IAM ARNs authorized to delete data in this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-* | list | `<list>` | no |
| allow_delete_data_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | string | `ArnEquals` | no |
| allow_read_data_arns | The list of fully-qualified AWS IAM ARNs authorized to read data in this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-* | list | `<list>` | no |
| allow_read_data_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | string | `ArnEquals` | no |
| allow_write_data_arns | The list of fully-qualified AWS IAM ARNs authorized to write data in this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-* | list | `<list>` | no |
| allow_write_data_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | string | `ArnEquals` | no |
| app | Name of the application the bucket supports | string | - | yes |
| block_public_acls |  | string | `true` | no |
| block_public_policy |  | string | `true` | no |
| env | Name of the environment the bucket supports | string | - | yes |
| force_destroy | Force destruction of the bucket and all objects in it; defaults to 'false' | string | `false` | no |
| ignore_public_acls |  | string | `true` | no |
| kms_master_key_id | (Optional) ARN of KMS key to encrypt objects with.  Empty string means use the default master key. | string | `` | no |
| logging_target_bucket | Bucket to use for request access logging | string | - | yes |
| logging_target_prefix | (Optional) Override the default log prefix path of log/s3/<bucket name>/ | string | `` | no |
| logical_name | Specify the 'logical' name of the bucket appropriate for the bucket's primary use case, e.g. media or orders | string | - | yes |
| org | Short id of the organization that owns the bucket | string | - | yes |
| owner | Name of the team or department that responsible for the bucket | string | - | yes |
| policy | (optional) fully rendered policy; if unspecified, the policy will be generated from the `allow_*` variables | string | `` | no |
| region | The region to instantiate the bucket in | string | - | yes |
| restrict_public_buckets |  | string | `true` | no |
| versioning_enabled | Enable versioning on the bucket; defaults to 'true' | string | `true` | no |
| versioning_mfa_delete | Require confirmation of deletes via multi-factor auth; defaults to 'false' | string | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_arn |  |
| bucket_domain_name |  |
| bucket_id |  |
| policy_json |  |

