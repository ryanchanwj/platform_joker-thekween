 # IAM role which dictates what other AWS services the Lambda function
 # may access.
resource "aws_iam_role" "cart" {
  name = "hk_serverless_lambda_cart"

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
  name = "hk_cart_dynamodb"
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
      module.cart_db.dynamodb_table_arn,
    ]
  }
  depends_on = [module.cart_db]
}

// SQS Permission
resource "aws_iam_role_policy_attachment" "lambda_sqs_role_policy" {
  role       = aws_iam_role.cart.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}
