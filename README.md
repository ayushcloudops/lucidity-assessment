# Lucidity Assessment — Hello World on Amazon EKS

| Project | Purpose |
|---------|---------|
| [`app/`](app/) | The Python (Flask) microservice + its container image |
| [`helm-app/`](helm-app/) | The Helm chart that deploys the service to Kubernetes |
| [`terraform/`](terraform/) | The AWS infrastructure (VPC, EKS, monitoring) the service runs on |

## 1. `app/` — Python microservice

A minimal **Flask** "Hello World" service, instrumented for Prometheus and
served in production by **gunicorn**.

### Endpoints

| Method | Path | Response | Purpose |
|--------|------|----------|---------|
| `GET` | `/` | `Hello World!` | Main route |
| `GET` | `/health` | `OK` | Liveness/readiness probe target |
| `GET` | `/metrics` | Prometheus exposition format | Metrics for scraping |

### Files

- `app.py` — the Flask application and metric definitions.
- `requirements.txt` — Flask, gunicorn, prometheus-client (pinned versions).
- `gunicorn.conf.py` — WSGI server config: binds `0.0.0.0:8080`, 2 workers × 2 threads.
- `Dockerfile` — builds on `python:3.12-slim` and runs the app under gunicorn.


## 2. `helm-app/` — Helm chart

A reusable Helm chart (`hello-world-app`) that deploys the microservice to
Kubernetes. Everything meaningful is parameterised in `values.yaml`, so the same
chart serves any environment by overriding values.

### What it creates

- **Deployment** — runs the app image (default 2 replicas) with CPU/memory
  requests & limits and `/health` liveness + readiness probes.
- **Service** — type `LoadBalancer`, exposing port `80` → container port `8080`,
  annotated so Prometheus scrapes `/metrics`.
- **Ingress** — optional (`ingress.enabled`), nginx class by default.

### Key values (`values.yaml`)

| Key | Default | Meaning |
|-----|---------|---------|
| `replicaCount` | `2` | Number of pods |
| `image.repository` / `image.tag` | ECR repo / `latest` | Image to deploy |
| `service.type` / `service.port` / `service.targetPort` | `LoadBalancer` / `80` / `8080` | How the app is exposed |
| `service.annotations` | `prometheus.io/*` | Enables metric scraping |
| `resources` | 100m/128Mi → 500m/512Mi | Requests and limits |
| `livenessProbe` / `readinessProbe` | `/health` | Health checking |


## 3. `terraform/` — AWS infrastructure

## Contents

| Path | Description |
|------|-------------|
| [`terraform/`](terraform/) | VPC + EKS platform (official modules, IRSA, managed node group) |
| `app/` | FastAPI microservice — _pending_ |
| `helm/` | Reusable Helm chart — _pending_ |
| `monitoring/` | Prometheus + Grafana stack — _pending_ |
| `Jenkinsfile` | Declarative CI/CD pipeline — _pending_ |
| `architecture/` | Architecture diagram — _pending_ |

## Monitoring

Prometheus and Grafana are installed into the `monitoring` namespace by the
`eks-utils` module. Prometheus scrapes the app's `/metrics` endpoint (via the
Service annotations) alongside Kubernetes and node metrics; Grafana ships with
the Prometheus datasource preconfigured.

```bash
kubectl -n monitoring port-forward svc/grafana 3000:80
# open http://localhost:3000  (user: admin)
```
