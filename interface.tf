variable "logical_name" {
  type        = "string"
  description = "Specify the 'logical' name of the bucket appropriate for the bucket's primary use case, e.g. media or orders"
}

variable "region" {
  type        = "string"
  description = "The region to instantiate the bucket in"
}

variable "policy" {
  description = "(optional) fully rendered policy; if unspecified, the secure-by-default.json policy will be rendered and used"
  type        = "string"
  default     = ""
}

variable "org" {
  type        = "string"
  description = "Short id of the organization that owns the bucket"
}

variable "owner" {
  type        = "string"
  description = "Name of the team or department that responsible for the bucket"
}

variable "env" {
  type        = "string"
  description = "Name of the environment the bucket supports"
}

variable "app" {
  type        = "string"
  description = "Name of the application the bucket supports"
}

variable "acl" {
  type        = "string"
  description = "(Optional) ACL to use for the bucket; defaults to 'private'"
  default     = "private"
}

variable "versioning_enabled" {
  type        = "string"
  description = "Enable versioning on the bucket; defaults to 'true'"
  default     = "true"
}

variable "versioning_mfa_delete" {
  type        = "string"
  description = "Require confirmation of deletes via multi-factor auth; defaults to 'false'"
  default     = "false"
}

variable "kms_master_key_id" {
  type        = "string"
  description = "(Optional) ARN of KMS key to encrypt objects with.  Empty string means use the default master key."
  default     = ""
}

variable "logging_target_bucket" {
  type        = "string"
  description = "Bucket to use for request access logging"
}

variable "logging_target_prefix" {
  type        = "string"
  description = "(Optional) Override the default log prefix path of log/s3/<bucket name>/"
  default     = ""
}

variable "block_public_acls" {
  type    = "string"
  default = "true"
}

variable "block_public_policy" {
  type    = "string"
  default = "true"
}

output "s3.id" {
  value = "${aws_s3_bucket.bucket.id}"
}

output "s3.arn" {
  value = "${aws_s3_bucket.bucket.arn}"
}

output "s3.bucket_domain_name" {
  value = "${aws_s3_bucket.bucket.bucket_domain_name}"
}
