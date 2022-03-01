resource "aws_s3_bucket_object" "add_to_cart" {
  bucket = data.aws_s3_bucket.lambda_functions.id

  key    = "add_to_cart.zip"
  source = data.archive_file.add_to_cart.output_path

  etag = filemd5(data.archive_file.add_to_cart.output_path)
}

resource "aws_lambda_function" "add_to_cart" {
   function_name = "add_to_cart"

   s3_bucket = data.aws_s3_bucket.lambda_functions.id
   s3_key    = aws_s3_bucket_object.add_to_cart.id

   
   handler = "add_to_cart.handler"
   runtime = "nodejs12.x"

   role = aws_iam_role.cart.arn
}

resource "aws_lambda_permission" "add_to_cart" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.add_to_cart.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_apigatewayv2_api.cart.execution_arn}/*/*"
}