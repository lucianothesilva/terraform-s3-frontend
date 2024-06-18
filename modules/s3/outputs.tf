output "bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.s3_bucket.bucket
}

output "bucket_arn" {
  description = "S3 bucket arn"
  value       = aws_s3_bucket.s3_bucket.arn
}

output "bucket_domain_name" {
  description = "Bucket domain name"
  value       = aws_s3_bucket.s3_bucket.bucket_domain_name
}
