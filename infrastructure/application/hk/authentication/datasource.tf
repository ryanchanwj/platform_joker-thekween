data "aws_cloudfront_distribution" "hk_www" {
  id = "EDEUAW4S2TT0J"
}

data "aws_acm_certificate" "cert" {
  domain   = "www.jokerandthekween.click"
  provider = "aws.us-region"
}