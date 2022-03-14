module "lambda_checkout_cart" {
   source      = "../../../../../modules/lambda"

   function_name = "checkout_cart"

   source_path = "${path.cwd}/functions/checkout_cart.zip"
   lambda_role = aws_iam_role.cart.arn

   runtime = "nodejs12.x"
   handler = "checkout_cart.handler"

   environment_variables = {
      STRIPE_SECRET: "sk_test_51IbDzyHA8Hke5K0TojMEVfeV8ihCgIxLTT6VMfTyDT5exzgfMJxaXdokcwWN5wgmx8G7G0Tfdx4tjPEFAMyhTj4M00smUxD1su",
      STRIPE_PUBLIC: "pk_test_51IbDzyHA8Hke5K0T8Nli6jFqnYTsUUrbw3LTh7OuR3BBzVMEhZT1NNVIDprXJ1uvUVYelFjM1kDW4N08sYi5RPZz00ZMZDfCMo",
   }
   
   depends_on = [
     aws_iam_role.cart
   ]
}

resource "aws_lambda_permission" "checkout_cart" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = module.lambda_checkout_cart.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_apigatewayv2_api.cart.execution_arn}/*/*"
}
