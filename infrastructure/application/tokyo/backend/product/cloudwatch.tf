resource "aws_cloudwatch_log_group" "product_api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.product.name}"

  retention_in_days = 30
}
