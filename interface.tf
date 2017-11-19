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

variable "versioning_enabled" {
  type    = "string"
  default = "true"
}

variable "versioning_mfa_delete" {
  type    = "string"
  default = "false"
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
