resource "aws_acm_certificate" "my_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"
}

locals {
  domain_validation_options = tolist(aws_acm_certificate.my_cert.domain_validation_options)
}

resource "cloudflare_record" "cert_validation" {
  count   = length(local.domain_validation_options)
  zone_id = var.zone_id
  name    = local.domain_validation_options[count.index].resource_record_name
  value   = local.domain_validation_options[count.index].resource_record_value
  type    = local.domain_validation_options[count.index].resource_record_type
  ttl     = 60
}

resource "aws_acm_certificate_validation" "my_cert_validation" {
  certificate_arn         = aws_acm_certificate.my_cert.arn
  validation_record_fqdns = [for record in cloudflare_record.cert_validation : record.hostname]
}

