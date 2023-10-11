# Local variables - relates to origin Id furhter down
locals {
    s3_origin_id = "MyS3Origin"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control

resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "OAC ${aws_s3_bucket.website_bucket.bucket}"
  description                       = "Origin Access Controls for Static Website Hosting ${aws_s3_bucket.website_bucket.bucket}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Static website hosting for: ${aws_s3_bucket.website_bucket.bucket}"
  default_root_object = "index.html"

 #you would use alias if you were going to put a custom doamin on this
  #aliases = ["mysite.example.com", "yoursite.example.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

 
  price_class = "PriceClass_200"

# specify here any geo restrictions we have set it to none, so we want no geo restrictions - refer to docs for whitelist help

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = {
    UserUuid = var.user_uuid
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "null_resource" "invalidate_cache" {
  triggers = {
    content_version = "${terraform.workspace}"
  }

  provisioner "local-exec" {
    command = <<-EOT
      aws cloudfront create-invalidation \
        --distribution-id ${aws_cloudfront_distribution.s3_distribution.id} \
        --paths "/*"
    EOT
  }
}
