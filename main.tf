provider "aws" {
  region = var.region
}

provider "cloudflare" {
  api_key = var.cloudflare_api_key
  email   = var.cloudflare_email
}

module "acm" {
  source = "./modules/acm"
  s3_bucket_name = var.s3_bucket_name
  domain_name = var.domain_name
  region = var.region
}

module "s3" {
  source = "./modules/s3"
  s3_bucket_name = var.s3_bucket_name
}

module "cloudfront" {
  source = "./modules/cloudfront"
  domain_name = var.domain_name
  cloudfront_comment = var.cloudfront_comment
  s3_bucket_name = var.s3_bucket_name
  region = var.region
}

module "cloudflare" {
  source = "./modules/cloudflare"
  domain_name = var.domain_name
  cloudflare_zone_id = var.cloudflare_zone_id
}

module "iam" {
  source = "./modules/iam"
  user_name = var.user_name
  s3_policy_name = var.s3_bucket_name
  group_name = var.group_name

}

# Data source for AWS caller identity
data "aws_caller_identity" "current" {}

# Outputs
output "cloudfront_domain_name" {
  value = module.cloudfront.cloudfront_domain
}
