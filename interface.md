## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| null | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| acl | ACL to use for the bucket; defaults to 'private' | `string` | `"private"` | no |
| additional\_tags | A map of additional tags to merge with the module's standard tags and apply to the bucket. | `map(string)` | `{}` | no |
| allow\_administer\_resource\_arns | The list of fully-qualified AWS IAM ARNs authorized to administer this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-\* | `list(string)` | `[]` | no |
| allow\_administer\_resource\_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | `string` | `"ArnEquals"` | no |
| allow\_delete\_data\_arns | The list of fully-qualified AWS IAM ARNs authorized to delete data in this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-\* | `list(string)` | `[]` | no |
| allow\_delete\_data\_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | `string` | `"ArnEquals"` | no |
| allow\_read\_data\_arns | The list of fully-qualified AWS IAM ARNs authorized to read data in this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-\* | `list(string)` | `[]` | no |
| allow\_read\_data\_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | `string` | `"ArnEquals"` | no |
| allow\_write\_data\_arns | The list of fully-qualified AWS IAM ARNs authorized to write data in this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-\* | `list(string)` | `[]` | no |
| allow\_write\_data\_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | `string` | `"ArnEquals"` | no |
| app | Name of the application the bucket supports | `string` | n/a | yes |
| availability | Expected Availability level of data in the bucket, e.g. 0.999, 0.9999, 0.99999, 0.999999 | `string` | `""` | no |
| block\_public\_acls | n/a | `string` | `"true"` | no |
| block\_public\_policy | n/a | `string` | `"true"` | no |
| business\_process | The high-level business process the bucket supports | `string` | `""` | no |
| business\_unit | The top-level organizational division that owns the resource. e.g. Consumer Retail, Enterprise Solutions, Manufacturing | `string` | `""` | no |
| compliance\_scheme | The regulatory compliance scheme the resource’s configuration should conform to | `string` | `""` | no |
| confidentiality | Expected Confidentiality level of data in the bucket, e.g. Public, Internal, Confidential, Restricted | `string` | `""` | no |
| cost\_center | The managerial accounting cost center for the bucket | `string` | `""` | no |
| env | Name of the environment the bucket supports | `string` | n/a | yes |
| force\_destroy | Force destruction of the bucket and all objects in it; defaults to 'false' | `string` | `"false"` | no |
| ignore\_public\_acls | n/a | `string` | `"true"` | no |
| integrity | Expected Integrity level of data in the bucket, e.g. 0.999, 0.9999, 0.99999, 0.999999 | `string` | `""` | no |
| kms\_master\_key\_id | (Optional) ARN of KMS key to encrypt objects with.  Empty string means use the default master key. | `string` | `""` | no |
| logging\_target\_bucket | Bucket to use for request access logging | `string` | n/a | yes |
| logging\_target\_prefix | (Optional) Override the default log prefix path of log/s3/<bucket name>/ | `string` | `""` | no |
| logical\_name | Specify the 'logical' name of the bucket appropriate for the bucket's primary use case, e.g. media or orders | `string` | n/a | yes |
| org | Short id of the organization that owns the bucket | `string` | n/a | yes |
| owner | Name of the team or department that responsible for the bucket | `string` | n/a | yes |
| policy | (optional) fully rendered policy; if unspecified, the policy will be generated from the `allow_*` variables | `string` | `""` | no |
| restrict\_public\_buckets | n/a | `string` | `"true"` | no |
| role | The role or function of this resource within the Application's logical architecture, e.g. load balancer, app server, database | `string` | `""` | no |
| versioning\_enabled | Enable versioning on the bucket; defaults to 'true' | `string` | `"true"` | no |
| versioning\_mfa\_delete | Require confirmation of deletes via multi-factor auth; defaults to 'false' | `string` | `"false"` | no |

## Outputs

| Name | Description |
|------|-------------|
| account\_id | n/a |
| bucket\_arn | n/a |
| bucket\_domain\_name | n/a |
| bucket\_id | n/a |
| policy\_json | n/a |

