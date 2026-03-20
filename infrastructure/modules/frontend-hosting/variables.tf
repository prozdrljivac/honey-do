variable "app_name" {
  description = "Application name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "force_destroy_bucket" {
  description = "Flag that enables/disables force destruciton of the bucket and it's contents. Should only be used in dev env."
  type = bool
  default = false
}

