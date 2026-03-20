variable "app_name" {
	description = "Application name"
	type = string
}

variable "environment" {
	description = "Environment name"
	type = string
}

variable "dynamodb_table_arn" {
  description = "Identifier for the Dynamo table lambdas use"
  type = string
}

variable "dynamodb_table_name" {
  description = "Table name currently only used as env variable"
  type = string
}

variable "cognito_user_pool_arn" {
  description = "Identifier of the Cognito user pool that is used for the app"
  type = string
}

variable "allowed_origin" {
  description = "Used to identify from which origin is BE allowed to recieve requests"
  type = string
}

variable "routes" {
  description = "Defines routes for our API"
  type = list(object({
    name = string
    path = string
    method = string
    lambda = string
    status_code = string
  }))
}

