provider "aws" {
  region = var.region
}

provider "cloudflare" {
  api_key = var.cloudflare_api_key
  email   = var.cloudflare_email
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name        = var.s3_bucket_name
    Environment = "Production"
  }
}
# Create ACM Certificate
resource "aws_acm_certificate" "my_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Name = "my-cert"
  }
}

locals {
  domain_validation_options = tolist(aws_acm_certificate.my_cert.domain_validation_options)
}

resource "cloudflare_record" "cert_validation" {
  count   = length(local.domain_validation_options)
  zone_id = var.cloudflare_zone_id
  name    = local.domain_validation_options[count.index].resource_record_name
  value   = local.domain_validation_options[count.index].resource_record_value
  type    = local.domain_validation_options[count.index].resource_record_type
  ttl     = 60
}

# Validate the certificate
resource "aws_acm_certificate_validation" "my_cert_validation" {
  certificate_arn         = aws_acm_certificate.my_cert.arn
  validation_record_fqdns = [for record in cloudflare_record.cert_validation : record.hostname]
}

# Create CloudFront Origin Access Identity
resource "aws_cloudfront_distribution" "cf_distribution" {
  origin {
    domain_name = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
    origin_id   = "myS3Origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.frontend_oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.cloudfront_comment
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "myS3Origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true

    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6" # CachingOptimized
    origin_request_policy_id = "b689b0a8-53d0-40ab-baf2-68738e2966ac" # Use an appropriate existing policy or create a new one
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
    prefix          = "logs/"
  }

  tags = {
    Name        = "cf-distribution"
    Environment = "Production"
  }
}

resource "aws_cloudfront_origin_access_identity" "frontend_oai" {
}




