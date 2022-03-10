module "lambda_process_payment" {
   source      = "../../../../../modules/lambda"

   function_name = "process_payment"

   source_path = "${path.cwd}/functions/process_payment"
   lambda_role = aws_iam_role.payment.arn

   runtime = "nodejs12.x"
   handler = "process_payment.handler"
   environment_variables = {
      "STRIPE_SECRET": "sk_test_51IbDzyHA8Hke5K0TojMEVfeV8ihCgIxLTT6VMfTyDT5exzgfMJxaXdokcwWN5wgmx8G7G0Tfdx4tjPEFAMyhTj4M00smUxD1su",
      "STRIPE_PUBLIC": "pk_test_51IbDzyHA8Hke5K0T8Nli6jFqnYTsUUrbw3LTh7OuR3BBzVMEhZT1NNVIDprXJ1uvUVYelFjM1kDW4N08sYi5RPZz00ZMZDfCMo",
      sqs_url = data.aws_sqs_queue.queue.url,
   }

   depends_on = [
     aws_iam_role.payment
   ]
}

# Event source from SQS
# resource "aws_lambda_event_source_mapping" "event_source_mapping" {
#   event_source_arn = data.aws_sqs_queue.queue.arn
#   function_name    = "${module.lambda_process_payment.invoke_arn}"
#   batch_size       = 1
# }


// Test
# Add to cart
resource "aws_apigatewayv2_integration" "process_payment" {
  api_id = data.aws_apigatewayv2_api.cart.id

  integration_uri    = module.lambda_process_payment.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "process_payment" {
  api_id = data.aws_apigatewayv2_api.cart.id

  route_key = "POST /process"
  target    = "integrations/${aws_apigatewayv2_integration.process_payment.id}"

  # authorization_type = "JWT" 
  # authorizer_id = aws_apigatewayv2_authorizer.cart.id
}