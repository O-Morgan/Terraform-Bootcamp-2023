output "bucket_name" {
  value = aws_s3_bucket.website_bucket.id
}

output "website_endpoint" {
   value = aws_s3_bucket.website_bucket
}