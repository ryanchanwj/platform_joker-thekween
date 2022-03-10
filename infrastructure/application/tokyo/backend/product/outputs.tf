output "base_url" {
  value = aws_apigatewayv2_stage.orders.invoke_url
}

output "dynamodb_name" {
  value = module.orders_db.dynamodb_table_id
}