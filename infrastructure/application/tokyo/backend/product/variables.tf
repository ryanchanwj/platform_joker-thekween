# ----------------------------------------
# Common
# ----------------------------------------

variable "aws_region" {
  description = "The AWS region to deploy the resources to"
  type        = string
}

variable "app_client_id" {
  default = "7ajhtqgej6i1c09f1u7lm6tqcq"
  type        = string
}