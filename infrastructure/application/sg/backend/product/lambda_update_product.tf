module "lambda_update_product" {
   source      = "../../../../../modules/lambda"

   function_name = "update_product"

   source_path = "${path.cwd}/functions/update_product"
   lambda_role = aws_iam_role.product.arn

   runtime = "nodejs12.x"
   handler = "update_product.handler"


   depends_on = [
     aws_iam_role.product
   ]
}

resource "aws_lambda_permission" "update_product" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = module.lambda_update_product.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_apigatewayv2_api.product.execution_arn}/*/*"
}
