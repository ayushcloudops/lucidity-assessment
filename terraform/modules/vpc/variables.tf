variable "name" {
  description = "Name prefix for the VPC and its resources."
  type        = string
}

variable "cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "azs" {
  description = "List of Availability Zones to deploy subnets into."
  type        = list(string)
}

variable "private_subnets" {
  description = "CIDR blocks for the private subnets (one per AZ)."
  type        = list(string)
}

variable "public_subnets" {
  description = "CIDR blocks for the public subnets (one per AZ)."
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "Provision a single shared NAT Gateway instead of one per AZ."
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "EKS cluster name, used for Kubernetes subnet discovery tags."
  type        = string
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}
