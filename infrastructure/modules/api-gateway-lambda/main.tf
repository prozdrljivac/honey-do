locals {
  unique_paths = distinct([for route in var.routes : route.path])

  resource_hierarchy = {
    for path in local.unique_paths : path => {
      segments    = split("/", path)
      path_part   = element(split("/", path), length(split("/", path)) - 1)
      parent_path = length(split("/", path)) > 1 ? join("/", slice(split("/", path), 0, length(split("/", path)) - 1)) : null
    }
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

resource "aws_api_gateway_resource" "resources" {
  for_each = local.resource_hierarchy

  rest_api_id = aws_api_gateway_rest_api.api.id

  # Use conditional to select parent: root if null, otherwise nested resource
  parent_id = each.value.parent_path == null ? (
    aws_api_gateway_rest_api.api.root_resource_id
    ) : (
    aws_api_gateway_resource.resources[each.value.parent_path].id
  )

  path_part = each.value.path_part
}

resource "aws_api_gateway_method" "methods" {
  for_each = local.routes_map

  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resources[each.value.path].id
  http_method   = each.value.http_method
  authorization = each.value.authorization
}

resource "aws_api_gateway_integration" "integrations" {
  for_each = local.routes_map

  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resources[each.value.path].id
  http_method = aws_api_gateway_method.methods[each.key].http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api[each.key].invoke_arn
}

resource "aws_api_gateway_deployment" "api" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = sha1(jsonencode([
      [for r in aws_api_gateway_resource.resources : r.id],
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
