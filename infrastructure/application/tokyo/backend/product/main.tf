provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "tokyo-application-tfstate"
    key = "backend/product/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

data "aws_caller_identity" "current" {
}
