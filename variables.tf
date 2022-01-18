variable "name_prefix" {
  type        = string
  description = "Prefix of almost resource names."
}

variable "name_suffix" {
  type        = string
  description = "Suffix of almost resource names. Ex) some random string"
}

variable "static_bucket_name" {
  type        = string
  description = "S3 Bucket name for static assets. It is mainly used when you want to reuse an existing bucket by importing it."
  default     = null
}

variable "enable_log" {
  type    = bool
  default = false
}

variable "log_bucket_domain" {
  type    = string
  default = null
}

variable "log_prefix" {
  type    = string
  default = ""
}

variable "mininum_protocol_version" {
  type    = string
  default = "TLSv1"
}

variable "lambda_role_permissions_boundary" {
  type = string
  # https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_boundaries.html
  description = "ARN of IAM policy that scopes aws_iam_role access for the lambda"
  default     = null
}

variable "basic_auth_credentials" {
  type        = object({ username = string, password = string })
  description = "Credentials for Basic Authentication. Pass a map composed of 'user' and 'password'."
  default     = null
}

variable "price_class" {
  type    = string
  default = "PriceClass_100"
}

variable "domain" {
  type    = string
  default = null
}

variable "route53_zone_name" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
