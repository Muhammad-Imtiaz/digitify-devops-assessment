module "vpc" {
  source              = "../../../modules/vpc"
  author              = "Imtiaz"
  business_unit       = "digitify"
  environment         = "dev"
  optional_identifier = ""

  # VPC CONFIGURATIONS
  vpc_cidr                   = "18.0.0.0/16"
  enable_dns_hostnames       = true
  enable_dns_support         = true
  azs                        = ["us-east-2a", "us-east-2b"]
  public_subnet_cidr_blocks  = ["18.0.1.0/24", "18.0.2.0/24"]
  private_subnet_cidr_blocks = ["18.0.32.0/19", "18.0.64.0/19"]
  create_igw                 = true
  enable_nat_gateway         = true
  single_nat_gateway         = true
}