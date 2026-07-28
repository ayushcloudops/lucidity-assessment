# ---------------------------------------------------------------------------
# Root input variables. Every tunable is declared here with a type, a
# description and a sensible default so the module is self-documenting and
# environment overrides (dev/prod) only need to set what actually differs.
# ---------------------------------------------------------------------------

# --- Naming & tagging -------------------------------------------------------
variable "project" {
  description = "Project name, used as a prefix for all resource names and tags."
  type        = string
  default     = "hello-world"
}

variable "environment" {
  description = "Deployment environment (e.g. dev, prod). Drives naming and tags."
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Team or individual responsible for these resources."
  type        = string
  default     = "platform-team"
}

variable "additional_tags" {
  description = "Extra tags merged into the common tag set."
  type        = map(string)
  default     = {}
}

# --- Region & networking ----------------------------------------------------
variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC. Subnets are carved from this automatically."
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "az_count" {
  description = "Number of Availability Zones to spread subnets across."
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 2
    error_message = "At least 2 AZs are required for EKS high availability."
  }
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway (cheaper, dev) vs one per AZ (HA, prod)."
  type        = bool
  default     = true
}

# --- EKS cluster ------------------------------------------------------------
variable "cluster_version" {
  description = "Kubernetes control-plane version for the EKS cluster."
  type        = string
  default     = "1.30"
}

variable "cluster_endpoint_public_access" {
  description = "Whether the EKS API server endpoint is publicly reachable."
  type        = bool
  default     = true
}

# --- Managed node group -----------------------------------------------------
variable "node_ami_type" {
  description = "AMI type for the managed node group."
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "node_instance_types" {
  description = "Instance types for the managed node group."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_capacity_type" {
  description = "Capacity type for nodes: ON_DEMAND or SPOT."
  type        = string
  default     = "ON_DEMAND"

  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.node_capacity_type)
    error_message = "node_capacity_type must be ON_DEMAND or SPOT."
  }
}

variable "node_min_size" {
  description = "Minimum number of worker nodes."
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of worker nodes."
  type        = number
  default     = 4
}

variable "node_desired_size" {
  description = "Desired number of worker nodes at creation."
  type        = number
  default     = 2
}

variable "node_labels" {
  description = "Kubernetes labels applied to worker nodes."
  type        = map(string)
  default     = {}
}

# --- Monitoring stack (eks-utils) -------------------------------------------
variable "monitoring_namespace" {
  description = "Namespace for the Prometheus + Grafana monitoring stack."
  type        = string
  default     = "monitoring"
}

variable "grafana_admin_password" {
  description = "Grafana admin password. Override via a secret var-file or TF_VAR env in real environments."
  type        = string
  sensitive   = true
  default     = "admin"
}
