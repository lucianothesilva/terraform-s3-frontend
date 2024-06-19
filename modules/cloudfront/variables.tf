variable "bucket_domain_name" {
  description = "The domain name of the S3 bucket"
  type        = string
}

variable "origin_id" {
  description = "The origin ID for CloudFront"
  type        = string
}

variable "cloudfront_comment" {
  description = "The comment for the CloudFront distribution"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the CloudFront distribution"
  type        = string
}

variable "acm_certificate_arn" {
  description = "The ARN of the ACM certificate"
  type        = string
}

variable "s3_bucket_name" {}

variable "s3_bucket_arn" {}