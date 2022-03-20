data "aws_s3_bucket" "lambda_functions" {
    bucket = "sg.jokerandthekween.click-functions"
}

data "aws_cognito_user_pools" "user_pools" {
  name = "customers"
}