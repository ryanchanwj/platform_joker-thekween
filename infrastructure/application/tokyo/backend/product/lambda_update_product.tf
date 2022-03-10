resource "aws_s3_bucket_object" "update_product" {
  bucket = data.aws_s3_bucket.lambda_functions.id

  key    = "update_product.zip"
  source = data.archive_file.update_product.output_path

  etag = filemd5(data.archive_file.update_product.output_path)
}

resource "aws_lambda_function" "update_product" {
   function_name = "update_product"

   s3_bucket = data.aws_s3_bucket.lambda_functions.id
   s3_key    = aws_s3_bucket_object.update_product.id

   
   handler = "update_product.handler"
   runtime = "nodejs12.x"

   role = aws_iam_role.cart.arn
}

module "lambda_update_product" {
   source      = "../../../../../modules/lambda"

   function_name = "update_product"

   source_path = "${path.cwd}/functions/update_product"
   lambda_role = aws_iam_role.cart.arn

   runtime = "nodejs12.x"
   handler = "update_product.handler"


   depends_on = [
     aws_iam_role.cart
   ]
}

resource "aws_lambda_permission" "update_product" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = module.lambda_update_product.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_apigatewayv2_api.cart.execution_arn}/*/*"
}