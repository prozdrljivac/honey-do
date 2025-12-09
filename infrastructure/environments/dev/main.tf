terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  required_version = ">= 1.2"
}

provider "aws" {
  region = "eu-north-1"
}

module "static_website" {
  source = "../../modules/s3-static-website"

  environment = var.environment
  bucket_name = var.bucket_name
  source_dir  = var.source_dir

  tags = {
    Environment = var.environment
    Project     = "honey-do"
    ManagedBy   = "terraform"
  }
}

module "api" {
  source = "../../modules/api-gateway-lambda"

  environment = var.environment
  api_name    = var.api_name

  routes = [
    {
      path               = "tasks"
      http_method        = "GET"
      lambda_name        = "${var.api_name}-list-tasks"
      lambda_handler     = "list_tasks.handler"
      lambda_runtime     = "python3.13"
      backend_source_dir = "${path.root}/../../../backend/src/tasks"
    },
    {
      path               = "tasks"
      http_method        = "POST"
      lambda_name        = "${var.api_name}-create-task"
      lambda_handler     = "create_task.handler"
      lambda_runtime     = "python3.13"
      backend_source_dir = "${path.root}/../../../backend/src/tasks"
    },
    {
      path               = "tasks/{id}"
      http_method        = "DELETE"
      lambda_name        = "${var.api_name}-delete-task"
      lambda_handler     = "delete_task.handler"
      lambda_runtime     = "python3.13"
      backend_source_dir = "${path.root}/../../../backend/src/tasks"
    }
  ]

  tags = {
    Environment = var.environment
    Project     = "honey-do"
    ManagedBy   = "terraform"
  }
}
