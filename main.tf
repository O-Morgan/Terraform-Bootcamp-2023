terraform {
  required_providers {
    terratowns = {
      source  = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
}
#  cloud {
#   organization = "Owen_Morgan"
#    workspaces {
#      name = "terra-house-of-funk"
#    }
# }
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs
  
  
provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid 
  token = var.terratowns_access_token
  
}
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.teacherseat_user_uuid
  s3_bucket_name = var.s3_bucket_name
  index_html_filepath = "/workspace/terraform-beginner-bootcamp-2023/public/index.html"
  error_html_filepath = "/workspace/terraform-beginner-bootcamp-2023/public/error.html"
  content_version = var.content_version
  assets_path = var.assets_path

}

resource "terratowns_home" "home" {
name = "RetroArcade!"
description = <<DESCRIPTION
A hotdog might not qualify as a sandwich, but when it comes to gaming, I'll gladly debate the most pressing issues of our time, like whether or not to call it a "sandwicheater.
DESCRIPTION
#domain_name = "module.terrahouse_aws.cloudfront.net"
domain_name = "http://3edq3gz.cloudfront.net"
town = "missingo"
content_version = 1
}




