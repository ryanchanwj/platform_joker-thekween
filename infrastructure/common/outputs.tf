output "cloudfront_www_domain_name" {
  value = aws_cloudfront_distribution.www_s3_distribution.domain_name
}

output "cloudfront_root_domain_name" {
  value = aws_cloudfront_distribution.root_s3_distribution.domain_name
}

output "route_53_www_domain_name" {
  value = aws_route53_record.www-a.name
}

output "route_53_root_domain_name" {
  value = aws_route53_record.root-a.name
}