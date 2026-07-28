# Installs the in-cluster monitoring stack via Helm.
#
# Prometheus is deployed with the chart's upstream defaults (scrapes the
# Kubernetes API, nodes and pods out of the box). Only Grafana is customised —
# its values preconfigure the Prometheus datasource and service, while the
# admin password is injected at apply time so no secret lands in the values.

resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  version          = var.prometheus_chart_version
  namespace        = var.namespace
  create_namespace = true

  # Default values only — no overrides.
}

resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  version          = var.grafana_chart_version
  namespace        = var.namespace
  create_namespace = true

  # Custom values live ONLY on Grafana. The namespace is templated in so the
  # datasource URL always points at the Prometheus service in this release.
  values = [
    templatefile("${path.module}/values/grafana-values.yaml.tftpl", {
      namespace = var.namespace
    })
  ]

  # Kept out of the values file and state-diff noise; supplied at apply time.
  set_sensitive {
    name  = "adminPassword"
    value = var.grafana_admin_password
  }

  depends_on = [helm_release.prometheus]
}
