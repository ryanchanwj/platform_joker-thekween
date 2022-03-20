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

variable "base_domain" {
  default     = "jokerandthekween.click"
  description = "Domain name registered in Route53"
  type        = string
}

variable "s3_reports" {
  default     = "jokerandthekween.click-reports"
  type        = string
}

variable "get_products_function_name" {
  default     = "view_products"
  type        = string
}