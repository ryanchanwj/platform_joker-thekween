module "lambda_generate_report" {
   source      = "../../../../../modules/lambda"

   function_name = "generate_report"

   source_path = "${path.cwd}/functions/generate_report"
   lambda_role = aws_iam_role.orders.arn

   runtime = "nodejs12.x"
   handler = "generate_report.handler"
   
   environment_variables = {
      S3Bucket      = var.s3_reports
      MailSender    = aws_ses_email_identity.email.email
      MailRecipient = aws_ses_email_identity.email.email
      AWSRegion     = var.aws_region
      GET_PRODUCTS_LAMBDA = data.aws_lambda_function.get_products.arn,
   }

   depends_on = [
     aws_iam_role.orders
   ]
}

resource "aws_lambda_permission" "generate_report" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = module.lambda_generate_report.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_apigatewayv2_api.orders.execution_arn}/*/*"
}