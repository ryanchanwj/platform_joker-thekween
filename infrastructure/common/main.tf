provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "sg-region"
  region = "ap-southeast-1"
}

provider "aws" {
  alias  = "tokyo-region"
  region = "ap-northeast-1"
}

terraform {
  backend "s3" {
    bucket = "common-tfstate"
    key = "common/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_caller_identity" "current" {
}
