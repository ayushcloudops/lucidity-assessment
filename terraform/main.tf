# ---------------------------------------------------------------------------
# Root module: wires the local vpc and eks modules together. The heavy lifting
# lives in the official upstream modules; our wrappers expose a curated,
# opinionated interface.
# ---------------------------------------------------------------------------

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "./modules/vpc"

  name               = local.name_prefix
  cidr               = var.vpc_cidr
  azs                = local.azs
  private_subnets    = local.private_subnet_cidrs
  public_subnets     = local.public_subnet_cidrs
  single_nat_gateway = var.single_nat_gateway
  cluster_name       = local.cluster_name
  tags               = local.common_tags
}

module "eks" {
  source = "./modules/eks"

  cluster_name                   = local.cluster_name
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = var.cluster_endpoint_public_access

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  ami_type            = var.node_ami_type
  node_instance_types = var.node_instance_types
  node_capacity_type  = var.node_capacity_type
  node_min_size       = var.node_min_size
  node_max_size       = var.node_max_size
  node_desired_size   = var.node_desired_size
  node_labels         = var.node_labels

  tags = local.common_tags
}

module "eks_utils" {
  source = "./modules/eks-utils"

  namespace              = var.monitoring_namespace
  grafana_admin_password = var.grafana_admin_password

  # Cluster and node group must exist before Helm can schedule workloads.
  depends_on = [module.eks]
}
