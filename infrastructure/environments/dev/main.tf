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
