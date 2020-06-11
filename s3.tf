locals {
  bucket_name = "${var.org}-${var.env}-${var.logical_name}"
  bucket_arn  = "arn:aws:s3:::${local.bucket_name}"

  standard_tags = {
    Owner       = "${var.owner}"
    Environment = "${var.env}"
    Application = "${var.app}"
    ManagedBy   = "Terraform"
  }

  tags = "${merge(local.standard_tags, var.additional_tags)}"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${local.bucket_name}"

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
    target_prefix = "${length(var.logging_target_prefix) == 0 ? "log/s3/${var.org}-${var.env}-${var.logical_name}/" : var.logging_target_prefix}"
  }

  force_destroy = true

  tags = "${local.tags}"
}

locals {
  use_custom_policy = "${length(var.policy) > 0}"

  policy = "${local.use_custom_policy ? var.policy : module.bucket_policy.policy_json}"
}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

module "bucket_policy" {
  source = "k9policy"

  s3_bucket_arn = "${local.bucket_arn}"

  allow_administer_resource_arns = "${var.allow_administer_resource_arns}"
  allow_administer_resource_test = "${var.allow_administer_resource_test}"

  allow_read_data_arns = "${var.allow_read_data_arns}"
  allow_read_data_test = "${var.allow_read_data_test}"

  allow_write_data_arns = "${var.allow_write_data_arns}"
  allow_write_data_test = "${var.allow_write_data_test}"

  allow_delete_data_arns = "${var.allow_delete_data_arns}"
  allow_delete_data_test = "${var.allow_delete_data_test}"
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 5"
  }

  depends_on = ["aws_s3_bucket.bucket"]
}

resource "aws_s3_bucket_policy" "bucket" {
  bucket = "${aws_s3_bucket.bucket.id}"

  policy = "${local.policy}"

  depends_on = ["null_resource.delay"]
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = "${aws_s3_bucket.bucket.id}"

  block_public_acls       = "${var.block_public_acls}"
  block_public_policy     = "${var.block_public_policy}"
  ignore_public_acls      = "${var.ignore_public_acls}"
  restrict_public_buckets = "${var.restrict_public_buckets}"

  depends_on = ["aws_s3_bucket_policy.bucket"]
}
