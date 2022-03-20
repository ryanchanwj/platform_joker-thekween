output "base_url" {
  value = aws_apigatewayv2_stage.product.invoke_url
}

output "dynamodb_name" {
  value = module.product_db.dynamodb_table_id
}