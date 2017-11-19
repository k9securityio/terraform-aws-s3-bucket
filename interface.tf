variable "logical_name" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "org" {
  type = "string"
}

variable "owner" {
  type = "string"
}

variable "env" {
  type = "string"
}

variable "app" {
  type = "string"
}

variable "acl" {
  type    = "string"
  default = "private"
}

variable "versioning_enabled" {
  type    = "string"
  default = "true"
}

variable "versioning_mfa_delete" {
  type    = "string"
  default = "false"
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

output "s3.id" {
  value = "${aws_s3_bucket.bucket.id}"
}

output "s3.arn" {
  value = "${aws_s3_bucket.bucket.arn}"
}

output "s3.bucket_domain_name" {
  value = "${aws_s3_bucket.bucket.bucket_domain_name}"
}
