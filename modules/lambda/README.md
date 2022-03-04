# Lambda Module

Module to deploy a lambda function.

Module can be used to deploy Lambda@Edge functions for security headers using enable_security_headers variable.

### Example usage

#### Default region (All configuration)

```terraform
module "this" {
  source = "../../../modules/project/lambda"

  providers = {
    aws = aws.default-region
  }

  name_suffix = "example"
  description = "example_description"

  enable_security_headers        = false
  enable_single_page_application = false
  lambda_at_edge                 = false
  publish                        = true

  strict_transport_security_header         = "max-age=3333000; includeSubdomains"
  x_content_type_options_header            = "nosniff"
  server_header                            = "server"
  x_frame_options_header                   = "sameorigin"
  referrer_policy_header                   = "unsafe-url"
  x_permitted_cross_domain_policies_header = "all"
  cross_origin_embedder_policy_header      = "unsafe-none"
  cross_origin_opener_policy_header        = "unsafe-none"
  cross_origin_resource_policy_header      = "cross-origin"
  permissions_policy_header                = ""
  clear_site_data_header                   = ""
  content_security_policy_header           = "default-src 'self' example.com;"
  access_control_allow_origin_header       = "example.com"

  handler                                 = "example.lambda_handler"
  source_path                             = "${path.cwd}/lambda-function/example.py"
  runtime                                 = "python3.8"
  timeout                                 = 15
  memory_size                             = 128
  cloudwatch_logs_retention_in_days       = 30
  lambda_kms_key_arn                      = data.aws_kms_key.lambda.arn
  cloudwatch_kms_key_arn                  = data.aws_kms_key.cloudwatch.arn
  create_current_version_allowed_triggers = false

  environment_variables = {
    example_key = "example_value"
  }
  
  attach_network_policy  = true
  vpc_subnet_ids         = ["subnet-example"]
  vpc_security_group_ids = ["sg-example"]

  attach_policy_jsons = true
  policy_jsons        = [data.aws_iam_policy_document.example.json]
  
  tags        = local.default_tags
  custom_tags = local.custom_tags

  # General
  iam_role_permissions_boundary = local.gcc_permissions_boundary_arn
}

```

#### Lambda@Edge Security headers (Default best practices headers)

```terraform
module "security_headers" {
  source = "../../../modules/project/lambda"

  providers = {
    aws = aws.us-east-1
  }

  name_suffix = "example"
  description = "example_description"

  enable_security_headers = true

  timeout                           = 10
  memory_size                       = 128
  cloudwatch_logs_retention_in_days = 30
  lambda_kms_key_arn                = data.aws_kms_key.lambda.arn
  cloudwatch_kms_key_arn            = data.aws_kms_key.cloudwatch.arn

  
  tags        = local.default_tags
  custom_tags = local.custom_tags

  # General
  iam_role_permissions_boundary = local.gcc_permissions_boundary_arn
}

```

#### Lambda@Edge Security headers (Modified headers)

```terraform
module "security_headers" {
  source = "../../../modules/project/lambda"

  providers = {
    aws = aws.us-east-1
  }

  name_suffix = "example"
  description = "example_description"

  enable_security_headers = true

  strict_transport_security_header         = "max-age=3333000; includeSubdomains"
  x_content_type_options_header            = "nosniff"
  server_header                            = "server"
  x_frame_options_header                   = "sameorigin"
  referrer_policy_header                   = "unsafe-url"
  x_permitted_cross_domain_policies_header = "all"
  cross_origin_embedder_policy_header      = "unsafe-none"
  cross_origin_opener_policy_header        = "unsafe-none"
  cross_origin_resource_policy_header      = "cross-origin"
  permissions_policy_header                = "accelerometer=()"
  clear_site_data_header                   = "\"cache\""
  content_security_policy_header           = "default-src 'self' example.com;"
  access_control_allow_origin_header       = "example.com"

  timeout                           = 10
  memory_size                       = 128
  cloudwatch_logs_retention_in_days = 30
  lambda_kms_key_arn                = data.aws_kms_key.lambda.arn
  cloudwatch_kms_key_arn            = data.aws_kms_key.cloudwatch.arn

  tags        = local.default_tags
  custom_tags = local.custom_tags

  # General
  iam_role_permissions_boundary = local.gcc_permissions_boundary_arn
}

```
#### Lambda@Edge Single Page Application w/o security headers

```terraform
module "single_page_application" {
  source = "../../../modules/project/lambda"

  providers = {
    aws = aws.us-east-1
  }

  name_suffix = "example"
  description = "example_description"

  enable_single_page_application = true

  timeout                           = 10
  memory_size                       = 128
  cloudwatch_logs_retention_in_days = 30
  lambda_kms_key_arn                = data.aws_kms_key.lambda.arn
  cloudwatch_kms_key_arn            = data.aws_kms_key.cloudwatch.arn

  tags        = local.default_tags
  custom_tags = local.custom_tags

  # General
  iam_role_permissions_boundary = local.gcc_permissions_boundary_arn
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name                                                                     | Version   |
| ------------------------------------------------------------------------ | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.0.0  |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 3.51.0 |

## Providers

| Name                                             | Version   |
| ------------------------------------------------ | --------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | >= 3.51.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="this"></a> [this](#module\_lambda_malware_ips) | terraform-aws-modules/lambda/aws | 2.18.0 |

## Resources

| Name                                                                                                                                 | Type     |
| ------------------------------------------------------------------------------------------------------------------------------------ | -------- |
| [aws_lambda_alias.latest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_alias)   | resource |
| [local_file.this](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file)   | resource |

## Inputs

| Name                                                                                                                                    | Description                                                                                                                                               | Type                                                                                                                                       | Default                            | Required |
| --------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------- | :------: |
| <a name="input_vpc_security_group_ids"></a> [vpc_security_group_ids](#input_vpc_security_group_ids)                                                    | The name suffix of the resource.                                                                                                                            | `list(string)`                                                                                                                                   | `null`                            |    no    |
| <a name="input_tags"></a> [tags](#input_tags) | A map of tags to add to all resources.                                                                                                        | `object`                                                                                                                                   | n/a                                |   yes    |
| <a name="input_custom_tags"></a> [custom_tags](#input_custom_tags)                                              | A map of custom tags to add to all resources.                                                                                                           | `map(string)`                                                                                                                                     | `null`                            |    no    |
| <a name="input_iam_role_permissions_boundary"></a> [iam_role_permissions_boundary](#input_iam_role_permissions_boundary)                                     | Permission Boundary to attach to an IAM role if the setup is done in GCC.                                                                                                        | `string`                                                                                                                                     | `null`                            |    no    |
| <a name="input_description"></a> [description](#input_description)                                                                      | The description of the Lambda function                                                                                                                     | `string`                                                                                                                              | `null`                             |    no    |
| <a name="input_enable_security_headers"></a> [enable_security_headers](#input_enable_security_headers)                                                                                  | Enabling it utilises default configuration for Lambda@Edge security headers and will ignore inputted variables for lambda_at_edge, publish, handler, source_path and runtime.                                                                                           | `bool`                                                                                                                                   | `false`                             |    no    |
| <a name="input_enable_single_page_application"></a> [enable_single_page_application](#input_enable_single_page_application)                                                                                  | Enabling it adds addition error 403 handling in lambda code for single page applications and will ignore inputted variables for lambda_at_edge, publish, handler, source_path and runtime.                                                                                           | `bool`                                                                                                                                   | `false`                             |    no    |
| <a name="input_lambda_at_edge"></a> [lambda_at_edge](#input_lambda_at_edge)                                                                      | Set this to true if using Lambda@Edge, to enable publishing, limit the timeout, and allow edgelambda.amazonaws.com to invoke the function. Value is strictly set to true if enable_security_headers or enable_single_page_application variable is true.                               | `bool`                                                                                                                                   | `false`                                |   no    |
| <a name="input_publish"></a> [publish](#input_publish)                                                                      | Whether to publish creation/change as new Lambda Function Version. Value is strictly set to true if enable_security_headers or enable_single_page_application variable is true.                                                                                                    | `bool`                                                                                                                                   | `false`                                |   no    |
| <a name="input_handler"></a> [handler](#input_handler)                                                             | Lambda Function entrypoint in your code. Value is strictly set to index.handler if enable_security_headers or enable_single_page_application variable is true.                                                                                                                                  | `string`                                                                                                                                   | `""`                         |    no    |
| <a name="input_runtime"></a> [runtime](#input_runtime)                                                             | Lambda Function runtime. Value is strictly set to nodejs14.x if enable_security_headers or enable_single_page_application variable is true.                                                                                                                                  | `string`                                                                                                                                   | `""`                         |    no    |
| <a name="input_source_path"></a> [source_path](#input_source_path)                                                             | The absolute path to a local file or directory containing your Lambda source code. Value is strictly set to path.module/cf-lambda if enable_security_headers or enable_single_page_application variable is true.                                                                                                                                       | `string`                                                                                                                                   | `null`                    |    no    |
| <a name="input_timeout"></a> [timeout](#input_timeout)                                                                      | The amount of time your Lambda Function has to run in seconds.                                                                                | `number`                                                                                                                                     | `10`                            |    no    |
| <a name="input_memory_size"></a> [memory_size](#input_memory_size)                                     | Amount of memory in MB your Lambda Function can use at runtime. Valid value between 128 MB to 10,240 MB (10 GB), in 64 MB increments.                                                                                                          | `number`                                                                                                                                     | `128`                            |    no    |
| <a name="input_lambda_kms_key_arn"></a> [lambda_kms_key_arn](#input_lambda_kms_key_arn)                                           | SThe ARN of KMS key that the Lambda Function will use to encrypt environment variables.                                                                | `string`                                                                                                                                   | `null`                            |    no    |
| <a name="input_attach_network_policy"></a> [attach_network_policy](#input_attach_network_policy)                                              | Controls whether VPC/network policy should be added to IAM role for Lambda Function.     | `bool`                                                                                                                                   | `false`                               |    no    |
| <a name="input_vpc_subnet_ids"></a> [vpc_subnet_ids](#input_vpc_subnet_ids)                                              | A list of subnet ids to associate with the Lambda function to run in the VPC.                                                                                                            | `list(string)`                                                                                                                                   | `null`                             |    no    |
| <a name="input_vpc_security_group_ids"></a> [vpc_security_group_ids](#input_vpc_security_group_ids)                                                                      | TList of security group ids when Lambda Function should run in the VPC.                                                                                                                           | `list(string)`                                                                                                                                   | `null`                                |   no    |
| <a name="input_attach_policy_jsons"></a> [attach_policy_jsons](#input_attach_policy_jsons)                               | Controls whether policy_jsons should be added to IAM role for Lambda Function.                                                                                                                       | `bool`                                                                                                                                   | `false`    |    no    |
| <a name="input_policy_jsons"></a> [policy_jsons](#input_policy_jsons)                                                    | List of additional policy documents as JSON to attach to Lambda Function role.          | `list(string)`                                                                                                                                   | `[]`                             |    no    |
| <a name="input_create_current_version_allowed_triggers"></a> [create_current_version_allowed_triggers](#input_create_current_version_allowed_triggers)                                                                                  | Whether to allow triggers on current version of Lambda Function (this will revoke permissions from previous version because Terraform manages only current resources).                                                                                                                                  | `bool` | `true`                               |    no    |
| <a name="input_environment_variables"></a> [environment_variables](#input_environment_variables)                      | A map that defines environment variables for the Lambda Function.                                                                                                                    | `map(string)`                                                                                                                                   | `{}` |    no    |
| <a name="input_strict_transport_security_header"></a> [strict_transport_security_header](#input_strict_transport_security_header)                                     | Value of Strict-Transport-Security header. Default to OWASP recommended best practice.                                                                                                                     | `string`                                                                                                                                   | `"max-age=31536000; includeSubdomains"`                       |    no    |
| <a name="input_x_content_type_options_header"></a> [x_content_type_options_header](#input_x_content_type_options_header)                                     | Value of X-Content-Type-Options header. Default to OWASP recommended best practice.                                                                                                                      | `string`                                                                                                                                   | `"nosniff"`                       |    no    |
| <a name="input_content_security_policy_header"></a> [content_security_policy_header](#input_content_security_policy_header)                                     | Value of Content-Security-Policy header. Default to OWASP recommended best practice.                                                                                                                      | `string`                                                                                                                                   | `"default-src 'self'; object-src 'none'; child-src 'self'; frame-ancestors 'none'; upgrade-insecure-requests; block-all-mixed-content"`                       |    no    |
| <a name="input_server_header"></a> [server_header](#input_server_header)                                     | Value of server header.                                                                                                                  | `string`                                                                                                                                   | `""`                       |    no    |
| <a name="input_x_frame_options_header"></a> [x_frame_options_header](#input_x_frame_options_header)                                     | VValue of X-Frame-Options header. Default to OWASP recommended best practice.                                                                                                                      | `string`                                                                                                                                   | `"deny"`                       |    no    |
| <a name="input_referrer_policy_header"></a> [referrer_policy_header](#input_referrer_policy_header)                                     | Value of Referrer-Policy header. Default to OWASP recommended best practice.                                                                                                                      | `string`                                                                                                                                   | `"no-referrer"`                       |    no    |
| <a name="input_x_permitted_cross_domain_policies_header"></a> [x_permitted_cross_domain_policies_header](#input_x_permitted_cross_domain_policies_header)                                     | Value of X-Permitted-Cross-Domain-Policies header. Default to OWASP recommended best practice.                                                                                                                      | `string`                                                                                                                                   | `"none"`                       |    no    |
| <a name="input_cross_origin_embedder_policy_header"></a> [cross_origin_embedder_policy_header](#input_cross_origin_embedder_policy_header)                                     | Value of Cross-Origin-Embedder-Policy header. Default to OWASP recommended best practice.                                                                                                                      | `string`                                                                                                                                   | `"require-corp"`                       |    no    |
| <a name="input_cross_origin_opener_policy_header"></a> [cross_origin_opener_policy_header](#input_cross_origin_opener_policy_header)                                     | Value of Cross-Origin-Opener-Policy header. Default to OWASP recommended best practice.                                                                                                                      | `string`                                                                                                                                   | `"same-origin"`                       |    no    |
| <a name="input_cross_origin_resource_policy_header"></a> [cross_origin_resource_policy_header](#input_cross_origin_resource_policy_header)                                     | Value of X-Permitted-Cross-Domain-Policies header. Default to OWASP recommended best practice.                                                                                                                      | `string`                                                                                                                                   | `"same-origin"`                       |    no    |
| <a name="input_permissions_policy_header"></a> [permissions_policy_header](#input_permissions_policy_header)                                     | Value of Permissions-Policy header. Default to OWASP recommended best practice.                                                                                                                      | `string`                                                                                                                                   | `"accelerometer=(), ambient-light-sensor=(), autoplay=(), battery=(), camera=(), cross-origin-isolated=(), display-capture=(), document-domain=(), encrypted-media=(), execution-while-not-rendered=(), execution-while-out-of-viewport=(), fullscreen=(), geolocation=(), gyroscope=(), keyboard-map=(), magnetometer=(), microphone=(), midi=(), navigation-override=(), payment=(), picture-in-picture=(), publickey-credentials-get=(), screen-wake-lock=(), sync-xhr=(), usb=(), web-share=(), xr-spatial-tracking=(), clipboard-read=(), clipboard-write=(), gamepad=(), speaker-selection=()"`                       |    no    |
| <a name="input_clear_site_data_header"></a> [clear_site_data_header](#input_clear_site_data_header)                                     | Value of Clear-Site-Data header. Default to OWASP recommended best practice.                                                                                                                      | `list(string)`                                                                                                                                   | `"\"cache\",\"cookies\",\"storage\""`                       |    no    |
| <a name="input_access_control_allow_origin_header"></a> [access_control_allow_origin_header](#input_access_control_allow_origin_header)                                           | Value of Access-Control-Allow-Origin header. | `string`                                                                                                                                   | `""`                             |    no    |
| <a name="input_cloudwatch_logs_retention_in_days"></a> [cloudwatch_logs_retention_in_days](#input_cloudwatch_logs_retention_in_days)                                                                         | Number of days to retain log events. Default retention - 90 days.                                                                                                                      | `number`                                            | `90`                               |    no    |
| <a name="input_cloudwatch_kms_key_arn"></a> [cloudwatch_kms_key_arn](#input_cloudwatch_kms_key_arn)                                     | The KMS key will be used to encrypt the corresponding log group. Please be sure that the KMS Key has an appropriate key policy.                                                                                                                      | `string`                                                                                                                                   | `null`                                |   no    |

## Outputs

| Name                                            | Description  |
| ----------------------------------------------- | ------------ |
| <a name="output_lambda"></a> [lambda](#output_lambda) | Lambda Resource |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
