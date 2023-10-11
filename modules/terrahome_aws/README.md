## Terrahome AWS


```t
module "home_RetroArcade" {
source = "./modules/terrahome_aws"
user_uuid = var.teacherseat_user_uuid
s3_bucket_name = var.s3_bucket_name
public_path = var.RetroArcade_public_path
content_version = var.content_version
}
```

The public directory expects the following
- index.html
- error.html
- assets

All top level files in assets will be copied, but not any subdirectories.
