output "output" {
  description = "Resource informations"
  value       = <<EOT
# Belows are used by lambda
export STATIC_S3_BUCKET=${module.cdn.s3_cdn_bucket}
export STATIC_S3_BUCKET_DOMAIN_NAME=${module.cdn.s3_cdn_bucket_domain_name}
export CLOUDFRONT_DOMAIN=${module.cdn.s3_cdn_cf_domain_name}
export CUSTOM_DOMAIN=${module.cdn.s3_cdn_custom_domain}
export AWS_ACCESS_KEY_ID=${module.cdn.s3_cdn_iam_user_access_key}
export AWS_SECRET_ACCESS_KEY=<decrypt below encrypted secret key>

------------ Encrypted secret key ------------
${module.cdn.s3_cdn_iam_user_encrypted_secret_key}

EOT
}
