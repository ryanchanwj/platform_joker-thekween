data "aws_s3_bucket" "lambda_functions" {
  bucket = "sg.jokerandthekween.click-functions"
}

data "aws_cognito_user_pools" "user_pools" {
  name = "customers"
}

data "aws_route53_zone" "main" {
  name         = var.base_domain
  private_zone = false
}

data "aws_s3_bucket" "reports" {
  bucket   = var.s3_reports
  provider = "aws.us-region"
}

data "aws_lambda_function" "get_products" {
  function_name = var.get_products_function_name
}