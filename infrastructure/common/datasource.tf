data "aws_acm_certificate" "cert" {
  domain   = "www.jokerandthekween.click"
}

data "aws_route53_zone" "main" {
  name         = var.base_domain
  private_zone = false
}

data "aws_s3_bucket" "customer_sg" {
  provider = "aws.sg-region"
  bucket = "www.sg.jokerandthekween.click"
}

data "aws_s3_bucket" "customer_root_sg" {
  provider = "aws.sg-region"
  bucket = "sg.jokerandthekween.click"
}


data "aws_s3_bucket" "customer_tokyo" {
  provider = "aws.tokyo-region"
  bucket = "www.tokyo.jokerandthekween.click"
}

data "aws_s3_bucket" "customer_root_tokyo" {
  provider = "aws.tokyo-region"
  bucket = "tokyo.jokerandthekween.click"
}