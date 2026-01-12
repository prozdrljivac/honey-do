provider "aws" {
  region = "eu-north-1"
}

module "honey_do_api" {
  source = "./modules/api-gateway-rest-api-lambda"

  app_name    = var.app_name
  environment = var.environment
}
