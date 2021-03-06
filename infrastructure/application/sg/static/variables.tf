# ----------------------------------------
# Common
# ----------------------------------------

variable "aws_region" {
  description = "The AWS region to deploy the resources to"
  type        = string
}
variable "bucket_name" {
  type = string
  description = "The name of the bucket without the www. prefix. Normally domain_name."
}

variable "domain_name" {
  type = string
  description = "Domain name."
}

variable "subject_alternative_names" {
  description = "A list of domains that should be SANs in the issued certificate"
  type        = list(string)
  default     = []
}
