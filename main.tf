provider "aws" {
  region = var.region
}

# Create S3 bucket
resource "aws_s3_bucket" "frontend-bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name        = var.s3_bucket_name
    Environment = "Production"
  }
}