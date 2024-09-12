variable "author" {
  type        = string
  description = "Author Name"
  default     = "Muhammad Imtiaz"
}

variable "business_unit" {
  type        = string
  default     = "digitify"
  description = "Business Unit"
}

variable "environment" {
  type        = string
  description = "Environment Name"
}

variable "optional_identifier" {
  type        = string
  default     = ""
  description = "Optional Identifier"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of ID of public subnets"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of ID of private subnets"
}

variable "bastion_sg_id" {
  type        = string
  description = "ID of bastion security group"
}

variable "s3_bucket" {
  type        = string
  description = "S3 bucket for storing terraform.tfstate files"
  default     = "digitify-terraform-state-remote-backend"
}

# EKS Cluster Configuration
variable "cluster_version" {
  type        = string
  description = "Kubernetes `<major>.<minor>` version to use for the EKS cluster (i.e.: `1.22`)"
  default     = "1.21"
}

variable "cluster_endpoint_private_access" {
  type        = bool
  default     = true
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled"
}

variable "cluster_endpoint_public_access" {
  type        = bool
  default     = false
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
}

variable "public_access_cidrs" {
  type        = list(string)
  default     = [""]
  description = "list of public cidrs that can access kubernetes API server"
}

variable "create_cluster_security_group" {
  type        = bool
  default     = true
  description = " Determines if a security group is created for the cluster or use the existing `cluster_security_group_id`"
}

variable "create_cluster_iam_role" {
  type        = bool
  default     = true
  description = " Determines if a iam role is created for the cluster or use the existing `cluster_security_group_id`"
}

variable "create_launch_template" {
  type        = bool
  default     = false
  description = "Whether to create launch template or not."
}

variable "kms_key_administrators" {
  description = "A list of IAM ARNs for [key administrators](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-default-allow-administrators). If no value is provided, the current caller identity is used to ensure at least one key admin is available"
  type        = list(string)
  default     = []
}

variable "kms_key_users" {
  description = "A list of IAM ARNs for [key users](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-default-allow-users)"
  type        = list(string)
  default     = []
}

# digitify Services Node Group
variable "digitify_services_size" {
  type        = list(number)
  default     = [1, 1, 2]
  description = "size of nodes in a group."
}

variable "digitify_services_instance_types" {
  type        = list(any)
  description = "List of instances types to be used in node group."
  default     = ["t3.small"]
}

variable "digitify_services_ebs_optimized" {
  type        = bool
  default     = true
  description = "Wether EBS voulme should be optimized."
}

variable "digitify_services_capacity_type" {
  type        = string
  default     = "ON_DEMAND"
  description = "Capacity type for ebs volume"
}

variable "digitify_services_disk_size" {
  description = "Disk size in GiB for nodes. Defaults to `20`. Only valid when `use_custom_launch_template` = `false`"
  type        = number
  default     = null
}

variable "digitify_services_labels" {
  type        = map(any)
  description = "Labels to apply on digitify node groups."
  default = {
    Environment = "test"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }
}

variable "eks_addons" {
  type = map(list(string))
  default = {
    # addons_name    = ["coredns", "kube-proxy", "vpc-cni", ],
    addons_version = ["v1.9.3-eksbuild.5", "v1.25.6-eksbuild.2", "v1.12.6-eksbuild.2"]
  }
}
variable "cloudwatch_log_group_retention_in_days" {
  type = number
  default = 7
  
}
