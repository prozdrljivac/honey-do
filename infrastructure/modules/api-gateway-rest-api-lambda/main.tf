locals {
  all_path_segments = flatten([
    for route in var.routes : [
      for i in range(1, length(split("/", route.path)) + 1) :
        join("/", slice(split("/", route.path), 0, i))
    ]
  ])

  unique_path_segments = toset(local.all_path_segments)

  path_metadata = {
    for path in local.unique_path_segments : path => {
      path_part: element(split("/", path), length(split("/", path)) - 1),
      parent_path: length(split("/", path)) > 1 ? join("/", slice(split("/", path), 0, length(split("/", path)) - 1)) : null
    }
  }

  routes = {
    for route in var.routes :
    "${route.method}-${route.name}" => route
  }
} 

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}

# API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name = "${var.app_name}"
  description = "Daily task manager API for couples"
}

resource "aws_api_gateway_resource" "resource" {
  for_each = local.path_metadata

  path_part   = each.value.path_part
  parent_id   = each.value.parent_path == null ? aws_api_gateway_rest_api.api.root_resource_id : aws_api_gateway_resource.resource[each.value.parent_path].id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "method" {
  for_each = local.routes

  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource[each.value.path].id
  http_method   = each.value.method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  for_each = local.routes

  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource[each.value.path].id
  http_method             = aws_api_gateway_method.method[each.key].http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.lambda[each.key].invoke_arn
}

resource "aws_api_gateway_method_response" "response_200" {
  for_each = local.routes

  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource[each.value.path].id
  http_method             = aws_api_gateway_method.method[each.key].http_method
  status_code = each.value.status_code
}

resource "aws_api_gateway_integration_response" "integration_response" {
  for_each = local.routes

  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource[each.value.path].id
  http_method             = aws_api_gateway_method.method[each.key].http_method
  status_code = aws_api_gateway_method_response.response_200[each.key].status_code

  depends_on = [aws_api_gateway_integration.integration]
}

# Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  for_each = local.routes

  statement_id  = "AllowExecutionFromAPIGateway-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda[each.key].function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/${var.environment}/${each.value.method}/${each.value.path}"
}

resource "aws_lambda_function" "lambda" {
  for_each = local.routes

  filename      = "${path.root}/../backend/${each.value.lambda}/lambda.zip"
  function_name = "${each.value.lambda}"
  role          = aws_iam_role.role.arn
  handler       = "bootstrap"
  runtime       = "provided.al2023"

  source_code_hash = filebase64sha256("${path.root}/../backend/${each.value.lambda}/lambda.zip")
}

# IAM
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "role" {
  name               = "task-lambda-execution"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Stage
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  depends_on = [
    aws_api_gateway_integration.integration
  ]
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name = "${var.environment}"
}
