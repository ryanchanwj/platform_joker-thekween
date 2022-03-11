data "aws_cloudfront_distribution" "www" {
  id = "EABUD7B9UNXZ9"
}

data "aws_acm_certificate" "cert" {
  domain   = "www.jokerandthekween.click"
  provider = "aws.us-region"
}

data "aws_cognito_user_pools" "tokyo" {
  name     = "customers"
  provider = "aws.tokyo-region"
}