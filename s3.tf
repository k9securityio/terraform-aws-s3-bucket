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
        sse_algorithm = "aws:kms"
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
