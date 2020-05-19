data "template_file" "least_privilege" {
  template = "${file("${path.module}/least-privilege.low-level.json.tpl")}"

  vars = {
    aws_s3_bucket_arn           = "${var.s3_bucket_arn}"
    allowed_aws_principals_json = "${jsonencode(var.allowed_aws_principal_arns)}"
    allowed_api_actions_json    = "${jsonencode(var.allowed_api_actions)}"
  }
}
