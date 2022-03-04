module "lambda_delete_product" {
   source      = "../../../../../modules/lambda"

   function_name = "delete_product"

   source_path = "${path.cwd}/functions/delete_product"
   lambda_role = aws_iam_role.cart.arn

   runtime = "nodejs12.x"
   handler = "delete_product.handler"


   depends_on = [
     aws_iam_role.cart
   ]
}

resource "aws_lambda_permission" "delete_product" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = module.lambda_delete_product.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_apigatewayv2_api.cart.execution_arn}/*/*"
}
