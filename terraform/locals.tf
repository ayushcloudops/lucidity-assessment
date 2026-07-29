locals {
  name_prefix  = "${var.project}"
  cluster_name = "${local.name_prefix}-eks"

  # Take the first N available AZs in the region rather than hardcoding them.
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)

  # Deterministically carve /20 subnets from the VPC CIDR — private first,
  # then public — so no subnet ranges are ever hardcoded.
  private_subnet_cidrs = [for i in range(var.az_count) : cidrsubnet(var.vpc_cidr, 4, i)]
  public_subnet_cidrs  = [for i in range(var.az_count) : cidrsubnet(var.vpc_cidr, 4, i + var.az_count)]

  # Single source of truth for tags, applied provider-wide via default_tags.
  common_tags = merge(
    {
      Project   = var.project
      ManagedBy = "Terraform"
    },
    var.additional_tags,
  )
}
