variable "s3_bucket_arn" {
  type        = "string"
  description = "The ARN of the bucket this policy protects, e.g. arn:aws:s3:::some-bucket-name"
}

variable "allow_administer_resource_arns" {
  type        = "list"
  default     = []
  description = "The list of fully-qualified AWS IAM ARNs authorized to administer this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-*"
}

variable "allow_administer_resource_test" {
  type        = "string"
  default     = "ArnEquals"
  description = "The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike'"
}

variable "allow_read_data_arns" {
  type        = "list"
  default     = []
  description = "The list of fully-qualified AWS IAM ARNs authorized to read data in this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-*"
}

variable "allow_read_data_test" {
  type        = "string"
  default     = "ArnEquals"
  description = "The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike'"
}

variable "allow_write_data_arns" {
  type        = "list"
  default     = []
  description = "The list of fully-qualified AWS IAM ARNs authorized to write data in this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-*"
}

variable "allow_write_data_test" {
  type        = "string"
  default     = "ArnEquals"
  description = "The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike'"
}

variable "allow_delete_data_arns" {
  type        = "list"
  default     = []
  description = "The list of fully-qualified AWS IAM ARNs authorized to delete data in this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-*"
}

variable "allow_delete_data_test" {
  type        = "string"
  default     = "ArnEquals"
  description = "The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike'"
}

output "policy_json" {
  value = "${data.aws_iam_policy_document.bucket_policy.json}"
}
