data "aws_s3_bucket" "lambda_functions" {
    bucket = "tokyo.jokerandthekween.click-functions"
}

data "aws_cognito_user_pools" "user_pools" {
  name = "customers"
}

data "aws_lambda_function" "create_order" {
  function_name = var.create_order_function_name
}

data "aws_lambda_function" "get_product" {
  function_name = var.get_product_function_name
}

data "aws_lambda_function" "update_product" {
  function_name = var.update_product_function_name
}

data "aws_s3_bucket" "reports" {
  bucket   = var.s3_reports
  provider = "aws.us-region"
}