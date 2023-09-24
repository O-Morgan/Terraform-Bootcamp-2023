terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}

provider "aws" {
  # Configuration options
}

provider "random" {
  # Configuration options
}
# Random string
# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
resource "random_string" "bucket_name" {
  lower            = true
  upper            = false
  length           = 32
  special          = false
  }

# S3 bucket naming rules
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_metric
resource "aws_s3_bucket" "example"{

# Bucket Naming Rules
# https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html 
bucket = random_string.bucket_name.result
}

output "random_bucket_name" {
 value = random_string.bucket_name.result
}


  
