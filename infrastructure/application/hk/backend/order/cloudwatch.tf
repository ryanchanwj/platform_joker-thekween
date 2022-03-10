resource "aws_cloudwatch_log_group" "orders_api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.orders.name}"

  retention_in_days = 30
}

# resource "aws_cloudwatch_log_group" "create_order" {
#   name = "/aws/lambda/${aws_lambda_function.create_order.function_name}"

#   retention_in_days = 30
# }

# resource "aws_cloudwatch_log_group" "view_orders" {
#   name = "/aws/lambda/${aws_lambda_function.view_orders.function_name}"

#   retention_in_days = 30
# }

# resource "aws_cloudwatch_log_group" "delete_orders" {
#   name = "/aws/lambda/${aws_lambda_function.delete_orders.function_name}"

#   retention_in_days = 30
# }