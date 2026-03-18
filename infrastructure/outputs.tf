output "api_url" {
  description = "URL of the app API"
  value       = module.honey_do_api.api_url
}

output "client_url" {
  description = "URL to the Cloudfront hosted app client"
  value       = module.honey_do_client.client_url
}

output "client_root_dir_name" {
  description = "Bucket name of the dir where build of the client is stored on s3"
  value       = module.honey_do_client.client_root_dir_name
}

output "user_pool_id" {
  description = "ID representing user poll in the cognito for the app"
  value       = module.honey_do_auth.user_pool_id
}

output "user_pool_client_id" {
  description = "ID of the app connected to the user pool"
  value       = module.honey_do_auth.user_pool_client_id
}
