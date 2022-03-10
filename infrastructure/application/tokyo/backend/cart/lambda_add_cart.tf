module "lambda_add_to_cart" {
   source      = "../../../../../modules/lambda"

   function_name = "add_to_cart"

   source_path = "${path.cwd}/functions/add_to_cart"
   lambda_role = aws_iam_role.cart.arn

   runtime = "nodejs12.x"
   handler = "add_to_cart.handler"


   depends_on = [
     aws_iam_role.cart
   ]
}

resource "aws_lambda_permission" "add_to_cart" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = module.lambda_add_to_cart.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_apigatewayv2_api.cart.execution_arn}/*/*"
}