// Instantiate a minimal version of the module for testing
provider "aws" {
  region = "us-east-1"
}

resource "random_id" "testing_suffix" {
  byte_length = 4
}

//Create a logging bucket specifically for this test to support shipping of the access logs produced by the it_minimal bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket        = "qm-test-log-${random_id.testing_suffix.hex}"
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
}

data "aws_caller_identity" "current" {}

locals {
  logical_name_custom_policy = "${var.logical_name}-custom-policy-${random_id.testing_suffix.hex}"
}

data "template_file" "my_custom_bucket_policy" {
  template = "${file("${path.module}/custom_bucket_policy.json")}"

  vars = {
    aws_s3_bucket_arn  = "arn:aws:s3:::${var.org}-${var.env}-${local.logical_name_custom_policy}"
    current_account_id = "${data.aws_caller_identity.current.account_id}"
  }
}

module "it_minimal_custom_policy" {
  source = "../../../" //minimal integration test

  logical_name = "${local.logical_name_custom_policy}"
  region       = "${var.region}"

  policy = "${data.template_file.my_custom_bucket_policy.rendered}"

  logging_target_bucket = "${aws_s3_bucket.log_bucket.id}"

  org   = "${var.org}"
  owner = "${var.owner}"
  env   = "${var.env}"
  app   = "${var.app}"

  kms_master_key_id = "${aws_kms_alias.test.target_key_id}"
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
  description = "Key for testing tf_s3_bucket infra and secure-by-default policy"
}

resource "aws_kms_alias" "test" {
  name          = "alias/${var.logical_name}-${random_id.testing_suffix.hex}"
  target_key_id = "${aws_kms_key.test.key_id}"
}

resource "aws_s3_bucket_object" "test" {
  bucket = "${module.it_minimal.s3.id}"
  key    = "an/object/key"

  content_type = "application/json"
  content      = "{message: 'hello world'}"
  depends_on   = ["null_resource.delay"]

  kms_key_id = "${aws_kms_alias.test.target_key_arn}"
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

output "module_under_test.bucket.id" {
  value = "${module.it_minimal.s3.id}"
}

output "kms_key.test.key_id" {
  value = "${aws_kms_key.test.key_id}"
}

output "module_under_test.bucket.custom_policy" {
  value = "${data.template_file.my_custom_bucket_policy.rendered}"
}
