# Thin wrapper around the official terraform-aws-modules/eks/aws module.
# Provisions the managed EKS control plane, cluster/node IAM roles (least
# privilege via AWS-managed EKS policies), the IAM OIDC provider for IRSA, the
# cluster security group, and a managed node group in the private subnets.
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = var.cluster_endpoint_public_access

  # Grants the identity running Terraform admin access via an EKS access entry,
  # so kubectl works immediately after apply without manual aws-auth edits.
  enable_cluster_creator_admin_permissions = true

  # Creates the IAM OIDC provider so workloads can assume IAM roles (IRSA).
  enable_irsa = true

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  eks_managed_node_group_defaults = {
    ami_type = var.ami_type
  }

  eks_managed_node_groups = {
    default = {
      min_size       = var.node_min_size
      max_size       = var.node_max_size
      desired_size   = var.node_desired_size
      instance_types = var.node_instance_types
      capacity_type  = var.node_capacity_type
      labels         = var.node_labels
    }
  }

  tags = var.tags
}
