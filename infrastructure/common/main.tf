provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "sg-region"
  region = "ap-southeast-1"
}

provider "aws" {
  alias  = "hk-region"
  region = "ap-east-1"
}

data "aws_caller_identity" "current" {
}
