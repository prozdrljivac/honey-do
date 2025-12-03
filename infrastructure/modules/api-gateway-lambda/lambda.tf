resource "aws_iam_role" "lambda" {
  for_each = local.routes_map

  name = "${each.value.lambda_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "${each.value.lambda_name}-role"
    }
  )
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  for_each = local.routes_map

  role       = aws_iam_role.lambda[each.key].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_cloudwatch_log_group" "lambda" {
  for_each = local.routes_map

  name              = "/aws/lambda/${each.value.lambda_name}"
  retention_in_days = 7

  tags = merge(
    var.tags,
    {
      Name = "${each.value.lambda_name}-logs"
    }
  )
}

data "archive_file" "lambda" {
  for_each = local.routes_map

  type        = "zip"
  source_dir  = each.value.backend_source_dir
  output_path = "${path.module}/.terraform/lambda_${each.value.lambda_name}.zip"
}

resource "aws_lambda_function" "api" {
  for_each = local.routes_map

  filename         = data.archive_file.lambda[each.key].output_path
  function_name    = each.value.lambda_name
  role             = aws_iam_role.lambda[each.key].arn
  handler          = each.value.lambda_handler
  runtime          = each.value.lambda_runtime
  memory_size      = var.lambda_memory
  timeout          = var.lambda_timeout
  source_code_hash = data.archive_file.lambda[each.key].output_base64sha256

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda,
    aws_iam_role_policy_attachment.lambda_basic
  ]

  tags = merge(
    var.tags,
    {
      Name = each.value.lambda_name
    }
  )
}
