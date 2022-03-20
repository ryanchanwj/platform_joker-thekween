resource "aws_apigatewayv2_api" "product" {
  name          = "serverless_product_lambda_gw"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = ["http://www.jokerandthekween.click", "https://www.jokerandthekween.click", "http://localhost"]
    allow_methods = ["POST", "GET", "PUT", "DELETE", "OPTIONS"]
    allow_headers = ["*"]
  }
}

resource "aws_apigatewayv2_stage" "product" {
  api_id = aws_apigatewayv2_api.product.id

  name        = "product"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.product_api_gw.arn

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

resource "aws_apigatewayv2_authorizer" "product" {
  api_id           = aws_apigatewayv2_api.product.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "product-cognito-auth"

  jwt_configuration {
    audience = [var.app_client_id]
    issuer   = "https://cognito-idp.${var.aws_region}.amazonaws.com/${tolist(data.aws_cognito_user_pools.user_pools.ids)[0]}"
  }
}

# Add to product
resource "aws_apigatewayv2_integration" "add_product" {
  api_id = aws_apigatewayv2_api.product.id

  integration_uri    = module.lambda_add_product.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "add_product" {
  api_id = aws_apigatewayv2_api.product.id

  route_key = "POST /create"
  target    = "integrations/${aws_apigatewayv2_integration.add_product.id}"

  authorization_type = "JWT" 
  authorizer_id = aws_apigatewayv2_authorizer.product.id
}

# Get product
resource "aws_apigatewayv2_integration" "get_product" {
  api_id = aws_apigatewayv2_api.product.id

  integration_uri    = module.lambda_get_product.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "get_product" {
  api_id = aws_apigatewayv2_api.product.id

  route_key = "GET /get"
  target    = "integrations/${aws_apigatewayv2_integration.get_product.id}"

  # authorization_type = "JWT" 
  # authorizer_id = aws_apigatewayv2_authorizer.product.id
}

# View products
resource "aws_apigatewayv2_integration" "view_products" {
  api_id = aws_apigatewayv2_api.product.id

  integration_uri    = module.lambda_view_products.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "view_products" {
  api_id = aws_apigatewayv2_api.product.id

  route_key = "GET /view"
  target    = "integrations/${aws_apigatewayv2_integration.view_products.id}"

  # authorization_type = "JWT" 
  # authorizer_id = aws_apigatewayv2_authorizer.product.id
}

# Delete from product
resource "aws_apigatewayv2_integration" "delete_product" {
  api_id = aws_apigatewayv2_api.product.id

  integration_uri    = module.lambda_delete_product.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "delete_product" {
  api_id = aws_apigatewayv2_api.product.id

  route_key = "DELETE /delete"
  target    = "integrations/${aws_apigatewayv2_integration.delete_product.id}"

  authorization_type = "JWT" 
  authorizer_id = aws_apigatewayv2_authorizer.product.id
}

# Update product
resource "aws_apigatewayv2_integration" "update_product" {
  api_id = aws_apigatewayv2_api.product.id

  integration_uri    = module.lambda_update_product.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "update_product" {
  api_id = aws_apigatewayv2_api.product.id

  route_key = "PUT /update"
  target    = "integrations/${aws_apigatewayv2_integration.update_product.id}"

  authorization_type = "JWT" 
  authorizer_id = aws_apigatewayv2_authorizer.product.id
}