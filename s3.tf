locals {
  bucket_name = "${var.org}-${var.env}-${var.logical_name}"
  bucket_arn  = "arn:aws:s3:::${local.bucket_name}"

  standard_tags = {
    Owner       = "${var.owner}"
    Name        = "${local.bucket_name}"
    Environment = "${var.env}"
    Application = "${var.app}"
    ManagedBy   = "Terraform"
  }

  opt_role = {
    exists = {
      Role = "${var.role}"
    }

    does_not_exist = {}
  }

  opt_business_unit = {
    exists = {
      BusinessUnit = "${var.business_unit}"
    }

    does_not_exist = {}
  }

  opt_business_process = {
    exists = {
      BusinessProcess = "${var.business_process}"
    }

    does_not_exist = {}
  }

  opt_cost_center = {
    exists = {
      CostCenter = "${var.cost_center}"
    }

    does_not_exist = {}
  }

  opt_compliance_scheme = {
    exists = {
      ComplianceScheme = "${var.compliance_scheme}"
    }

    does_not_exist = {}
  }

  opt_confidentiality = {
    exists = {
      Confidentiality = "${var.confidentiality}"
    }

    does_not_exist = {}
  }

  opt_integrity = {
    exists = {
      Integrity = "${var.integrity}"
    }

    does_not_exist = {}
  }

  opt_availability = {
    exists = {
      Availability = "${var.availability}"
    }

    does_not_exist = {}
  }

  tags = "${merge(local.standard_tags
  , local.opt_role[var.role != "" ? "exists" : "does_not_exist"]
  , local.opt_cost_center[var.cost_center != "" ? "exists" : "does_not_exist"]
  , local.opt_business_unit[var.business_unit != "" ? "exists" : "does_not_exist"]
  , local.opt_business_process[var.business_process != "" ? "exists" : "does_not_exist"]
  , local.opt_compliance_scheme[var.compliance_scheme != "" ? "exists" : "does_not_exist"]
  , local.opt_confidentiality[var.confidentiality != "" ? "exists" : "does_not_exist"]
  , local.opt_integrity[var.integrity != "" ? "exists" : "does_not_exist"]
  , local.opt_availability[var.availability != "" ? "exists" : "does_not_exist"]
  , var.additional_tags)}"
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
    target_prefix = "${length(var.logging_target_prefix) == 0 ? "log/s3/${local.bucket_name}/" : var.logging_target_prefix}"
  }

  force_destroy = "${var.force_destroy}"

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

  s3_bucket_arn = "${aws_s3_bucket.bucket.arn}"

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

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = "${aws_s3_bucket.bucket.id}"

  block_public_acls       = "${var.block_public_acls}"
  block_public_policy     = "${var.block_public_policy}"
  ignore_public_acls      = "${var.ignore_public_acls}"
  restrict_public_buckets = "${var.restrict_public_buckets}"

  depends_on = ["aws_s3_bucket_policy.bucket"]
}
