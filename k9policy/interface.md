
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allow_administer_resource_arns | The list of fully-qualified AWS IAM ARNs authorized to administer this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-* | list | `<list>` | no |
| allow_administer_resource_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | string | `ArnEquals` | no |
| allow_custom_actions | A custom list of S3 API actions to authorize ARNs listed in `allow_custom_actions_arns` to execute against this bucket. | list | `<list>` | no |
| allow_custom_actions_arns | The list of fully-qualified AWS IAM ARNs authorized to execute the custom actions against this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-* | list | `<list>` | no |
| allow_custom_arns_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | string | `ArnEquals` | no |
| allow_delete_data_arns | The list of fully-qualified AWS IAM ARNs authorized to delete data in this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-* | list | `<list>` | no |
| allow_delete_data_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | string | `ArnEquals` | no |
| allow_read_data_arns | The list of fully-qualified AWS IAM ARNs authorized to read data in this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-* | list | `<list>` | no |
| allow_read_data_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | string | `ArnEquals` | no |
| allow_write_data_arns | The list of fully-qualified AWS IAM ARNs authorized to write data in this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-* | list | `<list>` | no |
| allow_write_data_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | string | `ArnEquals` | no |
| s3_bucket_arn | The ARN of the bucket this policy protects, e.g. arn:aws:s3:::some-bucket-name | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| policy_json |  |

