provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      "managed_by" = "terraform"
    }
  }
}

terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.6"
    }
  }
}