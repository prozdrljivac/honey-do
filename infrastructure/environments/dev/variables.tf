variable "environment" {
  description = "Environment name"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name for static website"
  type        = string
}

variable "source_dir" {
  description = "Path to the dist directory"
  type        = string
}
