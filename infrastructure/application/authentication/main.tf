provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "ap-southeast-1"
  region = "ap-southeast-1"
}

provider "aws" {
  alias = "acm_provider"
  region = "us-east-1"
}

data "aws_caller_identity" "current" {
}
