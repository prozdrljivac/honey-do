output "website_endpoint" {
  description = "S3 website endpoint"
  value       = aws_s3_bucket_website_configuration.website_config.website_endpoint
}

output "website_url" {
  description = "Full HTTP URL to access the website"
  value       = "http://${aws_s3_bucket_website_configuration.website_config.website_endpoint}"
}

output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.website.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.website.arn
}

output "bucket_regional_domain_name" {
  description = "Regional domain name of the bucket"
  value       = aws_s3_bucket.website.bucket_regional_domain_name
}
