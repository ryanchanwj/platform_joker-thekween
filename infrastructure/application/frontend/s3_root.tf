# S3 bucket for redirecting non-www to www.
resource "aws_s3_bucket" "root" {
  bucket = var.bucket_name
  acl = "public-read"

  website {
    redirect_all_requests_to = "https://www.${var.domain_name}"
  }

}

resource "aws_s3_bucket_policy" "root" {
  bucket = aws_s3_bucket.root.id
  policy = data.aws_iam_policy_document.root.json
}

data "aws_iam_policy_document" "root" {
  statement {
    sid = "PublicReadGetObject"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    effect = "Allow"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.root.arn}/*",
    ]
  }

  statement {
    sid = ""

    principals {
      type        = "AWS"
      identifiers = data.aws_caller_identity.current.*.arn
    }

    effect = "Allow"

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.root.arn}/*",
    ]
  }

  statement {
    sid = ""

    principals {
      type        = "AWS"
      identifiers = data.aws_caller_identity.current.*.arn
    }

    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.root.arn
    ]
  }
}