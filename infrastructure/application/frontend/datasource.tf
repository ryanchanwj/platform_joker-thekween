data "aws_acm_certificate" "cert" {
  domain   = "www.jokerandthekween.click"
}

data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}