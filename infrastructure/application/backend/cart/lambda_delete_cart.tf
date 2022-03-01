resource "aws_s3_bucket_object" "delete_from_cart" {
  bucket = data.aws_s3_bucket.lambda_functions.id

  key    = "delete_from_cart.zip"
  source = data.archive_file.delete_from_cart.output_path

  etag = filemd5(data.archive_file.delete_from_cart.output_path)
}

resource "aws_lambda_function" "delete_from_cart" {
   function_name = "delete_from_cart"

   s3_bucket = data.aws_s3_bucket.lambda_functions.id
   s3_key    = aws_s3_bucket_object.delete_from_cart.id

   
   handler = "delete_from_cart.handler"
   runtime = "nodejs12.x"

   role = aws_iam_role.cart.arn
}

resource "aws_lambda_permission" "delete_from_cart" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.delete_from_cart.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_apigatewayv2_api.cart.execution_arn}/*/*"
}