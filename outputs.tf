output "s3_cdn_bucket" {
  value = module.static.s3_bucket_id
}
output "s3_cdn_bucket_domain_name" {
  value = module.static.s3_bucket_bucket_domain_name
}
output "s3_cdn_cf_domain_name" {
  value = module.cdn.cloudfront_distribution_domain_name
}
output "s3_cdn_custom_domain" {
  value = var.domain != null ? var.domain : ""
}
