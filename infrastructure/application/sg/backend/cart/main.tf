provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "sg-application-tfstate"
    key = "backend/cart/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

provider "aws" {
  alias  = "us-region"
  region = "us-east-1"
}

data "aws_caller_identity" "current" {
}
