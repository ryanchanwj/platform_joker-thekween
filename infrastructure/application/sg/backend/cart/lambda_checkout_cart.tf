module "lambda_checkout_cart" {
   source      = "../../../../../modules/lambda"

   function_name = "checkout_cart"

   source_path = "${path.cwd}/functions/checkout_cart"
   lambda_role = aws_iam_role.cart.arn

   runtime = "nodejs12.x"
   handler = "checkout_cart.handler"

   environment_variables = {
      sqs_url = aws_sqs_queue.queue.id
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
