output "base_url" {
  value = aws_apigatewayv2_stage.cart.invoke_url
}

output "dynamodb_name" {
  value = module.cart_db.dynamodb_table_id
}