provider "aws" {
  region = var.region
}

# Create S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name        = var.s3_bucket_name
    Environment = "Production"
  }
}