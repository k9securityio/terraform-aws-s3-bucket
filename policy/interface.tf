variable "s3_bucket_arn" {
  type = "string"
}
variable "allowed_aws_principal_arns" {
  type = "list"
}

variable "allowed_api_actions" {
  type    = "list"
  default = ["s3:*"]
}

output "policy_json" {
  value = "${data.template_file.least_privilege.rendered}"
}