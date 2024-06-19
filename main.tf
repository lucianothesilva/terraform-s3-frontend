provider "aws" {
  region = var.region
}

provider "cloudflare" {
  api_key = var.cloudflare_api_key
  email   = var.cloudflare_email
}

module "s3" {
  source         = "./modules/s3"
  s3_bucket_name = var.s3_bucket_name
}

module "acm" {
  source      = "./modules/acm"
  region = var.region
  s3_bucket_name = var.s3_bucket_name
  domain_name = var.domain_name
  cloudflare_zone_id = var.cloudflare_zone_id
}

locals {
  origin_id                 = "${var.s3_bucket_name}.${var.region}"
}

module "cloudfront" {
  source              = "./modules/cloudfront"
  bucket_domain_name  = module.s3.bucket_domain_name
  acm_certificate_arn = module.acm.acm_certificate_arn
  origin_id           = local.origin_id
  cloudfront_comment  = var.cloudfront_comment
  domain_name         = var.domain_name
  s3_bucket_name      = var.s3_bucket_name
  s3_bucket_arn = module.s3.bucket_arn
}

resource "cloudflare_record" "cname_record" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain_name
  value   = module.cloudfront.cloudfront_distribution_domain_name
  type    = "CNAME"
  ttl     = 300
}