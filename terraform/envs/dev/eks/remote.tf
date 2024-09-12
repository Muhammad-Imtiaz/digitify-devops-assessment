data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket  = "digitify-terraform-state-remote-backend"
    key     = "dev/vpc/terraform.tfstate"
    region  = "us-east-1"
  }
}

data "terraform_remote_state" "bastion" {
  backend = "s3"

  config = {
    bucket  = "digitify-terraform-state-remote-backend"
    key     = "dev/bastion/terraform.tfstate"
    region  = "us-east-1"
  }
}