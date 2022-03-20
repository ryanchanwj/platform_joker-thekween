# ----------------------------------------
# Common
# ----------------------------------------

variable "aws_region" {
  description = "The AWS region to deploy the resources to"
  type        = string
}

variable "app_client_id" {
  default = "2gob0c8744aql2q60gn1n30dk9"
  type    = string
}

variable "create_order_function_name" {
  default = "create_order"
  type    = string
}

variable "get_product_function_name" {
  default = "get_product"
  type    = string
}

variable "update_product_function_name" {
  default = "update_product"
  type    = string
}

variable "s3_reports" {
  default     = "jokerandthekween.click-reports"
  type        = string
}