provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "us-region"
  region = "us-east-1"
}

provider "aws" {
  alias  = "tokyo-region"
  region = "ap-northeast-1"
}

terraform {
  backend "s3" {
    bucket = "sg-application-tfstate"
    key = "authentication/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

data "aws_caller_identity" "current" {
}
