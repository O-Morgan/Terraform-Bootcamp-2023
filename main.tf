terraform {
required_providers {
terratowns = {
source = "local.providers/local/terratowns"
version = "1.0.0"
}
}
#https://developer.hashicorp.com/terraform/cli/cloud/settings
cloud {
organization = "Owen_Morgan"
hostname = "app.terraform.io"
workspaces {
name = "terra-house-of-funk"
}
}
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs

provider "terratowns" {
endpoint = var.terratowns_endpoint
user_uuid = var.teacherseat_user_uuid
token = var.terratowns_access_token
}

module "home_RetroArcade_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  #s3_bucket_name = var.s3_bucket_name
  public_path = var.RetroArcade.public_path
  content_version = var.RetroArcade.content_version
}

resource "terratowns_home" "home_RetroArcade" {
name = "RetroArcade!"
description = <<DESCRIPTION
A hotdog might not qualify as a sandwich, but when it comes to gaming, I'll gladly debate the most pressing issues of our time, like whether or not to call it a "sandwicheater.
DESCRIPTION
domain_name = module.home_RetroArcade_hosting.domain_name
#domain_name = "http://3edq3gz.cloudfront.net"
town = "gamers-grotto"
content_version = var.RetroArcade.content_version
}


#House No.2


module "home_PizzaCake_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  #s3_bucket_name = var.s3_bucket_name
  public_path = var.PizzaCake.public_path
  content_version = var.PizzaCake.content_version
}

resource "terratowns_home" "home_PizzaCake" {
name = "PizzaCake!"
description = <<DESCRIPTION
"Behold, the magnificent Pizza Cake, a creation that defies the laws of culinary gravity!
DESCRIPTION
domain_name = module.home_PizzaCake_hosting.domain_name
#domain_name = "http://3edq3gz.cloudfront.net"
town = "cooker-cove"
content_version = var.PizzaCake.content_version
}