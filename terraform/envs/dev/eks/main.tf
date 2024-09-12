module "eks" {
  source              = "../../../modules/eks"
  author              = "Imtiaz"
  business_unit       = "digitify"
  environment         = "dev"
  optional_identifier = ""

  # VPC CONFIGURATION
  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnets  = data.terraform_remote_state.vpc.outputs.public_subnets
  private_subnets = data.terraform_remote_state.vpc.outputs.private_subnets
  # BASTION CONFIGURATION
  bastion_sg_id = data.terraform_remote_state.bastion.outputs.bastion-sg

  # ADDONS
  eks_addons = {
    # addons_name    = ["coredns", "kube-proxy", "vpc-cni"],
    addons_version = ["v1.9.3-eksbuild.5", "v1.25.6-eksbuild.2", "v1.12.6-eksbuild.2"]
  }

  # EKS CONFIGURATIONS
  cluster_version                 = "1.31"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  public_access_cidrs             = ["182.191.84.208/32"]
  create_cluster_security_group   = true
  create_cluster_iam_role         = true
  create_launch_template          = false


  # NODE GROUPS CONFIGURATION

  digitify_services_size           = [1, 1, 2]
  digitify_services_ebs_optimized  = true
  digitify_services_capacity_type  = "ON_DEMAND"
  digitify_services_disk_size      = 50
  digitify_services_instance_types = ["t3.medium"]
  digitify_services_labels = {
    dedicated = "digitify_services"
  }
}

