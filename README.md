# s3-cdn
It provides a static web server by AWS Cloudfront and S3.

## Projects that inspired it.
- https://github.com/builtinnya/aws-lambda-edge-basic-auth-terraform
- https://github.com/cloudposse/terraform-aws-cloudfront-s3-cdn

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| archive | n/a |
| aws | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| basic\_auth\_credentials | Credentials for Basic Authentication. Pass a map composed of 'user' and 'password'. | `object({ username = string, password = string })` | `null` | no |
| domain | n/a | `string` | `null` | no |
| enable\_log | n/a | `bool` | `false` | no |
| lambda\_role\_permissions\_boundary | ARN of IAM policy that scopes aws\_iam\_role access for the lambda | `string` | `null` | no |
| log\_bucket\_domain | n/a | `string` | `null` | no |
| mininum\_protocol\_version | n/a | `string` | `"TLSv1"` | no |
| name\_prefix | Prefix of almost resource names. | `string` | n/a | yes |
| name\_suffix | Suffix of almost resource names. Ex) some random string | `string` | n/a | yes |
| price\_class | n/a | `string` | `"PriceClass_100"` | no |
| route53\_zone\_name | n/a | `string` | `null` | no |
| tags | n/a | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| s3\_cdn\_bucket | n/a |
| s3\_cdn\_bucket\_domain\_name | n/a |
| s3\_cdn\_cf\_domain\_name | n/a |
| s3\_cdn\_custom\_domain | n/a |
