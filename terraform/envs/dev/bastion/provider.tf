# Supports Terraform 0.13+
# PROVIDER
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.15.0"
    }
  }
}

# CONFIGURATION OPTIONS
provider "aws" {
  region = "us-east-1"
}