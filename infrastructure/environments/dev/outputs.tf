output "website_url" {
  description = "URL to access the website"
  value       = module.static_website.website_url
}

output "website_endpoint" {
  description = "S3 website endpoint"
  value       = module.static_website.website_endpoint
}

output "bucket_name" {
  description = "S3 bucket name"
  value       = module.static_website.bucket_name
}
