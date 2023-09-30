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
  

module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  s3_bucket_name = var.s3_bucket_name
  index_html_filepath = "/workspace/terraform-beginner-bootcamp-2023/public/index.html"
  error_html_filepath = "/workspace/terraform-beginner-bootcamp-2023/public/error.html"
}

  
