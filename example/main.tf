
locals {
  name_prefix = "test-cdn"
  name_suffix = "cw9few"
}

module "log" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> v2.4.0"

  bucket  = "${local.name_prefix}-logs-${local.name_suffix}"
  acl     = "log-delivery-write"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = false
  }
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

  log_bucket_domain = module.log.s3_bucket_bucket_domain_name
  log_prefix = "cdn"
}
