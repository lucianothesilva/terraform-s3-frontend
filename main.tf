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

resource "aws_acm_certificate" "my_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"
}

locals {
  domain_validation_options = tolist(aws_acm_certificate.my_cert.domain_validation_options)
  origin_id                 = "${var.s3_bucket_name}.${var.region}"
}

resource "cloudflare_record" "cert_validation" {
  count   = length(local.domain_validation_options)
  zone_id = var.cloudflare_zone_id
  name    = local.domain_validation_options[count.index].resource_record_name
  value   = local.domain_validation_options[count.index].resource_record_value
  type    = local.domain_validation_options[count.index].resource_record_type
  ttl     = 60
}

resource "aws_acm_certificate_validation" "my_cert_validation" {
  certificate_arn         = aws_acm_certificate.my_cert.arn
  validation_record_fqdns = [for record in cloudflare_record.cert_validation : record.hostname]
}

module "cloudfront" {
  source              = "./modules/cloudfront"
  bucket_domain_name  = module.s3.bucket_domain_name
  acm_certificate_arn = aws_acm_certificate.my_cert.arn
  origin_id           = local.origin_id
  cloudfront_comment  = var.cloudfront_comment
  domain_name         = var.domain_name
  s3_bucket_name      = var.s3_bucket_name
  s3_bucket_arn       = module.s3.bucket_arn
}

resource "cloudflare_record" "cname_record" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain_name
  value   = module.cloudfront.cloudfront_distribution_domain_name
  type    = "CNAME"
  ttl     = 300
}