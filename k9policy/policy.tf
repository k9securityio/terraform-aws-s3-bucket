locals {
  # future work: retrieve action mappings from k9 api
  actions_administer_resource = ["s3:*"]
  actions_use_resource = []
  actions_read_data = ["s3:GetObject*", "s3:List*"]
  actions_write_data = ["s3:PutObject*"]
  actions_delete_data = ["s3:DeleteObject*"]
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid = "AllowRestrictedAdministerResource"

    actions = "${local.actions_administer_resource}"
    resources = [
      "${var.s3_bucket_arn}",
    ]
    principals {
      type = "AWS"
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
      type = "AWS"
      identifiers = ["${var.allow_read_data}"]
    }
  }

  statement {
    sid = "AllowRestrictedWriteData"

    actions = "${local.actions_write_data}"
    resources = [
      "${var.s3_bucket_arn}",
      "${var.s3_bucket_arn}/*",
    ]
    principals {
      type = "AWS"
      identifiers = ["${var.allow_write_data}"]
    }
  }

}
