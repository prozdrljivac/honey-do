resource "aws_api_gateway_rest_api" "tasks_api" {
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "tasks api"
      version = "1.0"
    }
    paths = {
      "/tasks" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "GET"
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "https://ip-ranges.amazonaws.com/ip-ranges.json"
          }
        }
      }
    }
  })

  name = "${var.app_name}-api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "tasks_deployment" {
  rest_api_id = aws_api_gateway_rest_api.tasks_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.tasks_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "tasks_stage" {
  deployment_id = aws_api_gateway_deployment.tasks_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.tasks_api.id
  stage_name    = "${var.environment}"
}
