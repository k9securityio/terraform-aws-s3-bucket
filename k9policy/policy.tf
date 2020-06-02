locals {
  # future work: retrieve action mappings from k9 api
  actions_administer_resource_all    = ["s3:*"]
  actions_administer_resource_bucket = "${sort(distinct(compact(split("\n", file("${path.module}/k9-access_capability.administer-resource.bucket.tsv")))))}"
  actions_use_resource               = []
  actions_read_data                  = "${sort(distinct(compact(split("\n", file("${path.module}/k9-access_capability.read-data.tsv")))))}"
  actions_write_data                 = "${sort(distinct(compact(split("\n", file("${path.module}/k9-access_capability.write-data.tsv")))))}"
  actions_delete_data                = "${sort(distinct(compact(split("\n", file("${path.module}/k9-access_capability.delete-data.tsv")))))}"
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid = "AllowRestrictedAdministerResource"

    actions = "${local.actions_administer_resource_bucket}"

    resources = [
      "${var.s3_bucket_arn}",
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "${var.allow_administer_resource_test}"
      values   = ["${var.allow_administer_resource_arns}"]
      variable = "aws:PrincipalArn"
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
      identifiers = ["*"]
    }

    condition {
      test     = "${var.allow_read_data_test}"
      values   = ["${var.allow_read_data_arns}"]
      variable = "aws:PrincipalArn"
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
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "${var.allow_write_data_test}"
      values   = ["${var.allow_write_data_arns}"]
      variable = "aws:PrincipalArn"
    }
  }

  statement {
    sid = "AllowRestrictedDeleteData"

    actions = "${local.actions_delete_data}"

    resources = [
      "${var.s3_bucket_arn}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "${var.allow_delete_data_test}"
      values   = ["${var.allow_delete_data_arns}"]
      variable = "aws:PrincipalArn"
    }
  }

  statement {
    sid = "DenyEveryoneElse"

    effect = "Deny"

    actions = ["s3:*"]

    resources = [
      "${var.s3_bucket_arn}",
      "${var.s3_bucket_arn}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "ArnNotEquals"
      values   = ["${distinct(concat(var.allow_administer_resource_arns, var.allow_read_data_arns, var.allow_write_data_arns, var.allow_delete_data_arns))}"]
      variable = "aws:PrincipalArn"
    }
  }
}
