resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_bucket_name
  tags = {
    Name        = var.s3_bucket_name
    Environment = "Production"
  }
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.id

  policy = jsonencode({
    Version = "2008-10-17",
    Id      = "PolicyForCloudFrontPrivateContent",
    Statement = [
      {
        Sid    = "1",
        Effect = "Allow",
        Principal = {
          AWS = var.cloudfront_oai_iam_arn
        },
        Action   = "s3:GetObject",
        Resource = "${aws_s3_bucket.s3_bucket.arn}/*"
      }
    ]
  })
}