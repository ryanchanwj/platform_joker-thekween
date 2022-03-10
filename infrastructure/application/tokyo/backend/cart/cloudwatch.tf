resource "aws_cloudwatch_log_group" "cart_api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.cart.name}"

  retention_in_days = 30
}