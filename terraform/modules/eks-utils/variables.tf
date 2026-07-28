variable "namespace" {
  description = "Kubernetes namespace to install the monitoring stack into."
  type        = string
  default     = "monitoring"
}

variable "prometheus_chart_version" {
  description = "Version of the prometheus-community/prometheus Helm chart."
  type        = string
  default     = "25.27.0"
}

variable "grafana_chart_version" {
  description = "Version of the grafana/grafana Helm chart."
  type        = string
  default     = "8.5.1"
}

variable "grafana_admin_password" {
  description = "Grafana admin password. Injected securely, never stored in values."
  type        = string
  sensitive   = true
}
