variable "region" {
  type    = string
  default = "us-east-2"
}

variable "s3_bucket_name" {
  type = string
}

variable "cloudfront_comment" {
  type    = string
  default = "My CloudFront Distribution"
}

variable "group_name" {
  type = string
}

variable "user_name" {
  type = string
}

variable "cloudfront_policy_name" {
  type    = string
  default = "cloudfront_policy"
}

variable "s3_policy_name" {
  type    = string
  default = "s3_policy"
}


variable "cloudflare_email" {
  description = "Cloudflare account email"
  type        = string
}

variable "cloudflare_api_key" {
  description = "Cloudflare API key"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID"
  type        = string

  
}

variable "domain_name" {
  description = "The domain name for the SSL certificate"
  type        = string
}
