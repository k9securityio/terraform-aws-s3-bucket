## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allow\_administer\_resource\_arns | The list of fully-qualified AWS IAM ARNs authorized to administer this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-\* | `list(string)` | `[]` | no |
| allow\_administer\_resource\_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | `string` | `"ArnEquals"` | no |
| allow\_custom\_actions | A custom list of S3 API actions to authorize ARNs listed in `allow_custom_actions_arns` to execute against this bucket. | `list(string)` | <pre>[<br>  "s3:GetAnalyticsConfiguration"<br>]</pre> | no |
| allow\_custom\_actions\_arns | The list of fully-qualified AWS IAM ARNs authorized to execute the custom actions against this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-\* | `list(string)` | `[]` | no |
| allow\_custom\_arns\_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | `string` | `"ArnEquals"` | no |
| allow\_delete\_data\_arns | The list of fully-qualified AWS IAM ARNs authorized to delete data in this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-\* | `list(string)` | `[]` | no |
| allow\_delete\_data\_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | `string` | `"ArnEquals"` | no |
| allow\_read\_config\_arns | The list of fully-qualified AWS IAM ARNs authorized to read configuration of this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-\* | `list(string)` | `[]` | no |
| allow\_read\_config\_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | `string` | `"ArnEquals"` | no |
| allow\_read\_data\_arns | The list of fully-qualified AWS IAM ARNs authorized to read data in this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-\* | `list(string)` | `[]` | no |
| allow\_read\_data\_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | `string` | `"ArnEquals"` | no |
| allow\_write\_data\_arns | The list of fully-qualified AWS IAM ARNs authorized to write data in this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-\* | `list(string)` | `[]` | no |
| allow\_write\_data\_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | `string` | `"ArnEquals"` | no |
| s3\_bucket\_arn | The ARN of the bucket this policy protects, e.g. arn:aws:s3:::some-bucket-name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| policy\_json | n/a |

