variable "s3_bucket_arn" {
  type = "string"
}

variable "allow_administer_resource" {
  type    = "list"
  default = []
}

variable "allow_administer_resource_test" {
  type    = "string"
  default = "ArnEquals"
}

variable "allow_use_resource" {
  type    = "list"
  default = []
}

variable "allow_use_resource_test" {
  type    = "string"
  default = "ArnEquals"
}

variable "allow_read_data" {
  type    = "list"
  default = []
}

variable "allow_read_test" {
  type    = "string"
  default = "ArnEquals"
}

variable "allow_write_data" {
  type    = "list"
  default = []
}

variable "allow_write_test" {
  type    = "string"
  default = "ArnEquals"
}

variable "allow_delete_data" {
  type    = "list"
  default = []
}

variable "allow_delete_test" {
  type    = "string"
  default = "ArnEquals"
}

output "policy_json" {
  value = "${data.aws_iam_policy_document.bucket_policy.json}"
}