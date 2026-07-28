output "namespace" {
  description = "Namespace the monitoring stack is deployed into."
  value       = var.namespace
}

output "prometheus_release_name" {
  description = "Helm release name for Prometheus."
  value       = helm_release.prometheus.name
}

output "grafana_release_name" {
  description = "Helm release name for Grafana."
  value       = helm_release.grafana.name
}
