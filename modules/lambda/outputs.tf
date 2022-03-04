output "lambda" {
  description = "Lambda resource"
  value       = module.this
}

output "lambda_alias" {
  description = "Lambda alias resource."
  value = aws_lambda_alias.latest
}

output "invoke_arn" {
  description = "Lambda arn to invoke function"
  value = module.this.lambda_function_arn
}

output "function_name" {
  description = "Lambda function name"
  value = module.this.lambda_function_name
}