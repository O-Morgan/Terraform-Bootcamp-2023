# Configuration options



# S3 bucket naming rules
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_metric
resource "aws_s3_bucket" "website_bucket" {
#  bucket = var.s3_bucket_name
#
}


# Random string
resource "random_string" "bucket_suffix" {
  length  = 4
  special = false
}

# S3 bucket naming rules
resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.website_bucket.bucket
    
    index_document {
      suffix = "index.html"
    }

    error_document {
      key = "error.html"
    }
  }



# Modify other resources to use aws_s3_bucket.website_bucket.id as needed


# AWS S3 objects
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.website_bucket.bucket
  key          = "index.html"
  source = "${var.public_path}/index.html"
  content_type = "text/html"

  etag = filemd5("${var.public_path}/index.html")

  lifecycle {
    ignore_changes       = [etag]
    replace_triggered_by = [terraform_data.content_version.output]
  }
}


#House No.1

resource "aws_s3_object" "upload_assets" {
  for_each = fileset("${var.public_path}/assets", "*.{jpg,png,gif,css,jpeg}")
  bucket = aws_s3_bucket.website_bucket.bucket
  key = "assets/${each.key}"
  source = "${var.public_path}/assets/${each.key}"
  etag = filemd5("${var.public_path}/assets/${each.key}")

  lifecycle {
    ignore_changes = [etag]
    replace_triggered_by = [terraform_data.content_version.output]
  }
}

resource "aws_s3_object" "error_html" {
  bucket       = aws_s3_bucket.website_bucket.bucket 
  key          = "error.html"
  source       = "${var.public_path}/error.html"
  content_type = "text/html"

  etag = filemd5("${var.public_path}/error.html")
}

# Modify other existing resources to use the `aws_s3_bucket.pizza_cake_bucket.id` as needed.




# Define a dependency on the content_version variable to trigger updates.

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.bucket

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipalReadOnly",
        Effect    = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
          }
        }
      }
    ]
  })
}

# Now managed like a resource, control the state of the version just an imaginary object linked to variables and the trigger.
resource "terraform_data" "content_version" {
  input = var.content_version
}
