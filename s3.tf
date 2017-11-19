resource "aws_s3_bucket" "bucket" {
  bucket = "${var.org}-${var.env}-${var.logical_name}"

  region = "${var.region}"

  versioning {
    enabled    = "${var.versioning_enabled}"
    mfa_delete = "${var.versioning_mfa_delete}"
  }

  force_destroy = true

  tags {
    Owner       = "${var.owner}"
    Environment = "${var.env}"
    Application = "${var.app}"
    ManagedBy   = "Terraform"
  }
}
