resource "aws_s3_bucket_object" "create_order" {
  bucket = data.aws_s3_bucket.lambda_functions.id

  key    = "create_order.zip"
  source = data.archive_file.create_order.output_path

  etag = filemd5(data.archive_file.create_order.output_path)
}

resource "aws_lambda_function" "create_order" {
   function_name = "create_order"

   s3_bucket = data.aws_s3_bucket.lambda_functions.id
   s3_key    = aws_s3_bucket_object.create_order.id

   
   handler = "create_order.handler"
   runtime = "nodejs12.x"

   role = aws_iam_role.cart.arn
}

resource "aws_lambda_permission" "create_order" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.create_order.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_apigatewayv2_api.cart.execution_arn}/*/*"
}