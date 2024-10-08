# LOCAL VARIABLES
locals {
  # Common tags to be assigned to all resources
  common_name = join("-", [var.business_unit, var.environment])
  # ----
  vpc_name            = var.optional_identifier != "" ? join("-", [local.common_name, "vpc", var.optional_identifier]) : join("-", [local.common_name, "vpc"])
  igw_name            = var.optional_identifier != "" ? join("-", [local.common_name, "igw", var.optional_identifier]) : join("-", [local.common_name, "igw"])
  natgw_name          = var.optional_identifier != "" ? join("-", [local.common_name, "nat-gateway", var.optional_identifier]) : join("-", [local.common_name, "nat-gateway"])
  public_subnet_name  = var.optional_identifier != "" ? join("-", [local.common_name, "public-subnet", var.optional_identifier]) : join("-", [local.common_name, "public-subnet"])
  private_subnet_name = var.optional_identifier != "" ? join("-", [local.common_name, "private-subnet", var.optional_identifier]) : join("-", [local.common_name, "private-subnet"])
  public_rt_name      = var.optional_identifier != "" ? join("-", [local.common_name, "public-rt", var.optional_identifier]) : join("-", [local.common_name, "public-rt"])
  private_rt_name     = var.optional_identifier != "" ? join("-", [local.common_name, "private-rt", var.optional_identifier]) : join("-", [local.common_name, "private-rt"])

  common_tags = {
    # Name        = local.common_name
    Environment = var.environment
    Module      = "VPC"
    Terraform   = "true"
    CreatedBy   = var.author
    PartOfInfra = "true"
  }
}

# VPC MODULE
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name = local.common_name

  cidr                 = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  azs             = var.azs
  public_subnets  = var.public_subnet_cidr_blocks
  private_subnets = var.private_subnet_cidr_blocks

  create_igw = var.create_igw
  igw_tags = {
    Name = local.igw_name
  }

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  nat_gateway_tags = {
    Name = local.natgw_name
  }

  vpc_tags = {
    Name = local.vpc_name
  }

  # Tags from local variables
  tags = local.common_tags
  private_subnet_tags = {
    "Type" = "Private"
  }

  public_subnet_tags = {
    "Type"                   = "Public"
    "kubernetes.io/role/elb" = "1"
  }

}
