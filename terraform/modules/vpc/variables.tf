variable "author" {
  type        = string
  description = "Author Name"
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

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "A boolean flag to enable/disable DNS hostnames in the VPC."
  default     = true
}

variable "enable_dns_support" {
  type        = bool
  description = "A boolean flag to enable/disable DNS support in the VPC. Defaults true."
  default     = true
}

variable "azs" {
  type        = list(string)
  description = "Availability zones"
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "Public subnets CIDR blocks"
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "Private subnets CIDR blocks"
}

variable "create_igw" {
  type        = bool
  description = "A boolean flag to create internet gateway in the VPC. Defaults true."
  default     = true
}

variable "enable_nat_gateway" {
  type        = bool
  description = "A boolean flag to create NAT gateway for private subnets. Defaults true."
  default     = true
}

variable "single_nat_gateway" {
  type        = bool
  description = "Enable only one NAT gateway. Defaults true."
  default     = true
}
