provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "tokyo-application-tfstate"
    key = "backend/cart/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  alias  = "us-region"
  region = "us-east-1"
}

data "aws_caller_identity" "current" {
}
