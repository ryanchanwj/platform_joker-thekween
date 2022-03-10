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
resource "aws_apigatewayv2_integration" "add_product" {
  api_id = aws_apigatewayv2_api.order.id

  integration_uri    = module.lambda_add_product.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "add_product" {
  api_id = aws_apigatewayv2_api.order.id

  route_key = "POST /create"
  target    = "integrations/${aws_apigatewayv2_integration.add_product.id}"
}

# View orders
resource "aws_apigatewayv2_integration" "view_products" {
  api_id = aws_apigatewayv2_api.order.id

  integration_uri    = module.lambda_view_products.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "view_products" {
  api_id = aws_apigatewayv2_api.order.id

  route_key = "GET /view"
  target    = "integrations/${aws_apigatewayv2_integration.view_products.id}"
}

# Delete from order
resource "aws_apigatewayv2_integration" "delete_product" {
  api_id = aws_apigatewayv2_api.order.id

  integration_uri    = module.lambda_delete_product.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "delete_product" {
  api_id = aws_apigatewayv2_api.order.id

  route_key = "DELETE /delete"
  target    = "integrations/${aws_apigatewayv2_integration.delete_product.id}"
}

resource "aws_apigatewayv2_integration" "update_product" {
  api_id = aws_apigatewayv2_api.cart.id

  integration_uri    = module.lambda_update_product.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "update_product" {
  api_id = aws_apigatewayv2_api.cart.id

  route_key = "POST /update"
  target    = "integrations/${aws_apigatewayv2_integration.update_product.id}"
}