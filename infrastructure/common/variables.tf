# ----------------------------------------
# Common
# ----------------------------------------

variable "aws_region" {
  description = "The AWS region to deploy the resources to"
  type        = string
  default     = "us-east-1"
}

variable "domain_name_sg" {
  description = "Domain name for Singapore region (Primary)"
  type        = string
}

variable "domain_name_hk" {
  description = "Domain name for Hong Kong region (Secondary)"
  type        = string
}

variable "base_domain" {
  description = "Domain name registered in Route53"
  type        = string
}