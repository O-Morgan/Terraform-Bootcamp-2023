terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Data source should be placed outside the terraform block
data "aws_caller_identity" "current" {}

