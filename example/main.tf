
locals {
  name_prefix = "test-cdn"
  name_suffix = "cw9few"
}

module "cdn" {
  source = "../"

  name_prefix = local.name_prefix
  name_suffix = local.name_suffix

  route53_zone_name = "example.com."
  domain            = "s3-cdn.example.com"
  basic_auth_credentials = {
    username = "admin"
    password = "change-it"
  }
}
