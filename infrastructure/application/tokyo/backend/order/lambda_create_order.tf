module "lambda_create_order" {
   source      = "../../../../../modules/lambda"

   function_name = "create_order"

   source_path = "${path.cwd}/functions/create_order"
   lambda_role = aws_iam_role.orders.arn

   runtime = "nodejs12.x"
   handler = "create_order.handler"


   depends_on = [
     aws_iam_role.orders
   ]
}

resource "aws_lambda_permission" "create_order" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = module.lambda_create_order.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_apigatewayv2_api.orders.execution_arn}/*/*"
}