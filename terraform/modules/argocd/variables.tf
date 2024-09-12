variable "region" {
  type        = string
  description = "region"
  default     = "us-east-2"
}

variable "profile" {
  type        = string
  description = "profile"
  default     = "digitify"
}

variable "author" {
  type        = string
  description = "Author Name"
}

variable "business_unit" {
  type        = string
  default     = "dps"
  description = "Business Unit Name"
}

variable "environment" {
  type        = string
  description = "Environment Name"
  default     = "dev"
}

variable "optional_identifier" {
  type        = string
  default     = ""
  description = "Optional Identifier"
}

variable "remote_backend" {
  type        = string
  description = "S3 bucket for storing terraform.tfstate files"
  default     = "digitify-terraform-state-remote-backend"
}

variable "namespace" {
  description = "Namespace where manifests should be deployed."
  type        = string
  default     = "argocd"
}

variable "s3_bucket" {
  description = "S3 bucket for remote state"
  type        = string
  default     = "digitify-terraform-state-bucket"
}