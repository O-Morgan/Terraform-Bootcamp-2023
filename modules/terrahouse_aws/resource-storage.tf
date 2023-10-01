  # Configuration options


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
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration

resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.website_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object


resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.id
  key    = "index.html"
  source = (var.index_html_filepath)
  content_type = "text/html"

  etag   = filemd5(var.index_html_filepath)
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object

resource "aws_s3_object" "error_html" {
  bucket = aws_s3_bucket.website_bucket.id
  key    = "error.html"
  source = (var.error_html_filepath)
  content_type = "text/html"

  etag   = filemd5(var.error_html_filepath)
}

#policy =data.aws_iam_policy_document.allow_access_from_another_account.json
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "AllowCloudFrontServicePrincipalReadOnly",
        Effect = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action = "s3:GetObject",
        Resource = "${aws_s3_bucket.website_bucket.arn}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
          }
        }
      }
    ]
  })
}
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity (to get account ID where ive put it in main.tf)
                
    #We could of just used this - "AWS:SourceaArn": data.aws_caller_identity.current.arn
       

    