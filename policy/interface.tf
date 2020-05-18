variable "s3_bucket_arn" {
  type = "string"
}
variable "allowed_aws_principal_arns" {
  type = "list"
}

output "policy_json" {
  value = "${data.template_file.least_privilege.rendered}"
}