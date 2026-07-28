# Terraform — EKS Platform

Provisions a production-oriented Amazon EKS platform: a multi-AZ VPC and a
managed EKS cluster with a managed node group, IRSA (OIDC), and least-privilege
IAM. Built from the official `terraform-aws-modules` wrapped in thin local
modules so the interface stays curated and DRY.

## Layout

```
terraform/
├── backend.tf        # S3 remote state + DynamoDB locking (partial config)
├── providers.tf      # AWS provider + default_tags + versions
├── variables.tf      # All root inputs (typed, described, defaulted)
├── locals.tf         # Naming, CIDR math, common tags
├── main.tf           # Wires vpc + eks modules
├── outputs.tf        # cluster, oidc, vpc, subnets, node group
├── terraform.tfvars  # Default (dev) values — no secrets
├── environments/     # dev.tfvars, prod.tfvars overrides
└── modules/
    ├── vpc/          # VPC, IGW, NAT, subnets, route tables, k8s tags
    └── eks/          # Control plane, node group, IAM, OIDC/IRSA
```

## Usage

```bash
# Init with a remote backend (recommended)
terraform init \

# Format, validate, plan
terraform fmt -recursive
terraform validate
terraform plan -var-file=terraform.tfvars

# Apply
terraform apply -var-file=terraform.tfvars

# Wire up kubectl
aws eks update-kubeconfig --name $(terraform output -raw cluster_name) --region ap-south-1
```

For a quick local validate without a backend: `terraform init -backend=false`.

## Outputs

| Output | Description |
|--------|-------------|
| `cluster_name` | EKS cluster name |
| `cluster_endpoint` | Kubernetes API endpoint |
| `oidc_provider_arn` | IAM OIDC provider ARN (IRSA) |
| `vpc_id` | VPC ID |
| `private_subnet_ids` | Private subnet IDs |
| `node_group` | Managed node group details |

## Destroy

```bash
terraform destroy -var-file=environments/dev.tfvars
```
