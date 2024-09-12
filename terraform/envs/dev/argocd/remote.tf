
data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket  = "digitify-terraform-state-remote-backend"
    key     = "dev/eks/terraform.tfstate"
    region  = "us-east-1"
  }
}