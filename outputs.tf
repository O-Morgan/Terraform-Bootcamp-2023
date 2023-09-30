output "bucket_name"{
 description =  "Bucket name for our static website hosting" 
 value = module.terrahouse_aws.bucket_name
}

output "website_endpoint" {
    description = "s3 static website hosting endpoint" 
    value = module.terrahouse_aws.website_endpoint
}