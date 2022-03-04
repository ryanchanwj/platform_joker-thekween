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

module "lambda_create_order" {
   source      = "../../../../../modules/lambda"

   function_name = "create_order"

   source_path = "${path.cwd}/functions/create_order"
   lambda_role = aws_iam_role.cart.arn

   runtime = "nodejs12.x"
   handler = "create_order.handler"


   depends_on = [
     aws_iam_role.cart
   ]
}

resource "aws_lambda_permission" "create_order" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = module.lambda_create_order.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_apigatewayv2_api.cart.execution_arn}/*/*"
}