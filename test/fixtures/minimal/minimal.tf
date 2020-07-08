// Instantiate a minimal version of the module for testing
provider "aws" {
  region = "us-east-1"
}

resource "random_id" "testing_suffix" {
  byte_length = 4
}

//Create a logging bucket specifically for this test to support shipping of the access logs produced by the it_minimal bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket        = "k9-testenv-log-${random_id.testing_suffix.hex}"
  acl           = "log-delivery-write"
  force_destroy = "true"
}

module "it_minimal" {
  source = "../../../" //minimal integration test

  logical_name = "${var.logical_name}-${random_id.testing_suffix.hex}"
  region       = "${var.region}"

  logging_target_bucket = "${aws_s3_bucket.log_bucket.id}"

  org   = "${var.org}"
  owner = "${var.owner}"
  env   = "${var.env}"
  app   = "${var.app}"

  kms_master_key_id = "${aws_kms_alias.test.target_key_id}"

  allow_administer_resource_arns = "${local.administrator_arns}"
  allow_read_data_arns           = "${local.read_data_arns}"
  allow_write_data_arns          = "${local.write_data_arns}"

  # unused: allow_delete_data_arns          = [] (default)
}

data "aws_caller_identity" "current" {}

locals {
  logical_name_custom_policy      = "${var.logical_name}-custom-policy-${random_id.testing_suffix.hex}"
  logical_name_declarative_policy = "${var.logical_name}-declarative-policy-${random_id.testing_suffix.hex}"
}

data "template_file" "custom_bucket_policy" {
  template = "${file("${path.module}/custom_bucket_policy.json")}"

  vars = {
    aws_s3_bucket_arn  = "arn:aws:s3:::${var.org}-${var.env}-${local.logical_name_custom_policy}"
    current_account_id = "${data.aws_caller_identity.current.account_id}"
  }
}

module "custom_bucket" {
  source = "../../../" //minimal integration test

  logical_name = "${local.logical_name_custom_policy}"
  region       = "${var.region}"

  policy = "${data.template_file.custom_bucket_policy.rendered}"

  logging_target_bucket = "${aws_s3_bucket.log_bucket.id}"

  org   = "${var.org}"
  owner = "${var.owner}"
  env   = "${var.env}"
  app   = "${var.app}"

  kms_master_key_id = "${aws_kms_alias.test.target_key_id}"

  additional_tags = {
    Confidentiality = "Internal"
    Integrity       = "0.9999"
    Availability    = "0.999"
  }
}

resource "null_resource" "before" {}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 60"
  }

  triggers = {
    "before" = "${null_resource.before.id}"
  }
}

resource "aws_kms_key" "test" {
  description = "Key for testing tf_s3_bucket infra and policy"
}

resource "aws_kms_alias" "test" {
  name          = "alias/${var.logical_name}-${random_id.testing_suffix.hex}"
  target_key_id = "${aws_kms_key.test.key_id}"
}

resource "aws_s3_bucket_object" "test" {
  bucket = "${module.it_minimal.bucket_id}"
  key    = "an/object/key"

  content_type = "application/json"
  content      = "{message: 'hello world'}"
  depends_on   = ["null_resource.delay"]

  kms_key_id = "${aws_kms_alias.test.target_key_arn}"
}

module "bucket_with_declarative_policy" {
  source = "../../../" //minimal integration test

  logical_name = "${local.logical_name_declarative_policy}"
  region       = "${var.region}"

  policy = "${module.declarative_privilege_policy.policy_json}"

  logging_target_bucket = "${aws_s3_bucket.log_bucket.id}"

  org   = "${var.org}"
  owner = "${var.owner}"
  env   = "${var.env}"
  app   = "${var.app}"

  kms_master_key_id = "${aws_kms_alias.test.target_key_id}"
}

locals {
  administrator_arns = [
    "arn:aws:iam::139710491120:user/ci",
    "arn:aws:iam::139710491120:user/skuenzli",
  ]

  read_data_arns = [
    "arn:aws:iam::139710491120:user/skuenzli",
    "arn:aws:iam::139710491120:user/ssutton",
  ]

  write_data_arns = "${local.read_data_arns}"

  delete_data_arns = ["arn:aws:iam::139710491120:user/skuenzli"]
}

module "declarative_privilege_policy" {
  source        = "../../../k9policy"
  s3_bucket_arn = "${module.bucket_with_declarative_policy.bucket_arn}"

  allow_administer_resource_arns = "${local.administrator_arns}"
  allow_read_data_arns           = "${local.read_data_arns}"
  allow_write_data_arns          = "${local.write_data_arns}"

  # unused: allow_delete_data_arns          = [] (default)
  # unused: allow_use_resource_arns         = [] (default)
}

resource "local_file" "declarative_privilege_policy" {
  content  = "${module.declarative_privilege_policy.policy_json}"
  filename = "${path.module}/generated/declarative_privilege_policy.json"
}

module "declarative_custom_policy" {
  source        = "../../../k9policy"
  s3_bucket_arn = "${module.bucket_with_declarative_policy.bucket_arn}"

  allow_administer_resource_arns = "${local.administrator_arns}"

  allow_custom_actions_arns      = ["arn:aws:iam::139710491120:user/skuenzli"]
}

resource "local_file" "declarative_custom_policy" {
  content  = "${module.declarative_privilege_policy.policy_json}"
  filename = "${path.module}/generated/declarative_custom_policy.json"
}

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

output "module_under_test-bucket-id" {
  value = "${module.it_minimal.bucket_id}"
}

output "module_under_test-custom_bucket-id" {
  value = "${module.custom_bucket.bucket_id}"
}

output "module_under_test-bucket_with_declarative_policy-id" {
  value = "${module.bucket_with_declarative_policy.bucket_id}"
}

output "module_under_test-custom_bucket-policy" {
  value = "${data.template_file.custom_bucket_policy.rendered}"
}

output "module_under_test-least_privilege_policy-policy_json" {
  value = "${data.template_file.custom_bucket_policy.rendered}"
}

output "module_under_test-declarative_privilege_policy-policy_json" {
  value = "${module.declarative_privilege_policy.policy_json}"
}

output "kms_key-test-key_id" {
  value = "${aws_kms_key.test.key_id}"
}
