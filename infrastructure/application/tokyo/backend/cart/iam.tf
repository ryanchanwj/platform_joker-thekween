 # IAM role which dictates what other AWS services the Lambda function
 # may access.
resource "aws_iam_role" "cart" {
  name = "tokyo_serverless_lambda_cart"

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
  role       = aws_iam_role.cart.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

// DynamoDB permission
resource "aws_iam_role_policy_attachment" "dynamodb" {
  role       = aws_iam_role.cart.name
  policy_arn = aws_iam_policy.dynamodb.arn
}

resource "aws_iam_policy" "dynamodb" {
  name = "tokyo_cart_dynamodb"
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
      "*",
    ]
  }
  depends_on = [module.cart_db]
}

// Lambda invokation permission
resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.cart.name
  policy_arn = aws_iam_policy.lambda.arn
}

resource "aws_iam_policy" "lambda" {
  name = "tokyo_cart_lambda"
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
      module.lambda_delete_from_cart.invoke_arn,
      data.aws_lambda_function.create_order.arn,
      data.aws_lambda_function.get_product.arn,
      data.aws_lambda_function.update_product.arn,
    ]
  }
}

// SES permissions
resource "aws_iam_role_policy_attachment" "ses" {
  role       = aws_iam_role.cart.name
  policy_arn = aws_iam_policy.ses.arn
}

resource "aws_iam_policy" "ses" {
  name = "tokyo_cart_ses"
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