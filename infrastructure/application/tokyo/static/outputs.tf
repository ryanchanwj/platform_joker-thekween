output "s3_bucket_name_www" {
  value = aws_s3_bucket.customer.id
}

output "s3_bucket_name_root" {
  value = aws_s3_bucket.root.id
}

output "s3_bucket_name_lambda" {
  value = aws_s3_bucket.lambda_functions.id
}
