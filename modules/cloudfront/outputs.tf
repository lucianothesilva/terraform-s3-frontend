output "cloudfront_distribution_id" {
  value       = aws_cloudfront_distribution.cf_distribution.id
}

output "cloudfront_distribution_domain_name" {
  value       = aws_cloudfront_distribution.cf_distribution.domain_name
}

output "iam_arn" {
  value       = aws_cloudfront_origin_access_identity.frontend_oai.iam_arn
}
