# S3 bucket for website.
resource "aws_s3_bucket" "customer" {
  bucket = "www.${var.bucket_name}"
  acl = "public-read"

  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://www.${var.domain_name}"]
    max_age_seconds = 3000
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

}

resource "aws_s3_bucket_policy" "customer" {
  bucket = aws_s3_bucket.customer.id
  policy = data.aws_iam_policy_document.customer.json
}

data "aws_iam_policy_document" "customer" {
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
      "${aws_s3_bucket.customer.arn}/*",
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
      "${aws_s3_bucket.customer.arn}/*",
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
      aws_s3_bucket.customer.arn
    ]
  }
}

# #Upload files of your static website
resource "aws_s3_bucket_object" "html" {
  for_each = fileset("./serverless-shop/aws", "**/*.html")

  bucket = aws_s3_bucket.customer.bucket
  key    = each.value
  source = "./serverless-shop/aws/${each.value}"
  etag   = filemd5("./serverless-shop/aws/${each.value}")
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "ico" {
  for_each = fileset("./serverless-shop/aws", "**/*.ico")

  bucket = aws_s3_bucket.customer.bucket
  key    = each.value
  source = "./serverless-shop/aws/${each.value}"
  etag   = filemd5("./serverless-shop/aws/${each.value}")
  content_type = "image/x-icon"
}

resource "aws_s3_bucket_object" "svg" {
  for_each = fileset("./serverless-shop/aws", "**/*.svg")

  bucket = aws_s3_bucket.customer.bucket
  key    = each.value
  source = "./serverless-shop/aws/${each.value}"
  etag   = filemd5("./serverless-shop/aws/${each.value}")
  content_type = "image/svg+xml"
}

resource "aws_s3_bucket_object" "css" {
  for_each = fileset("./serverless-shop/aws", "**/*.css")

  bucket = aws_s3_bucket.customer.bucket
  key    = each.value
  source = "./serverless-shop/aws/${each.value}"
  etag   = filemd5("./serverless-shop/aws/${each.value}")
  content_type = "text/css"
}

resource "aws_s3_bucket_object" "js" {
  for_each = fileset("./serverless-shop/aws", "**/*.js")

  bucket = aws_s3_bucket.customer.bucket
  key    = each.value
  source = "./serverless-shop/aws/${each.value}"
  etag   = filemd5("./serverless-shop/aws/${each.value}")
  content_type = "application/javascript"
}


resource "aws_s3_bucket_object" "images" {
  for_each = fileset("./serverless-shop/aws", "**/*.png")

  bucket = aws_s3_bucket.customer.bucket
  key    = each.value
  source = "./serverless-shop/aws/${each.value}"
  etag   = filemd5("./serverless-shop/aws/${each.value}")
  content_type = "image/png"
}

resource "aws_s3_bucket_object" "json" {
  for_each = fileset("./serverless-shop/aws", "**/*.json")

  bucket = aws_s3_bucket.customer.bucket
  key    = each.value
  source = "./serverless-shop/aws/${each.value}"
  etag   = filemd5("./serverless-shop/aws/${each.value}")
  content_type = "application/json"
}


# resource "aws_s3_bucket_object" "json" {
#   for_each = fileset("./serverless-shop/aws", "**")

#   bucket = aws_s3_bucket.customer.bucket
#   key    = each.value
#   source = "./serverless-shop/aws/${each.value}"
#   etag   = filemd5("./serverless-shop/aws/${each.value}")
#   # content_type = "application/json"
# }

