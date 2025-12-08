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
  value       = local.all_resources
}

output "api_resource_ids" {
  description = "Map of resource paths to their IDs for easy reference"
  value = {
    for path, resource in local.all_resources :
    path => resource.id
  }
}

output "lambda_functions" {
  description = "Map of Lambda functions by route key (path-method format, e.g., 'tasks-GET'). Each entry contains function details."
  value = {
    for key, lambda in aws_lambda_function.api :
    key => {
      function_name = lambda.function_name
      arn          = lambda.arn
      invoke_arn   = lambda.invoke_arn
      role_arn     = aws_iam_role.lambda[key].arn
      log_group    = aws_cloudwatch_log_group.lambda[key].name
    }
  }
}

output "lambda_function_names" {
  description = "Map of route keys to Lambda function names"
  value = {
    for key, lambda in aws_lambda_function.api :
    key => lambda.function_name
  }
}

output "lambda_function_arns" {
  description = "Map of route keys to Lambda function ARNs"
  value = {
    for key, lambda in aws_lambda_function.api :
    key => lambda.arn
  }
}
