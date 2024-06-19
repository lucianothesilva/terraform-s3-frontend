resource "aws_cloudfront_origin_access_identity" "frontend_oai" {}

resource "aws_cloudfront_distribution" "cf_distribution" {
  origin {
    domain_name = var.bucket_domain_name
    origin_id   = var.origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.frontend_oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.cloudfront_comment
  default_root_object = "index.html"

  aliases = [var.domain_name]

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 403
    response_page_path    = "/index.html"
    response_code         = 200
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.origin_id
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true

    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6" # CachingOptimized
    origin_request_policy_id = null
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = var.s3_bucket_name

  policy = jsonencode({
    Version = "2008-10-17",
    Id      = "PolicyForCloudFrontPrivateContent",
    Statement = [
      {
        Sid    = "1",
        Effect = "Allow",
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.frontend_oai.iam_arn
        },
        Action   = "s3:GetObject",
        Resource = "${var.s3_bucket_arn}/*"
      }
    ]
  })
}
