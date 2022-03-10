module "lambda_view_products" {
   source      = "../../../../../modules/lambda"

   function_name = "view_products"

   source_path = "${path.cwd}/functions/view_products"
   lambda_role = aws_iam_role.cart.arn

   runtime = "nodejs12.x"
   handler = "view_products.handler"


   depends_on = [
     aws_iam_role.cart
   ]
}

resource "aws_lambda_permission" "view_products" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = module.lambda_view_products.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_apigatewayv2_api.cart.execution_arn}/*/*"
}
