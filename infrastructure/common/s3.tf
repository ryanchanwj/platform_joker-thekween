resource "aws_s3_bucket" "lambda_functions" {
  bucket = "jokerandthekween-functions"
}

resource "aws_s3_bucket_policy" "lambda_functions" {
  bucket = aws_s3_bucket.lambda_functions.id
  policy = data.aws_iam_policy_document.lambda_functions.json
}

data "aws_iam_policy_document" "lambda_functions" {
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
      "${aws_s3_bucket.lambda_functions.arn}/*",
    ]
  }
}