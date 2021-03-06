provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "sg-application-tfstate"
    key = "static/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

data "aws_caller_identity" "current" {
}
