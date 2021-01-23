variable "logical_name" {
  type        = string
  description = "Specify the 'logical' name of the bucket appropriate for the bucket's primary use case, e.g. media or orders"
}

variable "policy" {
  description = "(optional) fully rendered policy; if unspecified, the policy will be generated from the `allow_*` variables"
  type        = string
  default     = ""
}

variable "org" {
  type        = string
  description = "Short id of the organization that owns the bucket"
}

variable "owner" {
  type        = string
  description = "Name of the team or department that responsible for the bucket"
}

variable "env" {
  type        = string
  description = "Name of the environment the bucket supports"
}

variable "app" {
  type        = string
  description = "Name of the application the bucket supports"
}

variable "role" {
  type        = string
  description = "The role or function of this resource within the Application's logical architecture, e.g. load balancer, app server, database"
  default     = ""
}

variable "business_unit" {
  type        = string
  description = "The top-level organizational division that owns the resource. e.g. Consumer Retail, Enterprise Solutions, Manufacturing"
  default     = ""
}

variable "business_process" {
  type        = string
  description = "The high-level business process the bucket supports"
  default     = ""
}

variable "cost_center" {
  type        = string
  description = "The managerial accounting cost center for the bucket"
  default     = ""
}

variable "compliance_scheme" {
  type        = string
  description = "The regulatory compliance scheme the resource’s configuration should conform to"
  default     = ""
}

variable "confidentiality" {
  type        = string
  description = "Expected Confidentiality level of data in the bucket, e.g. Public, Internal, Confidential, Restricted"
  default     = ""
}

variable "integrity" {
  type        = string
  description = "Expected Integrity level of data in the bucket, e.g. 0.999, 0.9999, 0.99999, 0.999999"
  default     = ""
}

variable "availability" {
  type        = string
  description = "Expected Availability level of data in the bucket, e.g. 0.999, 0.9999, 0.99999, 0.999999"
  default     = ""
}

variable "acl" {
  type        = string
  description = "ACL to use for the bucket; defaults to 'private'"
  default     = "private"
}

variable "versioning_enabled" {
  type        = string
  description = "Enable versioning on the bucket; defaults to 'true'"
  default     = "true"
}

variable "versioning_mfa_delete" {
  type        = string
  description = "Require confirmation of deletes via multi-factor auth; defaults to 'false'"
  default     = "false"
}

variable "force_destroy" {
  type        = string
  description = "Force destruction of the bucket and all objects in it; defaults to 'false'"
  default     = "false"
}

variable "kms_master_key_id" {
  type        = string
  description = "(Optional) ARN of KMS key to encrypt objects with.  Empty string means use the default master key."
  default     = ""
}

variable "logging_target_bucket" {
  type        = string
  description = "Bucket to use for request access logging"
}

variable "logging_target_prefix" {
  type        = string
  description = "(Optional) Override the default log prefix path of log/s3/<bucket name>/"
  default     = ""
}

variable "block_public_acls" {
  type    = string
  default = "true"
}

variable "block_public_policy" {
  type    = string
  default = "true"
}

variable "ignore_public_acls" {
  type    = string
  default = "true"
}

variable "restrict_public_buckets" {
  type    = string
  default = "true"
}

variable "allow_administer_resource_arns" {
  type        = list(string)
  default     = []
  description = "The list of fully-qualified AWS IAM ARNs authorized to administer this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-*"
}

variable "allow_administer_resource_test" {
  type        = string
  default     = "ArnEquals"
  description = "The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike'"
}

variable "allow_read_config_arns" {
  type        = list(string)
  default     = []
  description = "The list of fully-qualified AWS IAM ARNs authorized to read configuration of this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-*"
}

variable "allow_read_config_test" {
  type        = string
  default     = "ArnEquals"
  description = "The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike'"
}

variable "allow_read_data_arns" {
  type        = list(string)
  default     = []
  description = "The list of fully-qualified AWS IAM ARNs authorized to read data in this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-*"
}

variable "allow_read_data_test" {
  type        = string
  default     = "ArnEquals"
  description = "The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike'"
}

variable "allow_write_data_arns" {
  type        = list(string)
  default     = []
  description = "The list of fully-qualified AWS IAM ARNs authorized to write data in this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-*"
}

variable "allow_write_data_test" {
  type        = string
  default     = "ArnEquals"
  description = "The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike'"
}

variable "allow_delete_data_arns" {
  type        = list(string)
  default     = []
  description = "The list of fully-qualified AWS IAM ARNs authorized to delete data in this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-*"
}

variable "allow_delete_data_test" {
  type        = string
  default     = "ArnEquals"
  description = "The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike'"
}

variable "additional_tags" {
  type        = map(string)
  default     = {}
  description = "A map of additional tags to merge with the module's standard tags and apply to the bucket."
}

output "bucket_id" {
  value = aws_s3_bucket.bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.bucket.arn
}

output "bucket_domain_name" {
  value = aws_s3_bucket.bucket.bucket_domain_name
}

output "policy_json" {
  value = aws_s3_bucket_policy.bucket.policy
}

