variable "region" {}
variable "s3_bucket_name" {}
variable "domain_name" {}

variable "cloudflare_zone_id" {
  description = "The Cloudflare zone ID"
  type        = string
}