variable "bucket_name" {
  description = "Name of the S3 bucket that stores static-site assets."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.bucket_name))
    error_message = "Bucket name must be lowercase alphanumeric with hyphens."
  }
}

variable "environment" {
  description = "Deployment environment (e.g., dev, stg, prod)."
  type        = string

  validation {
    condition     = contains(["dev", "stg", "prod"], var.environment)
    error_message = "Environment must be one of 'dev', 'stg', or 'prod'."
  }
}

variable "source_dir" {
  description = "Local directory containing the static website files to be uploaded to the S3 bucket."
  type        = string
}

variable "index_document" {
  description = "Index document for the website"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "Error document for the website (use index.html for SPA routing)"
  type        = string
  default     = "index.html"
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
