# module "lambda_pre_auth" {
#    source      = "../../../../modules/lambda"

#    function_name = "pre_auth"

#    source_path = "${path.cwd}/functions/pre_auth"
#    lambda_role = aws_iam_role.pre_auth.arn

#    runtime = "nodejs12.x"
#    handler = "pre_auth.handler"


#    depends_on = [
#      aws_iam_role.pre_auth
#    ]
# }