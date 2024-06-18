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
}


#--------------------------------------------------------------------------------
resource "aws_iam_policy" "cloudfront_policy" {
  name        = "cloudfront_policy"
  description = "Policy for CloudFront invalidation"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "VisualEditor0",
        Effect = "Allow",
        Action = [
          "cloudfront:GetInvalidation",
          "cloudfront:CreateInvalidation"
        ],
        Resource = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${module.cloudfront.cloudfront_distribution_id}"
      }
    ]
  })
}

resource "aws_iam_policy" "s3_policy" {
  name        = var.s3_policy_name
  description = "Policy for S3 access"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::${module.s3.bucket_name}/*",
          "arn:aws:s3:::${module.s3.bucket_name}"
        ]
      }
    ]
  })
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = module.s3.bucket_name

  policy = jsonencode({
    Version = "2008-10-17",
    Id      = "PolicyForCloudFrontPrivateContent",
    Statement = [
      {
        Sid    = "1",
        Effect = "Allow",
        Principal = {
          AWS = module.cloudfront.iam_arn
        },
        Action   = "s3:GetObject",
        Resource = "${module.s3.bucket_arn}/*"
      }
    ]
  })
}


resource "aws_iam_policy_attachment" "attach_cloudfront_policy" {
  name       = "attach_cloudfront_policy"
  policy_arn = aws_iam_policy.cloudfront_policy.arn
  groups     = [aws_iam_group.frontend_group.name]
}

resource "aws_iam_policy_attachment" "attach_s3_policy" {
  name       = "attach_s3_policy"
  policy_arn = aws_iam_policy.s3_policy.arn
  groups     = [aws_iam_group.frontend_group.name]
}

data "aws_caller_identity" "current" {}

resource "aws_iam_group" "frontend_group" {
  name = var.group_name
}

resource "aws_iam_user" "frontend_user" {
  name = var.user_name
}

resource "aws_iam_group_membership" "frontend_group_membership" {
  name  = "frontend_group_membership"
  users = [aws_iam_user.frontend_user.name]
  group = aws_iam_group.frontend_group.name
}

#--------------------------------------------------------------------------------
resource "cloudflare_record" "cname_record" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain_name
  value   = module.cloudfront.cloudfront_distribution_domain_name
  type    = "CNAME"
  ttl     = 300
}