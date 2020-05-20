locals {
  # future work: retrieve action mappings from k9 api
  actions_administer_resource = ["s3:*"]
  actions_use_resource        = []
  actions_read_data           = ["s3:GetObject*", "s3:List*"]
  actions_write_data          = "${compact(split("\n", file("${path.module}/k9-access_capability.write-data.tsv")))}"
  actions_delete_data         = "${compact(split("\n", file("${path.module}/k9-access_capability.delete-data.tsv")))}"
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid = "AllowRestrictedAdministerResource"

    actions = "${local.actions_administer_resource}"
    resources = [
      "${var.s3_bucket_arn}",
    ]
    principals {
      type        = "AWS"
      identifiers = ["${var.allow_administer_resource}"]
    }
  }

  statement {
    sid = "AllowRestrictedReadData"

    actions = "${local.actions_read_data}"
    resources = [
      "${var.s3_bucket_arn}",
      "${var.s3_bucket_arn}/*",
    ]
    principals {
      type        = "AWS"
      identifiers = ["${var.allow_read_data}"]
    }
  }

  statement {
    sid = "AllowRestrictedWriteData"

    actions = "${local.actions_write_data}"
    resources = [
      "${var.s3_bucket_arn}/*",
    ]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "ArnEquals"
      values   = ["${var.allow_write_data}"]
      variable = "aws:PrincipalArn"
    }

  }

  statement {
    sid = "AllowRestrictedDeleteData"

    actions = "${local.actions_delete_data}"
    resources = [
      "${var.s3_bucket_arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "ArnEquals"
      values   = ["${var.allow_delete_data}"]
      variable = "aws:PrincipalArn"
    }
  }

}
