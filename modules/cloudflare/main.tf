resource "cloudflare_record" "cname_record" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain_name
  value   = aws_cloudfront_distribution.cf_distribution.domain_name
  type    = "CNAME"
  ttl     = 300
}