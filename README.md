# s3-cdn
It provides a static web server by AWS Cloudfront and S3.

## Projects that inspired it.
- https://github.com/builtinnya/aws-lambda-edge-basic-auth-terraform
- https://github.com/cloudposse/terraform-aws-cloudfront-s3-cdn

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.30.0, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.30.0, < 4.0 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | terraform-aws-modules/acm/aws | ~> v3.0 |
| <a name="module_basic_auth_as_lambda_edge"></a> [basic\_auth\_as\_lambda\_edge](#module\_basic\_auth\_as\_lambda\_edge) | terraform-aws-modules/lambda/aws | ~> v2.4.0 |
| <a name="module_cdn"></a> [cdn](#module\_cdn) | terraform-aws-modules/cloudfront/aws | ~> 2.5.0 |
| <a name="module_static"></a> [static](#module\_static) | terraform-aws-modules/s3-bucket/aws | ~> v2.4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.ci](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_user.ci](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.ci](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_route53_record.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket_object.index_html](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [aws_s3_bucket_object.secret_json](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [aws_s3_bucket_policy.origin_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [archive_file.basic_auth_function](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_iam_policy_document.cf_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_route53_zone.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [template_file.basic_auth_function](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_basic_auth_credentials"></a> [basic\_auth\_credentials](#input\_basic\_auth\_credentials) | Credentials for Basic Authentication. Pass a map composed of 'user' and 'password'. | `object({ username = string, password = string })` | `null` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | `null` | no |
| <a name="input_enable_log"></a> [enable\_log](#input\_enable\_log) | n/a | `bool` | `false` | no |
| <a name="input_lambda_role_permissions_boundary"></a> [lambda\_role\_permissions\_boundary](#input\_lambda\_role\_permissions\_boundary) | ARN of IAM policy that scopes aws\_iam\_role access for the lambda | `string` | `null` | no |
| <a name="input_log_bucket_domain"></a> [log\_bucket\_domain](#input\_log\_bucket\_domain) | n/a | `string` | `null` | no |
| <a name="input_log_prefix"></a> [log\_prefix](#input\_log\_prefix) | n/a | `string` | `""` | no |
| <a name="input_mininum_protocol_version"></a> [mininum\_protocol\_version](#input\_mininum\_protocol\_version) | n/a | `string` | `"TLSv1"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix of almost resource names. | `string` | n/a | yes |
| <a name="input_name_suffix"></a> [name\_suffix](#input\_name\_suffix) | Suffix of almost resource names. Ex) some random string | `string` | n/a | yes |
| <a name="input_price_class"></a> [price\_class](#input\_price\_class) | n/a | `string` | `"PriceClass_100"` | no |
| <a name="input_route53_zone_name"></a> [route53\_zone\_name](#input\_route53\_zone\_name) | n/a | `string` | `null` | no |
| <a name="input_static_bucket_name"></a> [static\_bucket\_name](#input\_static\_bucket\_name) | S3 Bucket name for static assets. It is mainly used when you want to reuse an existing bucket by importing it. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3_cdn_bucket"></a> [s3\_cdn\_bucket](#output\_s3\_cdn\_bucket) | n/a |
| <a name="output_s3_cdn_bucket_domain_name"></a> [s3\_cdn\_bucket\_domain\_name](#output\_s3\_cdn\_bucket\_domain\_name) | n/a |
| <a name="output_s3_cdn_cf_domain_name"></a> [s3\_cdn\_cf\_domain\_name](#output\_s3\_cdn\_cf\_domain\_name) | n/a |
| <a name="output_s3_cdn_custom_domain"></a> [s3\_cdn\_custom\_domain](#output\_s3\_cdn\_custom\_domain) | n/a |
| <a name="output_s3_cdn_iam_user_access_key"></a> [s3\_cdn\_iam\_user\_access\_key](#output\_s3\_cdn\_iam\_user\_access\_key) | n/a |
| <a name="output_s3_cdn_iam_user_encrypted_secret_key"></a> [s3\_cdn\_iam\_user\_encrypted\_secret\_key](#output\_s3\_cdn\_iam\_user\_encrypted\_secret\_key) | n/a |
