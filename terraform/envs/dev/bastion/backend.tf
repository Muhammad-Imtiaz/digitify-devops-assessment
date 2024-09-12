# TERRAFORM BACKEND
terraform {
  backend "s3" {
    bucket = "digitify-terraform-state-remote-backend"
    key    = "dev/bastion/terraform.tfstate"
    region = "us-east-1"

    # ENABLES STATE LOCKING
    dynamodb_table = "digitify-terraform-state-lock"
  }
} 