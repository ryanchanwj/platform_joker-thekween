resource "aws_s3_bucket_object" "update_cart" {
  bucket = data.aws_s3_bucket.lambda_functions.id

  key    = "update_cart.zip"
  source = data.archive_file.update_cart.output_path

  etag = filemd5(data.archive_file.update_cart.output_path)
}

resource "aws_lambda_function" "update_cart" {
   function_name = "update_cart"

   s3_bucket = data.aws_s3_bucket.lambda_functions.id
   s3_key    = aws_s3_bucket_object.update_cart.id

   
   handler = "update_cart.handler"
   runtime = "nodejs12.x"

   role = aws_iam_role.cart.arn
}

resource "aws_lambda_permission" "update_cart" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.update_cart.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_apigatewayv2_api.cart.execution_arn}/*/*"
}
