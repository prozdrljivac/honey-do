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

  environment        = var.environment
  api_name           = var.api_name
  lambda_name        = var.lambda_name
  lambda_handler     = "list.list"
  lambda_runtime     = "python3.13"
  backend_source_dir = "${path.root}/../../../backend/src/tasks"

  routes = [
    {
      path        = "tasks"
      http_method = "GET"
    },
    # To add POST endpoint tomorrow, just uncomment:
    # {
    #   path        = "tasks"
    #   http_method = "POST"
    # },
  ]

  tags = {
    Environment = var.environment
    Project     = "honey-do"
    ManagedBy   = "terraform"
  }
}
