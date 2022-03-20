resource "aws_ses_domain_identity" "primary" {
  domain = data.aws_route53_zone.main.name
}

# resource "aws_route53_record" "ses_verify" {
#   zone_id = data.aws_route53_zone.main.zone_id
#   name    = "_amazonses.${aws_ses_domain_identity.primary.id}"
#   type    = "TXT"
#   ttl     = "600"
#   records = [aws_ses_domain_identity.primary.verification_token]
# }

resource "aws_ses_domain_identity_verification" "ses_verify" {
  domain = aws_ses_domain_identity.primary.id

  depends_on = [aws_route53_record.ses_verify]
}

# resource "aws_route53_record" "email" {
#   zone_id = data.aws_route53_zone.main.zone_id
#   name    = data.aws_route53_zone.main.name
#   type    = "MX"
#   ttl     = "600"
#   records = ["10 inbound-smtp.${var.aws_region}.amazonaws.com"]
# }

resource "aws_ses_email_identity" "email" {
  email = "ryanchan1997@hotmail.com"
}

// Add your email here to test report generation 
# resource "aws_ses_email_identity" "email" {
#   email = ""
# }