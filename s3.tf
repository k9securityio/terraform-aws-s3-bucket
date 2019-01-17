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

data "aws_caller_identity" "current" {}

output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_policy" "bucket" {
  bucket = "${aws_s3_bucket.bucket.id}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DenyUnSecureCommunications",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "${aws_s3_bucket.bucket.arn}"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        },
        {
            "Sid": "DenyIncorrectEncryptionHeader",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": [
                "${aws_s3_bucket.bucket.arn}/*"
            ],
            "Condition": {
                "StringNotEquals": {
                    "s3:x-amz-server-side-encryption": "AES256"
                }
            }
        },
        {
            "Sid": "DenyUnEncryptedObjectUploads",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": [
                "${aws_s3_bucket.bucket.arn}/*"
            ],
            "Condition": {
                "Null": {
                    "s3:x-amz-server-side-encryption": "true"
                }
            }
        },
        {
            "Sid": "PermitOnlyRolesWithinAccount",
            "Effect": "Allow",
            "Principal": {
                "AWS": "<account-id>"
            },
            "Action": "*",
            "Resource": [
                "${aws_s3_bucket.bucket.arn}"
            ],
        }
    ]
}
POLICY
}
