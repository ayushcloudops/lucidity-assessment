variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the control plane."
  type        = string
}

variable "cluster_endpoint_public_access" {
  description = "Whether the API server endpoint is publicly accessible."
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "ID of the VPC to deploy the cluster into."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the control plane ENIs and worker nodes."
  type        = list(string)
}

variable "ami_type" {
  description = "AMI type for the managed node group."
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "node_instance_types" {
  description = "Instance types for the managed node group."
  type        = list(string)
}

variable "node_capacity_type" {
  description = "Capacity type: ON_DEMAND or SPOT."
  type        = string
  default     = "ON_DEMAND"
}

variable "node_min_size" {
  description = "Minimum node count."
  type        = number
}

variable "node_max_size" {
  description = "Maximum node count."
  type        = number
}

variable "node_desired_size" {
  description = "Desired node count at creation."
  type        = number
}

variable "node_labels" {
  description = "Kubernetes labels applied to the nodes."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}
