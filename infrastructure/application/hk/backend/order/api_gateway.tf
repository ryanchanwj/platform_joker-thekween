resource "aws_apigatewayv2_api" "orders" {
  name          = "serverless_orders_lambda_gw"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "orders" {
  api_id = aws_apigatewayv2_api.orders.id

  name        = "orders"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.order_api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

# Add to order
resource "aws_apigatewayv2_integration" "create_order" {
  api_id = aws_apigatewayv2_api.order.id

  integration_uri    = aws_lambda_function.create_order.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "create_order" {
  api_id = aws_apigatewayv2_api.order.id

  route_key = "POST /create"
  target    = "integrations/${aws_apigatewayv2_integration.create_order.id}"
}

# View orders
resource "aws_apigatewayv2_integration" "view_orders" {
  api_id = aws_apigatewayv2_api.order.id

  integration_uri    = aws_lambda_function.view_orders.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "view_orders" {
  api_id = aws_apigatewayv2_api.order.id

  route_key = "GET /view"
  target    = "integrations/${aws_apigatewayv2_integration.view_orders.id}"
}

# Delete from order
resource "aws_apigatewayv2_integration" "delete_orders" {
  api_id = aws_apigatewayv2_api.order.id

  integration_uri    = aws_lambda_function.delete_orders.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "delete_orders" {
  api_id = aws_apigatewayv2_api.order.id

  route_key = "DELETE /delete"
  target    = "integrations/${aws_apigatewayv2_integration.delete_orders.id}"
}