output "api_id" {
  description = "ID of the API Gateway"
  value       = aws_api_gateway_rest_api.api.id
}

output "api_endpoint" {
  description = "Base URL of the API Gateway. Append your resource paths to construct full endpoint URLs (e.g., {api_endpoint}/tasks)"
  value       = aws_api_gateway_stage.api.invoke_url
}

output "api_resources" {
  description = "Map of created API Gateway resources (full_path -> resource object). For nested routes, includes all explicitly defined resources."
  value       = aws_api_gateway_resource.resources
}

output "api_resource_ids" {
  description = "Map of resource paths to their IDs for easy reference"
  value = {
    for path, resource in aws_api_gateway_resource.resources :
    path => resource.id
  }
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.api.function_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.api.arn
}

output "lambda_role_arn" {
  description = "ARN of the Lambda execution role"
  value       = aws_iam_role.lambda.arn
}

output "cloudwatch_log_group" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.lambda.name
}
