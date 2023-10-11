
output "bucket_id" {
  description = "The ID of the AWS S3 bucket"
  value       = module.home_RetroArcade_hosting.aws_s3_bucket_id
}


output "website_endpoint" {
  description = "The website endpoint of the S3 bucket"
  value       = module.home_RetroArcade_hosting.website_endpoint
}


output "cloudfront_url" {
  description = "The ID of the AWS CloudFront distribution"
  value       = module.home_RetroArcade_hosting.domain_name
}

