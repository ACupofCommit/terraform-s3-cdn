terraform {
  required_version = ">= 0.15.5"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 3.30.0, < 4.0"
      configuration_aliases = [aws.global_region]
    }
  }
}