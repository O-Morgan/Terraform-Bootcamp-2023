terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }

#  cloud {
#    organization = "Owen_Morgan"

#    workspaces {
#      name = "terra-house-of-funk"
#    }
# }
#}
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs
  }
  
provider "terratowns" {
  endpoint = "http//localhost:4567"
  user_uuid = "e328f4ab-b99f-421c-84c9-4ccea042c7d1" 
  token = "9b49b3fb-b8e9-483c-b703-97ba88eef8e0"
  
}
#module "terrahouse_aws" 
#  source = "./modules/terrahouse_aws"
#  user_uuid = var.user_uuid
#  s3_bucket_name = var.s3_bucket_name
#  index_html_filepath = "/workspace/terraform-beginner-bootcamp-2023/public/index.html"
#  error_html_filepath = "/workspace/terraform-beginner-bootcamp-2023/public/error.html"
#  content_version = var.content_version
#  assets_path = var.assets_path


  
