locals {
  # future work: retrieve action mappings from k9 api
  actions_administer_resource_all = ["s3:*"]
  actions_administer_resource_bucket = "${compact(split("\n", file("${path.module}/k9-access_capability.administer-resource.bucket.tsv")))}"
  # actions_administer_resource_object = "${compact(split("\n", file("${path.module}/k9-access_capability.administer-resource.object.tsv")))}"
  actions_use_resource        = []
  actions_read_data           = "${compact(split("\n", file("${path.module}/k9-access_capability.read-data.tsv")))}"
  actions_write_data          = "${compact(split("\n", file("${path.module}/k9-access_capability.write-data.tsv")))}"
  actions_delete_data         = "${compact(split("\n", file("${path.module}/k9-access_capability.delete-data.tsv")))}"
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid = "AllowRestrictedAdministerResource"

    actions = "${local.actions_administer_resource_all}"
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
      identifiers = ["*"]
    }
    condition {
      test     = "ArnEquals"
      values   = ["${var.allow_read_data}"]
      variable = "aws:PrincipalArn"
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

  statement {
    sid = "DenyEveryoneElse"

    effect = "Deny"

    actions = ["s3:*"]
    resources = [
      "${var.s3_bucket_arn}",
      "${var.s3_bucket_arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "ArnNotEquals"
      values   = ["${distinct(concat(var.allow_administer_resource, var.allow_read_data, var.allow_write_data, var.allow_delete_data))}"]
      variable = "aws:PrincipalArn"
    }
  }

}
