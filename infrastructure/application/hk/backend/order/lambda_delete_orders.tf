resource "aws_s3_bucket_object" "delete_orders" {
  bucket = data.aws_s3_bucket.lambda_functions.id

  key    = "delete_orders.zip"
  source = data.archive_file.delete_orders.output_path

  etag = filemd5(data.archive_file.delete_orders.output_path)
}

resource "aws_lambda_function" "delete_orders" {
   function_name = "delete_orders"

   s3_bucket = data.aws_s3_bucket.lambda_functions.id
   s3_key    = aws_s3_bucket_object.delete_orders.id

   
   handler = "delete_orders.handler"
   runtime = "nodejs12.x"

   role = aws_iam_role.cart.arn
}

resource "aws_lambda_permission" "delete_orders" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.delete_orders.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_apigatewayv2_api.cart.execution_arn}/*/*"
}
