resource "aws_s3_bucket" "bucket" {
  bucket = "${var.org}-${var.env}-${var.logical_name}"

  region = "${var.region}"

  acl = "${var.acl}"

  versioning {
    enabled    = "${var.versioning_enabled}"
    mfa_delete = "${var.versioning_mfa_delete}"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = "${var.kms_master_key_id}"
      }
    }
  }

  logging {
    target_bucket = "${var.logging_target_bucket}"
    target_prefix = "${length(var.logging_target_prefix) == 0 ? "log/s3/${var.org}-${var.env}-${var.logical_name}/" : var.logging_target_prefix }"
  }

  force_destroy = true

  tags {
    Owner       = "${var.owner}"
    Environment = "${var.env}"
    Application = "${var.app}"
    ManagedBy   = "Terraform"
  }
}

locals {
  use_custom_policy = "${length(var.policy) > 0}"

  policy = "${local.use_custom_policy ? var.policy : data.template_file.default_access_policy.rendered}"
}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

data "template_file" "default_access_policy" {
  template = "${file("${path.module}/secure-by-default.json")}"

  vars = {
    aws_s3_bucket_arn  = "${aws_s3_bucket.bucket.arn}"
    current_account_id = "${data.aws_caller_identity.current.account_id}"
  }
}

resource "aws_s3_bucket_policy" "bucket" {
  bucket = "${aws_s3_bucket.bucket.id}"

  policy = "${local.policy}"
}
