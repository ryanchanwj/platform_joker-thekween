resource "aws_apigatewayv2_api" "cart" {
  name          = "serverless_cart_lambda_gw"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "cart" {
  api_id = aws_apigatewayv2_api.cart.id

  name        = "cart"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.cart_api_gw.arn

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

resource "aws_apigatewayv2_authorizer" "cart" {
  api_id           = aws_apigatewayv2_api.cart.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "cart-cognito-auth"

  jwt_configuration {
    audience = [var.app_client_id]
    issuer   = "https://cognito-idp.${var.aws_region}.amazonaws.com/${tolist(data.aws_cognito_user_pools.user_pools.ids)[0]}"
  }
}

# Add to cart
resource "aws_apigatewayv2_integration" "add_to_cart" {
  api_id = aws_apigatewayv2_api.cart.id

  integration_uri    = module.lambda_add_to_cart.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "add_to_cart" {
  api_id = aws_apigatewayv2_api.cart.id

  route_key = "POST /add"
  target    = "integrations/${aws_apigatewayv2_integration.add_to_cart.id}"

  authorization_type = "JWT" 
  authorizer_id = aws_apigatewayv2_authorizer.cart.id
}


# Update Cart
resource "aws_apigatewayv2_integration" "update_cart" {
  api_id = aws_apigatewayv2_api.cart.id

  integration_uri    = module.lambda_update_cart.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "update_cart" {
  api_id = aws_apigatewayv2_api.cart.id

  route_key = "POST /update"
  target    = "integrations/${aws_apigatewayv2_integration.update_cart.id}"

  authorization_type = "JWT" 
  authorizer_id = aws_apigatewayv2_authorizer.cart.id
}

# View Cart
resource "aws_apigatewayv2_integration" "view_cart" {
  api_id = aws_apigatewayv2_api.cart.id

  integration_uri    = module.lambda_view_cart.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "view_cart" {
  api_id = aws_apigatewayv2_api.cart.id

  route_key = "GET /view"
  target    = "integrations/${aws_apigatewayv2_integration.view_cart.id}"

  authorization_type = "JWT" 
  authorizer_id = aws_apigatewayv2_authorizer.cart.id
}

# Delete from Cart
resource "aws_apigatewayv2_integration" "delete_from_cart" {
  api_id = aws_apigatewayv2_api.cart.id

  integration_uri    = module.lambda_delete_from_cart.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "delete_from_cart" {
  api_id = aws_apigatewayv2_api.cart.id

  route_key = "DELETE /delete"
  target    = "integrations/${aws_apigatewayv2_integration.delete_from_cart.id}"

  authorization_type = "JWT" 
  authorizer_id = aws_apigatewayv2_authorizer.cart.id
}

# Checkout Cart
resource "aws_apigatewayv2_integration" "checkout_cart" {
  api_id = aws_apigatewayv2_api.cart.id

  integration_uri    = module.lambda_checkout_cart.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "checkout_cart" {
  api_id = aws_apigatewayv2_api.cart.id

  route_key = "POST /checkout"
  target    = "integrations/${aws_apigatewayv2_integration.checkout_cart.id}"

  authorization_type = "JWT" 
  authorizer_id = aws_apigatewayv2_authorizer.cart.id
}