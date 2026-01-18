provider "aws" {
  region = "eu-north-1"
}

module "honey_do_api" {
  source = "./modules/api-gateway-rest-api-lambda"

  app_name    = var.app_name
  environment = var.environment
  # Let's say I want to define routes here
  # routes = [
  #   {
  #     path: "tasks",
  #     method: "GET",
  #     lambda: "list-tasks",
  #     status_code: "200",
  #   }
  # ]
}
