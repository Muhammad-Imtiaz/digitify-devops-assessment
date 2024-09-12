# LOCAL VARIABLES
locals {
  # Common tags to be assigned to all resources
  common_name               = join("-", [var.business_unit, var.environment])
  cluster_name              = var.optional_identifier != "" ? join("-", [local.common_name, "eks-cluster", var.optional_identifier]) : join("-", [local.common_name, "eks-cluster"])
  eks_cluster_sg_name       = var.optional_identifier != "" ? join("-", [local.common_name, "eks-cluster-security-group", var.optional_identifier]) : join("-", [local.common_name, "eks-cluster-security-group"])
  eks_worker_node_sg_name   = var.optional_identifier != "" ? join("-", [local.common_name, "eks-worker-node-security-group", var.optional_identifier]) : join("-", [local.common_name, "eks-worker-node-security-group"])
  eks_cluster_iam_role_name = var.optional_identifier != "" ? join("-", [local.common_name, "eks-cluster-iam-role", var.optional_identifier]) : join("-", [local.common_name, "eks-cluster-iam-role"])
  worker_node_key_name      = var.optional_identifier != "" ? join("-", [local.common_name, "eks-worker-node-key", var.optional_identifier]) : join("-", [local.common_name, "eks-worker-node-key"])

  # Common tags to be assigned to all resources  
  common_tags = {
    Name        = local.common_name
    Environment = var.environment
    Module      = "EKS"
    Terraform   = "true"
    CreatedBy   = var.author
    PartOfInfra = "true"
  }
}

# EKS MODULE
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = local.cluster_name
  cluster_version = var.cluster_version
  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days

  cluster_endpoint_private_access      = var.cluster_endpoint_private_access
  cluster_endpoint_public_access       = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.public_access_cidrs

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  # use existing one if not created or otherwise
  create_cluster_security_group = var.create_cluster_security_group
  cluster_security_group_name   = local.eks_cluster_sg_name

  cluster_security_group_tags = merge(local.common_tags, {
    Name = "${local.eks_cluster_sg_name}"
  })

  # use existing one if not created or otherwise
  create_iam_role = var.create_cluster_iam_role
  iam_role_name   = local.eks_cluster_iam_role_name

  # KMS key
  create_kms_key         = true
  kms_key_administrators = var.kms_key_administrators
  kms_key_users          = var.kms_key_users

  # EKS Managed Node Groups 
  eks_managed_node_groups = {

    digitify-services = {
      name            = "spring-boot"
      use_name_prefix = false
      description     = "EKS managed node group for Spring boot services template"

      min_size       = var.digitify_services_size[0]
      desired_size   = var.digitify_services_size[1]
      max_size       = var.digitify_services_size[2]
      instance_types = var.digitify_services_instance_types

      ebs_optimized = var.digitify_services_ebs_optimized
      capacity_type = var.digitify_services_capacity_type
      disk_size     = var.digitify_services_disk_size

      labels = var.digitify_services_labels

      subnet_ids = var.private_subnets

      # Remote access cannot be specified with a launch template
      use_custom_launch_template = false
      remote_access = {
        ec2_ssh_key               = aws_key_pair.worker_nodes.key_name
        source_security_group_ids = [aws_security_group.remote_access.id]
      }
      tags = {
        Name = "sprint-boot-services"
      }
    }
  }

  # CLUSTER ADDSON
  cluster_addons = {
    coredns = {
      addon_version            = var.eks_addons.addons_version[0]
      before_compute           = true
      service_account_role_arn = ""
    }
    kube-proxy = {
      addon_version            = var.eks_addons.addons_version[1]
      before_compute           = true
      service_account_role_arn = ""
    }
    vpc-cni = {
      addon_version            = var.eks_addons.addons_version[2]
      before_compute           = true
      service_account_role_arn = ""
      configuration_values = jsonencode({
        env = {
          # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }

  tags = local.common_tags
}

resource "tls_private_key" "eks_worker_nodes_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "worker_nodes" {
  key_name = local.worker_node_key_name

  public_key = tls_private_key.eks_worker_nodes_private_key.public_key_openssh
  # Generate and save private key () in current directory
  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.eks_worker_nodes_private_key.private_key_pem}' > '${local.worker_node_key_name}.pem'
      chmod 400 '${local.worker_node_key_name}.pem'
    EOT
  }
  tags = local.common_tags
}


resource "aws_security_group" "remote_access" {
  name        = local.eks_worker_node_sg_name
  description = "Allow remote SSH access to EKS worker nodes"
  vpc_id      = var.vpc_id


  ingress {
    description     = "Allow SSH access from bastion host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${var.bastion_sg_id}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = local.common_tags
}
