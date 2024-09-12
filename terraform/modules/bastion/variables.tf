variable "author" {
  type        = string
  description = "Author name"
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

# ec2_instance
variable "az" {
  type        = list(string)
  description = "Availability zones"
}

variable "pub_subnet_id" {
  type        = string
  description = "Public Subnet ID"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "monitoring" {
  type        = bool
  default     = false
  description = "Enable/disable detailed monitoring for ec2"
}

variable "ami" {
  type        = string
  description = "AMI to use for the instance."
  default     = "ami-0fb653ca2d3203ac1"
}

variable "instance_type" {
  type        = string
  description = "The instance type to use for the instance. Updates to this field will trigger a stop/start of the EC2 instance."
  default     = "t2.small"
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Whether to associate a public IP address with an instance in a VPC."
  default     = false
}

#aws_eip
variable "eip_domain" {
  type        = string
  description = "Indicates if this EIP is for use in VPC."
  default     = "vpc"
}

# SG
variable "sg_ingress" {
  type        = list(any)
  description = "description"
}
