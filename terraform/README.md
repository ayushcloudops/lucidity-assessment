# terraform-eks

End-to-end, production-oriented deployment of a Hello World Python microservice
on Amazon EKS.

> **Status:** Infrastructure (Terraform) delivered. Application, Helm chart,
> monitoring stack, and Jenkins pipeline are added incrementally.

## Contents

| Path | Description |
|------|-------------|
| [`terraform/`](terraform/) | VPC + EKS platform (official modules, IRSA, managed node group) |
| `app/` | FastAPI microservice — _pending_ |
| `helm/` | Reusable Helm chart — _pending_ |
| `monitoring/` | Prometheus + Grafana stack — _pending_ |
| `Jenkinsfile` | Declarative CI/CD pipeline — _pending_ |
| `architecture/` | Architecture diagram — _pending_ |

## Quick start (infrastructure)

```bash
cd terraform
terraform init -backend=false        # or a full -backend-config for remote state
terraform validate
terraform plan -var-file=environments/dev.tfvars
```

See [`terraform/README.md`](terraform/README.md) for full usage.
