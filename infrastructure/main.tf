provider "aws" {
  region = "eu-north-1"
}

module "honey_do_api" {
  source = "./modules/api-gateway-rest-api-lambda"

  app_name    = var.app_name
  environment = var.environment
  routes = [
    {
      name        = "list-tasks"
      path        = "tasks"
      method      = "GET"
      lambda      = "list-tasks"
      status_code = "200"
    },
    {
      name        = "create-task"
      path        = "tasks"
      method      = "POST"
      lambda      = "create-task"
      status_code = "201"
    }
  ]
}
