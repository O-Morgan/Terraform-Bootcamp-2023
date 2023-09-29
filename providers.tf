terraform {
#  cloud {
#    organization = "Owen_Morgan"

#    workspaces {
#      name = "terra-house-of-funk"
#    }
# }
#}
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs
  }
   terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  # Configuration options
}


provider "random" {
  # Configuration options
  }