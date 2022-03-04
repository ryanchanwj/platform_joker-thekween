resource "aws_s3_bucket_object" "view_orders" {
  bucket = data.aws_s3_bucket.lambda_functions.id

  key    = "view_orders.zip"
  source = data.archive_file.view_orders.output_path

  etag = filemd5(data.archive_file.view_orders.output_path)
}

resource "aws_lambda_function" "view_orders" {
   function_name = "view_orders"

   s3_bucket = data.aws_s3_bucket.lambda_functions.id
   s3_key    = aws_s3_bucket_object.view_orders.id

   
   handler = "view_orders.handler"
   runtime = "nodejs12.x"

   role = aws_iam_role.cart.arn
}

resource "aws_lambda_permission" "view_orders" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.view_orders.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_apigatewayv2_api.cart.execution_arn}/*/*"
}