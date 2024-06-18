output "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.cf_distribution.id
}

output "cloudfront_distribution_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.cf_distribution.domain_name
}

output "iam_arn" {
  description = "The IAM ARN for the CloudFront Origin Access Identity"
  value       = aws_cloudfront_origin_access_identity.frontend_oai.iam_arn
}
