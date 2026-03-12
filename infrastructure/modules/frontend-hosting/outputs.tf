output "client_url" {
  value = "https://${aws_cloudfront_distribution.cdn.domain_name}"
}

output "client_root_dir_name" {
  value = aws_s3_bucket.client_app_assets.bucket
}
