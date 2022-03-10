resource "aws_s3_bucket_object" "add_product" {
  bucket = data.aws_s3_bucket.lambda_functions.id

  key    = "add_product.zip"
  source = data.archive_file.add_product.output_path

  etag = filemd5(data.archive_file.add_product.output_path)
}

resource "aws_lambda_function" "add_product" {
   function_name = "add_product"

   s3_bucket = data.aws_s3_bucket.lambda_functions.id
   s3_key    = aws_s3_bucket_object.add_product.id

   
   handler = "add_product.handler"
   runtime = "nodejs12.x"

   role = aws_iam_role.cart.arn
}

module "lambda_add_product" {
   source      = "../../../../../modules/lambda"

   function_name = "add_product"

   source_path = "${path.cwd}/functions/add_product"
   lambda_role = aws_iam_role.cart.arn

   runtime = "nodejs12.x"
   handler = "add_product.handler"


   depends_on = [
     aws_iam_role.cart
   ]
}

resource "aws_lambda_permission" "add_product" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = module.lambda_add_product.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_apigatewayv2_api.cart.execution_arn}/*/*"
}