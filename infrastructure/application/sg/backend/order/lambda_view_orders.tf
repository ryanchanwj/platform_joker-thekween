module "lambda_view_orders" {
   source      = "../../../../../modules/lambda"

   function_name = "view_orders"

   source_path = "${path.cwd}/functions/view_orders"
   lambda_role = aws_iam_role.cart.arn

   runtime = "nodejs12.x"
   handler = "view_orders.handler"


   depends_on = [
     aws_iam_role.cart
   ]
}

resource "aws_lambda_permission" "view_orders" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = module.lambda_view_orders.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_apigatewayv2_api.cart.execution_arn}/*/*"
}