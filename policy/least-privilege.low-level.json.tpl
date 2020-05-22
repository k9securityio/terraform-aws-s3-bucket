{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyInsecureCommunications",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
        "${aws_s3_bucket_arn}",
        "${aws_s3_bucket_arn}/*"
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
        "${aws_s3_bucket_arn}/*"
      ],
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption": "aws:kms"
        }
      }
    },
    {
      "Sid": "DenyUnencryptedObjectUploads",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": [
        "${aws_s3_bucket_arn}/*"
      ],
      "Condition": {
        "Null": {
          "s3:x-amz-server-side-encryption": "true"
        }
      }
    },
    {
      "Sid": "AllowRestrictedPrincipals",
      "Effect": "Allow",
      "Principal": {
        "AWS": ${allowed_aws_principals_json}
      },
      "Action": ${allowed_api_actions_json},
      "Resource": [
        "${aws_s3_bucket_arn}",
        "${aws_s3_bucket_arn}/*"
      ]
    },
    {
      "Sid": "DenyEveryoneElse",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
          "${aws_s3_bucket_arn}",
          "${aws_s3_bucket_arn}/*"
      ],
      "Condition": {
        "ArnNotEquals": {
          "aws:PrincipalArn": ${allowed_aws_principals_json}
        }
      }
    }
  ]
}
