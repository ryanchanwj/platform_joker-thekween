provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "sg-application-tfstate"
    key = "backend/product/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

data "aws_caller_identity" "current" {
}
