provider "aws" {
  region = "eu-north-1"
}

module "honey_do_db" {
  source      = "./modules/dynamodb"
  app_name    = var.app_name
  environment = var.environment
}

module "honey_do_auth" {
  source      = "./modules/cognito"
  app_name    = var.app_name
  environment = var.environment
}

module "honey_do_api" {
  source = "./modules/api-gateway-rest-api-lambda"

  app_name              = var.app_name
  environment           = var.environment
  dynamodb_table_arn    = module.honey_do_db.table_arn
  dynamodb_table_name   = module.honey_do_db.table_name
  cognito_user_pool_arn = module.honey_do_auth.user_pool_arn
  routes = [
    {
      name        = "list-tasks"
      path        = "tasks"
      method      = "GET"
      lambda      = "list-tasks"
      status_code = "200"
    },
    {
      name        = "detail-task"
      path        = "tasks/{id}"
      method      = "GET"
      lambda      = "detail-task"
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

module "honey_do_client" {
  source = "./modules/frontend-hosting"

  app_name             = var.app_name
  environment          = var.environment
  force_destroy_bucket = var.force_destroy_bucket
}
