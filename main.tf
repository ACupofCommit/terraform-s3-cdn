provider "aws" {
  alias = "us-east-1"
  region = "us-east-1"
}

terraform {
  required_version = ">= 0.14.7"
  required_providers {
    aws = {
      version = ">= 3.30.0, < 4.0"
      source = "hashicorp/aws"
    }
  }
}

##############################
# S3 for static assets

module "static" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> v2.4.0"

  bucket  = "${var.name_prefix}-static-${var.name_suffix}"
  acl     = "private"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = false
  }
}

locals {
  key_for_secret_file = "secret.json"
  origin_path = ""
}

data "aws_iam_policy_document" "cf_access" {
  statement {
    sid       = "S3GetObjectForCloudFront"
    actions   = ["s3:GetObject"]
    resources = ["${module.static.s3_bucket_arn}${local.origin_path}/*"]

    principals {
      type        = "AWS"
      identifiers = module.cdn.cloudfront_origin_access_identity_iam_arns
    }
  }

  # Do not expose the secrets to the public
  statement {
    sid       = "DenyS3GetObjectForCloudFront"
    effect    = "Deny"
    actions   = ["s3:GetObject"]
    resources = ["${module.static.s3_bucket_arn}/${local.key_for_secret_file}"]

    principals {
      type        = "AWS"
      identifiers = module.cdn.cloudfront_origin_access_identity_iam_arns
    }
  }
}

resource "aws_s3_bucket_policy" "origin_access" {
  bucket = module.static.s3_bucket_id
  policy = data.aws_iam_policy_document.cf_access.json
}

resource "aws_s3_bucket_object" "index_html" {
  bucket        = module.static.s3_bucket_id
  key           = "index.html"
  content       = file("${path.module}/assets/index.html")
  content_type  = "text/html"
}

resource "aws_s3_bucket_object" "secret_json" {
  bucket        = module.static.s3_bucket_id
  key           = "secret.json"
  content       = file("${path.module}/assets/secret.json")
}

##############################
# Lambda functions

data "template_file" "basic_auth_function" {
  count = var.basic_auth_credentials != null ? 1 : 0
  template = file("${path.module}/src/basic-auth-handler.js")
  vars = var.basic_auth_credentials
}

data "archive_file" "basic_auth_function" {
  count = var.basic_auth_credentials != null ? 1 : 0
  type = "zip"
  output_path = "${path.module}/dist/basic-auth-handler.zip"

  source {
    content = data.template_file.basic_auth_function[0].rendered
    filename = "basic-auth-handler.js"
  }
}

module "basic_auth_as_lambda_edge" {
  source                    = "terraform-aws-modules/lambda/aws"
  version                   = "~> v2.4.0"
  count                     = length(data.archive_file.basic_auth_function)
  lambda_at_edge            = true
  function_name             = "${var.name_prefix}-edge-proxy-${var.name_suffix}"
  description               = "basic auth as lambda@edge"
  handler                   = "basic-auth-handler.handler"
  runtime                   = "nodejs14.x"
  role_permissions_boundary = var.lambda_role_permissions_boundary

  create_package            = false
  local_existing_package    = data.archive_file.basic_auth_function[0].output_path

  cloudwatch_logs_retention_in_days = 30
  tags                              = var.tags

  providers = {
    aws = aws.us-east-1
  }
}

##############################
# cloudfront

module "cdn" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "~> 2.5.0"
  aliases = var.domain != null ? [var.domain] : null

  comment             = "${var.name_prefix}-cdn-${var.name_suffix}"
  default_root_object = "index.html"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = var.price_class
  retain_on_delete    = false
  wait_for_deployment = true

  create_origin_access_identity = true
  origin_access_identities = {
    s3_bucket_one = "Only ${var.name_prefix}-cdn-${var.name_suffix} CloudFront can access"
  }

  logging_config = var.log_bucket_domain != null ? {
    bucket = var.log_bucket_domain // "logs-my-cdn.s3.amazonaws.com"
    prefix = var.log_prefix
  } : {}

  # Static deployment S3 bucket
  origin = {
    static = {
      domain_name = module.static.s3_bucket_bucket_regional_domain_name
      s3_origin_config = {
        origin_access_identity = "s3_bucket_one"
      }
      custom_header = [{
        name  = "x-hello"
        value = "world"
      }]
    }
  }

  default_cache_behavior = {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "static"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 3600

    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    lambda_function_association = length(module.basic_auth_as_lambda_edge) == 1 ? {
      viewer-request = {
        lambda_arn   = module.basic_auth_as_lambda_edge[0].lambda_function_qualified_arn
        include_body = false
      }
    } : {}
  }

  viewer_certificate = length(module.acm) == 1 ? {
    acm_certificate_arn = module.acm[0].acm_certificate_arn
    ssl_support_method  = "sni-only"
  } : {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1"
  }
}

#######################################
# domain

data "aws_route53_zone" "selected" {
  count        = var.domain != null ? 1 : 0
  name         = var.route53_zone_name
  private_zone = false
}

module "acm" {
  source                    = "terraform-aws-modules/acm/aws"
  version                   = "~> v3.0"
  count                     = var.domain != null ? 1 : 0
  domain_name               = var.domain
  zone_id                   = data.aws_route53_zone.selected[0].zone_id
  subject_alternative_names = []
  tags                      = var.tags

  providers = {
    aws = aws.us-east-1
  }
}

resource "aws_route53_record" "service" {
  count   = var.domain != null ? 1 : 0
  zone_id = data.aws_route53_zone.selected[0].zone_id
  name    = var.domain
  type    = "A"
  alias {
    name                   = module.cdn.cloudfront_distribution_domain_name
    zone_id                = module.cdn.cloudfront_distribution_hosted_zone_id
    evaluate_target_health = false
  }
}

