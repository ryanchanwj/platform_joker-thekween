# # SSL Certificate
# resource "aws_acm_certificate" "cert" {
#   domain_name = var.domain_name
#   # subject_alternative_names = var.subject_alternative_names
#   validation_method = "DNS"

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_acm_certificate_validation" "cert" {
#   certificate_arn = aws_acm_certificate.cert.arn
#   validation_record_fqdns = [
#       aws_route53_record.cert_validation.fqdn
#   ]
#   timeouts {
#     create = "10m"
#   }
# }

# resource "aws_route53_record" "cert_validation" {
#   name    = sort(aws_acm_certificate.cert.domain_validation_options[*].resource_record_name)[0]
#   # type    = sort(aws_acm_certificate.cert.domain_validation_options[*].resource_record_type)[0]
#   type    = "CNAME"
#   zone_id = data.aws_route53_zone.main.id
#   ttl     = 60
#   records = [sort(aws_acm_certificate.cert.domain_validation_options[*].resource_record_value)[0]] 
#   depends_on = [aws_acm_certificate.cert]
# }