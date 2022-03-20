resource "aws_apigatewayv2_api" "orders" {
  name          = "serverless_orders_lambda_gw"
  protocol_type = "HTTP"  
  cors_configuration {
    allow_origins = ["http://www.jokerandthekween.click", "https://www.jokerandthekween.click", "http://localhost"]
    allow_methods = ["POST", "GET", "PUT", "DELETE", "OPTIONS"]
    allow_headers = ["*"]
  }
}

resource "aws_apigatewayv2_stage" "orders" {
  api_id = aws_apigatewayv2_api.orders.id

  name        = "orders"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.orders_api_gw.arn

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

resource "aws_apigatewayv2_authorizer" "orders" {
  api_id           = aws_apigatewayv2_api.orders.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "orders-cognito-auth"

  jwt_configuration {
    audience = [var.app_client_id]
    issuer   = "https://cognito-idp.${var.aws_region}.amazonaws.com/${tolist(data.aws_cognito_user_pools.user_pools.ids)[0]}"
  }
}

# Add to order
resource "aws_apigatewayv2_integration" "create_order" {
  api_id = aws_apigatewayv2_api.orders.id

  integration_uri    = module.lambda_create_order.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "create_order" {
  api_id = aws_apigatewayv2_api.orders.id

  route_key = "POST /create"
  target    = "integrations/${aws_apigatewayv2_integration.create_order.id}"

  authorization_type = "JWT" 
  authorizer_id = aws_apigatewayv2_authorizer.orders.id
}

# View orders
resource "aws_apigatewayv2_integration" "view_orders" {
  api_id = aws_apigatewayv2_api.orders.id

  integration_uri    = module.lambda_view_orders.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "view_orders" {
  api_id = aws_apigatewayv2_api.orders.id

  route_key = "GET /view"
  target    = "integrations/${aws_apigatewayv2_integration.view_orders.id}"

  authorization_type = "JWT" 
  authorizer_id = aws_apigatewayv2_authorizer.orders.id
}

# Delete from order
resource "aws_apigatewayv2_integration" "delete_orders" {
  api_id = aws_apigatewayv2_api.orders.id

  integration_uri    = module.lambda_delete_orders.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "delete_orders" {
  api_id = aws_apigatewayv2_api.orders.id

  route_key = "DELETE /delete"
  target    = "integrations/${aws_apigatewayv2_integration.delete_orders.id}"

  authorization_type = "JWT" 
  authorizer_id = aws_apigatewayv2_authorizer.orders.id
}

# # Generate report
# resource "aws_apigatewayv2_integration" "generate_report" {
#   api_id = aws_apigatewayv2_api.orders.id

#   integration_uri    = module.lambda_generate_report.invoke_arn
#   integration_type   = "AWS_PROXY"
#   integration_method = "POST"
# }

# resource "aws_apigatewayv2_route" "generate_report" {
#   api_id = aws_apigatewayv2_api.orders.id

#   route_key = "GET /report"
#   target    = "integrations/${aws_apigatewayv2_integration.generate_report.id}"

#   authorization_type = "JWT" 
#   authorizer_id = aws_apigatewayv2_authorizer.orders.id
# }