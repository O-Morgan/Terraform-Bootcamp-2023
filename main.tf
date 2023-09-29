

# Random string
# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string


# S3 bucket naming rules
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_metric
resource "aws_s3_bucket" "website_bucket" {

# Bucket Naming Rules
# https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html 
bucket = var.s3_bucket_name


tags = {
    UserUuid = var.user_uuid
  }
}


  
