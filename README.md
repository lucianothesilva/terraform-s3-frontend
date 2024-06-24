<!-- BEGIN_TF_DOCS -->
# tofu-cloudfront-cloudflare
Simple terraform project to deploy an S3 bucket and CloudFront distribution, creating and registering an SSL certificate for the distribution from AWS in Cloudflare.

There are lots of things to be improved like a Cloudflare module etc.
## Requirements

| Name | Version |
|------|---------|
| <a name="aws-cli"></a> [aws-cli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html) | 2.16.8 |
| <a name="opentofu"></a> [opentofu](https://opentofu.org/docs/intro/install/) | 1.7.2|

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.55.0 |
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 4.29.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudfront"></a> [cloudfront](#module\_cloudfront) | ./modules/cloudfront | n/a |
| <a name="module_s3"></a> [s3](#module\_s3) | ./modules/s3 | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.my_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.my_cert_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [cloudflare_record.cert_validation](https://registry.terraform.io/providers/hashicorp/cloudflare/latest/docs/resources/record) | resource |
| [cloudflare_record.cname_record](https://registry.terraform.io/providers/hashicorp/cloudflare/latest/docs/resources/record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudflare_api_key"></a> [cloudflare\_api\_key](#input\_cloudflare\_api\_key) | n/a | `any` | n/a | yes |
| <a name="input_cloudflare_email"></a> [cloudflare\_email](#input\_cloudflare\_email) | n/a | `any` | n/a | yes |
| <a name="input_cloudflare_zone_id"></a> [cloudflare\_zone\_id](#input\_cloudflare\_zone\_id) | n/a | `any` | n/a | yes |
| <a name="input_cloudfront_comment"></a> [cloudfront\_comment](#input\_cloudfront\_comment) | n/a | `any` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | n/a | `any` | n/a | yes |
| <a name="input_group_name"></a> [group\_name](#input\_group\_name) | n/a | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `any` | n/a | yes |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | n/a | `any` | n/a | yes |
| <a name="input_s3_policy_name"></a> [s3\_policy\_name](#input\_s3\_policy\_name) | n/a | `any` | n/a | yes |
| <a name="input_user_name"></a> [user\_name](#input\_user\_name) | n/a | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
