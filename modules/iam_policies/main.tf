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
        Resource = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${var.cloudfront_distribution_id}"
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
          "arn:aws:s3:::${var.s3_bucket_name}/*",
          "arn:aws:s3:::${var.s3_bucket_name}"
        ]
      }
    ]
  })
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

data "aws_caller_identity" "current" {}
