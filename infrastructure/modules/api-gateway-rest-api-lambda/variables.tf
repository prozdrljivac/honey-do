variable "app_name" {
	description = "Application name"
	type = string
}

variable "environment" {
	description = "Environment name"
	type = string
}

variable "routes" {
  description = "Defines routes for our API"
  type = list(object({
    name = string
    path = string
    method = string
    lambda = string
    status_code = string
  }))
}
