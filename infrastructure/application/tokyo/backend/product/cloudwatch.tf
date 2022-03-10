resource "aws_cloudwatch_log_group" "orders_api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.orders.name}"

  retention_in_days = 30
}