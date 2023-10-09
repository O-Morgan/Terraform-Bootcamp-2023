variable "user_uuid" {
  description = "User UUID"
  type        = string

  validation {
    condition     = can(regex("^([a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12})$", var.user_uuid))
    error_message = "User UUID must be in the format of a UUID (e.g., xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)"
  }
}


variable "s3_bucket_name" {
  description = "The name of the AWS S3 bucket"
  type        = string

  validation {
    condition = can(regex("^([a-zA-Z0-9.-]+)$", var.s3_bucket_name))
    error_message = "Invalid bucket name. The name must consist of letters, numbers, periods, or hyphens."
  }
}

variable "index_html_filepath" {
  description = "The file path for index.html"
  type        = string

  validation {
    condition     = fileexists(var.index_html_filepath)
    error_message = "The provided path for index.html does not exist"
  }
}

variable "error_html_filepath" {
  description = "The file path for error.html"
  type        = string

  validation {
    condition     = fileexists(var.error_html_filepath)
    error_message = "The provided path for error.html does not exist"
  }
}

 variable "content_version" {
  description = "Content Versioning"
  type        = number
  default     = 1
  validation {
    condition = var.content_version >= 1 && floor(var.content_version) == var.content_version
    error_message = "Content version must be a positive integer starting at 1."
  }
}

variable "assets_path" {
  description = "path to assest folder"
  type = string
}

variable "style_css_filepath" {
  description = "The file path to style.css"
  default     = "/workspace/terraform-beginner-bootcamp-2023/public/assets/style.css"  # Updated default path
}


