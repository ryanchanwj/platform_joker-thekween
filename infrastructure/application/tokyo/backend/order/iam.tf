 # IAM role which dictates what other AWS services the Lambda function may access.
resource "aws_iam_role" "orders" {
  name = "tokyo_serverless_lambda_orders"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.orders.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

// DynamoDB permissions
resource "aws_iam_role_policy_attachment" "dynamodb" {
  role       = aws_iam_role.orders.name
  policy_arn = aws_iam_policy.dynamodb.arn
}

resource "aws_iam_policy" "dynamodb" {
  name = "tokyo_orders_dynamodb"
  policy = data.aws_iam_policy_document.dynamodb.json
}

data "aws_iam_policy_document" "dynamodb" {
  statement {
    sid = "DynamoDBActions"
    
    effect = "Allow" 

    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:BatchWriteItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
    ]

    resources = [
      module.orders_db.dynamodb_table_arn,
    ]
  }
  depends_on = [module.orders_db]
}

// SES permissions
resource "aws_iam_role_policy_attachment" "ses" {
  role       = aws_iam_role.orders.name
  policy_arn = aws_iam_policy.ses.arn
}

resource "aws_iam_policy" "ses" {
  name = "tokyo_orders_ses"
  policy = data.aws_iam_policy_document.ses.json
}

data "aws_iam_policy_document" "ses" {
  statement {
    sid = "AllowLambdaToSendEmails"
    
    effect = "Allow" 

    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail",
      "s3:PutObject"
    ]

    resources = [
      "${data.aws_s3_bucket.reports.arn}/email/*",
      "arn:aws:ses:${var.aws_region}:${data.aws_caller_identity.current.account_id}:identity/*"
    ]
  }
}

// Lambda invokation permission
resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.orders.name
  policy_arn = aws_iam_policy.lambda.arn
}

resource "aws_iam_policy" "lambda" {
  name = "tokyo_orders_lambda"
  policy = data.aws_iam_policy_document.lambda.json
}

data "aws_iam_policy_document" "lambda" {
  statement {
    sid = "LambdaActions"
    
    effect = "Allow" 

    actions = [
      "lambda:InvokeFunction",
    ]

    resources = [
      data.aws_lambda_function.get_products.arn,
    ]
  }
}

// S3 bucket policy 
resource "aws_s3_bucket_policy" "reports" {
  bucket = data.aws_s3_bucket.reports.id
  policy = data.aws_iam_policy_document.reports.json

  provider = "aws.us-region"
}

data "aws_iam_policy_document" "reports" {
  # statement {
  #   sid = "AllowUser"

  #   principals {
  #     type        = "AWS"
  #     identifiers = data.aws_caller_identity.current.*.arn
  #   }

  #   effect = "Allow"

  #   actions = [
  #     "s3:PutObject"
  #   ]

  #   resources = [
  #     "${aws_s3_bucket.reports.arn}/*",
  #   ]
  # }

  statement {
    sid = "AllowSES"

    principals {
      type        = "Service"
      identifiers = ["ses.amazonaws.com"]
    }

    effect = "Allow"

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${data.aws_s3_bucket.reports.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:Referer"

      values = [
        data.aws_caller_identity.current.account_id
      ]
    }
  }

  statement {
    sid = "AllowLambda"

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.orders.arn]
    }

    effect = "Allow"

    actions = [
      "s3:*"
    ]

    resources = [
      data.aws_s3_bucket.reports.arn,
      "${data.aws_s3_bucket.reports.arn}/*",
    ]
  }
}