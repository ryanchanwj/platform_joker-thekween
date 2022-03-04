module "lambda_generate_report" {
   source      = "../../../../../modules/lambda"

   function_name = "generate_report"

   source_path = "${path.cwd}/functions/generate_report"
   lambda_role = aws_iam_role.cart.arn

   runtime = "python3.8"
   handler = "generate_report.handler"


   depends_on = [
     aws_iam_role.cart
   ]
}

resource "aws_lambda_permission" "generate_report" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = module.lambda_generate_report.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_apigatewayv2_api.cart.execution_arn}/*/*"
}