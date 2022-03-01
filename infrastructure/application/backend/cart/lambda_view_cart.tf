resource "aws_s3_bucket_object" "view_cart" {
  bucket = data.aws_s3_bucket.lambda_functions.id

  key    = "view_cart.zip"
  source = data.archive_file.view_cart.output_path

  etag = filemd5(data.archive_file.view_cart.output_path)
}

resource "aws_lambda_function" "view_cart" {
   function_name = "view_cart"

   s3_bucket = data.aws_s3_bucket.lambda_functions.id
   s3_key    = aws_s3_bucket_object.view_cart.id

   
   handler = "view_cart.handler"
   runtime = "nodejs12.x"

   role = aws_iam_role.cart.arn
}

resource "aws_lambda_permission" "view_cart" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.view_cart.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_apigatewayv2_api.cart.execution_arn}/*/*"
}
