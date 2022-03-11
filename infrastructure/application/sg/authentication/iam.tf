 # IAM role which dictates what other AWS services the Lambda function
 # may access.
resource "aws_iam_role" "auth" {
  name = "sg_serverless_lambda_auth"

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
  role       = aws_iam_role.auth.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

// cognito permission
resource "aws_iam_role_policy_attachment" "cognito" {
  role       = aws_iam_role.auth.name
  policy_arn = aws_iam_policy.cognito.arn
}

resource "aws_iam_policy" "cognito" {
  name = "sg_auth_cognito"
  policy = data.aws_iam_policy_document.cognito.json
}

data "aws_iam_policy_document" "cognito" {
  statement {
    sid = "CognitoActions"
    
    effect = "Allow" 

    actions = [
      "cognito-idp:*",
    ]

    resources = [
      "*",
    ]
  }
}
