# ----------------------------------------
# General
# ----------------------------------------

variable "iam_role_permissions_boundary" {
  type        = string
  description = "Permission Boundary to attach to an IAM role if the setup is done in GCC."
  default     = null
}

# ----------------------------------------
# Lambda
# ----------------------------------------

variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "description" {
  description = "The description of the Lambda function"
  type        = string
  default     = null
}

variable "handler" {
  description = "Lambda Function entrypoint in your code. Value is strictly set to index.handler if enable_security_headers or enable_single_page_application variable is true."
  type        = string
}

variable "source_path" {
  description = "The absolute path to a local file or directory containing your Lambda source code. Value is strictly set to path.module/cf-lambda if enable_security_headers or enable_single_page_application variable is true."
  type        = string
}

variable "runtime" {
  description = "Lambda Function runtime. Value is strictly set to nodejs14.x if enable_security_headers or enable_single_page_application variable variable is true."
  type        = string
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
  type        = number
  default     = 10
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime. Valid value between 128 MB to 10,240 MB (10 GB), in 64 MB increments."
  type        = number
  default     = 128
}

variable "lambda_kms_key_arn" {
  description = "The ARN of KMS key that the Lambda Function will use to encrypt environment variables."
  type        = string
  default     = null
}

variable "lambda_role" {
  description = " IAM role ARN attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to. See Lambda Permission Model for more details."
  type        = string
  default     = ""
}

variable "attach_network_policy" {
  description = "Controls whether VPC/network policy should be added to IAM role for Lambda Function."
  type        = bool
  default     = false
}

variable "vpc_subnet_ids" {
  description = "A list of subnet ids to associate with the Lambda function to run in the VPC."
  type        = list(string)
  default     = null
}

variable "vpc_security_group_ids" {
  description = "List of security group ids when Lambda Function should run in the VPC."
  type        = list(string)
  default     = null
}

variable "attach_policy_jsons" {
  description = "Controls whether policy_jsons should be added to IAM role for Lambda Function."
  type        = bool
  default     = false
}

variable "policy_jsons" {
  description = "List of additional policy documents as JSON to attach to Lambda Function role."
  type        = list(string)
  default     = []
}

variable "create_current_version_allowed_triggers" {
  description = "Whether to allow triggers on current version of Lambda Function (this will revoke permissions from previous version because Terraform manages only current resources)."
  type        = bool
  default     = true
}

variable "environment_variables" {
  description = "A map that defines environment variables for the Lambda Function."
  type        = map(any)
  default     = {}
}

# ----------------------------------------
# Cloudwatch
# ----------------------------------------

variable "cloudwatch_logs_retention_in_days" {
  description = "Number of days to retain log events. Default retention - 90 days."
  type        = number
  default     = 90
}

variable "cloudwatch_kms_key_arn" {
  description = "The KMS key will be used to encrypt the corresponding log group. Please be sure that the KMS Key has an appropriate key policy."
  type        = string
  default     = null
}

