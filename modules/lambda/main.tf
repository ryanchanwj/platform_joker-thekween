module "this" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "2.18.0"

  function_name = var.function_name
  description   = var.description

  handler = var.handler

  source_path = [{
    path = var.source_path,
  }]

  create_package = var.create_package

  create_role = false
  lambda_role = var.lambda_role

  environment_variables = var.environment_variables

  runtime                           = var.runtime
  timeout                           = var.timeout
  memory_size                       = var.memory_size
  cloudwatch_logs_retention_in_days = var.cloudwatch_logs_retention_in_days
  kms_key_arn                       = var.lambda_kms_key_arn

  # Configure Lambda in a VPC
  attach_network_policy  = var.attach_network_policy
  vpc_subnet_ids         = var.vpc_subnet_ids
  vpc_security_group_ids = var.vpc_security_group_ids

  #Use custom policy for Lambda
  attach_policy_jsons               = length(var.policy_jsons) > 0 ? true : var.attach_policy_jsons
  policy_jsons                      = var.policy_jsons

  # Permissions boundary required for GCCR setup
  role_permissions_boundary = var.iam_role_permissions_boundary

  # Cloudwatch
  use_existing_cloudwatch_log_group = false
  create_current_version_allowed_triggers = var.create_current_version_allowed_triggers
}

resource "aws_lambda_alias" "latest" {
  name             = "latest"
  description      = "Latest version of Lambda"
  function_name    = module.this.lambda_function_arn
  function_version = module.this.lambda_function_version
}