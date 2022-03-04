resource "aws_cloudwatch_log_group" "cart_api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.cart.name}"

  retention_in_days = 30
}

# resource "aws_cloudwatch_log_group" "add_to_cart" {
#   name = "/aws/lambda/${module.lambda_add_to_cart.function_name}"

#   retention_in_days = 30
# }

# resource "aws_cloudwatch_log_group" "update_cart" {
#   name = "/aws/lambda/${aws_lambda_function.update_cart.function_name}"

#   retention_in_days = 30
# }

# resource "aws_cloudwatch_log_group" "view_cart" {
#   name = "/aws/lambda/${aws_lambda_function.view_cart.function_name}"

#   retention_in_days = 30
# }

# resource "aws_cloudwatch_log_group" "delete_from_cart" {
#   name = "/aws/lambda/${aws_lambda_function.delete_from_cart.function_name}"

#   retention_in_days = 30
# }