locals {
  unique_paths = distinct([for route in var.routes : route.path])

  resource_hierarchy = {
    for path in local.unique_paths : path => {
      segments    = split("/", path)
      depth       = length(split("/", path))
      path_part   = element(split("/", path), length(split("/", path)) - 1)
      parent_path = length(split("/", path)) > 1 ? join("/", slice(split("/", path), 0, length(split("/", path)) - 1)) : null
    }
  }

  level_1_resources = {
    for path, attrs in local.resource_hierarchy :
    path => attrs if attrs.depth == 1
  }

  level_2_resources = {
    for path, attrs in local.resource_hierarchy :
    path => attrs if attrs.depth == 2
  }

  routes_map = { for route in var.routes : "${route.path}-${route.http_method}" => route }
}

resource "aws_api_gateway_rest_api" "api" {
  name        = var.api_name
  description = "REST API for ${var.api_name}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = merge(
    var.tags,
    {
      Name = var.api_name
    }
  )
}

# Level 1 resources (direct children of root)
resource "aws_api_gateway_resource" "level_1" {
  for_each = local.level_1_resources

  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = each.value.path_part
}

# Level 2 resources (children of level 1)
resource "aws_api_gateway_resource" "level_2" {
  for_each = local.level_2_resources

  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.level_1[each.value.parent_path].id
  path_part   = each.value.path_part
}

locals {
  # Unified resource lookup for downstream compatibility
  all_resources = merge(
    aws_api_gateway_resource.level_1,
    aws_api_gateway_resource.level_2
  )
}

resource "aws_api_gateway_method" "methods" {
  for_each = local.routes_map

  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = local.all_resources[each.value.path].id
  http_method   = each.value.http_method
  authorization = each.value.authorization
}

resource "aws_api_gateway_integration" "integrations" {
  for_each = local.routes_map

  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = local.all_resources[each.value.path].id
  http_method = aws_api_gateway_method.methods[each.key].http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api[each.key].invoke_arn
}

resource "aws_api_gateway_deployment" "api" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = sha1(jsonencode([
      [for r in local.all_resources : r.id],
      [for m in aws_api_gateway_method.methods : m.id],
      [for i in aws_api_gateway_integration.integrations : i.id],
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_method.methods,
    aws_api_gateway_integration.integrations,
  ]
}

resource "aws_api_gateway_stage" "api" {
  deployment_id = aws_api_gateway_deployment.api.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = var.environment

  tags = merge(
    var.tags,
    {
      Name = "${var.api_name}-${var.environment}"
    }
  )
}

resource "aws_lambda_permission" "api_gateway" {
  for_each = local.routes_map

  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api[each.key].function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}
