variable "environment" {
  description = "Environment name (dev, stg, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "stg", "prod"], var.environment)
    error_message = "Environment must be dev, stg or prod."
  }
}

variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
}

variable "lambda_memory" {
  description = "Lambda memory in MB (also affects CPU)"
  type        = number
  default     = 128

  validation {
    condition     = var.lambda_memory >= 128 && var.lambda_memory <= 10240
    error_message = "Lambda memory must be between 128 and 10240 MB."
  }
}

variable "lambda_timeout" {
  description = "Lambda timeout in seconds"
  type        = number
  default     = 10

  validation {
    condition     = var.lambda_timeout >= 1 && var.lambda_timeout <= 900
    error_message = "Lambda timeout must be between 1 and 900 seconds."
  }
}

variable "routes" {
  description = "List of API routes with their HTTP methods"
  type = list(object({
    path               = string
    http_method        = string
    lambda_name        = string
    lambda_handler     = string
    lambda_runtime     = string
    backend_source_dir = string
    authorization      = optional(string, "NONE")
  }))

  validation {
    condition = alltrue([
      for route in var.routes : contains(["GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS", "HEAD"], route.http_method)
    ])
    error_message = "HTTP method must be one of: GET, POST, PUT, DELETE, PATCH, OPTIONS, HEAD."
  }

  validation {
    condition = alltrue([
      for route in var.routes : route.path != ""
    ])
    error_message = "Path cannot be empty. Root path routes (/) are not supported. All routes must be under a resource path (e.g., 'tasks', 'users')."
  }

  validation {
    condition = alltrue([
      for route in var.routes : can(regex("^[a-zA-Z0-9/_{}\\-]+$", route.path))
    ])
    error_message = "Path must contain only alphanumeric characters, slashes, hyphens, underscores, and curly braces for parameters."
  }

  validation {
    condition = alltrue([
      for route in var.routes : !can(regex("^/", route.path))
    ])
    error_message = "Paths should not start with a leading slash."
  }

  validation {
    condition = alltrue([
      for route in var.routes : !can(regex("/$", route.path))
    ])
    error_message = "Paths should not end with a trailing slash."
  }

  validation {
    condition = alltrue(flatten([
      for route in var.routes : [
        for i in range(1, length(split("/", route.path))) :
        contains([for r in var.routes : r.path], join("/", slice(split("/", route.path), 0, i)))
      ]
    ]))
    error_message = "All parent path segments must be explicitly defined in routes. For example, if you define 'tasks/{id}/comments', you must also define 'tasks' and 'tasks/{id}'."
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
