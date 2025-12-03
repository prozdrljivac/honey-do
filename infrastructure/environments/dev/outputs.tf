output "website_url" {
  description = "URL to access the website"
  value       = module.static_website.website_url
}

output "website_endpoint" {
  description = "S3 website endpoint"
  value       = module.static_website.website_endpoint
}

output "bucket_name" {
  description = "S3 bucket name"
  value       = module.static_website.bucket_name
}

output "api_endpoint" {
  description = "Base API Gateway URL"
  value       = module.api.api_endpoint
}

output "api_endpoint_tasks" {
  description = "URL to test /tasks endpoint"
  value       = "${module.api.api_endpoint}/tasks"
}

output "api_id" {
  description = "API Gateway ID"
  value       = module.api.api_id
}

output "lambda_function_names" {
  description = "Map of Lambda function names by route (key format: path-method)"
  value       = module.api.lambda_function_names
}

output "lambda_functions" {
  description = "Map of all Lambda function details by route (includes ARN, role, log group)"
  value       = module.api.lambda_functions
}
