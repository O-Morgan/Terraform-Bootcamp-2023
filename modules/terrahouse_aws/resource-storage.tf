  # Configuration options


# Random string
# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string


# S3 bucket naming rules
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_metric
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.s3_bucket_name
}



# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.id
  key = "index.html"
  source = var.index_html_filepath
  content_type = "text/html"

  etag = filemd5(var.index_html_filepath)

  lifecycle {
    ignore_changes = [etag]
    replace_triggered_by = [terraform_data.content_version.output]
       
    }
  }

resource "aws_s3_object" "upload_assets" {
  for_each = fileset(var.assets_path, "*.{jpg,png,gif,css,jpeg}")
  bucket   = aws_s3_bucket.website_bucket.id
  key      = "assets/${each.key}"
  source   = "${var.assets_path}/${each.key}"  # Remove the trailing slash
  etag     = filemd5("${var.assets_path}/${each.key}")  # Include a slash here
  lifecycle {
    ignore_changes       = [etag]
    replace_triggered_by = [terraform_data.content_version.output]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object

resource "aws_s3_object" "error_html" {
  bucket = aws_s3_bucket.website_bucket.id
  key    = "error.html"
  source = var.error_html_filepath
  content_type = "text/html"

  etag   = filemd5(var.error_html_filepath)
  
  #lifecycle {
   # ignore_changes = [etag]
 # }
}
# or // at the beginning of each comment line. This should resolve the "Unsupported block type" error you were encountering.

resource "aws_s3_object" "css" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "assets/style.css"  # S3 object key
  source       = var.style_css_filepath  # Use the variable
  content_type = "text/css"
}


# Define a dependency on the content_version variable to trigger updates.
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

# now managed like a resource,control the state of the version just an imaginer object linke to variables and the trigger.
resource "terraform_data" "content_version" {
  input = var.content_version
}




