# ----------------------------------------
# Common
# ----------------------------------------

variable "aws_region" {
  description = "The AWS region to deploy the resources to"
  type        = string
}

variable "app_client_id" {
  default = "2gob0c8744aql2q60gn1n30dk9"
  type        = string
}