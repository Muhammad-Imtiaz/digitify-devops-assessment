locals {
  allow_vpn = [{
    port        = 22
    protocol    = "tcp"
    description = "SSH from My HOME route"
    cidr        = ["182.191.84.208/32"]
  }]
}

module "bastion" {
  source              = "../../../modules/bastion"
  author              = "Imtiaz"
  business_unit       = "digitify"
  environment         = "dev"
  optional_identifier = ""

  # BASTION CONFIGURATIONS
  az                          = ["us-east-2a"]
  monitoring                  = false
  ami                         = "ami-0fb653ca2d3203ac1"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  eip_domain                  = "vpc"
  sg_ingress                  = local.allow_vpn
  vpc_id                      = data.terraform_remote_state.vpc.outputs.vpc_id
  pub_subnet_id               = data.terraform_remote_state.vpc.outputs.public_subnets[0]

}