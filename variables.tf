variable "terratowns_endpoint" {
  type = string
}

variable "terratowns_access_token" {
  type = string
}

variable "teacherseat_user_uuid" {
  type = string
}

#variable "s3_bucket_name" {
#  type = string
#}

variable "RetroArcade" {
  type = object({
    public_path = string
    content_version = string
  })
}

variable "PizzaCake" {
  type = object({
    public_path = string
    content_version = string

  })
}

#variable "assets_path" {
#  description = "path to assest folder"
#  type = string
#}