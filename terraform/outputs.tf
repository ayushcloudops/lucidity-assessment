# ---------------------------------------------------------------------------
# Outputs consumed by downstream tooling (kubectl/helm config, CI pipelines,
# IRSA trust policies). Exposes exactly what the assignment requires.
# ---------------------------------------------------------------------------

output "cluster_name" {
  description = "Name of the EKS cluster."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint of the EKS Kubernetes API server."
  value       = module.eks.cluster_endpoint
}

output "oidc_provider_arn" {
  description = "ARN of the IAM OIDC provider, used for IRSA."
  value       = module.eks.oidc_provider_arn
}

output "vpc_id" {
  description = "ID of the VPC."
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets hosting the worker nodes."
  value       = module.vpc.private_subnets
}

output "node_group" {
  description = "Managed node group details."
  value       = module.eks.eks_managed_node_groups
}
