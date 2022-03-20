module "lambda_cross_region" {
   source      = "../../../../../modules/lambda"

   function_name = "cognito_cross_region"

   source_path = "${path.cwd}/functions/cross_region"
   lambda_role = aws_iam_role.auth.arn

   runtime = "nodejs12.x"
   handler = "cross_region.handler"

   environment_variables = {
      UserPoolId: tolist(data.aws_cognito_user_pools.tokyo.ids)[0],
      CognitoRegion: "ap-northeast-1",
   }

   depends_on = [
     aws_iam_role.auth
   ]
}

resource "aws_lambda_permission" "cross_region" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = module.lambda_cross_region.function_name
   principal     = "cognito-idp.amazonaws.com"
   source_arn    = aws_cognito_user_pool.user_pool.arn
   depends_on = [
      module.lambda_cross_region
   ]
}