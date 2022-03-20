 # IAM role which dictates what other AWS services the Lambda function may access.
resource "aws_iam_role" "product" {
  name = "serverless_lambda_product"

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
  role       = aws_iam_role.product.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "dynamodb" {
  role       = aws_iam_role.product.name
  policy_arn = aws_iam_policy.dynamodb.arn
}

resource "aws_iam_policy" "dynamodb" {
  name = "product_dynamodb"
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
      module.product_db.dynamodb_table_arn,
    ]
  }
  depends_on = [module.product_db]
}